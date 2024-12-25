import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      String duration = _durationController.text.trim();
      String motive = _motiveController.text.trim();

      try {
        // Send data to Firestore
        await FirebaseFirestore.instance.collection('Challenges').add({
          'name': name,
          'duration': duration,
          'motive': motive,
          'created_at': Timestamp.now(), // Optional
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Challenge created successfully!')),
        );

        // Clear the form
        _formKey.currentState?.reset();
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
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
