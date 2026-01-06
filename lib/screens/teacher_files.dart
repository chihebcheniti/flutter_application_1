import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class TeacherFiles extends StatefulWidget {
  final String course;
  const TeacherFiles({super.key, required this.course});

  @override
  State<TeacherFiles> createState() => _TeacherFilesState();
}

class _TeacherFilesState extends State<TeacherFiles> {
  bool uploading = false;

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() => uploading = true);
    
    final file = result.files.first;
    
    // Save file info to Firestore
    await FirebaseFirestore.instance
        .collection('teacher_files')
        .add({
          'course': widget.course,
          'fileName': file.name,
          'fileSize': file.size,
          'uploadedAt': DateTime.now(),
          'uploadedBy': FirebaseAuth.instance.currentUser!.email,
        });
    
    setState(() => uploading = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File info saved: ${file.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course} Files'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Upload button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              icon: uploading 
                  ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Icon(Icons.upload),
              label: Text(uploading ? 'Saving...' : 'Upload File Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 50),
              ),
              onPressed: uploadFile,
            ),
          ),
          
          // Show uploaded files
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teacher_files')
                  .where('course', isEqualTo: widget.course)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final files = snapshot.data!.docs;
                
                if (files.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('No files uploaded yet'),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file, color: Colors.green),
                        title: Text(file['fileName']),
                        subtitle: Text('Uploaded by: ${file['uploadedBy']}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}