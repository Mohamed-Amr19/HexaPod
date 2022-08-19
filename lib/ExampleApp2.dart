//@dart=2.9
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/circle_view.dart';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';
import 'dart:math' as math;

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:happytimes1/DiscoveryPage.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//void main() {
// runApp(ExampleApp());
//}

class ExampleApp2 extends StatefulWidget {
  final BluetoothDevice server;

  const ExampleApp2({ this.server});

  @override
  _ExampleApp2 createState() => new _ExampleApp2();
}

class _ExampleApp2 extends State<ExampleApp2>
{
      var connection;
      bool isConnecting= true;
      bool isDisconnecting = false;
      Uint8List data;
      Uint8List buffer=ascii.encode("hi");
      String humiditystring='';
      String heatstring='';
      String ultrastring='';
      String ldrstring='';
      String gyrostring='';
      double ax=90.0,ay=90.0,az=0.0,px=0,py=0,pz=0;
      int i=0;
      int j=0;
      int flag;
      @override
      void initState()
      {
      super.initState();
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,]);

      BluetoothConnection.toAddress(widget.server.address).then((_connection) {
        print('Connected to the device');
        connection = _connection;
        setState(() {
         // isConnecting = false;
          //isDisconnecting = false;
        });

         connection.input.listen(_onDataReceived).onDone(() {
        //   // Example: Detect which side closed the connection
        //   // There should be `isDisconnecting` flag to show are we are (locally)
        //   // in middle of disconnecting process, should be set before calling
        //   // `dispose`, `finish` or `close`, which all causes to disconnect.
        //   // If we except the disconnection, `onDone` should be fired as result.
        //   // If we didn't except this (no flag set), it means closing by remote.
          if (isDisconnecting) {
             print('Disconnecting locally!');
          } else {
            print('Disconnected remotely!');
          }
          if (this.mounted) {
            setState(() {});
          }
        });
      }).catchError((error) {
        print('Cannot connect, exception occured');
        print(error);
      });
      }

      bool isConnected() {
        return connection != null && connection.isConnected;
      }

      @override
      void dispose() {
        // Avoid memory leak (`setState` after dispose) and disconnect
        if (isConnected()) {
          isDisconnecting = true;
          connection.dispose();
          connection = null;
        }
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeRight,
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]);
        super.dispose();
      }

      void _onDataReceived(Uint8List data) async {
        // Allocate buffer for parsed data
        int backspacesCounter = 0;
        for (var byte in data) {
          if (byte == 8 || byte == 127) {
            backspacesCounter++;
          }
        }
        buffer = Uint8List(data.length - backspacesCounter);
        int bufferIndex = buffer.length;

        // Apply backspace control character
        backspacesCounter = 0;
        for (int i = data.length - 1; i >= 0; i--) {
          if (data[i] == 8 || data[i] == 127) {
            backspacesCounter++;
          } else {
            if (backspacesCounter > 0) {
              backspacesCounter--;
            } else {
              buffer[--bufferIndex] = data[i];
            }
          }
        }
        setState(() {

                if(flag==1) {
                  if (i % 2 == 0) {
                    humiditystring = buffer[0].toString();
                    i++;
                  }
                  else {
                    heatstring = buffer[0].toString();
                    i++;
                  }
                  //print(heatstring + humiditystring);
                }
                if(flag==2)
                  {
                    ultrastring=buffer[0].toString();
                    print(ultrastring);
                  }
                if(flag==3)
                  {
                    ldrstring=buffer[0].toString();
                    print(ldrstring);
                  }
                if(flag==4) {
                  print("length" + buffer.length.toString());
                  // buffer.forEach((element) {
                  //   {
                  //     print(element);
                  //   }
                    if(j==0)
                    {
                      ax=buffer[0].toDouble();
                      j=1;
                      print("ax:"+ax.toString()+"j:"+j.toString());
                    }
                    else if(j==1)
                    {
                      ay=buffer[0].toDouble();
                      j=2;
                      print("ay:"+ay.toString()+"j:"+j.toString());
                    }
                    else if(j==2)
                    {
                      az=buffer[0].toDouble();
                      j=0;
                      print("az:"+az.toString()+"j:"+j.toString());
                    }
                  //   if(j==3)
                  //   {
                  //     px=buffer[0];
                  //     j++;
                  //   }
                  //   if(j==4)
                  //   {
                  //     py=buffer[0];
                  //     j++;
                  //   }
                  //   if(j==5)
                  //   {
                  //     pz=buffer[0];
                  //     j=0;
                  //   }
                    // print("$ax $ay $az ");



                }

                });

          //print(dataString2);
        }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
                //appBar: AppBar(
                //title: Text('Control Pad Example'),
                //),
                body: Container(
                  color: Colors.white24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SpeedDial(
                            label: const Text('Actions'),
                          overlayOpacity: 0,
                              icon: Icons.navigation,
                              //animatedIcon: AnimatedIcons.menu_close,
                              closeManually: true,

                              children:
                              [
                                SpeedDialChild
                                  (
                                  child: const Icon(Icons.download_rounded),
                                  label: 'Down',
                                  onTap: (){
                                    connection.output.add(utf8.encode("8"));
                                  }

                                  ),
                                SpeedDialChild
                                  (
                                  child: const Icon(Icons.upload_rounded),
                                  label: 'Up',
                                  onTap: (){
                                    connection.output.add(utf8.encode("9"));
                                  }
                                  )
                              ]
                              ),
                          Container(
                            height: 25,
                          )
                                ],),

                        Container(
                          height: height * .75,
                          width: width * .4,
                          decoration: BoxDecoration(
                            //color: green,
                            border: Border.all(
                                color: Colors.black
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)),
                          ),
                         child:
                          Center(
                            child: Object3D(
                            size: const Size(12, 120),
                            path: "assets/hexa_spider.obj",
                            angleX: ax*180/math.pi,
                            angleY: ay*180/math.pi,
                            angleZ: az*180/math.pi,
                            asset: true,
                            zoom: 30,
                          ),
                        ),

                      ),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           Padding(
                              padding: const EdgeInsets.only(top:30.0),
                                child: Text("Heat \n $heatstring C"),

                          ),

                           Padding(
                            padding: const EdgeInsets.only(top:1),

                            child: Text("Humidity \n  $humiditystring %"),

                          ),


                            Padding(
                             padding: const EdgeInsets.all(1.0),
                             child: Text("Ultrasonic \n $ultrastring cm"),
                           ),
                           Padding(
                              padding: const EdgeInsets.only(top:10.0),
                                child: Text("LDR\n $ldrstring"),
                          ),
                        ],
                      ),
                      //Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SpeedDial(
                              label: const Text("Sensors"),
                              overlayOpacity: 0,
                              icon: Icons.navigation,
                              animatedIcon: AnimatedIcons.menu_close,
                              closeManually: true,
                              children: [
                                SpeedDialChild(
                                    child: const Icon(Icons.local_fire_department_rounded),
                                  label: 'heat sensor',
                                    onTap:() async{
                                      print("zzzzzzz");
                                      flag=1;
                                      j=0;
                                      i=0;
                                      connection.output.add(utf8.encode("1"));
                                      //connection.input.listen(_onDataReceived(data,0));
                                      await connection.output.allsent;},
                                ),
                                SpeedDialChild(
                                    child: const Icon(Icons.visibility),
                                  label: 'Ultrasonic',
                                  onTap:()  async{
                                  print("zzzzzzz");
                                  flag=2;
                                  j=0;
                                  connection.output.add(utf8.encode("2"));
                                  //connection.input.listen(_onDataReceived(data,0));
                                  await connection.output.allsent;},
                                  ),

                                SpeedDialChild(
                                    child: const Icon(Icons.light_mode_rounded),
                                  label: 'LDR',
                                  onTap:()  async{
                                  print("zzzzzzz");
                                  flag=3;
                                  j=0;
                                  connection.output.add(utf8.encode("3"));
                                  //connection.input.listen(_onDataReceived(data,0));
                                  await connection.output.allsent;
                                  },
                                  ),

                                SpeedDialChild(
                                    child: const Icon(Icons.control_camera_rounded),
                                  label: 'Gyroscope',
                                  onTap:() async{
                                  print("zzzzzzz");
                                  flag=4;
                                  j=0;
                                  connection.output.add(utf8.encode("4"));
                                  await connection.output.allsent;
                                  print("$ax  $ay $az $px $py $pz");
                                  },
                                  ),
                                ]
                                  ),
                            Container(
                              height: 25,
                            )
                          ],

                        ),

                        ),

                      ]
                      ),



                  ),

                /* bottomNavigationBar:
                  BottomNavigationBar(items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',

                ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      label: 'Business',
                      backgroundColor: Colors.green,
                    ),],
                    elevation: 2, landscapeLayout: BottomNavigationBarLandscapeLayout.centered),

              */
              );




// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'Control Pad Example',
//     home: HomePage(),
//   );
// }
//class HomePage extends State<ExampleApp2> {

            }}