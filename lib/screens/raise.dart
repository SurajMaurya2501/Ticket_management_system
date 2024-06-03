import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_management/screens/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Raise extends StatefulWidget {
  const Raise({super.key});

  @override
  State<Raise> createState() => _RaiseState();
}

class _RaiseState extends State<Raise> {
  final workController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final roomController = TextEditingController();
  final assetController = TextEditingController();
  final remarkController = TextEditingController();
  final List<String> serviceProviders = [
    'Provider A',
    'Provider B',
    'Provider C',
    'Provider D',
  ];

  String? _selectedServiceProvider;
  String ticketID = '';

  @override
  void dispose() {
    workController.dispose();
    buildingController.dispose();
    floorController.dispose();
    roomController.dispose();
    assetController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Center(child: Text('Raise Ticket')),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Ticket #: 12345',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    customTextField('Work', workController),
                    customTextField('Building', buildingController),
                    customTextField('Floor', floorController),
                    customTextField('Room', roomController),
                    customTextField('Asset', assetController),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: _selectedServiceProvider,
                      items: serviceProviders.map((String provider) {
                        return DropdownMenuItem(
                          value: provider,
                          child: Text(provider),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedServiceProvider = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Service Provider',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Remark:-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: remarkController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Remarks',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Imagepick()));
                    },
                    child: Text('Pick Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      generateTicketID();
                      storeRaisedTicket(ticketID);
                    },
                    child: Text('Save'),
                  ),
                  Text(
                    _getCurrentDate(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            )),
      ),
    );
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  String generateTicketID() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(9999);
    ticketID = '#$random';
    return ticketID;
  }

  Future<void> storeRaisedTicket(String ticketID) async {
    await FirebaseFirestore.instance
        .collection("raisedTickets")
        .doc(ticketID)
        .set({
      "work": workController.text,
      "building": buildingController.text,
      "floor": floorController.text,
      "room": roomController.text,
      "asset": assetController.text,
      "remark": remarkController.text
    });

    print("Data Stored Succesfully");
  }
}
