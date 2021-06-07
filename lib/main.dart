import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  //證明then會立即執行, 不會進入microtask
  //Future的then方法, 本身也會回傳另一個Future
  //如果先印出micro再印出then 2 的話就是代表 then有進入microtask, 但證明結果是沒有的
  Future.delayed(Duration(seconds: 1), () => print("delayed")).then((value) {
    scheduleMicrotask(() => print("micro"));
    print("then 1");
  }).then((value) => print("then 2"));

  // Future.delayed(Duration(seconds: 1), ()=>print("event 3"));
  // Future(()=>print("event 1"));
  // Future.delayed(Duration.zero, ()=>print("event 2"));//這邊說的時間指的是最短的等待時間, 例如是最少等1秒.
  //
  // scheduleMicrotask(()=>print("microtask 1"));
  // Future.microtask(() => print("microtask 2"));
  // Future.value(123).then((value) => print("microtask 3"));
  //
  //
  // print("main 1");
  // Future.sync(() => print("sync 1"));//Future.sync 會直接執行, 不會進入Event Queue
  // Future.value(getName());//會立即執行, 不會放到Event Queue
  // print("main 2");

  runApp(MyApp());
}

String getName() {
  print("get name");
  return "bob";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Future<int> getFuture() {
  //   // return Future.delayed(Duration(seconds: 1), () => "alice");
  //   //Future.error
  //   // return Future.error(Exception("something went wring"));
  //   return Future.value(100);
  // }

  Future<int> getFuture() async{
    // return Future.delayed(Duration(seconds: 1), () => "alice");
    //Future.error
    // return Future.error(Exception("something went wring"));
    throw "oops";
    return 100;
  }

  void _incrementCounter() async{

    try{
      int id = await getFuture();
    }
    catch(err){
      print(err);
    }


    //await 的使用, 可以取代下面那段程式效果

    // int id = await getFuture();
    // print(id);
    // id *= 2;
    // print(id);



    // getFuture().then((value) => print(value));

    // ---  ---
    getFuture()
        .then((value) {
          print(value);
          return value * 2 ;
        })
        .then((value) => print(value)) //then 是可以chain起來的
        .catchError((err) => print(err))
        .whenComplete(() => print("complete"));

    // // --- Future.error ---
    // getFuture()
    //     .then((value) => print(value))
    //     .catchError((err)=>print(err))
    //     .whenComplete(()=>print("complete"));
    print("hi");

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
