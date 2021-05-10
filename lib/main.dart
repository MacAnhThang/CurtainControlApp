import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guimoRem(int d)async {
  print(d);
  final response = await http.get(
      Uri.parse('http://autogolikefree.xyz/rem/add_time.php?time_set=$d'),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });
  print(response.statusCode);
  print(response.body);
}
Future moRem()async {
  final response = await http.get(
      Uri.parse('http://autogolikefree.xyz/rem/add_poin.php?poin=0'),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });
  print(response.statusCode);
  print(response.body);
}

Future dieukhienRem(int value)async {
  final response = await http.get(
      Uri.parse('http://autogolikefree.xyz/rem/add_poin.php?poin=$value'),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      });

  print(response.statusCode);
  print(response.body);
}

void main() async{
  runApp(new MyApp());
  await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
        primaryColor: const Color(0xFF00bcd4),
        accentColor: const Color(0xFF00bcd4),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
@override
void initState(){
  super.initState();
  _docbiennho();
}
  TimeOfDay _time = new TimeOfDay.now();
int a = 0;
int b = 0;
int c = 0;
  Future<Null> selectTime(BuildContext context) async{
    SharedPreferences biennho = await SharedPreferences.getInstance();
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time);
    if(picked != null && picked != _time){
      setState(() {
        _time = picked;
      });
      print('Thời gian đã cài: ${_time.toString()}');
      a = _time.hour;
      b = _time.minute;
      c = (a*3600 + b*60)-25200;
      if(c <= 0){
        c = 86400 + c;
      }
      String _timebiendoi = _time.format(context);
      print(_timebiendoi);
      biennho.setInt("biennho1", _time.hour);
      biennho.setInt("biennho2", _time.minute);
      if (isOn == true) {
        guimoRem(c);
        AndroidAlarmManager.oneShotAt(
            DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_time.hour,_time.minute), alarmId, moRem);
      } else {
        AndroidAlarmManager.cancel(alarmId);
        print('Alarm Timer Canceled');
      }
    }
  }

  int biennho1 = 0, biennho2= 0;
Future<Null> _docbiennho() async{
    SharedPreferences biennho = await SharedPreferences.getInstance();
    setState(() {
        biennho1 = (biennho.getInt("biennho1") ?? 0);
        biennho2 = (biennho.getInt("biennho2") ?? 0);
        _time = (TimeOfDay(hour: biennho1, minute: biennho2) ?? TimeOfDay.now());
      });
    }


  double _hesomoRem = 0;
  String datatoChange = "";
  bool isOn = true;
  int alarmId = 1;


  void changeData100(){
    setState(() {
      datatoChange = "Rèm đang được mở hoàn toàn";
    });}
    void changeData0(){
      setState(() {
        datatoChange = "Rèm đang được đóng kín";
      });}
      void changeData20(){
        setState(() {
          datatoChange = "Rèm đang được mở 20%";
        });}
        void changeData40(){
          setState(() {
            datatoChange = "Rèm đang được mở 40%";
          });}
          void changeData60(){
            setState(() {
              datatoChange = "Rèm đang được mở 60%";
            });}
            void changeData80(){
              setState(() {
                datatoChange = "Rèm đang được mở 80%";
              });}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Điều khiển Rèm thông minh', style: TextStyle(color: Colors.white)),
        ),
        body:
        new ListView(
            children: <Widget>[
              new Image.asset(
                'assets/images/remdep.jpg',
                fit:BoxFit.fill,
              ),
              new Text("               "),
              new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                Text("$datatoChange", style: TextStyle(fontSize: 22.0, color: Colors.cyan,
                  fontWeight: FontWeight.w300, // light
                  fontFamily: "RaleWay",
                ))])),
              new Text("               "),
              new Text("               "),

              new Container(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new IconButton(
                        icon: const Icon(Icons.code),
                        onPressed:() {
                          dieukhienRem(0);
                          changeData100();
                        },
                        iconSize: 50.0,
                        tooltip:"Mở hết Rèm",
                        color: const Color(0xFF000000),
                      ),

                      new IconButton(
                        icon: const Icon(Icons.last_page),
                        onPressed:() {
                          dieukhienRem(100);
                          changeData0();
                        },
                        iconSize: 50.0,
                        tooltip:"Đóng kín",
                        color: const Color(0xFF000000),
                      )
                    ]
                ),
              ),

              new Text("               "),
              new Slider(
                value: _hesomoRem,
                min: 0,
                max: 100,
                divisions: 5,
                label: _hesomoRem.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _hesomoRem = value;
                  });
                  if(_hesomoRem == 0){
                    dieukhienRem(100);
                    changeData0();
                  }
                  else if (_hesomoRem == 20){
                    dieukhienRem(80);
                    changeData20();
                  }
                  else if (_hesomoRem == 40){
                    dieukhienRem(60);
                    changeData40();
                  }
                  else if (_hesomoRem == 60){
                    dieukhienRem(40);
                    changeData60();
                  }
                  else if (_hesomoRem == 80){
                    dieukhienRem(20);
                    changeData80();
                  }
                  else{
                    dieukhienRem(0);
                    changeData100();
                  }
                },
              ),
              new Text("               "),
              new Center(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Thời gian mở Rèm mặc định: $_time", style: TextStyle(fontSize: 15.0, color: Colors.cyan,
                          fontWeight: FontWeight.w300, // light
                          fontFamily: "RaleWay",
                        ))])),
      Center(
        child: Transform.scale(
          scale: 2,
          child: Switch(
            value: isOn,
            onChanged: (value) {
              setState(() {
                isOn = value;
              });
              if (isOn == true) {
                AndroidAlarmManager.oneShotAt(
                    DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_time.hour,_time.minute), alarmId, moRem);
              } else {
                AndroidAlarmManager.cancel(alarmId);
                print('Alarm Timer Canceled');
              }
            },
          ),
        ),
      ),
            ]
        ),


        floatingActionButton: FloatingActionButton(
            child: IconButton(
              icon: Icon(Icons.alarm),
              color: Colors.white,
              tooltip:"Hẹn giờ mở Rèm",
              onPressed: (){
                selectTime(context);
              },
            )
        )
    );
  }
}
