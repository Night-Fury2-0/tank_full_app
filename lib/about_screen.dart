import 'package:flutter/material.dart';
import 'NavBar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static List<String> bulletpoints = [
    "In-flow and Out-flow measurements with 30-day graphical representations.",
    "Water level monitoring with visual and percentage representations.",
    "Notifications for high and low threshold levels in the tank.",
    "A printable PDF document with graphs and statistics about the water level and flow in your tank for the last 30-days."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: NavBar(),
        appBar: AppBar(
          title: const Text('About Screen'),
        ),
        //main body is a List view
        body: ListView(
          children: [
            //First text block is stored here in a Padding widget
            const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Tank-Full is a home automation app that monitors your water tank in real-time. Its functionalities include:",
                  style: TextStyle(fontSize: 18, height: 1.5),
                )),

            //Bullet points are formatted here
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                children: bulletpoints.map((strone) {
                  return Row(children: [
                    const Text(
                      "\u2022",
                      style: TextStyle(fontSize: 30),
                    ), //bullet text
                    const SizedBox(
                      width: 10,
                      height: 65,
                    ), //space between bullet and text
                    Expanded(
                      child: Text(
                        strone,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ), //text
                    )
                  ]);
                }).toList(),
              ),
            ),

            //Another block of text stored in a padding
            const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Tank-Full makes home automations easier. Monitoring your tank right on your phone!",
                  style: TextStyle(fontSize: 18, height: 1.5),
                )),

            //Version number text added here
            Container(
                padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                child: Column(
                  children: const [
                    Text("Version 1.0.0",
                        style: TextStyle(fontStyle: FontStyle.italic))
                  ],
                )),
          ],
        ));
  }
}
