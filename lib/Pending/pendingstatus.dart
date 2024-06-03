import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class pendingstatus extends StatefulWidget {
  String Number;
  pendingstatus({super.key, required this.Number});

  @override
  State<pendingstatus> createState() => _pendingstatusState();
}

class _pendingstatusState extends State<pendingstatus> {
  final List<String> serviceProviders = [
    'Provider A',
    'Provider B',
    'Provider C',
    'Provider D',
  ];
  String asset = '';
  String building = '';
  String floor = '';
  String remark = '';
  String room = '';
  String work = '';
  String serviceprovider = '';

  String? _selectedServiceProvider;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket ${widget.Number}'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                customCard('asset', asset, Icons.account_balance),
                customCard('building', building, Icons.business),
                customCard('floor', floor, Icons.layers),
                customCard('remark', remark, Icons.comment),
                customCard('room', room, Icons.room),
                customCard('work', work, Icons.work),
                customCard('serviceprovider', serviceprovider, Icons.build),
              ],
            ),
    );
  }

  Widget customCard(String title, String message, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 14),
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
