import 'package:flutter/material.dart';

class TabsContent extends StatefulWidget {
  TabsContent({Key? key}) : super(key: key);

  @override
  State<TabsContent> createState() => _TabsContentState();
}

class _TabsContentState extends State<TabsContent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike))
            ]),
           ),
        ),
      ),
    );
  }
}
