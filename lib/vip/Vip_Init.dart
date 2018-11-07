import 'package:flutter/material.dart';
import 'dart:async';
import '../views/AntRouterAnim.dart';
import 'VIPMainScreen.dart';

class Vip_Init extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Vip_InitState();
  }

}

class _Vip_InitState extends State<Vip_Init> with SingleTickerProviderStateMixin<Vip_Init>{

  AnimationController _controller;
  Animation valueAnim = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(seconds: 3));

    valueAnim = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener((){
      this.setState((){
//        print("-----------here");
      });
    });
    _controller.forward();

    new Timer.periodic(new Duration(seconds: 2), (timer){
      Navigator.of(context).push(new AntRouterAnim(builder: (BuildContext context)=>new VIPMainScreen()));
//      Navigator.pushReplacement(context, new AntRouterAnim(builder: (context)=> new VIPMainScreen()));
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //
    return new Scaffold(
      body: new InkWell(
        onTap: (){
          Navigator.of(context).push(new AntRouterAnim(builder: (BuildContext context)=>new VIPMainScreen()));
        },
        child:new Image.asset("imgs/vips/vip_init_bg.png", fit: BoxFit.fill, width: double.infinity,),
      ),
    );
  }

}