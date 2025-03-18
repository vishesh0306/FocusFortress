import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeTrackerPage extends StatelessWidget {
  final String challengeId;

  const ChallengeTrackerPage({Key? key, required this.challengeId})
      : super(key: key);


  Future<List<Map<String, dynamic>>> _getProofs() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final trackCollection = FirebaseFirestore.instance
        .collection('Users') // Root collection for Users
        .doc(userId)
        .collection('Challenges')
        .doc(challengeId)
        .collection('challenge_track');

    final snapshot = await trackCollection.get();
    return snapshot.docs.map((doc) {
      return {'day': doc.id, 'proof': doc.data()['proof'] ?? 'No proof'};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Challenge Tracker')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getProofs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No progress added yet.'));
          }

          final proofs = snapshot.data!;

          return ListView.builder(
            itemCount: proofs.length,
            itemBuilder: (context, index) {
              final dayProof = proofs[index];
              return ListTile(
                title: Text('Day ${index+1}: ${dayProof['proof']}'),
              );
            },
          );
        },
      ),
    );
  }
}
