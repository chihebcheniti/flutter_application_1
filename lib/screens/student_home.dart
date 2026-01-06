import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_card.dart';
import 'student_marks.dart';
import 'student_timetable.dart';
import 'login_screen.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            dashboardCard(
              icon: Icons.badge,
              title: 'My Student Card',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentCard()),
              ),
            ),
            dashboardCard(
              icon: Icons.schedule,
              title: 'My Timetable',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentTimetable()),
              ),
            ),
            dashboardCard(
              icon: Icons.grade,
              title: 'My Marks',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentMarks()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}