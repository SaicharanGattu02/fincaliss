import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture; // Changed to nullable Future

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      // Obtain a list of the available cameras
      List<CameraDescription> cameras = await availableCameras();
      // Get the front camera
      var frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      // Initialize the CameraController
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );

      // Ensure that the CameraController is initialized
      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture; // Wait until the controller is initialized
      // Construct the path where the image should be saved
      final Directory extDir = await getTemporaryDirectory();
      final String dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${DateTime.now()}.png';
      // Attempt to take a picture
      await _controller.takePicture();
      // Print statement to verify the file path
      print('Picture saved to $filePath');
      // Wait a brief moment to ensure file write operation completes
      await Future.delayed(Duration(milliseconds: 500));
      // Verify that the file exists before navigation (optional, for safety)
      File imageFile = File(filePath);
      if (await imageFile.exists()) {
        // Navigate to the DisplayPictureScreen to display the picture
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: filePath),
          ),
        );
      } else {
        print('File does not exist: $filePath');
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a selfie')),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to initialize camera: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: ClipOval(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 20.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: _takePicture,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
