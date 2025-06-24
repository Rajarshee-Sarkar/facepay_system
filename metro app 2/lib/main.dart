import 'package:flutter/material.dart';
import 'capture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metro App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/capture': (context) => const CapturePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStationId;
  String _stationType = 'source';

  // Station data with ID and name
  final Map<String, String> _stations = {
    'S1': 'Sealdah',
    'S2': 'Phoolbagan',
    'S3': 'Salt Lake Stadium',
    'S4': 'Bengal Chemical',
    'S5': 'City Centre',
    'S6': 'Central Park',
    'S7': 'Karunamoyee',
    'S8': 'Salt Lake Sector V',
  };

  void _navigateToCapturePage() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        '/capture',
        arguments: {
          'stationId': _selectedStationId,
          'stationType': _stationType,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.train, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text(
                  'Metro Station Entry',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField<String>(
                  value: _selectedStationId,
                  decoration: const InputDecoration(
                    labelText: 'Select Station',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a station';
                    }
                    return null;
                  },
                  items: _stations.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text('${entry.key} (${entry.value})'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStationId = newValue;
                    });
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Station Type',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Source'),
                              value: 'source',
                              groupValue: _stationType,
                              onChanged: (value) {
                                setState(() {
                                  _stationType = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Destination'),
                              value: 'destination',
                              groupValue: _stationType,
                              onChanged: (value) {
                                setState(() {
                                  _stationType = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _navigateToCapturePage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Proceed to Capture'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}