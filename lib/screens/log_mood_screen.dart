import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/api_service.dart';

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

  // Store all fetched questions from the API
  List<Map<String, dynamic>> allQuestions = []; // Store questions for both logs
  String? selectedMorningAnswer; // Variable to hold selected answer for morning logs
  String? selectedNightAnswer;   // Variable to hold selected answer for night logs

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    apiService = ApiService();
    _fetchMoodTags(); // Fetch mood tags on initialization
    _fetchQuestions(); // Fetch questions for mood logs
  }

  Future<void> _fetchMoodTags() async {
    try {
      final tags = await apiService.get('/api/moods');
      setState(() {
        if (tags is List) {
          moodTagsList = List<String>.from(tags.map((tag) => tag['moodName'] as String));
        }
      });
    } catch (e) {
      print('Error fetching mood tags: $e');
    }
  }

  Future<void> _fetchQuestions() async {
    try {
      final questionsResponse = await apiService.get('/api/questionaire/mood_log');

      // Safely cast the response to List<Map<String, dynamic>>
      if (questionsResponse is List) {
        setState(() {
          allQuestions = List<Map<String, dynamic>>.from(questionsResponse); // Cast to the correct type
        });
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  /// Submit Mood Log
  Future<void> _sendMoodLog({
    required String logType,
    required String messagePrefix,
    required TextEditingController moodNoteController,
    required List<String> selectedTags,
  }) async {
    // Determine which key to use for the selected answer based on log type
    String answerKey = logType == 'morning_log' ? 'mlSleep' : 'nlDay';
    String? selectedAnswer = logType == 'morning_log' ? selectedMorningAnswer : selectedNightAnswer;

    final body = {
      'moodTagsChosen': selectedTags,
      'moodNote': moodNoteController.text,
      'moodLogType': logType,
      answerKey: selectedAnswer, // Send as a single string value rather than a list
    };

    try {
      final response = await apiService.post('/api/users/mood', body);

      if (response != null && response['message'] == 'Success') {
        print("$messagePrefix Mood Log Submitted Successfully!");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$messagePrefix Log Submitted Successfully!')),
        );

        // Clear mood note and selected tags after submission
        moodNoteController.clear(); 
        selectedTags.clear();
        selectedMorningAnswer = null; // Clear the selected answer for morning log
        selectedNightAnswer = null; // Clear the selected answer for night log

        setState(() {}); // Force a widget rebuild
      } else {
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
    // Filter questions based on the log type
    List<Map<String, dynamic>> filteredQuestions = allQuestions.where((question) {
      return question['questionaireType'] == logType;
    }).toList();

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

          // Display questions based on the selected log type
          if (filteredQuestions.isNotEmpty) ...filteredQuestions.map((question) {
            List<String> answers = List<String>.from(question['answer'] ?? []); // List of answers
            String? currentAnswer = logType == 'morning_log' ? selectedMorningAnswer : selectedNightAnswer; // Use corresponding variable

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question['question'], style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Select an answer"),
                  value: currentAnswer,
                  items: answers.isNotEmpty 
                      ? answers.map((answer) {
                          return DropdownMenuItem<String>(
                            value: answer,
                            child: Text(answer),
                          );
                        }).toList()
                      : [
                          DropdownMenuItem<String>(
                            value: '', // Provide empty string if no answers are available
                            child: Text('No answers available'),
                          ),
                        ],
                  onChanged: (String? newValue) {
                    setState(() {
                      if (logType == 'morning_log') {
                        selectedMorningAnswer = newValue; // Store the answer for morning log
                      } else {
                        selectedNightAnswer = newValue; // Store the answer for night log
                      }
                    });
                  },
                ),
              ],
            );
          }).toList(),

          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _canSubmit(logType)
                  ? () => _sendMoodLog(
                        logType: logType,
                        messagePrefix: messagePrefix,
                        moodNoteController: moodNoteController,
                        selectedTags: selectedTags,
                      )
                  : null, // Disable if not all questions have answers
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit(String logType) {
    // Check if an answer for the selected logType has been given
    if (logType == 'morning_log') {
      return selectedMorningAnswer != null && selectedMorningAnswer!.isNotEmpty; // Check for morning answer
    } else {
      return selectedNightAnswer != null && selectedNightAnswer!.isNotEmpty; // Check for night answer
    }
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