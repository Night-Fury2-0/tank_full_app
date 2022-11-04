import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_multi_carousel/carousel.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = (MediaQuery.of(context).size.height) - 100;

    return Scaffold(
      //drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Center(
        child: Carousel(
            height: height,
            width: 350,
            initialPage: 3,
            allowWrap: false,
            type: Types.simple,
            onCarouselTap: (i) {
              print("onTap $i");
            },
            indicatorType: IndicatorTypes.bubble,
            arrowColor: Colors.black,
            axis: Axis.horizontal,
            showArrow: false,
            children: List.generate(
                7,
                (i) => Center(
                      child:
                          Container(color: Colors.red.withOpacity((i + 1) / 7)),
                    ))),
      ),
    );
  }
}
