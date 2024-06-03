import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_management/Service%20Provider/pendingstatus_service.dart';
import 'package:flutter/material.dart';

class service_pending extends StatefulWidget {
  service_pending({super.key});

  @override
  State<service_pending> createState() => _service_pendingState();
}

class _service_pendingState extends State<service_pending> {


  List<dynamic> ticketList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingTicket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('service_pending Tickets'),
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
                          builder: (context) => pendingstatus_service(
                                Number: ticketList[index],
                              )));
                },
                child: const Text('Open')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => pendingstatus_service(
                            Number: ticketList[index],
                          )));
            },
          );
        },
      ),
    );
  }

  Future<void> getPendingTicket() async {
    QuerySnapshot ticketQuery =
        await FirebaseFirestore.instance.collection('raisedTickets').get();
    ticketList = ticketQuery.docs.map((e) => e.id).toList();
    setState(() {});
    print(ticketList);
  }
}
