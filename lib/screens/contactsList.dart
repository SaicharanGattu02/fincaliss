import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ContactUploader extends StatefulWidget {
  @override
  _ContactUploaderState createState() => _ContactUploaderState();
}

class _ContactUploaderState extends State<ContactUploader> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      _retrieveContacts();
    } else {
      // Handle the case where the user denied the permission
      print("Permission denied");
    }
  }

  Future<void> _retrieveContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  Future<void> _uploadContacts() async {
    // Format the contacts data
    List<Map<String, dynamic>> contactsData = _contacts.map((contact) {
      return {
        'displayName': contact.displayName,
        'phones': contact.phones?.map((phone) => phone.value).toList(),
        // 'emails': contact.emails?.map((email) => email.value).toList(),
      };
    }).toList();

    // Upload the contacts to the API
    var response = await http.post(
      Uri.parse('https://your-api-endpoint.com/upload-contacts'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'contacts': contactsData}),
    );

    if (response.statusCode == 200) {
      print("Contacts uploaded successfully");
    } else {
      print("Failed to upload contacts: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  subtitle: Text(
                    (contact.phones?.isNotEmpty ?? false)
                        ? contact.phones!.first.value!
                        : '',
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _uploadContacts,
            child: Text('Upload Contacts'),
          ),
        ],
      ),
    );
  }
}
