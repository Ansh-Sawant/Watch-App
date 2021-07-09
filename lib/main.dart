import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tb;
  int hour = 0, min = 0, sec = 0;
  String timeToDisplay = "";
  bool started = true, stopped = true;
  late int timeForTimer;
  final dur = const Duration(seconds: 1);
  bool cancelTimer = false;

  @override
  void initState(){
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start(){

    setState(() {
      started = false;
      stopped = false;
    });

    timeForTimer = ((hour * 3600) + (min * 60) + sec);
    Timer.periodic(dur, (Timer t) {
      setState(() {
        if(timeForTimer < 1 || cancelTimer == true){
          t.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        }
        else if(timeForTimer < 60){
          timeToDisplay = timeForTimer.toString();
          timeForTimer -= 1;
        }
        else if(timeForTimer < 3600){
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (m*60);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer -= 1;
        }
        else{
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (h*3600);
          int m = t ~/ 60;
          int s = t - (60*m);
          timeToDisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer -= 1;
        }
      });
     });
  }

  void stop(){
    setState(() {
      started = true;
      stopped = true;
      cancelTimer = true;
      timeToDisplay = "";
    });
  }

  Widget timer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("HH"),
                    ),

                    NumberPicker(
                      value: hour,
                      minValue: 0, 
                      maxValue: 23, 
                      itemWidth: 60.0,
                      onChanged: (val){
                        setState(() {
                          hour = val;
                        });
                      }
                    )
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("MM"),
                    ),

                    NumberPicker(
                      value: min,
                      minValue: 0, 
                      maxValue: 59, 
                      itemWidth: 60.0,
                      onChanged: (val){
                        setState(() {
                          min = val;
                        });
                      }
                    )
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("SS"),
                    ),

                    NumberPicker(
                      value: sec,
                      minValue: 0, 
                      maxValue: 59, 
                      itemWidth: 60.0,
                      onChanged: (val){
                        setState(() {
                          sec = val;
                        });
                      }
                    )
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              timeToDisplay,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [                
                ElevatedButton(
                  onPressed: started ? start : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 35.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: stopped ? null : stop,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 35.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      "Stop",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch"),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[
            Text("Timer"),
            Text("Stopwatch"),
          ],
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: EdgeInsets.only(
            bottom: 10,
          ),
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: <Widget> [
          timer(),
          Text("Stopwatch"),
        ],
        
        controller: tb,
      ),
    );
  }
}
