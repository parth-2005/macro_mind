import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../domain/entities/interaction_entity.dart';

/// The "Ghost Protocol" - Biometric Behavioral Analysis Service
/// Singleton service that collects raw sensor data without calculating trust scores
/// Trust scoring happens server-side to prevent client manipulation
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  // Gyroscope stream subscription
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  // Current interaction data
  final List<Offset> _touchPath = [];
  final List<double> _gyroReadings = [];
  DateTime? _cardLoadTime;
  DateTime? _firstTouchTime;

  int _touchPointCounter = 0; // For throttling
  static const int _touchSampleRate = 5; // Record every 5th point
  static const int _maxTouchPoints = 50; // Cap at 50 points

  bool _isRecording = false;

  /// Initialize the service and start listening to gyroscope
  Future<void> initialize() async {
    debugPrint('[BiometricService] Initializing Ghost Protocol...');

    // Start listening to gyroscope
    _gyroSubscription = gyroscopeEventStream().listen((event) {
      if (_isRecording) {
        // Calculate magnitude of gyroscope vector
        final magnitude =
            (event.x * event.x + event.y * event.y + event.z * event.z);
        _gyroReadings.add(magnitude);
      }
    });

    debugPrint('[BiometricService] Ghost Protocol initialized');
  }

  /// Start recording for a new card interaction
  void startRecording() {
    debugPrint('[BiometricService] Started recording');
    _isRecording = true;
    _touchPath.clear();
    _gyroReadings.clear();
    _touchPointCounter = 0;
    _cardLoadTime = DateTime.now();
    _firstTouchTime = null;
  }

  /// Record a touch point during swipe gesture
  void recordTouchPoint(Offset point) {
    if (!_isRecording) return;

    // Record first touch time
    _firstTouchTime ??= DateTime.now();

    // Throttle: only record every Nth point to reduce lag
    _touchPointCounter++;
    if (_touchPointCounter % _touchSampleRate != 0) return;

    // Cap total points to prevent memory issues
    if (_touchPath.length >= _maxTouchPoints) return;

    _touchPath.add(point);
  }

  /// Stop recording and generate interaction entity
  InteractionEntity? stopRecording({required bool swipedRight}) {
    if (!_isRecording) return null;

    _isRecording = false;

    // Calculate hesitation time
    final hesitationMs = _firstTouchTime != null && _cardLoadTime != null
        ? _firstTouchTime!.difference(_cardLoadTime!).inMilliseconds
        : 0;

    // Calculate gyroscope variance
    final gyroVariance = _calculateVariance(_gyroReadings);

    final interaction = InteractionEntity(
      touchPath: List.from(_touchPath),
      gyroVariance: gyroVariance,
      hesitationMs: hesitationMs,
      timestamp: DateTime.now(),
      swipedRight: swipedRight,
    );

    debugPrint('[BiometricService] Interaction captured:');
    debugPrint('  - Touch points: ${_touchPath.length}');
    debugPrint('  - Gyro variance: ${gyroVariance.toStringAsFixed(6)}');
    debugPrint('  - Hesitation: ${hesitationMs}ms');
    debugPrint(
      '  - Path curvature: ${interaction.pathCurvature.toStringAsFixed(4)}',
    );
    debugPrint('  - Swiped right: $swipedRight');

    return interaction;
  }

  /// Calculate variance of a list of numbers
  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean));
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;

    return variance;
  }

  /// Reset all data
  void reset() {
    _touchPath.clear();
    _gyroReadings.clear();
    _cardLoadTime = null;
    _firstTouchTime = null;
    _isRecording = false;
    debugPrint('[BiometricService] Data reset');
  }

  /// Dispose of resources
  void dispose() {
    _gyroSubscription?.cancel();
    _gyroSubscription = null;
    debugPrint('[BiometricService] Disposed');
  }

  // Getters for debugging
  int get touchPointCount => _touchPath.length;
  int get gyroReadingCount => _gyroReadings.length;
  bool get isRecording => _isRecording;
}
