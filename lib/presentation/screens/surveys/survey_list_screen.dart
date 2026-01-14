import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({Key? key}) : super(key: key);

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  bool _showConfetti = false;

  void _startSurvey(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyFormScreen(
          title: title,
          onComplete: () {
            setState(() => _showConfetti = true);
            Future.delayed(const Duration(seconds: 4), () {
              if (mounted) setState(() => _showConfetti = false);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taste Tests',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSurveyCard(
                'Sample A Taste Test',
                'Rate the new chocolate bars.',
                500,
              ),
              const SizedBox(height: 16),
              _buildSurveyCard(
                'Soda Flavor Comparison',
                'Which bubble flavor is better?',
                300,
              ),
            ],
          ),
          if (_showConfetti)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Using a placeholder Lottie URL for now
                  Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_myej9h9g.json',
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Text(
                      '500 Points Unlocked!',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSurveyCard(String title, String description, int points) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '+$points',
            style: GoogleFonts.inter(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => _startSurvey(title),
      ),
    );
  }
}

class SurveyFormScreen extends StatelessWidget {
  final String title;
  final VoidCallback onComplete;

  const SurveyFormScreen({
    Key? key,
    required this.title,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question 1',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'How much did you like Sample A?',
              style: GoogleFonts.inter(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Slider(value: 0.7, onChanged: (_) {}),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onComplete();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('SUBMIT FEEDBACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
