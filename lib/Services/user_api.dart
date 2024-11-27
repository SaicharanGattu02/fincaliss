import 'dart:convert';
import 'dart:io';
import 'package:fincalis/model/BusinessDetailsModel.dart';
import 'package:fincalis/model/EmibrakeupModel.dart';
import 'package:fincalis/model/GetCreditScoreOtpModel.dart';
import 'package:fincalis/model/GetEmployeeDetailsModel.dart';
import 'package:fincalis/model/ListOfLoanTypesModel.dart';
import 'package:fincalis/model/LoanStatusModel.dart';
import 'package:fincalis/model/OtpVerifyModel.dart';
import 'package:fincalis/model/SchoolsListModel.dart';
import 'package:fincalis/model/StudentModel.dart';
import 'package:fincalis/student/selfie.dart';
import 'package:flutter/cupertino.dart';
import '../model/AadharModel.dart';
import '../model/BasicDetailsModel.dart';
import '../model/GetBankListModel.dart';
import '../model/GetCreditScoreReportModel.dart';
import '../model/GetProfileModel.dart';
import '../model/KYCDetailsModel.dart';
import '../model/KycProcessStatusModel.dart';
import '../model/LoanApplicationInfoModel.dart';
import '../model/LoanEMITenuresModel.dart';
import '../model/LoanOverView.dart';
import '../model/NatureOfBusinessModel.dart';
import '../model/ReceiveOtp.dart';
import '../model/RegistrationTypeDetailsModel.dart';
import '../model/SubmittDataModel.dart';
import '../model/SubscriptionModel.dart';
import '../model/SubscriptioninfoModel.dart';
import '../model/UpcomingEmiModel.dart';
import '../model/UploadImageModel.dart';
import '../model/UserVerifyModel.dart';
import 'api_calls.dart';
import 'api_names.dart';
import 'other_services.dart';

class UserApi {
  // static const host = "http://192.168.0.169:8080";
  static const host = "https://fincalis-user-api-fincalis-env.up.railway.app";

  static Future<OtpVerifyModel?> verify_otp(mobile, otp,fcmToken) async {
    try {
      Map<String, String> data = {
        'mobile': (mobile).toString(),
        'otp': (otp).toString(),
        'fcm_token': (fcmToken).toString(),
      };
      print("verify_otp Data:${data}");
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final res = await post1(data, OtpVerifyApi, headers);
      if (res != null) {
        print("Otp Verify response:${res.body}");
        return OtpVerifyModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('hello bev=bug $e ');
      print(e.toString() + "error verifying");
      return null;
    }
  }

  static Future<RecieveOtp?> ReceiveOtp(String mobile) async {
    try {
      Map<String, String> data = {
        'mobile': mobile,
      };
      print("SignUp Data:${data}");

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final res = await post1(data, ReceiveOtpApi, headers);
      if (res != null) {
        print("ReceiveOtp response:${res.body}");
        return RecieveOtp.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<RecieveOtp?> ResendOtpApi(String mobile) async {
    try {
      final headers = {
        'accept': 'application/json',
      };
      // Pass an empty body to the POST request
      final res = await post2({}, '${host}/otp/resend?mobile=$mobile', headers);
      if (res != null) {
        print("ReceiveOtp response: ${res.body}");
        return RecieveOtp.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }


  static Future<SubmittDataModel?> SubmittingBasicDetailsApi(
    String fathers_name,
    String mothers_name,
    String dob,
    String marital_status,
    String address,
    String pincode,
    String gender,
    String loan_purpose,
    String profession,
    String user_id,
    String status,
  ) async {
    try {
      Map<String, String> data = {
        'father_name': fathers_name,
        'mother_name': mothers_name,
        'dob': dob,
        'marital_status': marital_status,
        'address': address,
        'pincode': pincode,
        'gender': gender,
        'loan_purpose': loan_purpose,
        'profession': profession,
        'user_id': user_id.toString(),
      };
      print("SubmittingBasicDetailsApi data:${data}");
      final headers = await getheader();
      if (status == "Insert") {
        print("Insert");
        final res = await post(
            jsonEncode(data),
            "${host}/user/basic",
            headers);
        if (res != null) {
          print("SubmittingBasicDetailsapi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } else {
        print("Update");
        final res = await put(
            jsonEncode(data), "${host}/user/basic?user_id=$user_id", headers);
        if (res != null) {
          print("SubmittingBasicDetailsapi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> SubmittingEmployeeDetailsApi(
      String company_name,
      String designation,
      String office_email,
      String work_exp,
      String company_address,
      String pincode,
      String user_id,
      String salary,
      int industry_type,
      String status,
      String mobile_number,
      ) async {
    try {
      Map<String, dynamic> data = {
        "company_name": company_name,
        "designation": designation,
        "office_email": office_email,
        "work_exp": work_exp,
        "industry_type_id": industry_type,
        "company_address": company_address,
        "pincode": pincode,
        "user_id": user_id,
        "salary": salary,
        "mobile": mobile_number,
      };
      print("SubmittingEmployeeDetailsApi Data:${data}");
      final headers = await getheader();
      if (status == "Insert") {
        final res =
            await post(jsonEncode(data), SubmittingEmployeeDetailsapi, headers);
        if (res != null) {
          print("POST SubmittingBasicDetailsapi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } else {
        final res = await put(
            jsonEncode(data), "${host}/user/company?user_id=$user_id", headers);
        if (res != null) {
          print("PUT SubmittingBasicDetailsapi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> VerifyPanNumberApi(
      String pan_number, String userid) async {
    try {
      final headers = await getheader3();
      final res = await post(
          "",
          "${host}/user/verify/pan/number?pan_number=${pan_number}&user_id=${userid}",
          headers);
      if (res != null) {
        print("VerifyPanNumberApi Response: ${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<AadharModel?> VerifyAaadharNumberApi(
      String aadhaar_number) async {
    try {
      Map<String, String> data = {
        "aadhaar_number": aadhaar_number,
      };
      print("VerifyAaadharNumberApi Data:${data}");
      final headers = await getheader();
      final res = await post1(data, VerifyAaadharNumberapi, headers);
      if (res != null) {
        print("VerifyAaadharNumberApi Response:${res.body}");
        return AadharModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> UploadPanImageApi(
      File file, String Userid) async {
    try {
      Map<String, String> data = {
        "user_id": Userid,
      };
      print("UploadPanImageApi:${data}");
      if (file == null) return null;
      final headers = await getheader1();
      final res = await postImage(data, UploadPanImageapi, headers, file);
      if (res != null && res.isNotEmpty) {
        print("UploadPanImage Response: $res");
        final parsedRes = jsonDecode(res);
        return SubmittDataModel.fromJson(parsedRes);
      } else {
        print("Null or empty response");
        return null;
      }
    } catch (e) {
      debugPrint('Error in UploadPanImageApi: $e');
      return null;
    }
  }


    static Future<SubmittDataModel?> UploadAadharImageApi(
        File file, String Userid) async {
      try {
        Map<String, String> data = {
          "user_id": Userid,
        };
        print("UploadAadharImageApi:${data}");
        if (file == null) return null;
        final headers = await getheader1();
        final res = await postImage(data, UploadAadharImageapi, headers, file);
        if (res != null && res.isNotEmpty) {
          print("UploadAadharImageApi Response: $res");
          final parsedRes = jsonDecode(res);
          return SubmittDataModel.fromJson(parsedRes);
        } else {
          print("Null or empty response");
          return null;
        }
      } catch (e) {
        debugPrint('Error in UploadPanImageApi: $e');
        return null;
      }
    }

  static Future<SubmittDataModel?> SubmittingStudentDetailsApi(
      String school_name,
      String branch,
      String student_class,
      String student_name,
      String fee,
      String guardian_name,
      String guardian_mobile,
      String user_id,
      String address,
      String status) async {
    try {
      Map<String, String> data = {
        "school_name": school_name,
        "branch": branch,
        "student_class": student_class,
        "student_name": student_name,
        "fee": fee,
        "guardian_name": guardian_name,
        "guardian_mobile": guardian_mobile,
        "user_id": user_id,
        "school_address": address,
      };
      print("SubmittingStudentDetailsApi Data:${data} and address:${address}");
      final headers = await getheader();
      if (status == "Insert") {
        final res =
            await post(jsonEncode(data), SubmittingStudentDetailsapi, headers);
        if (res != null) {
          print("SubmittingStudentDetailsApi Response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } else {
        final res = await put(
            jsonEncode(data), "${host}/user/school?user_id=$user_id", headers);
        if (res != null) {
          print("SubmittingStudentDetailsApi Response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<KycProcessStatusModel?> KycProcessStatusapi(
      String userId) async {
    try {
      final headers = await getheader();
      final res =
          await get("${host}/user/signup/level?user_id=${userId}", headers);
      if (res != null) {
        print("KycProcessStatusApi Response:${res.body}");
        return KycProcessStatusModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> UploadBankStatementApi(
      File file, String Userid) async {
    try {
      Map<String, String> data = {
        "user_id": Userid,
      };
      print("UploadPanImageApi:${data}");
      if (file == null) return null;
      final headers = await getheader2();
      final res =
          await postDocument(data, UploadBankStatementapi, headers, file);
      if (res != null && res.isNotEmpty) {
        print("UploadPanImage Response: $res");
        final parsedRes = jsonDecode(res);
        return SubmittDataModel.fromJson(parsedRes);
      } else {
        print("Null or empty response");
        return null;
      }
    } catch (e) {
      debugPrint('Error in UploadPanImageApi: $e');
      return null;
    }
  }

  static Future<BasicDetailsModel?> GetBasicDetailsApi(String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/basic?user_id=${userId}", headers);
      if (res != null) {
        print("GetBasicDetailsApi Response:${res.body}");
        return BasicDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetEmployeeDetailsModel?> GetEmployeeDetailsApi(
      String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/company?user_id=${userId}", headers);
      if (res != null) {
        print("GetEmployeeDetailsApi Response:${res.body}");
        return GetEmployeeDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<BusinessDetailsModel?> GetBusinessDetailsApi(
      String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/business?user_id=${userId}", headers);
      if (res != null) {
        print("GetBusinessDetailsApi Response:${res.body}");
        return BusinessDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<StudentModel?> GetSchoolDetailsApi(String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/school?user_id=${userId}", headers);
      if (res != null) {
        print("GetSchoolDetailsApi Response:${res.body}");
        return StudentModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> SubmitReferenceapi(
    String user_id,
    String name,
    String relation,
    String mobile,
  ) async {
    try {
      Map<String, String> data = {
        "user_id": user_id,
        "name": name,
        "relation": relation,
        "mobile": mobile,
      };
      print("SubmittingUserReferenceApi Data:${data}");
      final headers = await getheader();
      final res =
          await post(jsonEncode(data), SubmittingUserReferenceApi, headers);
      if (res != null) {
        print("SubmittingUserReferenceApi response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> SubmittBusineesDetailsApi(
    String businessname,
    String registeredaddress,
    String officialmail,
    String anualincome,
    String pincode,
    int registraationtype,
    String userid,
    String status,
    String nature_of_business,
  ) async {
    try {
      Map<String, dynamic> data = {
        "business_name": businessname,
        "registered_address": registeredaddress,
        "official_email": officialmail,
        "annual_income": anualincome,
        "pincode": pincode,
        "registration_type_id": registraationtype,
        "nature_of_business_id": nature_of_business,
        "user_id": userid,
      };
      print("BusinessDetailsApi Data:${data}");
      final headers = await getheader();
      if (status == "Insert") {
        final res =
            await post(jsonEncode(data), SubmittBusineesDetailsapi, headers);
        if (res != null) {
          print("BusinessDetailsApi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } else {
        final res = await put(jsonEncode(data),
            "${host}/user/business?user_id=${userid}", headers);
        if (res != null) {
          print("BusinessDetailsApi response:${res.body}");
          return SubmittDataModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> Consentapi(
    String UserID,
    bool status,
  ) async {
    try {
      Map<String, dynamic> data = {
        "user_id": UserID,
        "status": status,
      };
      print("ConsentApi Data:${data}");
      final headers = await getheader();
      final res = await post(jsonEncode(data), ConsentApi, headers);
      if (res != null) {
        print("ConsentApi response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<UploadImageModel?> UploadSelfieApi(
      File file, String Userid) async {
    try {

      if (file == null) return null;
      print(file);
      final headers = await getheader1();
      final res = await postImage1({},"${host}/user/liveness?user_id=${Userid}", headers, file);
      if (res != null && res.isNotEmpty) {
        print("UploadSelfieApi Response: $res");
        final parsedRes = jsonDecode(res);
        return UploadImageModel.fromJson(parsedRes);
      } else {
        print("Null or empty response");
        return null;
      }
    } catch (e) {
      debugPrint('Error in UploadPanImageApi: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> TicketsRaiseapi(
    String user_id,
    String title,
    String description,
    // String Status
  ) async {
    try {
      Map<String, String> data = {
        "user_id": user_id,
        "title": title,
        "description": description,
        "status": "open",
      };
      print("TicketsRaiseapi Data:${data}");
      final headers = await getheader();
      final res = await post(jsonEncode(data), TicketsRaiseApi, headers);
      if (res != null) {
        print("TicketsRaiseapi response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> LoanApplicationApi(
      int loan_amount,
      int emi,
      String user_id,
      ) async {
    try {
      final headers = await getheader4();
      final url = "${host}/user/loan/application?total_loan_amount=$loan_amount&monthly_emi=$emi&user_id=$user_id";
      // Send an empty body
      final res = await post3({}, url, headers);

      if (res != null && res.body != null) {
        print("LoanApplicationApi Response: ${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoanEMITenuresModel?>SelectLoanAmountApi(
       int loan_amount,
       String user_id,
       ) async {
     try {
       final headers = await getheader();
       final res = await post("","${host}/user/select/loan/application?loan_amount=${loan_amount}&user_id=${user_id}",
           headers);
       if (res != null) {
         print("LoanApplicationApi1 Response:${res.body}");
         return LoanEMITenuresModel.fromJson(jsonDecode(res.body));
       } else {
         print("Null Response");
         return null;
       }
     } catch (e) {
       debugPrint('Error: $e');
       return null;
     }
   }

  static Future<LoanApplicationInfoModel?> GetLoanApplicationInfoApi(
    String user_id,
  ) async {
    try {
      final headers = await getheader();
      final res = await get(
          "${host}/user/loan/application/info?user_id=${user_id}", headers);
      if (res != null) {
        print("GetLoanApplicationInfoApi Response:${res.body}");
        return LoanApplicationInfoModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<RegistrationTypeDetailsModel?>
      GetRegistrationDetialsApi() async {
    try {
      final headers = await getheader();
      final res = await get("${host}/user/registration/type", headers);
      if (res != null) {
        print("GetRegistrationDetialsApi Response:${res.body}");
        return RegistrationTypeDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<NatureOfBusinessModel?> GetNatueOfBusinessDetailsApi() async {
    try {
      final headers = await getheader();
      final res = await get("${host}/user/business/nature", headers);
      if (res != null) {
        print("GetNatueOfBusinessDetailsApi Response:${res.body}");
        return NatureOfBusinessModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<ListOfLoanTypesModel?> GetListOfLoanTypesApi() async {
    try {
      final headers = await getheader();
      final res = await get("${host}/user/loan/type", headers);
      if (res != null) {
        print("GetListOfLoanTypesApi Response:${res.body}");
        return ListOfLoanTypesModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<KYCDetailsModel?> GetKycDetailsApi(String user_id) async {
    try {
      final headers = await getheader();
      final res =
          await get("${host}/user/kyc/details?user_id=${user_id}", headers);
      if (res != null) {
        print("GetKycDetailsApi Response:${res.body}");
        return KYCDetailsModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<OtpVerifyModel?> VerifyAadharOTPApi(
    String aadhar,
    String otp,
    String id,
    String user_id,
  ) async {
    try {
      print("VerifyAadharOTPApi Data:${aadhar},${otp},${id},${user_id}");
      final headers = await getheader();
      final res = await post(
          "",
          "${host}/user/verify/aadhaar/otp?otp=${otp}&TransID=${id}&user_id=${user_id}&aadhaar_number=${aadhar}",
          headers);
      if (res != null) {
        print("VerifyAadharOTPApi Response:${res.body}");
        return OtpVerifyModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoanStatusModel?> GettingLoanStatusAPI(String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get(
          "${host}/user/loan/status?user_id=${userId}",
          headers);
      if (res != null) {
        print("GettingLoanStatusAPI Response:${res.body}");
        return LoanStatusModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> SelectLoanTypeAPI(
      int user_id, int id) async {
    try {
      final headers = await getheader();
      final res = await post("","${host}/user/select/loan/type?loan_id=${id}&user_id=${user_id}", headers);
      if (res != null) {
        print("SelectLoanTypeAPI Response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<LoanOverView?> GetLoanOverViewAPI(String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/loan/overview?user_id=${userId}", headers);
      if (res != null) {
        print("GetLoanOverView Response:${res.body}");
        return LoanOverView.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> BankTransferApi(
    String user_id,
    String accountnumber,
    String ifsc,
  ) async {
    try {
      Map<String, String> data = {
        "user_id": user_id,
        "account_number": accountnumber,
        "ifsc_code": ifsc,
      };
      print("BankTransferApi Data:${data}");
      final headers = await getheader();
      final res = await post(
          jsonEncode(data),
          '${host}/user/verify/bank?user_id=${user_id}&account_number=${accountnumber}&ifsc_code=${ifsc}',
          headers);
      if (res != null) {
        print("BankTransferApi response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetProfileModel?> GetProfileApi(String userId) async {
    try {
      final headers = await getheader();
      print("UserID:${userId}");
      print("Host url:${host}");
      final res = await get("${host}/user/profile?user_id=${userId}", headers);
      if (res != null) {
        print("GetProfileApi Response:${res.body}");
        return GetProfileModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> ProfileApi(
      String Userid, String Email, String Fullname, File? image) async {
    try {
      print("Called ProfileApi");
      final headers = await getheader();
      final res = await postImage2({},
          "${host}/user/profile?user_id=${Userid}&email=${Email}&full_name=${Fullname}",
          headers,
          image);
      if (res != null) {
        print("ProfileApi response:${res}");
        return SubmittDataModel.fromJson(jsonDecode(res));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetBankListModel?> GetBankListApi() async {
    try {
      final headers = await getheader();

      print("Host url:${host}");
      final res = await get("${host}/user/bank/name", headers);
      if (res != null) {
        print("GetBankListApi Response:${res.body}");
        return GetBankListModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> submitContactApi(
      File file, String userId) async {
    try {
      final headers =
          await getheader(); // Ensure this method returns the headers including Authorization
      final res = await postImage3(
        {},
        "${host}/user/contact?user_id=${userId}",
        headers,
        file,
      );

      // Handle the response based on its type
      final responseJson = jsonDecode(res) as Map<String, dynamic>;
      if (responseJson.containsKey('data')) {
        final result = responseJson['data']['result'] as Map<String, dynamic>;
        print("submitContactApi response: ${result}");
        return SubmittDataModel.fromJson(result);
      } else {
        print("Response does not contain 'data' key");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubmittDataModel?> SendigUserLatlongsApi(
    String user_id,
    String latitude,
    String longitude,
    String address,
  ) async {
    try {
      Map<String, String> data = {
        "user_id": user_id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
      print("SendigUserLatlongsApi Data:${data}");
      final headers = await getheader();
      final res = await post(jsonEncode(data), SendigUserLatlongsapi, headers);
      if (res != null) {
        print("SendigUserLatlongsApi response:${res.body}");
        return SubmittDataModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<UserVerifyModel?> GetUserVerifyApi(String userId) async {
    try {
      final headers = await getheader();
      print("Host url:${host}");
      final res = await get('${host}/subscription/pre/info?user_id=${userId}', headers);
      if (res != null) {
        print("GetUserVerifyApi Response:${res.body}");
        return UserVerifyModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<SubscriptionModel?> SubmitUserVerifyApi(
      String user_id,
      String name,
      String mobile,
      String email,
      String account_number,
      String accountHolderName,
      String ifsc
      ) async {
    try {
      final headers = await getheader();
      final res = await post(
          "",
          "${host}/subscription/plan/subscription?user_id=${user_id}&name=${name}&mobile=${mobile}&email=${email}&account_number=${account_number}&account_holder_name=${accountHolderName}&ifsc_code=${ifsc}",
          headers);
      if (res != null) {
        print("SubmitUserVerifyApi response:${res.body}");
        return SubscriptionModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<EmibrakeupModel?>EmibreakupdetailsApi(
      String user_id,
      ) async {
    try {
      final headers = await getheader();
      final res = await get(
          "${host}/user/emi/breakup?user_id=${user_id}", headers);
      if (res != null) {
        print("EmibreakupdetailsApi Response:${res.body}");
        return EmibrakeupModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetCreditScoreOtpModel?> GetCreditScoreOTPApi(String user_id,) async {
    try {
      Map<String, String> data = {
        "user_id": user_id
      };
      final headers = await getheader();
        final res =
        await post(jsonEncode(data), '${host}/user/credit?user_id=${user_id}', headers);
        if (res != null) {
          print("GetCreditScoreOTPApi Response:${res.body}");
          return GetCreditScoreOtpModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }

    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<GetCreditScoreReportModel?> GetCreditScoreOTPVerificationApi(String otp,String transid,String userid) async {
    try {
      final headers = await getheader();
      final res =
      await post("",'${host}/user/credit/otp/verification?user_id=${userid}&otp=${otp}&tsTransID=${transid}', headers);
      if (res != null) {
        print("GetCreditScoreOTPVerificationApi Response:${res.body}");
        return GetCreditScoreReportModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }

    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

   static Future<GetCreditScoreReportModel?> CreditScoreDetailsSubmittingApi(String userid,transID,password) async {
     try {
       final headers = await getheader();
       final res =
       await put("",'${host}/user/credit/report/password?user_id=${userid}&credit_report_password=${password}&transaction_id=${transID}', headers);
       if (res != null) {
         print("CreditScoreDetailsSubmittingApi Response:${res.body}");
         return GetCreditScoreReportModel.fromJson(jsonDecode(res.body));
       } else {
         print("Null Response");
         return null;
       }
     } catch (e) {
       debugPrint('Error: $e');
       return null;
     }
   }

    static Future<SchoolsListModel?>GetSchoolnamesApi() async {
      try {
        final headers = await getheader();
        final res = await get("${host}/user/school/name", headers);
        if (res != null) {
          print("GetSchoolnamesApi Response:${res.body}");
          return SchoolsListModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } catch (e) {
        debugPrint('Error: $e');
        return null;
      }
    }

    static Future<GetBankListModel?>GetTransactionHistoryApi(String userid) async {
      try {
        final headers = await getheader();
        final res = await get("${host}/user/transaction/history?user_id=${userid}", headers);
        if (res != null) {
          print("GetTransactionHistoryApi Response:${res.body}");
          return GetBankListModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } catch (e) {
        debugPrint('Error: $e');
        return null;
      }
    }


    static Future<GetBankListModel?>GetBannersApi() async {
      try {
        final headers = await getheader();
        final res = await get("${host}/user/banner", headers);
        if (res != null) {
          print("GetBannersApi Response:${res.body}");
          return GetBankListModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } catch (e) {
        debugPrint('Error: $e');
        return null;
      }
    }

    static Future<UpcomingEmiModel?>UpcomingEmiApi(
        String user_id,
        ) async {
      try {
        final headers = await getheader();
        final res = await get(
            "${host}/user/upcoming/emi?user_id=${user_id}", headers);
        if (res != null) {
          print("UpcomingEmiApi Response:${res.body}");
          return UpcomingEmiModel.fromJson(jsonDecode(res.body));
        } else {
          print("Null Response");
          return null;
        }
      } catch (e) {
        debugPrint('Error: $e');
        return null;
      }
    }

   static Future<SubmittDataModel?>RegistrationApi(String name,String email,String Userid) async {
     try {
       print("${name},${email},${Userid}");
       final headers = await getheader();
       final res = await put("",'${host}/user/registration?user_id=${Userid}&full_name=${name}&email=${email}', headers);
       if (res != null) {
         print("RegistrationApi response:${res.body}");
         return SubmittDataModel.fromJson(jsonDecode(res.body));
       } else {
         print("Null Response");
         return null;
       }
     } catch (e) {
       debugPrint('Error: $e');
       return null;
     }
   }

  static Future<SubscriptioninfoModel?> GettingSubscriptionStatusApi(String userId) async {
    try {
      final headers = await getheader();
      final res = await get(
          "${host}/subscription/subscription/info?user_id=${userId}", headers);
      if (res != null) {
        print("GettingSubscriptionStatusApi Response:${res.body}");
        return SubscriptioninfoModel.fromJson(jsonDecode(res.body));
      } else {
        print("Null Response");
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

}
