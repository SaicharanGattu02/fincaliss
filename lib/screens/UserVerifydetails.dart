import 'package:fincalis/screens/AutheticationPending.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:fincalis/screens/pendingDisbursalScreen.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';

class Userverifydetails extends StatefulWidget {
  const Userverifydetails({super.key});

  @override
  State<Userverifydetails> createState() => _UserverifydetailsState();
}

class _UserverifydetailsState extends State<Userverifydetails> {
  bool is_loading = true;
  bool _isLoading = false;

  String name = "";
  String phone = "";
  String email = "";
  String accountNumber = "";
  String accountHolderName = "";
  String ifsc = "";
  String bank_name = "";

  String authLink="";

  @override
  void initState() {
    GetBankDetails();
    super.initState();
  }

  Future<void> GetBankDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    print("GetBankDetails hhhakjk");
    await UserApi.GetUserVerifyApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              is_loading=false;

              name = data.data?.result?.name ?? "";
              phone = data.data?.result?.phone ?? "";
              email = data.data?.result?.email ?? "";
              accountNumber = data.data?.result?.accountNumber ?? "";
              bank_name = data.data?.result?.bankName ?? "";
              accountHolderName =
                  data.data?.result?.accountHolderName ?? "";
              ifsc = data.data?.result?.ifsc ?? "";
              print("account details are fetched");
            } else {
              is_loading=false;
              print("account details are fetched");
            }
          })
        }
    });
  }

  Future<void> SubmitUserVerifyapi() async {
    var Userid = await PreferenceService().getString('user_id');

    await UserApi.SubmitUserVerifyApi(Userid!, name,phone,email, accountNumber, accountHolderName, ifsc).then((data)=>{
      if( data != null){
        setState(() {
          if (data.settings?.success == 1) {
            _isLoading=false;
            authLink=data.data?.result?.authLink??"";
            _launchURL();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthenticationPending()),
            );
            Flashbar(context, "Subscription plan Created successfully!", "subscription1");
          } else{
            setState(() {
              _isLoading=false;
            });
            Flashbar(context, "${data.settings?.message}!", "subscription2");
          }
        })
      }

    });
  }

  void _launchURL() async {
    if (await canLaunch(authLink)) {
      await launch(authLink);
    } else {
      throw 'Could not launch $authLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return is_loading
        ? Center(
      child: CircularProgressIndicator(
        color: Color(0xff2DB3FF),
      ),
    )
        : Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.7,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFCDE2FB).withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bank Account Details for verification",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoRow("Name", name),
                  const SizedBox(height: 20),
                  _buildInfoRow("Phone Number", phone),
                  const SizedBox(height: 20),
                  _buildInfoRow("Bank Name", bank_name),
                  const SizedBox(height: 20),
                  _buildInfoRow("Account Number", accountNumber),
                  const SizedBox(height: 20),
                  _buildInfoRow("IFSC Code", ifsc),
                  const SizedBox(height: 20),
                  _buildInfoRow("A/c Holder Name", accountHolderName),
                  SizedBox(height: screenHeight * 0.13),
                  Text(
                    "Note: Please find above the bank details for your reference. Kindly review them and proceed with creating the subscription plan.",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_isLoading) {
                    return;
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    SubmitUserVerifyapi();
                  }
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2DB3FF),
                  ),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text(
                      "Continue",
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
          ],
        ),
      ),
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Container(
          width: MediaQuery.of(context).size.width * 0.4, // Fixed width for the label
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 20),
        // Value
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

}