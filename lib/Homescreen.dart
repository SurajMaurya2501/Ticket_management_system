import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_management/screens/pending.dart';
import 'package:complaint_management/screens/profile.dart';
import 'package:complaint_management/screens/raise.dart';
import 'package:complaint_management/screens/report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  List<String> buttons = [
    'Raise Ticket',
    'Pending Tickets',
    'Reports',
    'Profile',
  ];

  List<Widget> screens = [
    const Raise(),
    pending(),
    const Report(),
    password(),
  ];

  int resolvedTicketLen = 0;
  int pendingTicketLen = 0;

  @override
  void initState() {
    getPendingTicket().whenComplete(() async {
      await getResolvedTicket();
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'C.🅼.S',
          style: TextStyle(color: Colors.deepPurple, fontSize: 30),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active,
              color: Colors.deepPurple,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.deepPurple,
              )),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: GridView.builder(
                          itemCount: buttons.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10.0),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: InkWell(
                                          onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        screens[index]),
                                              ),
                                          child: getIcon(buttons[index])),
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => screens[index],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      buttons[index],
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            );
                          })),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(
                        10.0,
                      ),
                      child: Card(
                        elevation: 10.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(
                                5.0,
                              ),
                              child: const Text(
                                'Complaint Overview',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 5.0,
                                            ),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.purple,
                                              child: Text(
                                                pendingTicketLen.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: Text(
                                            'Pending Ticket',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 5.0,
                                            ),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.orange,
                                              child: Text(
                                                resolvedTicketLen.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: Text(
                                            'Completed Ticket',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 180,
                                  height: 180,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceRadius: 30,
                                      sections: [
                                        PieChartSectionData(
                                          color: Colors.deepPurple,
                                          value: 40,
                                          title: pendingTicketLen.toString(),
                                          titleStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          radius: 50,
                                        ),
                                        PieChartSectionData(
                                          color: Colors.orange,
                                          value: 20,
                                          title: resolvedTicketLen.toString(),
                                          titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          radius: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future getPendingTicket() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('raisedTickets').get();

    List<dynamic> pendingTicketData =
        querySnapshot.docs.map((e) => e.id).toList();
    pendingTicketLen = pendingTicketData.length;
  }

  Future getResolvedTicket() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('resolvedTicket').get();

    List<dynamic> resolvedTicketData =
        querySnapshot.docs.map((e) => e.id).toList();
    resolvedTicketLen = resolvedTicketData.length;
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      case "Raise Ticket":
        return const Icon(
          Icons.receipt_long_rounded,
          size: 85,
          color: Colors.deepPurple,
        );
      // case "Pending Ticket":
      //   return const Icon(
      //     Icons.messenger_outline_rounded,
      //     size: 85,
      //   );
      case "Reports":
        return const Icon(
          Icons.report_sharp,
          size: 85,
          color: Colors.deepPurple,
        );
      case "Profile":
        return const Icon(
          Icons.person_outlined,
          size: 85,
          color: Colors.deepPurple,
        );

      default:
        return const Icon(
          Icons.pending_actions_outlined,
          size: 85,
          color: Colors.deepPurple,
        );
    }
  }
}
