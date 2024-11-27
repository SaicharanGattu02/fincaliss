import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown with Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  String? selectedItem;
  final List<String> items = [
    "State Bank of India (SBI)",
        "Punjab National Bank (PNB)",
        "Bank of Baroda",
        "Canara Bank",
        "Union Bank of India",
        "Bank of India",
        "Indian Bank",
        "Central Bank of India",
        "Indian Overseas Bank",
        "UCO Bank",
        "HDFC Bank",
        "ICICI Bank",
        "Axis Bank",
        "Kotak Mahindra Bank",
        "Yes Bank",
        "IDFC FIRST Bank",
        "IndusInd Bank",
        "Bandhan Bank",
        "Federal Bank",
        "RBL Bank",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown with Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller:searchController ,
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0,
                    height: 1.2,
                    color: Color(0xffAFAFAF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Color(0xffffffff),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                    BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                    BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) {
                return items.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily:"Inter",
                      fontWeight: FontWeight.w400
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  selectedItem = suggestion;
                  searchController.text=selectedItem!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an item';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              selectedItem != null ? 'Selected item: $selectedItem' : 'No item selected',
              style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
