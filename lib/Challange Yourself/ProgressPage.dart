import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  final String name;
  final String duration;
  final String motive;

  const ProgressPage({
    Key? key,
    required this.name,
    required this.duration,
    required this.motive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Duration: $duration',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Motive: $motive',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
