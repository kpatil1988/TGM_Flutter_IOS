import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For file handling
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Input controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // State variables
  String? selectedGender; // Ensuring gender dropdown value is of type String
  String? userTimeZone;
  File? _profileImage;
  bool isLoading = true;
  bool isSaving = false;
  bool isLocationLoading = false;

  // Interests
  final List<String> availableInterests = [
    "Music",
    "Sports",
    "Reading",
    "Traveling",
    "Cooking",
  ];
  Map<String, bool> interests = {};

  final ApiService apiService = ApiService(); // API service instance

  @override
  void initState() {
    super.initState();
    _fetchTimeZone();
    _fetchProfileData();
    for (var interest in availableInterests) {
      interests[interest] = false; // Initialize all interests as unchecked
    }
  }

  // Fetching time zone
  Future<void> _fetchTimeZone() async {
    try {
      final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      setState(() {
        userTimeZone = currentTimeZone;
      });
    } catch (e) {
      setState(() {
        userTimeZone = 'Unknown';
      });
      print("Error fetching timezone: $e");
    }
  }

  // Fetch Profile data from the API
  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.get("/api/users/profile");
      if (response != null) {
        setState(() {
          firstNameController.text = response['firstName'] ?? '';
          lastNameController.text = response['lastName'] ?? '';
          birthDateController.text = response['birthDate'] ?? '';
          selectedGender = response['gender']; // Make sure this is a String
          cityController.text = response['city'] ?? '';
          stateController.text = response['state'] ?? '';
          countryController.text = response['country'] ?? '';

          if (response['selected_interests'] != null) {
            for (var interest in availableInterests) {
              interests[interest] =
                  (response['selected_interests'].contains(interest));
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile data: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save Profile Data to API
  Future<void> _saveProfile() async {
    setState(() {
      isSaving = true;
    });

    final profileData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'birthDate': birthDateController.text,
      'gender': selectedGender,
      'city': cityController.text,
      'state': stateController.text,
      'country': countryController.text,
      'timezone': userTimeZone,
      'interests': interests.keys
          .where((key) => interests[key] == true)
          .toList(), // Only selected interests
    };

    try {
      final response = await apiService.put("/api/users/profile", profileData);
      if (response != null && response['message'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  // Location Autofill
  Future<void> _autofillLocation() async {
    setState(() {
      isLocationLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception("Location permission denied.");
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          cityController.text = place.locality ?? '';
          stateController.text = place.administrativeArea ?? '';
          countryController.text = place.country ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error autofilling location: $e")),
      );
    } finally {
      setState(() {
        isLocationLoading = false;
      });
    }
  }

  // Picking Profile Picture
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!) as ImageProvider
                                : const AssetImage("assets/images/placeholder.png"),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form fields
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: birthDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Birth Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          birthDateController.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stateController,
                    decoration: const InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: countryController,
                    decoration: const InputDecoration(
                      labelText: "Country",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLocationLoading ? null : _autofillLocation,
                    child: isLocationLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Autofill Location"),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Interests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...availableInterests.map((interest) {
                    return CheckboxListTile(
                      title: Text(interest),
                      value: interests[interest],
                      onChanged: (bool? value) {
                        setState(() {
                          interests[interest] = value ?? false;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isSaving ? null : _saveProfile,
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Changes"),
                  ),
                ],
              ),
            ),
    );
  }
}