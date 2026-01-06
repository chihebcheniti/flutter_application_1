import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final group = TextEditingController();
  String role = 'student';

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user!.uid)
        .set({
      'name': name.text,
      'email': email.text,
      'role': role,
      'group': role == 'student' ? group.text : '',
      'approved': role == 'student' ? false : true,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField(
                value: role,
                items: ['student', 'teacher', 'admin']
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => role = v!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              if (role == 'student')
                TextFormField(
                  controller: group,
                  decoration: const InputDecoration(labelText: 'Group'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: signup, child: const Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}