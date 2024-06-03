import 'package:flutter/material.dart';

class pendingstatus_service extends StatefulWidget {
  const pendingstatus_service({super.key});

  @override
  State<pendingstatus_service> createState() => _pendingstatus_serviceState();
}

class _pendingstatus_serviceState extends State<pendingstatus_service> {
  final List<String> serviceProviders = [
    'Provider A',
    'Provider B',
    'Provider C',
    'Provider D',
  ];

  String? _selectedServiceProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pending status of Ticket',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ticket #: 12345',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const TextField(
                    decoration: InputDecoration(hintText: 'Work'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Building'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Floor'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Room'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Asset'),
                  ),
                  // const TextField(
                  //   decoration: InputDecoration(hintText: 'Service Provider'),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
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

                  const SizedBox(
                    height: 35,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Remarks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Pick Image'),
                ),
              ],
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
}
