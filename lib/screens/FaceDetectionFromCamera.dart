// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:camera/camera.dart';
// import 'dart:typed_data';
// import 'dart:io';
//
// import 'FaceDetection.dart';
//
// class FaceDetectionFromCamera extends StatefulWidget {
//   @override
//   _FaceDetectionFromCameraState createState() => _FaceDetectionFromCameraState();
// }
//
// class _FaceDetectionFromCameraState extends State<FaceDetectionFromCamera> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   FaceDetection faceDetection = FaceDetection();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     _controller = CameraController(_cameras![0], ResolutionPreset.high);
//     await _controller!.initialize();
//     _controller!.startImageStream(_processCameraImage);
//     setState(() {});
//   }
//
//   void _processCameraImage(CameraImage image) async {
//     final inputImage = _convertCameraImage(image, _controller!.description);
//     final faces = await faceDetection.detectFaces(inputImage);
//
//     for (Face face in faces) {
//       if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
//         if (face.leftEyeOpenProbability! > 0.8 && face.rightEyeOpenProbability! > 0.8) {
//           print("Both eyes are open");
//         }
//       }
//       if (face.smilingProbability != null) {
//         if (face.smilingProbability! > 0.8) {
//           print("Person is smiling");
//         }
//       }
//       // Add additional checks as needed
//     }
//   }
//
//   InputImage _convertCameraImage(CameraImage image, CameraDescription description) {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//
//     final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//
//     final InputImageRotation imageRotation = _rotationIntToImageRotation(description.sensorOrientation);
//     final InputImageFormat inputImageFormat = InputImageFormatMethods.fromRawValue(image.format.raw) ?? InputImageFormat.NV21;
//
//     final planeData = image.planes.map(
//           (Plane plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList();
//
//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );
//
//     return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
//   }
//
//   InputImageRotation _rotationIntToImageRotation(int rotation) {
//     switch (rotation) {
//       case 90:
//         return InputImageRotation.Rotation_90deg;
//       case 180:
//         return InputImageRotation.Rotation_180deg;
//       case 270:
//         return InputImageRotation.Rotation_270deg;
//       default:
//         return InputImageRotation.Rotation_0deg;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }
//     return CameraPreview(_controller!);
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }
