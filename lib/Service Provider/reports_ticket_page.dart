import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportTicketScreen extends StatefulWidget {
  final String ticketNo;
  final String asset;
  final String building;
  final String floor;
  final String remark;
  final String room;
  final String work;

  const ReportTicketScreen(
      {super.key,
      required this.ticketNo,
      required this.asset,
      required this.building,
      required this.floor,
      required this.remark,
      required this.room,
      required this.work});

  @override
  State<ReportTicketScreen> createState() => _ReportTicketScreenState();
}

class _ReportTicketScreenState extends State<ReportTicketScreen> {
  List<dynamic> ticketData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticketNo),
        backgroundColor: Colors.deepPurple,
      ),
      body: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customRow("Asset:", widget.asset),
              customRow("Building:", widget.building),
              customRow("Floor:", widget.floor),
              customRow("Remark:", widget.remark),
              customRow("Room:", widget.room),
              customRow("Work:", widget.work),
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
