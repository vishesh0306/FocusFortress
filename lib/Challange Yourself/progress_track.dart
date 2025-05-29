import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DropBoxPreviewPage.dart';


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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () async {
                        final url = dayProof['proof'];
                        final uri = Uri.parse(url);
                        print(url);
                        print('Scheme: ${uri.scheme}');
                        print('Host: ${uri.host}');
                        print('Path: ${uri.path}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch URL')),
                          );
                        }
                      },
                      child: Text(
                        'View Proof',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      dayProof['proof'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.open_in_new, color: Colors.blue),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
