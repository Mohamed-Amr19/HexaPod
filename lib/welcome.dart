import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slider_button/slider_button.dart';

import 'main.dart';

class welcome extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    double heigh = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,]);
    return Scaffold(
      body: Container(
        color: Colors.white24,
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("assets/suffer.jpg"),
        //       fit: BoxFit.fill ,
        //     )
        // ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Container(
                height: heigh*.3,
              width: width*.75,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/launch_spider.png"),
                  fit: BoxFit.fill ,
                )
          ),
              ),
            ),

            //const Center(child: Text("asdfasdf")),
            // Container(
            //   // height: 250,
            //   // width: 250,
            //   decoration:
            //   const BoxDecoration(
            //     image: DecorationImage(
            //       image: ExactAssetImage('assets/launch_spider.png') ,
            //     )
            //   )
            //   ,
            //   child: Image.asset(
            //     "assets/launch_spider.png"
            //   ),
            // ),
            Expanded(child: Container()),


            SliderButton(
              action: ()
              {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothApp()));
                Navigator.push(
                  context,
                  PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: BluetoothApp(),
                ));
              },
              label: const Text(
                "Slide to Continue !",
                style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              icon: const Center(
                child: Icon(
                  Icons.all_inclusive_rounded,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              boxShadow: const BoxShadow(
                color: Colors.black,
                blurRadius: 4,
              ),
            ),
            Container(
              height: 30,
            )

          ],
        ),
      ),
    );

  }
}