import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class pendingstatus_service extends StatefulWidget {
  String Number;
  pendingstatus_service({super.key, required this.Number});

  @override
  State<pendingstatus_service> createState() => _pendingstatus_serviceState();
}

class _pendingstatus_serviceState extends State<pendingstatus_service> {
  String asset = '';
  String building = '';
  String floor = '';
  String remark = '';
  String room = '';
  String work = '';
  String serviceprovider = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getTicketData().whenComplete(
      () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Ticket ${widget.Number}'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customRow('asset', asset),
                  customRow('building', building),
                  customRow('floor', floor),
                  customRow('remark', remark),
                  customRow('room', room),
                  customRow('work', work),
                  customRow('serviceprovider', serviceprovider),
                  InkWell(
                    onTap: () async {
                      customAlert();
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 5.0,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            child: const Text(
                              "Task Accomplished",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future storeCompletedTicket() async {
    await FirebaseFirestore.instance
        .collection("resolvedTicket")
        .doc(widget.Number)
        .set({
      "asset": asset,
      "building": building,
      "floor": floor,
      "remark": remark,
      "room": room,
      "work": work,
      "isSeen": false
    }).whenComplete(() {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ticket Resolved!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  Future removeCompletedTicket(String ticketNumber) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("raisedTickets")
        .doc(ticketNumber);
    await documentReference.delete();
  }

  void customAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Are You Sure Task Is Completed!",
            ),
            icon: const Icon(
              Icons.warning,
              color: Colors.blue,
              size: 60,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      storeCompletedTicket().whenComplete(() {
                        removeCompletedTicket(widget.Number);
                      });
                    },
                    child: const Text(
                      "OK",
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget customRow(String title, String message) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(message),
        ],
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

  Future<void> getTicketData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('raisedTickets')
        .doc(widget.Number)
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      asset = mapData['asset'];
      building = mapData['building'];
      floor = mapData['floor'];
      remark = mapData['remark'];
      room = mapData['room'];
      work = mapData['work'];
      serviceprovider = mapData['serviceprovider'] ?? "";
      setState(() {
        loading = false;
      });
    }
  }
}
