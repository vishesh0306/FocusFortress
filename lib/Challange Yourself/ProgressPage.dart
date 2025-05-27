import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/Challange%20Yourself/progress_track.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class ChallengeProofPage extends StatefulWidget {
  final String id;
  final String name;
  final String userId;


  const ChallengeProofPage({
    Key? key,
    required this.id,
    required this.name,
    required this.userId,
  }) : super(key: key);

  @override
  _ChallengeProofPageState createState() => _ChallengeProofPageState();
}
class _ChallengeProofPageState extends State<ChallengeProofPage> {
  TextEditingController _proofController = TextEditingController();
  bool isButtonDisabled = false; // Variable to handle button state
  FilePickerResult? selectedFile;
  String? selectedOption;

  // Add Proof Function to Firestore
  // Future<void> _addProof() async {
  //   String proofText = _proofController.text.trim();
  //
  //   if (proofText.isEmpty && (selectedFile?.count ?? 0) == 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Please enter proof text'),
  //     ));
  //     return;
  //   }
  //   else if((selectedFile?.count ?? 0) > 0){
  //     File? file;
  //
  //     if (selectedFile != null && selectedFile?.files.single.path != null) {
  //       file = File(selectedFile!.files.single.path!);
  //       // Now `file` is assigned properly
  //     }
  //
  //     if (file != null) {
  //       proofText = await uploadImageToDropbox(file);
  //     } else {
  //       print("File path was null.");
  //     }
  //   }
  //   sendToFireBase(proofText);
  // }

  Future<void> _addProof() async {
    String proofText = _proofController.text.trim();

    if (proofText.isEmpty && (selectedFile?.count ?? 0) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter proof or upload a file'),
      ));
      return;
    }

    // Handle file upload
    if ((selectedFile?.count ?? 0) > 0) {
      File? file;

      if (selectedFile?.files.single.path != null) {
        file = File(selectedFile!.files.single.path!);
      }

      if (file != null) {
        proofText = await uploadImageToDropbox(file);
        if (proofText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File upload failed. Please try again.'),
          ));
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid file. Please try again.'),
        ));
        return;
      }
    }

    // Final check before sending to Firebase
    if (proofText.isNotEmpty) {
      await sendToFireBase(proofText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Proof is empty. Not saving.'),
      ));
    }
  }


  Future<void> sendToFireBase(String proofText) async{
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
      context as BuildContext,
      MaterialPageRoute(
        builder: (context) => ChallengeTrackerPage(
          challengeId: widget.id,
        ),
      ),
    );
  }

  Future<String> uploadImageToDropbox(File file) async {
    String fileName = path.basename(file.path);
    String dropboxPath = "/${widget.userId}/Challanges/${widget.name}/$fileName";  // Saves inside App Folder

    try {
      await dotenv.load();
      var response = await http.post(
        Uri.parse("https://content.dropboxapi.com/2/files/upload"),
        headers: {
          "Authorization": "Bearer ${dotenv.env['DROPBOX_ACCESS_TOKEN']}",
          "Dropbox-API-Arg": jsonEncode({
            "path": dropboxPath,
            "mode": "add",
            "autorename": true,
            "mute": false,
          }),
          "Content-Type": "application/octet-stream",
        },
        body: await file.readAsBytes(),
      );

      if (response.statusCode == 200) {
        // String shareURL =  await getDropboxSharedLink(dropboxPath); // Get shareable link
        // return shareURL;
        return await createDropboxSharedLink(dropboxPath);
      } else {
        print("Upload failed: ${response.body}");
        return "";
      }
    } catch (e) {
      print("Error uploading: $e");
      return "";
    }
  }

  // Future<String> createDropboxSharedLink(String dropboxPath) async {
  //   final String accessToken = dotenv.env['DROPBOX_ACCESS_TOKEN'] ?? ''; // Use your own Dropbox access token
  //   const String dropboxApiUrl = 'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';
  //
  //   final response = await http.post(
  //     Uri.parse(dropboxApiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       "path": dropboxPath,
  //       "settings": {
  //         "requested_visibility": "public"
  //       }
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     String originalUrl = data['url'];
  //
  //     // Convert Dropbox's preview URL to direct download link
  //     return originalUrl.replaceAllMapped(RegExp(r'\?dl=\d'), (match) => '?raw=1');
  //
  //   } else {
  //     print("Failed to create shared link: ${response.body}");
  //     return "";
  //   }
  // }

  Future<String> createDropboxSharedLink(String dropboxPath) async {
    final String accessToken = dotenv.env['DROPBOX_ACCESS_TOKEN'] ?? '';
    const String createUrl = 'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';
    const String listUrl = 'https://api.dropboxapi.com/2/sharing/list_shared_links';

    final response = await http.post(
      Uri.parse(createUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "path": dropboxPath,
        "settings": {
          "requested_visibility": "public"
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String originalUrl = data['url'];
      return originalUrl.replaceAllMapped(RegExp(r'\?dl=\d'), (match) => '?raw=1');
    } else {
      final body = jsonDecode(response.body);
      if ((body["error_summary"] as String).startsWith("shared_link_already_exists")) {
        // Fetch existing link instead of failing
        final existingResponse = await http.post(
          Uri.parse(listUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "path": dropboxPath,
            "direct_only": true
          }),
        );

        if (existingResponse.statusCode == 200) {
          final existingData = jsonDecode(existingResponse.body);
          if (existingData["links"] != null && existingData["links"].isNotEmpty) {
            String existingUrl = existingData["links"][0]["url"];
            return existingUrl.replaceAllMapped(RegExp(r'\?dl=\d'), (match) => '?raw=1');
          }
        }

        print("Failed to fetch existing shared link: ${existingResponse.body}");
      } else {
        print("Failed to create shared link: ${response.body}");
      }
      return "";
    }
  }


  Future<String> getDropboxSharedLink(String path) async {
    var response = await http.post(
      Uri.parse("https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings"),
      headers: {
        "Authorization": "Bearer ${dotenv.env['DROPBOX_ACCESS_TOKEN']}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"path": path}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String sharablelink=data["url"];
      // Convert to direct link
      if (sharablelink.length > 4) {
        return sharablelink.substring(0, sharablelink.length - 4) + "raw=1";
      }
      return sharablelink;

    }
    var errorResponse = jsonDecode(response.body);
    if (errorResponse["error_summary"]?.contains("shared_link_already_exists") ?? false) {
      return "existingLink";
    }
    else {
      print("Error getting shared link: ${response.body}");
      return "";
    }
  }

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = result;
      });
      String filePath = result.files.single.path!;
      File file = File(filePath);
      print("\n\n\nTrying to upload file at: ${file.path}\n\n\n");
      await uploadImageToDropbox(file);
    } else {
      print("File pick cancelled.");
    }
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

              DropdownButtonFormField<String>(
                value: selectedOption,
                items: [
                  DropdownMenuItem(value: "link", child: Text("Share a Link")),
                  DropdownMenuItem(value: "file", child: Text("Upload a File")),
                ],
                hint: Text("Select an Option"),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Show input field for link
              if (selectedOption == "link")
                Column(
                  children: [

                    TextField(
                      controller: _proofController,
                      decoration: InputDecoration(
                        labelText: 'Enter Proof Text',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        final link = _proofController.text.trim();
                        if (link.isNotEmpty) {
                          // _addProof(link);
                          _addProof();
                        }
                      },
                      child: Text("Submit Link"),
                    ),
                  ],
                ),

              // Show upload button for file
              if (selectedOption == "file")
                Column(
                  children: [
                    (selectedFile?.count ?? 0) > 0
                        ? Text("File Selected")
                        : Text(""),
                    ElevatedButton.icon(
                      onPressed: _pickAndUploadFile,
                      icon: Icon(Icons.upload_file),
                      label: Text("Pick and Upload File"),
                    ),
                  ],
                ),
        
              // Proof Text Field
              // TextField(
              //   controller: _proofController,
              //   decoration: InputDecoration(
              //     labelText: 'Enter Proof Text',
              //     border: OutlineInputBorder(),
              //   ),
              // ),

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

