import 'package:flutter/material.dart';

class FlipTheStory extends StatefulWidget {
  const FlipTheStory({Key? key}) : super(key: key);

  @override
  _FlipTheStoryState createState() => _FlipTheStoryState();
}

class _FlipTheStoryState extends State<FlipTheStory> {
  bool isFlipped = false;
  final TextEditingController inputController = TextEditingController();
  String alertMessage = "";

  void handleSubmit() {
    if (inputController.text.length > 2000) {
      setState(() {
        alertMessage = "Maximum character limit is 2000!";
      });
    } else {
      setState(() {
        alertMessage =
            "Your wishes are already granted... better ride the appreciation tide!";
        inputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flip the Story")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isFlipped)
              Column(
                children: [
                  const Text(
                    "Flip the Story",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFlipped = true;
                      });
                    },
                    child: const Text("Flip the Story"),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    "Now you have flipped the story. Go ahead and script your heart here.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: inputController,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Type your new story here...",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    child: const Text(
                        "I promise to live my new story from now on!"),
                  ),
                  if (alertMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        alertMessage,
                        style:
                            const TextStyle(color: Colors.indigo, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}