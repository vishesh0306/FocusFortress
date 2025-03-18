import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateChallengePage extends StatefulWidget {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration'),
                keyboardType: TextInputType.number, // Ensures that the input is numeric
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  // Check if the value can be parsed as an integer
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';  // Error message if it's not a valid integer
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _motiveController,
                decoration: InputDecoration(labelText: 'Motive'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a motive';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
