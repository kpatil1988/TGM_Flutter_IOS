import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../services/api_service.dart';


class InstantScreen extends StatefulWidget {
  @override
  _InstantScreenState createState() => _InstantScreenState();
}

class _InstantScreenState extends State<InstantScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false; // Track whether TTS is speaking
  String _voiceText = "";
  final TextEditingController moodNoteController = TextEditingController();
  List<String> moodTagsList = [];
  List<String> selectedMoodTags = [];
  late ApiService apiService;
  String? _selectionError;
  String _apiResponse = "";
  String _exerciseTitle = "";
  String _exerciseInstructions = "";
  double _speechSpeed = 0.5; // Default speech speed
  final ScrollController _scrollController = ScrollController();

  // Available speech speeds
  List<double> _availableSpeeds = [0.1, 0.2, 0.3, 0.4, 0.5];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    apiService = ApiService();
    _fetchMoodTags();
    _setInitialSpeechParams(); // Initialize Speech Parameters
  }

  Future<void> _setInitialSpeechParams() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(_speechSpeed); // Set initial speech speed
  }

  Future<void> _fetchMoodTags() async {
    try {
      final tags = await apiService.get('/api/moods');
      if (tags is List) {
        setState(() {
          moodTagsList = List<String>.from(tags.map((tag) => tag['moodName'] as String));
        });
      } else {
        throw Exception('Unexpected response type: ${tags.runtimeType}');
      }
    } catch (e) {
      print('Error fetching mood tags: $e');
    }
  }

  Future<void> _sendMoodLog() async {
    final body = {
      'moodTagsChosen': selectedMoodTags,
      'moodNote': moodNoteController.text,
      'moodLogType': 'instant',
    };

    try {
      final response = await apiService.post('/api/users/mood', body);
      setState(() {
        _apiResponse = 'Success: ${response.toString()}';

        if (response is Map) {
          _exerciseTitle = response['title'] ?? '';
          _exerciseInstructions = response['exercise'] ?? '';
        }
      });
    } catch (error) {
      setState(() {
        _apiResponse = 'Error: $error';
      });
    }
  }

  Future<void> _speakResponse() async {
    String textToSpeak = "${_exerciseTitle}. ${_exerciseInstructions}";
    await _flutterTts.setSpeechRate(_speechSpeed); // Set speech speed when speaking
    await _flutterTts.speak(textToSpeak);
  }

  void _toggleSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      // Call _speakResponse when play button is pressed
      await _speakResponse();
      setState(() {
        _isSpeaking = true;
      });
    }
  }

  void _changeSpeechSpeed(double newSpeed) async {
    if (_isSpeaking) {
      await _flutterTts.stop(); // Pause TTS if it's currently speaking
      setState(() {
        _isSpeaking = false; // Update speaking status
      });
    }

    setState(() {
      _speechSpeed = newSpeed; // Update speech speed
      _flutterTts.setSpeechRate(_speechSpeed); // Set speech rate to the TTS
    });
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
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              buttonIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
              searchable: true,
              onConfirm: (results) {
                if (results.length > 5) {
                  setState(() {
                    _selectionError = 'You can select a maximum of 5 moods.';
                  });
                  return; 
                } else {
                  setState(() {
                    _selectionError = null; 
                    selectedMoodTags = results.cast<String>();
                  });
                }
              },
            ),
            if (_selectionError != null) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _selectionError!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 16),
            _buildSelectedMoods(),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _shouldEnableButton() ? _sendMoodLog : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Soothe Me!', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 24),
            if (_apiResponse.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    // Display the exercise in a fancy way
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _exerciseTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _exerciseInstructions,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Play/Pause button for TTS
              Center(
                child: ElevatedButton.icon(
                  onPressed: _toggleSpeaking,
                  icon: Icon(_isSpeaking ? Icons.pause : Icons.play_arrow),
                  label: Text(_isSpeaking ? 'Pause' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Dropdown to adjust speech speed
              Text('Speech Speed: ${_speechSpeed.toStringAsFixed(1)}x'),
              DropdownButton<double>(
                value: _speechSpeed,
                items: _availableSpeeds.map((double speed) {
                  return DropdownMenuItem<double>(
                    value: speed,
                    child: Text('${speed.toString()}x'),
                  );
                }).toList(),
                onChanged: (double? newSpeed) {
                  if (newSpeed != null) {
                    _changeSpeechSpeed(newSpeed); // Change speech speed and pause TTS
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _shouldEnableButton() {
    return moodNoteController.text.isNotEmpty && selectedMoodTags.isNotEmpty;
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your mood note here or use voice input',
            ),
            style: TextStyle(fontSize: 14, color: Colors.black),
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
        onStatus: (val) {
          setState(() {
            _isListening = val == 'listening';
          });
          print('Speech recognition status: $val');
        },
        onError: (val) {
          setState(() {
            _isListening = false;
          });
          print('Error: $val');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceText = val.recognizedWords;
            moodNoteController.text = _voiceText;
            print('Recognized words: $_voiceText');
          }),
        );
      } else {
        print('Speech recognition not available');
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
              if (selectedMoodTags.isEmpty) {
                _selectionError = null; // Clear selection error if no tags
              }
            });
          },
          deleteIcon: Icon(Icons.close, size: 16),
          padding: EdgeInsets.symmetric(horizontal: 8),
        );
      }).toList(),
    );
  }
}