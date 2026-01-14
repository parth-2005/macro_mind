import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _checkCompatibility(BuildContext context, String userId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool loading = true;
          int? score;

          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              setState(() {
                loading = false;
                score = 70 + (DateTime.now().millisecond % 30); // 70-99%
              });
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              children: [
                Icon(
                  loading ? Icons.radar : Icons.favorite,
                  color: Colors.pink,
                ),
                const SizedBox(width: 12),
                const Text('Scanner'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading) ...[
                  const CircularProgressIndicator(color: Colors.pink),
                  const SizedBox(height: 24),
                  Text(
                    "Scanning Partner's Vibe...",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ] else ...[
                  Text(
                    '$score% MATCH!',
                    style: GoogleFonts.inter(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Perfect Valentine Connection'),
                ],
              ],
            ),
            actions: [
              if (!loading)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('AWESOME!'),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String? name;
          String? photoUrl;
          int points = 0;
          String userId = "";

          if (state is AuthAuthenticated) {
            name = state.user.displayName;
            photoUrl = state.user.photoUrl;
            points = state.user.points;
            userId = state.user.id;
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name ?? 'Macro User',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Points Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL POINTS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      points.toString(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Compatibility Button
              ElevatedButton.icon(
                onPressed: () => _checkCompatibility(context, userId),
                icon: const Icon(Icons.favorite),
                label: const Text('Check Couple Compatibility'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade50,
                  foregroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SwitchListTile(
                title: Text(
                  'Join Beta Club',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Get early access to premium rewards'),
                value: false,
                onChanged: (_) {},
                secondary: const Icon(Icons.star, color: Colors.amber),
              ),
              const Divider(height: 40),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(const SignOutRequested());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
