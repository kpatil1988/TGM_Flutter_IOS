import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class InstantScreen extends StatefulWidget {
  @override
  _InstantScreenState createState() => _InstantScreenState();
}

class _InstantScreenState extends State<InstantScreen> {
  late stt.SpeechToText _speech; // Use late initialization
  bool _isListening = false;
  String _voiceText = "";

  final TextEditingController moodNoteController = TextEditingController();
  final List<String> moodTagsList = ["Happy", "Sad", "Energetic", "Calm", "Anxious", "Relaxed"];
  List<String> selectedMoodTags = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Check-In'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                "We're here for you",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextLabel('Mood Note'),
            _buildVoiceInputBox(),
            SizedBox(height: 16),
            _buildTextLabel('Mood Tags'),
            MultiSelectDialogField(
              items: moodTagsList.map((tag) => MultiSelectItem<String>(tag, tag)).toList(),
              title: Text("Mood Tags"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              searchable: true,
              onConfirm: (results) {
                setState(() {
                  selectedMoodTags = results.cast<String>();
                });
              },
            ),
            SizedBox(height: 16),
            _buildSelectedMoods(),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Mood Note: ${moodNoteController.text}');
                  print('Mood Tags: $selectedMoodTags');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Soothe Me!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildVoiceInputBox() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: moodNoteController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your mood note here or use voice input',
            ),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: _listen,
        ),
      ],
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceText = val.recognizedWords;
            moodNoteController.text = _voiceText;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Widget _buildSelectedMoods() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: selectedMoodTags.map((mood) {
        return Chip(
          label: Text(mood),
          onDeleted: () {
            setState(() {
              selectedMoodTags.remove(mood);
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
          padding: EdgeInsets.symmetric(horizontal: 8),
        );
      }).toList(),
    );
  }
}