import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/classes/FirstLetterCaps.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:fincalis/utils/ShakeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../Services/other_services.dart';


class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  File? _image;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodeMobileNumber = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();

  String _validateFullName = "";
  String _validateNumber = "";
  String _validateEmail = "";
  bool is_loading = false;
  String profile_image="";
  var image_picked = 0;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        image_picked=1;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    GetPrifileData();
    super.initState();
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

  @override
  void dispose() {
    _focusNodeFullName.dispose();
    _focusNodeMobileNumber.dispose();
    _focusNodeEmail.dispose();
    _nameController.dispose();
    // _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  Future<void> updateUserProfile(File? image) async {
    final userId = await PreferenceService().getString('user_id');
    final sessionid = await PreferenceService().getString("token");

    final url = Uri.parse('http://192.168.0.169:8000/user/profile?user_id=${userId}&email=${_emailController.text}&full_name=${_nameController.text}');

    // Create a new multipart request
    var request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer ${sessionid}'
      ..headers['accept'] = 'application/json';

    // Add the profile image field if an image is provided
    if (image != null) {
      // Determine MIME type of the file
      print('Entered');
      final mimeType = lookupMimeType(image.path);
      final contentType = mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream'); // Fallback

      // Add file to multipart request
      request.files.add(await http.MultipartFile.fromPath('profile_img', image.path, contentType: contentType));
    } else {
      // No image provided
      // You can omit this field or add an empty field if required by your API
      request.fields['profile_img'] = ''; // Optionally you could omit this line
    }

    // Send the request
    var response = await request.send();

    // Check the response
    if (response.statusCode == 200) {
      print('Request successful');

      var responseData = await response.stream.bytesToString();
      print(responseData);
      // Parse the JSON response
      final responseJson = jsonDecode(responseData);

      // Handle the parsed response
      if (responseJson['success'] == 1) {
        setState(() {
          is_loading = false;
        });
        Navigator.pop(context);
        // Handle success (e.g., show a message, navigate to another screen)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile details updated successfully!",
              style: TextStyle(color: Color(0xff000000)),
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFFCDE2FB),
          ),
        );
      } else {
        setState(() {
          is_loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Profile details updating failed!",
            style: TextStyle(color: Color(0xff000000)),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFFCDE2FB),
        ));
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      var responseData = await response.stream.bytesToString();
      print(responseData);
    }
  }


  // Future<void> updateUserProfile() async {
  //   var Userid = await PreferenceService().getString('user_id');
  //   // int userIdInt = int.parse(Userid!);
  //   await UserApi.ProfileApi(Userid!,_emailController.text,_nameController.text,_image)
  //       .then((data) => {
  //     if (data != null)
  //       {
  //         setState(() {
  //           if (data.success == 1) {
  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               content: Text(
  //                 "Basic Details submitted successfully!",
  //                 style: TextStyle(color: Color(0xff000000)),
  //               ),
  //               duration: Duration(seconds: 1),
  //               backgroundColor: Color(0xFFCDE2FB),
  //             ));
  //           }else{
  //
  //           }
  //         })
  //       }
  //   });
  // }




  Future<void> GetPrifileData() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetProfileApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              _emailController.text = (data.data?.result?.email ?? "");
              _nameController.text=(data.data?.result?.fullName ?? "");
                profile_image=(data.data?.result?.image ?? "");

              print("Profile Data Fetched");
            } else {
              print("Profile Not Fetched");
            }
          })
        }
    });
  }

  void _validateFields() {
    setState(() {
      is_loading = true;
      _validateFullName =
      _nameController.text.isEmpty ? "Please enter a valid full name" : "";
      _validateEmail = !_isValidEmail(_emailController.text)
          ? "Please enter a valid email address"
          : "";
    });

    if (_validateFullName.isEmpty &&
        _validateNumber.isEmpty &&
        _validateEmail.isEmpty) {
      updateUserProfile(_image);
    } else {
      setState(() {
        is_loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields",
            style: TextStyle(color: Color(0xff000000)),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFFCDE2FB),
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String nameInitial = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()[0].toUpperCase()
        : "";

    return (isDeviceConnected == "ConnectivityResult.wifi" || isDeviceConnected == "ConnectivityResult.mobile")
        ? Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 30,
        title: const Text(
          'Profile Details',
          style: TextStyle(
            color: Color(0xFF000000),
            fontWeight: FontWeight.w600,
            fontSize: 24,
            fontFamily: "Poppins",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none, // Ensure the Stack can handle overflow
                children: [
                  // if(image_picked==1)...[
                  //   CircleAvatar(
                  //     radius: 60,
                  //     backgroundColor: Color(0xff80C4E9),
                  //     backgroundImage:(_image != null ? FileImage(_image!) : null), // Fallback to null if no image is available
                  //     child: _image == null
                  //         ? Text(
                  //       nameInitial,
                  //       style: const TextStyle(
                  //         fontSize: 50,
                  //         color: Color(0xffFFF6E9), // Optional: set color if needed
                  //       ),
                  //     )
                  //         : null,
                  //   ),
                  // ]else...[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xff80C4E9),
                      backgroundImage: profile_image != null
                          ? NetworkImage(profile_image!) as ImageProvider<Object> // Network image
                          : null,
                      child: profile_image == ""
                          ? Text(
                        nameInitial,
                        style: const TextStyle(
                          fontSize: 50,
                          color: Color(0xffFFF6E9), // Optional: set color if needed
                        ),
                      )
                          : null,
                    ),
                 // ],
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: GestureDetector(
                  //     onTap: _pickImage,
                  //     child: CircleAvatar(
                  //       radius: 18,
                  //       backgroundColor: Colors.grey,
                  //       child: Icon(
                  //         Icons.edit,
                  //         color: Color(0xffffffff),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Name",
                _nameController,
                TextInputType.text,
                _validateFullName,
                _focusNodeFullName,
                r'^[a-zA-Z\s]+$',
                0,
                [CapitalizationInputFormatter()],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Email",
                _emailController,
                TextInputType.emailAddress,
                _validateEmail,
                _focusNodeEmail,
                r'[a-zA-Z0-9@._-]',
                0,
                [],
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  if(is_loading){

                  }else{
                    _validateFields();
                  }
                },
                child: Container(
                  width: 240,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2DB3FF),
                  ),
                  child: Center(
                    child: is_loading
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        :
                    Text(
                      "Save",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : NoInternetWidget();
  }


  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      String validationMessage,
      FocusNode focus,
      String pattern,
      int length,
      List<TextInputFormatter> additionalFormatters,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          focusNode: focus,
          keyboardType: keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(pattern)),
            if (length > 0) LengthLimitingTextInputFormatter(length),
            ...additionalFormatters,
          ],
          onTap: () {
            setState(() {
              if (label == "Name") _validateFullName = "";
              if (label == "Mobile number") _validateNumber = "";
              if (label == "Email") _validateEmail = "";
            });
          },
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 0,
            height: 1.2,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: "Enter your $label",
            hintStyle: const TextStyle(
              fontSize: 15,
              letterSpacing: 0,
              height: 1.2,
              color: Color(0xffAFAFAF),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
        ),
        if (validationMessage.isNotEmpty)
          ShakeWidget(
            key: Key(label),
            duration: const Duration(milliseconds: 700),
            child: Text(
              validationMessage,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}