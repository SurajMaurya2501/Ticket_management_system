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
        title: const Center(child: Text('Raise Ticket')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Ticket #: 12345', // Display your ticket number here
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: workController,
                      decoration: const InputDecoration(hintText: 'Work'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: buildingController,
                      decoration: const InputDecoration(hintText: 'Building'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: floorController,
                      decoration: const InputDecoration(hintText: 'Floor'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(hintText: 'Room'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: assetController,
                      decoration: const InputDecoration(hintText: 'Asset'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 30,
                      width: 130,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButtonFormField(
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
                        decoration: const InputDecoration(
                          hintText: 'Service Provider',
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Remark:-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: remarkController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Remarks',
                          border: OutlineInputBorder(),
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
                    child: const Text('Pick Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      generateTicketID();
                      storeRaisedTicket(ticketID);
                    },
                    child: const Text('Save'),
                  ),
                  Text(
                    _getCurrentDate(),
                    style: const TextStyle(
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
