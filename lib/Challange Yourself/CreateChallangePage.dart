import 'package:flutter/material.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({Key? key}) : super(key: key);

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _challengeNameController = TextEditingController();
  final TextEditingController _challengeDurationController = TextEditingController();
  final TextEditingController _challengeMotiveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Challenge")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Challenge Name
              Text(
                "Challenge Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField(
                controller: _challengeNameController,
                hintText: "Enter challenge name",
              ),

              SizedBox(height: 20),

              // Challenge Duration
              Text(
                "Challenge Duration (days)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField(
                controller: _challengeDurationController,
                hintText: "Enter duration in days",
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),

              // Challenge Motive
              Text(
                "Challenge Motive",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField(
                controller: _challengeMotiveController,
                hintText: "Enter challenge motive",
              ),

              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process form data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Challenge Created Successfully!")),
                      );
                    }
                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a custom styled TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.lightBlue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Circular shape
          borderSide: BorderSide.none, // Remove default border
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill in this field';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _challengeNameController.dispose();
    _challengeDurationController.dispose();
    _challengeMotiveController.dispose();
    super.dispose();
  }
}
