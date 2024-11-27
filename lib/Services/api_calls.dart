
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
//
// Future<http.Response?> post(Map<String, dynamic> data, String urlLink,
//     Map<String, String> headers) async {
//   http.Response? response;
//   debugPrint(DateTime.now().toString());
//   try {
//     response = await http.post(Uri.parse(urlLink), headers: headers, body: data);
//     // jsonEncode(data)
//     //log("Customer Response is ${response.body}");
//   } catch (e) {
//     debugPrint(e.toString());
//   }
//   //print("Post RESPONSE BODY IS ${response?.statusCode}");
//   return response;
// }

Future<http.Response?> post1(Map<String, String> data, String urlLink,
    Map<String, String> headers) async {
  http.Response? response;
  try {
    Uri uri = Uri.parse(urlLink).replace(queryParameters: data);
    response = await http.post(uri, headers: headers);
  } catch (e) {
    debugPrint('Error posting data: $e');
  }
  return response;
}

Future<http.Response?> post2(Map<String, String> data, String urlLink,
    Map<String, String> headers) async {
  http.Response? response;
  try {
    Uri uri = Uri.parse(urlLink); // No need to replace query parameters if they are already included in the URL
    response = await http.post(uri, headers: headers);
  } catch (e) {
    debugPrint('Error posting data: $e');
  }
  return response;
}

Future<http.Response?> post3(Map<String, dynamic> data, String urlLink, Map<String, String> headers) async {
  http.Response? response;
  try {
    print("URL: $urlLink");
    print("Headers: $headers");
    Uri uri = Uri.parse(urlLink);

    // Convert the body to JSON string (empty in this case)
    final body = jsonEncode(data);

    // Send the request with an empty body
    response = await http.post(
      uri,
      headers: headers,
      body: body,
    );
  } catch (e) {
    debugPrint('Error posting data: $e');
  }
  return response;
}



Future<http.Response?> post(String data, String urlLink, Map<String, String> headers) async {
  http.Response? response;
  try {
    print("${urlLink}");
    response = await http.post(Uri.parse(urlLink), headers: headers, body: data);
  } catch (e) {
    debugPrint('Error posting data: $e');
  }
  return response;
}

Future<http.Response?> put(String data, String urlLink, Map<String, String> headers) async {
  http.Response? response;
  try {
    response = await http.put(Uri.parse(urlLink), headers: headers, body: data);
  } catch (e) {
    debugPrint('Error putting data: $e');
  }
  return response;
}


Future<http.Response?> get(String urlLink, Map<String, String> headers) async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse(urlLink),
      headers: headers,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
  //log("Get RESPONSE BODY IS ${response?.body}");
  return response;
}

// Future<String?> postImage(Map<String, String> body, String urlLink,
//     Map<String, String> headers, File image) async {
//   try {
//     var req = http.MultipartRequest('POST', Uri.parse(urlLink));
//     req.headers.addAll(headers);
//     req.files.add(await http.MultipartFile.fromPath('file', image.path));
//     req.fields.addAll(body);
//
//     var res = await req.send();
//     final resBody = await res.stream.bytesToString();
//
//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       print("**** $resBody .... $res");
//       return resBody;
//     } else {
//       print("error: ${res.reasonPhrase}");
//       return null;
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//     return null;
//   }
// }
//
// Future<String> postImage(Map<String, String> body, String urlLink,
//     Map<String, String> headers, File image) async {
//   try {
//     print(image);
//     var req = http.MultipartRequest('POST', Uri.parse(urlLink));
//     req.headers.addAll(headers);
//     req.files.add(await http.MultipartFile.fromPath('file', image.path));
//     req.fields.addAll(body);
//
//     var res = await req.send();
//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       final resBody = await res.stream.bytesToString();
//       print("**** $resBody .... $res");
//       return resBody;
//     } else {
//       print("error: ${res.reasonPhrase}");
//       return ''; // Handle error case by returning appropriate value
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//     return ''; // Handle error case by returning appropriate value
//   }
// }

Future<String> postImage(Map<String, String> body, String urlLink,
    Map<String, String> headers, File image) async {
  try {
    String? mimeType = lookupMimeType(image.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      print('Selected file is not a valid image.');
      return mimeType!;
    }
    var req = http.MultipartRequest('POST', Uri.parse(urlLink));
    req.headers.addAll(headers);
    req.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType.parse(mimeType), // Parse the MIME type
      ),
    );
    req.fields.addAll(body);

    var res = await req.send();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final resBody = await res.stream.bytesToString();
      print("**** $resBody .... $res");
      return resBody;
    } else {
      print("Error: ${res.reasonPhrase}");
      return ''; // Handle error case by returning appropriate value
    }
  } catch (e) {
    debugPrint(e.toString());
    return ''; // Handle error case by returning appropriate value
  }
}

Future<String> postImage1(Map<String, String> body, String urlLink,
    Map<String, String> headers, File image) async {
  try {
    print('File size: ${image!.lengthSync()} bytes');
    String mimeType = lookupMimeType(image.path)!;
    print("MediaType:${MediaType.parse(mimeType)}");
    var req = http.MultipartRequest('POST', Uri.parse(urlLink));
    req.headers.addAll(headers);
    req.files.add(
      await http.MultipartFile.fromPath(
        'file_img',
        image.path,
        contentType: MediaType.parse(mimeType),
      ),
    );
    req.fields.addAll(body);

    var res = await req.send();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final resBody = await res.stream.bytesToString();
      print("Successful response: $resBody");
      return resBody;
    } else {
      final resBody = await res.stream.bytesToString();
      print("Error response: ${res.statusCode} ${res.reasonPhrase} $resBody");
      return 'Error: ${res.statusCode} ${res.reasonPhrase}';
    }
  } catch (e) {
    print("Exception during request: $e");
    return 'Exception during request: $e';
  }
}


Future<String> postImage2(
    Map<String, String> body, String urlLink,
    Map<String, String> headers, File? image) async {
  try {
    // Create a multipart request
    var uri = Uri.parse(urlLink);
    var req = http.MultipartRequest('PUT', uri);
    req.headers.addAll(headers);

    // Add fields to the request
    req.fields.addAll(body);

    // Add the profile image field if an image is provided
    if (image != null) {
      // Determine MIME type of the file
      print('Entered');
      final mimeType = lookupMimeType(image.path);
      final contentType = mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream'); // Fallback

      // Add file to multipart request
      req.files.add(await http.MultipartFile.fromPath('profile_img', image.path, contentType: contentType));
    } else {
      // No image provided
      // You can omit this field or add an empty field if required by your API
      req.fields['profile_img'] = ''; // Optionally you could omit this line
    }

    // Send the request
    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print("Successful response: $resBody");
      return resBody;
    } else {
      print("Error response: ${res.statusCode} ${res.reasonPhrase} $resBody");
      return 'Error: ${res.statusCode} ${res.reasonPhrase}';
    }
  } catch (e) {
    print("Exception during request: $e");
    return 'Exception during request: $e';
  }
}


Future<String> postImage3(
    Map<String, String> body, String urlLink,
    Map<String, String> headers, File file) async {
  try {
    String mimeType = lookupMimeType(file.path) ?? 'application/octet-stream'; // Ensure mimeType is not null
    var req = http.MultipartRequest('POST', Uri.parse(urlLink)); // Use POST method
    final fileBytes = await file.readAsBytes();

    req.headers.addAll(headers);

    req.files.add(http.MultipartFile.fromBytes(
      'contact_json', // Field name
      fileBytes,
      filename: file.path.split('/').last,
      contentType: MediaType('application', 'json'), // Set the content type as application/json
    ));

    req.fields.addAll(body);

    var res = await req.send();

    // Check response status and handle accordingly
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final resBody = await res.stream.bytesToString();
      print("Successful response: $resBody");
      return resBody;
    } else {
      // Log and return error response
      final resBody = await res.stream.bytesToString();
      print("Error response: ${res.statusCode} ${res.reasonPhrase} $resBody");
      return 'Error: ${res.statusCode} ${res.reasonPhrase} $resBody';
    }
  } catch (e) {
    // Handle any exceptions that occur during the request
    print("Exception during request: $e");
    return 'Exception during request: $e';
  }
}



Future<String?> PostMultipleImages(Map<String, String> body, String urlLink,
    Map<String, String> headers, List<http.MultipartFile> newList) async {
  try {
    var req = http.MultipartRequest('POST', Uri.parse(urlLink));
    req.headers.addAll(headers);
    req.files.addAll(newList);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print("**** $resBody .... $res");
      return resBody;
    } else {
      print("error: ${res.reasonPhrase}");
      return null;
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}


Future<String> postDocument(Map<String, String> body, String urlLink,
    Map<String, String> headers, File document) async {
  try {
    String? mimeType = lookupMimeType(document.path);
    if (mimeType == null || !mimeType.startsWith('application/pdf')) {
      print('Selected file is not a valid PDF document.');
      return 'Selected file is not a valid PDF document.';
    }
    var req = http.MultipartRequest('POST', Uri.parse(urlLink));
    req.headers.addAll(headers);
    req.files.add(
      await http.MultipartFile.fromPath(
        'file',
        document.path,
        contentType: MediaType.parse('application/pdf'), // Set the MIME type for PDF
      ),
    );
    req.fields.addAll(body);

    var res = await req.send();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final resBody = await res.stream.bytesToString();
      print("**** $resBody");
      return resBody;
    } else {
      print("Error: ${res.reasonPhrase}");
      return ''; // Handle error case by returning appropriate value
    }
  } catch (e) {
    print('Error uploading document: $e');
    return ''; // Handle error case by returning appropriate value
  }
}

