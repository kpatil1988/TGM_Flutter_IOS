import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/api_service.dart';
import 'dart:convert';

class LogMoodScreen extends StatefulWidget {
  @override
  _LogMoodScreenState createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends State<LogMoodScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  // Controllers and state for mood logs
  final TextEditingController morningMoodNoteController = TextEditingController();
  final TextEditingController nightMoodNoteController = TextEditingController();
  List<String> moodTagsList = []; // Tags fetched from the API
  List<String> morningSelectedTags = [];
  List<String> nightSelectedTags = [];
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    apiService = ApiService();
    _fetchMoodTags(); // Fetch mood tags on initialization
  }

  Future<void> _fetchMoodTags() async {
    try {
      final tags = await apiService.get('/api/moods');
      setState(() {
        if (tags is List) {
          // Map tags from the API into a list of strings for display
          moodTagsList = List<String>.from(tags.map((tag) => tag['moodName'] as String));
        }
      });
    } catch (e) {
      print('Error fetching mood tags: $e');
    }
  }

  /// Submit Mood Log
  Future<void> _sendMoodLog({
    required String logType,
    required String messagePrefix,
    required TextEditingController moodNoteController,
    required List<String> selectedTags,
  }) async {
    // Body to send in the API call
    final body = {
      'moodTagsChosen': selectedTags,
      'moodNote': moodNoteController.text,
      'moodLogType': logType,
    };

    try {
      // Make API call
      final response = await apiService.post('/api/users/mood', body);

      // Handle success based on HTTP status code
      if (response != null && response['message'] == 'Success') {
        print("$messagePrefix Mood Log Submitted Successfully!");

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$messagePrefix Log Submitted Successfully!')),
        );

        // Reset form state
        moodNoteController.clear(); // Clear the mood text
        selectedTags.clear(); // Clear the selected tags

        // Force a widget rebuild by calling setState()
        setState(() {});
      } else {
        // If response message is not success, show this
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$messagePrefix Mood Log Submission Failed!')),
        );
      }
    } catch (error) {
      print("Error while doing a post request ::: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  /// Initiate listening for input (Speech-to-Text)
  void _listen(TextEditingController controller) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          setState(() {
            _isListening = val == 'listening';
          });
        },
        onError: (val) => print('Error: $val'),
      );
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  /// Build mood entry section (Reusable for Morning/Night logs)
  Widget _buildMoodEntrySection({
    required String title,
    required String logType,
    required String messagePrefix,
    required TextEditingController moodNoteController,
    required List<String> selectedTags,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Mood Note', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: moodNoteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: 'Enter your mood note...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isListening ? Icons.radio_button_checked : Icons.mic_none, color: _isListening ? Colors.red : Colors.grey),
                onPressed: () => _listen(moodNoteController),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('Mood Tags', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          MultiSelectDialogField(
            items: moodTagsList.map((tag) => MultiSelectItem<String>(tag, tag)).toList(),
            title: Text("Select Tags"),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.grey),
            ),
            buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
            searchable: true,
            onConfirm: (results) {
              setState(() {
                selectedTags.clear();
                selectedTags.addAll(results.cast<String>());
              });
            },
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: Icon(Icons.cancel, size: 18),
                onDeleted: () {
                  setState(() {
                    selectedTags.remove(tag);
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: moodNoteController.text.isNotEmpty && selectedTags.isNotEmpty
                  ? () => _sendMoodLog(
                        logType: logType,
                        messagePrefix: messagePrefix,
                        moodNoteController: moodNoteController,
                        selectedTags: selectedTags,
                      )
                  : null,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Morning Log and Night Log
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log Mood"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Morning Log'),
              Tab(text: 'Night Log'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab for Morning Log
            SingleChildScrollView(
              child: _buildMoodEntrySection(
                title: 'Morning Log',
                logType: 'morning_log',
                messagePrefix: 'Morning',
                moodNoteController: morningMoodNoteController,
                selectedTags: morningSelectedTags,
              ),
            ),
            // Tab for Night Log
            SingleChildScrollView(
              child: _buildMoodEntrySection(
                title: 'Night Log',
                logType: 'night_log',
                messagePrefix: 'Night',
                moodNoteController: nightMoodNoteController,
                selectedTags: nightSelectedTags,
              ),
            ),
          ],
        ),
      ),
    );
  }
}