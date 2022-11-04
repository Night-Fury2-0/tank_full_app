import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getwidget/getwidget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  //Contains the list of all images to be used in the help page
  static List<String> imageList = [
    'assets/images/test1.jpg',
    'assets/images/test2.jpg',
    'assets/images/test3.jpg',
  ];

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    //Finds the height of the page to be used for the Carousel height
    //Minus 25 just to avoid any pixel overflow errors
    final double height = (MediaQuery.of(context).size.height) - 25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Center(
        //This is the main widget for the carousel
        child: GFCarousel(
          height: height,
          hasPagination: true,
          passiveIndicator: Color.fromARGB(255, 37, 84, 155),
          activeIndicator: Color.fromARGB(255, 0, 225, 255),
          viewportFraction: 1.0,
          items: HelpScreen.imageList.map(
            (path) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: ClipRRect(
                  //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.asset(path),
                ),
              );
            },
          ).toList(),
          onPageChanged: (index) {
            setState(() {
              index;
            });
          },
        ),
      ),
    );
  }
}
