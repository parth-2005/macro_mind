import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../../bloc/survey/survey_bloc.dart';
import '../../bloc/survey/survey_event.dart';
import '../../bloc/survey/survey_state.dart';
import '../../../domain/entities/survey_entity.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({super.key});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    context.read<SurveyBloc>().add(LoadSurveys());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startSurvey(SurveyEntity survey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          survey: survey,
          onComplete: (earnedPoints) {
            // Bloc handles state, but we can also trigger local UI here if needed.
            // However, the listener on Bloc is cleaner.
          },
        ),
      ),
    );
  }

  List<SurveyEntity> _lastSurveys = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyBloc, SurveyState>(
      listener: (context, state) {
        if (state is SurveySuccess) {
          _confettiController.play();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('+500 Points Added!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Taste Tests',
            style: GoogleFonts.inter(fontWeight: FontWeight.w800),
          ),
        ),
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoading && _lastSurveys.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SurveyError && _lastSurveys.isEmpty) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is SurveyLoaded) {
              _lastSurveys = state.surveys;
            }

            if (_lastSurveys.isEmpty && state is! SurveyLoading) {
              return const Center(
                child: Text('No surveys available right now.'),
              );
            }

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _lastSurveys.length,
                  itemBuilder: (context, index) {
                    final survey = _lastSurveys[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSurveyCard(survey),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2, // Up
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    maxBlastForce: 100,
                    minBlastForce: 80,
                    gravity: 0.3,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSurveyCard(SurveyEntity survey) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          survey.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(survey.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '+${survey.rewardPoints}',
            style: GoogleFonts.inter(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => _startSurvey(survey),
      ),
    );
  }
}

class SurveyFormScreen extends StatefulWidget {
  final SurveyEntity survey;
  final Function(int) onComplete;

  const SurveyFormScreen({
    super.key,
    required this.survey,
    required this.onComplete,
  });

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final Map<String, dynamic> _answers = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyBloc, SurveyState>(
      listener: (context, state) {
        if (state is SurveySuccess) {
          Navigator.pop(context);
          widget.onComplete(state.earnedPoints);
        } else if (state is SurveyError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.survey.title)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.survey.questions.length,
                  itemBuilder: (context, index) {
                    final question = widget.survey.questions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          question.text,
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        if (question.type ==
                                SurveyQuestionType.multipleChoice ||
                            question.type == SurveyQuestionType.binary)
                          RadioGroup<String>(
                            groupValue: _answers[question.id] as String?,
                            onChanged: (String? val) {
                              setState(() => _answers[question.id] = val);
                            },
                            child: Column(
                              children:
                                  (question.options ??
                                          (question.type ==
                                                  SurveyQuestionType.binary
                                              ? ['Yes', 'No']
                                              : []))
                                      .map((option) {
                                        return ListTile(
                                          title: Text(option),
                                          leading: Radio<String>(value: option),
                                          onTap: () {
                                            setState(
                                              () => _answers[question.id] =
                                                  option,
                                            );
                                          },
                                        );
                                      })
                                      .toList(),
                            ),
                          ),
                        if (question.type == SurveyQuestionType.slider)
                          Slider(
                            value: (_answers[question.id] as double?) ?? 0.5,
                            onChanged: (val) {
                              setState(() => _answers[question.id] = val);
                            },
                          ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
              BlocBuilder<SurveyBloc, SurveyState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is SurveySubmitting
                          ? null
                          : () {
                              context.read<SurveyBloc>().add(
                                SubmitSurvey(widget.survey.id, _answers),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state is SurveySubmitting
                          ? const CircularProgressIndicator()
                          : const Text('SUBMIT FEEDBACK'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
