import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class HealthSyncScreen extends StatefulWidget {
  const HealthSyncScreen({Key? key}) : super(key: key);

  @override
  _HealthSyncScreenState createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends State<HealthSyncScreen> {
  bool _isSyncing = false;
  String _statusMessage = "";
  
  // Define health data types for Android and iOS
  final List<HealthDataType> _dataTypesIOS = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.WATER,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.WEIGHT,
  ];


  final List<HealthDataType> _dataTypesAndroid = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.WATER,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.WEIGHT,
  ];

  Future<void> _syncHealthData() async {
    setState(() {
      _isSyncing = true;
      _statusMessage = "Syncing health data, please wait...";
    });

    try {
      // Initialize the health client
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Determine the list of health data types based on the platform
      final List<HealthDataType> dataTypes = Platform.isIOS ? _dataTypesIOS : _dataTypesAndroid;
      final health = Health();

      
      // Request authorization to read health data
      final isAuthorized = await health.requestAuthorization(dataTypes);
       print("aaaaaa:::$isAuthorized");
      if (isAuthorized) {
        // Fetch the health data for the last day
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startTime: yesterday,
          endTime: now,
          types: dataTypes,
        );

        // Remove duplicates
        final uniqueHealthData = healthData.toSet().toList();

        // Convert health data to a map for easier processing
        Map<String, dynamic> healthMap = {};
        for (var dataPoint in uniqueHealthData) {
          var key = dataPoint.type.name;
          healthMap[key] = dataPoint.value;
        }

        // Ensure user is logged in
        final userId = Provider.of<AuthProvider>(context, listen: false).user?.sessionId;
        if (userId == null) {
          setState(() {
            _statusMessage = "User is not logged in.";
            _isSyncing = false;
          });
          return;
        }

        // Prepare the data for sending to the backend API
        final responseData = {
          "userId": userId,
          "data": {
            "steps": healthMap['STEPS'] ?? 0,
            "caloriesBurned": healthMap['ACTIVE_ENERGY_BURNED'] ?? 0,
            "caloriesConsumed": healthMap['DIETARY_ENERGY_CONSUMED'] ?? 0,
            "heartRate": healthMap['HEART_RATE'] ?? 0,
            "sleepHours": healthMap['SLEEP_ASLEEP'] ?? 0,
            "water": healthMap['WATER'] ?? 0,
            "distance": healthMap['DISTANCE_WALKING_RUNNING'] ?? 0,
            "bloodPressureSystolic": healthMap['BLOOD_PRESSURE_SYSTOLIC'] ?? 0,
            "bloodPressureDiastolic": healthMap['BLOOD_PRESSURE_DIASTOLIC'] ?? 0,
            "bloodOxygen": healthMap['BLOOD_OXYGEN'] ?? 0,
            "weight": healthMap['WEIGHT'] ?? 0,
          },
        };

        // Send the data to your backend API
        final apiService = ApiService();
        await apiService.post('/api/users/healthSync', responseData);
       
        setState(() {
          _statusMessage = "Health data synced successfully!";
        });
      } else {
        setState(() {
          _statusMessage = "Failed to get permissions from the health app.";
        });
      }
    } catch (e) {
      print("Error ::::$e");
      setState(() {
        _statusMessage = "Failed to sync health data: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Sync"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sync your health data with your app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSyncing ? null : _syncHealthData,
              child: _isSyncing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sync Now"),
            ),
            
            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: _statusMessage.contains("Failed") ? Colors.red : Colors.green,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}