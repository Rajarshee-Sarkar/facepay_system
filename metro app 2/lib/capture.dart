// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'services/api_service.dart';

// class CapturePage extends StatefulWidget {
//   const CapturePage({Key? key}) : super(key: key);

//   @override
//   State<CapturePage> createState() => _CapturePageState();
// }

// class _CapturePageState extends State<CapturePage> {
//   File? _image;
//   bool _isUploading = false;
//   String? _uploadStatus;
//   String? _stationId;
//   String? _stationType;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     if (args != null) {
//       _stationId = args['stationId'] as String?;
//       _stationType = args['stationType'] as String?;
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker()
//         .pickImage(source: ImageSource.camera, imageQuality: 80);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _sendDataToServer() async {
//     if (_image == null || _stationId == null || _stationType == null) {
//       setState(() {
//         _uploadStatus =
//             'Please capture an image and ensure station details are available.';
//       });
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//       _uploadStatus = null;
//     });

//     try {
//       bool success = await ApiService.sendStationData(
//         stationId: _stationId!,
//         stationType: _stationType!,
//         imageFile: _image!,
//       );
//       setState(() {
//         _uploadStatus = success ? 'Access Granted!' : 'Access Denied!';
//       });
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Error uploading image: $e';
//       });
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xF3FDFEFF),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF673AB7), // Metro Purple
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(40),
//                   bottomRight: Radius.circular(40),
//                 ),
//               ),
//               padding: const EdgeInsets.only(top: 60, bottom: 20),
//               child: const Center(
//                 child: Text('Capture Picture',
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (_stationId != null && _stationType != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Text(
//                   'Station ID: $_stationId\nType: $_stationType',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             const SizedBox(height: 24),
//             Container(
//               width: 250,
//               height: 300,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade400, width: 2),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: _image == null
//                   ? const Center(
//                       child: Icon(Icons.camera_enhance,
//                           size: 100, color: Colors.grey))
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(14),
//                       child: Image.file(_image!,
//                           fit: BoxFit.cover, width: 250, height: 300),
//                     ),
//             ),
//             const SizedBox(height: 24),
//             IconButton(
//               icon: const Icon(Icons.camera_alt,
//                   size: 40, color: Color(0xFF673AB7)),
//               onPressed: _pickImage,
//               tooltip: 'Take Photo',
//             ),
//             const SizedBox(height: 32),
//             if (_isUploading)
//               const CircularProgressIndicator()
//             else
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF673AB7),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   textStyle: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: _image == null ? null : _sendDataToServer,
//                 child: const Text('Upload Data'),
//               ),
//             if (_uploadStatus != null)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(_uploadStatus!,
//                     style: TextStyle(
//                         color: _uploadStatus!.contains('successful')
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


























import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({Key? key}) : super(key: key);

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  File? _image;
  bool _isUploading = false;
  String? _uploadStatus;
  String? _stationId;
  String? _stationType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _stationId = args['stationId'] as String?;
      _stationType = args['stationType'] as String?;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendDataToServer() async {
    if (_image == null || _stationId == null || _stationType == null) {
      setState(() {
        _uploadStatus =
            'Please capture an image and ensure station details are available.';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = null;
    });

    try {
      bool success = await ApiService.sendStationData(
        stationId: _stationId!,
        stationType: _stationType!,
        imageFile: _image!,
      );
      setState(() {
        _uploadStatus = success ? 'Access Granted!' : 'Access Denied!';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error uploading image: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF3FDFEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF673AB7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: const Center(
                child: Text('Capture Picture',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ),
            const SizedBox(height: 24),
            
            // Station Details
            if (_stationId != null && _stationType != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Station ID: $_stationId\nType: $_stationType',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            const SizedBox(height: 24),
            
            // Image Preview
            Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _image == null
                  ? const Center(
                      child: Icon(Icons.camera_enhance,
                          size: 100, color: Colors.grey),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(_image!,
                          fit: BoxFit.cover, width: 250, height: 300),
                    ),
            ),
            const SizedBox(height: 24),
            
            // Camera Button
            IconButton(
              icon: const Icon(Icons.camera_alt,
                  size: 40, color: Color(0xFF673AB7)),
              onPressed: _pickImage,
              tooltip: 'Take Photo',
            ),
            
            const SizedBox(height: 32),
            
            // Upload Button / Loading
            if (_isUploading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _image == null ? null : _sendDataToServer,
                child: const Text('Upload Data'),
              ),
            
            // Status Text
            if (_uploadStatus != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_uploadStatus!,
                    style: TextStyle(
                      color: _uploadStatus == 'Access Granted!'
                          ? Colors.green
                          : _uploadStatus == 'Access Denied!'
                              ? Colors.red
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
