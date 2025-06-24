import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Multiple server URLs to try
  static const List<String> serverUrls = [
    'http://10.230.246.23:5000',
    'http://10.0.2.2:5000', // Android emulator to localhost
    'http://localhost:5000',
    'http://127.0.0.1:5000',
  ];

  static String get baseUrl => serverUrls[0]; // Primary URL

  /// Test server connectivity with multiple URLs
  static Future<Map<String, dynamic>> testConnection() async {
    Map<String, dynamic> results = {};

    for (String url in serverUrls) {
      try {
        print('Testing connection to: $url');
        final response = await http.get(
          Uri.parse('$url/'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 5));

        results[url] = {
          'status': response.statusCode,
          'body': response.body,
          'success': response.statusCode == 200,
        };
        print('✅ $url: Status ${response.statusCode}');

        if (response.statusCode == 200) {
          break; // Found working server
        }
      } catch (e) {
        results[url] = {
          'error': e.toString(),
          'success': false,
        };
        print('❌ $url: $e');
      }
    }

    return results;
  }

  /// Find working server URL
  static Future<String?> findWorkingServer() async {
    final results = await testConnection();
    for (String url in serverUrls) {
      if (results[url]?['success'] == true) {
        print('🎯 Found working server: $url');
        return url;
      }
    }
    print('❌ No working server found');
    return null;
  }

  /// Sends captured face image plus station metadata to the Flask endpoint.
  ///
  /// * [stationId]      – e.g. 'S1'
  /// * [stationType]    – 'source' (entry) or 'destination' (exit)
  /// * [imageFile]      – image captured via camera / gallery
  ///
  /// Returns true on 200 + "success":true, otherwise throws.
  static Future<bool> sendCaptureData(
    String stationId,
    String stationType,
    File imageFile,
  ) async {
    // Find working server first
    final workingUrl = await findWorkingServer();
    if (workingUrl == null) {
      throw Exception(
          'No server available. Check server URLs and network connection.');
    }

    final url = Uri.parse('$workingUrl/destination');
    print('📤 Sending data to: $url');
    print('📋 Station ID: $stationId, Type: $stationType');

    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      // Get file size
      final fileSize = await imageFile.length();
      print('📁 Image file size: ${fileSize} bytes');

      // Create multipart request
      final request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['station_id'] = stationId;
      request.fields['station_type'] = stationType;
      request.fields['timestamp'] = DateTime.now().toIso8601String();

      // Add image file
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      print('🚀 Sending request...');

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout after 30 seconds');
        },
      );

      print('📥 Response status: ${streamedResponse.statusCode}');
      print('📥 Response headers: ${streamedResponse.headers}');

      // Read response body
      final responseBody = await streamedResponse.stream.bytesToString();
      print('📥 Response body: $responseBody');

      // Parse response
      Map<String, dynamic> responseJson;
      try {
        responseJson = jsonDecode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Invalid JSON response: $responseBody');
      }

      // Check response
      if (streamedResponse.statusCode == 200) {
        if (responseJson['success'] == true) {
          print('✅ Server request successful');
          return true;
        } else {
          final errorMsg = responseJson['error'] ??
              responseJson['message'] ??
              'Unknown server error';
          throw Exception('Server returned success=false: $errorMsg');
        }
      } else {
        final errorMsg = responseJson['error'] ??
            responseJson['message'] ??
            'HTTP ${streamedResponse.statusCode}';
        throw Exception(
            'Server error ${streamedResponse.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ API call failed: $e');
      rethrow;
    }
  }

  /// Simple test endpoint
  static Future<bool> testSimpleEndpoint() async {
    final workingUrl = await findWorkingServer();
    if (workingUrl == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$workingUrl/test'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'test': 'data'}),
          )
          .timeout(const Duration(seconds: 10));

      print(
          'Test endpoint response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test endpoint failed: $e');
      return false;
    }
  }

  static Future<bool> uploadBiometric({
    required String userId,
    required String userName,
    required File imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/biometric');
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['user_id'] = userId
        ..fields['user_name'] = userName
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> sendStationData({
    required String stationId,
    required String stationType,
    required File imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/destination');
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['station_id'] = stationId
        ..fields['station_type'] = stationType
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
