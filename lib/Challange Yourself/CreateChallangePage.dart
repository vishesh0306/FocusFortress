import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class CreateChallengePage extends StatefulWidget {

  final String userId;
  CreateChallengePage({super.key, required this.userId});

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();


  // Controllers to capture input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _motiveController = TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Collect data
      String name = _nameController.text.trim();
      int? duration = int.tryParse(_durationController.text) ?? 0;
      String motive = _motiveController.text.trim();

      try {
        // Get the current user's UID
        String? userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          // Send data to Firestore as a subcollection under the user's document
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Challenges')
              .add({
            'name': name,
            'duration': duration,
            'motive': motive,
            'created_at': Timestamp.now(),
            'status': "In Progress",
            "completedDays": 0
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Challenge created successfully!')),
          );

          // Clear the form
          _formKey.currentState?.reset();
        } else {
          // Show an error if user ID is not available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not authenticated. Please log in.')),
          );
        }
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create challenge: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Challenge'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Challenge Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: 'Duration (in days)',
                        prefixIcon: Icon(Icons.timer),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _motiveController,
                      decoration: InputDecoration(
                        labelText: 'Motive',
                        prefixIcon: Icon(Icons.lightbulb_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a motive';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitData,
                        icon: Icon(Icons.check_circle_outline, color: Colors.white,),
                        label: Text('Submit', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
