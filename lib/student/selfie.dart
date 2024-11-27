import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/BankDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';

class UploadSelfie extends StatefulWidget {
  const UploadSelfie({Key? key}) : super(key: key);
  @override
  _UploadSelfieState createState() => _UploadSelfieState();
}
class _UploadSelfieState extends State<UploadSelfie> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  late List<CameraDescription> _cameras;
  late CameraController? cam_controller;
  bool _isLoading = true;
  File? _image;
  var success="";

  bool isloading=false;


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _getavailableCameras();
  }
  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      // Check connectivity and get the result
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    // Update connection status based on the single ConnectivityResult
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      for (int i = 0; i < _connectionStatus.length; i++) {
        setState(() {
          isDeviceConnected = _connectionStatus[i].toString();
          print("isDeviceConnected:${isDeviceConnected}");
        });
      }
    });
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> _getavailableCameras() async {
    try {
      _cameras = await availableCameras();
      // Find the front camera
      CameraDescription? frontCamera;
      for (var camera in _cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }
      if (frontCamera != null) {
        // Initialize cam_controller with the front camera
        cam_controller = CameraController(frontCamera, ResolutionPreset.max);
        await cam_controller!.initialize();
        setState(() {
          _isLoading = false; // Update loading state after initialization
        });
      } else {
        print('No front camera found');
        setState(() {
          _isLoading = false; // Update loading state if no front camera
        });
        // Handle case where no front camera is available
      }
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _isLoading = false; // Update loading state on error
      });
      // Handle initialization errors as needed
    }
  }

  @override
  void dispose() {
    cam_controller?.dispose();
    super.dispose();
  }

  Future<void> UploadSelfie(File file) async {
    var Userid = await PreferenceService().getString('user_id');
    print("User id:${Userid}");
    if (Userid != null) {
      await UserApi.UploadSelfieApi(file, Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success == 1) {
              success="1";
              isloading=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Selfie uploaded successfully!",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>BankDetailsScreen(isKycCompleted: true)), // Replace with your next screen
              );
            }else{
                success="0";
              isloading=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${data.settings?.message??""}",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
      // Handle the case where Userid is null (if needed)
    }
  }

  @override
  Widget build(BuildContext context) {
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile") ?
      Scaffold(
      appBar: AppBar(
        title: Text('Upload Selfie'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 18, right: 18, top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStep(0),
                    _buildSeparator(0),
                    _buildStep(1),
                    _buildSeparator(1),
                    _buildStep(2),
                    _buildSeparator(2),
                    _buildStep(3),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18,right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                          "Basic",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    Expanded(
                        child: Center(
                            child: Text(
                              "Work",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              "KYC",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              "Documents",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ))),
                  ],
                ),
              ),
               SizedBox(height: 40),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFCDE2FB).withOpacity(0.25),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Get ready for your camera \n selfie capture",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Frame your face in the circle.",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: "Inter"
                      ),),
                    Text("Make sure open your eyes"),
                    const SizedBox(height:50),
                    Center(
                      child: _image == null
                          ? _isLoading?
                      CircularProgressIndicator(
                        color: Color(0xff2DB3FF),
                      ):
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: ClipOval(
                          child: AspectRatio(
                            aspectRatio: cam_controller!.value.aspectRatio,
                            child: CameraPreview(cam_controller!),
                          ),
                        ),
                      )
                          :  Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffD1D5DB),
                          border: Border.all(
                            color: success =="1" ? Colors.green :(success =="0")? Colors.red: Color(0xFFCDE2FB).withOpacity(0.25),
                            width: 2, // Border width
                          ),
                        ),
                        child: ClipOval(
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    (success=="0")?
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _getavailableCameras(); // Assuming this function gets available cameras
                          setState(() {
                            _image = null;
                            success="";// Set _image to null to clear it
                          });
                        },
                        child: Container(
                          height: 56,
                          width: 100,
                          margin: EdgeInsets.only(left: 20,right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xFF2DB3FF),
                          ),
                          child: const Center(
                            child: Text(
                              "Retake",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ):Container(),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if(isloading){

                    }else{
                      final image = await cam_controller?.takePicture();
                      setState(() {
                         isloading=true;
                        _image = File(image!.path);
                        print(_image);
                         print('File size: ${_image!.lengthSync()} bytes');
                         UploadSelfie(_image!);
                      });
                    }
                  },
                  child: Container(
                    height: 56,
                    margin: EdgeInsets.only(left: 20,right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF2DB3FF),
                    ),
                    child:  Center(
                      child:isloading
                          ? CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          :
                      Text(
                        "Upload",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ]
      ),
    ):
    NoInternetWidget();
  }

  Widget _buildStep(int stepIndex) {
    bool isCompleted = stepIndex < 3;
    Color stepColor =
    isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: stepColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
          Icons.check,
          color: Colors.white,
          size: 10,
        )
            : Text(
          (stepIndex + 1).toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(int separatorIndex) {
    bool isCompleted = separatorIndex < 3;
    Color separatorColor =
    isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
    return Expanded(
      child: Container(
        height: 2,
        color: separatorColor,
        alignment: Alignment.center,
      ),
    );
  }
}



