import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/Challange%20Yourself/progress_track.dart';

class ChallengeProofPage extends StatefulWidget {
  final String id;
  final String name;

  const ChallengeProofPage({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  _ChallengeProofPageState createState() => _ChallengeProofPageState();
}
class _ChallengeProofPageState extends State<ChallengeProofPage> {
  TextEditingController _proofController = TextEditingController();
  bool isButtonDisabled = false; // Variable to handle button state

  // Add Proof Function to Firestore
  Future<void> _addProof() async {
    String proofText = _proofController.text.trim();

    if (proofText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter proof text'),
      ));
      return;
    }

    try {
      // Get the current user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the current challenge document to get the existing completedDays and duration
      DocumentSnapshot challengeSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Challenges')
          .doc(widget.id)
          .get();

      if (!challengeSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Challenge not found.'),
        ));
        return;
      }

      var challengeData = challengeSnapshot.data() as Map<String, dynamic>;
      int completedDays = challengeData['completedDays'] ?? 0;
      int duration = challengeData['duration'] ?? 0;

      // Increment the completedDays by 1
      completedDays++;

      // Update the status if the challenge is completed
      String status = completedDays >= duration ? 'Challenge completed' : 'in-progress';

      // Save the proof to Firestore under the corresponding challenge
      await FirebaseFirestore.instance
          .collection('Users') // Root collection for Users
          .doc(userId) // Current user document
          .collection('Challenges') // Challenges sub-collection
          .doc(widget.id) // Specific challenge document (using challenge ID)
          .collection('challenge_track') // challenge_track sub-collection for the challenge
          .add({
        'proof': proofText,
        'status': 'in-progress', // Initially setting status to "in-progress"
        'currentDay': completedDays,
        'totalDays': duration,
      });

      // Update the challenge's completedDays and status in the "Challenges" collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Challenges')
          .doc(widget.id)
          .update({
        'completedDays': completedDays,
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Proof added successfully!'),
      ));

      _proofController.clear(); // Clear input field after submission

      // Disable the button if the challenge is completed
      if (completedDays >= duration) {
        setState(() {
          isButtonDisabled = true; // Disable the button
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving proof: $e'),
      ));
    }
  }

  // Navigate to the Progress Page
  void _goToProgressPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeTrackerPage(
          challengeId: widget.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Challenge time')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Displaying the Challenge Information
              // Text(
              //   'Challenge: ${widget.name}',
              //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 20),
        
              // StreamBuilder to fetch challenge details from Firebase
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Challenges')
                    .doc(widget.id) // Challenge ID passed to widget
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No challenge details available.');
                  }
        
                  var challengeData = snapshot.data!.data() as Map<String, dynamic>;
        
                  String name = challengeData['name'] ?? 'N/A';
                  String motive = challengeData['motive'] ?? 'N/A';
                  int duration = challengeData['duration'] ?? 0;
                  String status = challengeData['status'] ?? 'N/A';
                  int completedDays = challengeData['completedDays'] ?? 0;
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge: $name',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Motive:  ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('$motive'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Duration:  ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('$duration days'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Status:  ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('$status'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Completed Days:  ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('$completedDays'),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
        
              // Proof Text Field
              TextField(
                controller: _proofController,
                decoration: InputDecoration(
                  labelText: 'Enter Proof Text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
        
              // Submit Button with Disabled State
              ElevatedButton(
                onPressed: isButtonDisabled ? null : _addProof, // Disables the button
                child: Text(isButtonDisabled ? 'Challenge Completed' : 'Submit Proof'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonDisabled ? Colors.grey : Colors.blue, // Disable appearance
                ),
              ),
              SizedBox(height: 30),
        
              // Button to Navigate to Progress Page
              ElevatedButton(
                onPressed: _goToProgressPage,
                child: Text('Go to Progress Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

