import 'package:complaint_management/Pending/pendingstatus.dart';
import 'package:flutter/material.dart';

class pending extends StatelessWidget {
  pending({super.key});

  final List<String> tickets = [
    '#Ticket 1',
    '#Ticket 2',
    '#Ticket 3',
    '#Ticket 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pending Tickets'),
        ),
        body: ListView.builder(
            itemCount: tickets.length, //* 2 - 1,
            itemBuilder: (BuildContext context, int index) {
              // if (index.isOdd) {
              //   return Divider();
              // }
              //final itemIndex = index ~/ 3;

              return ListTile(
                title: Text(tickets[index]),
                trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Pendingstatus()));
                    },
                    child: const Text('Open')),
                onTap: () {
                  print('Tapped on Ticekt: ${tickets[index]}');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Pendingstatus()));
                },
              );
            }));
  }
}
