import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

////////////paga ta3 l Admin dashboard (dinamic state full widget)
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String search = '';

  void _logout() {
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
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
//////////////// hadi ui ta3 search
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search  for students...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (v) => setState(() => search = v.toLowerCase()),
              ),
            ),
          ),

///////////////////// lista ta3 students
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'student')
                  .snapshots(), //updatesss ta3ha a
              builder: (context, snapshot) {
//////////////////hadi bah dir search logo a3aboud
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
/////////////tjib data men data base  we tfiltriham  3la 7asb varibale search wtraja3ham f lista 
                final students = snapshot.data!.docs.where((doc) {
                  return doc['name']
                      .toString()
                      .toLowerCase()
                      .contains(search);
                }).toList();
/////////////////////// tafichi bark fi lista
                return ListView.builder(
                  itemCount: students.length, 
                  itemBuilder: (context, index) {
                    final s = students[index];
                    final approved = s['approved']; // hadi bah ta3raf lakan student mprouvi wela no
///////////////////////cart  ta ta3 sudent hadi
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            s['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Group: ${s['group']}'),
                          trailing: approved
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 28)
                              : ElevatedButton(
                                  onPressed: () =>
                                      s.reference.update({'approved': true}),
                                  child: const Text('Approve'),//ta3 aproved wela no
                                ),
                        ),
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