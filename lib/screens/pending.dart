import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_management/Service%20Provider/pendingstatus_service.dart';
import 'package:complaint_management/screens/notification.dart';
import 'package:complaint_management/screens/ticket_screen.dart';
import 'package:flutter/material.dart';

class pending extends StatefulWidget {
  pending({super.key});

  @override
  State<pending> createState() => _pendingState();
}

class _pendingState extends State<pending> {
  List<dynamic> ticketList = [];
  @override
  void initState() {
    super.initState();
    getPendingTicket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('pending Tickets'),
        ),
        body: ListView.builder(
            itemCount: ticketList.length, //* 2 - 1,
            itemBuilder: (BuildContext context, int index) {
              // if (index.isOdd) {
              //   return Divider();
              // }
              //final itemIndex = index ~/ 3;

              return ListTile(
                title: Text('Ticket ${ticketList[index]}'),
                trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TicketScreen(
                                    Number: ticketList[index],
                                    showResolvedTickets: false,
                                  )));
                    },
                    child: const Text('Open')),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
              );
            }));
  }

  Future<void> getPendingTicket() async {
    QuerySnapshot ticketQuery =
        await FirebaseFirestore.instance.collection('raisedTickets').get();
    ticketList = ticketQuery.docs.map((e) => e.id).toList();
    setState(() {});
    print(ticketList);
  }
}
