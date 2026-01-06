import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teacher_courses.dart';
import 'teacher_marks.dart';
import 'login_screen.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.school, size: 40, color: Colors.green),
                    SizedBox(width: 16),
                    Text(
                      'Welcome Teacher 👋',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _menuButton(
              context,
              title: 'My Courses',
              icon: Icons.book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeacherCourses()),
              ),
            ),
            _menuButton(
              context,
              title: 'Manage Marks',
              icon: Icons.grade,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeacherMarks()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}