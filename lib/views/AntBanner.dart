import 'package:flutter/material.dart';
import 'dart:async';

double _minHeight = 150.0;

class AntBanner extends StatefulWidget{

  List<Widget> children;
  double height;
  Function _callback;
  Duration _duration;


  AntBanner({
    List<Widget> children:const <Widget>[],
    double height:0.0,
    Function callback(int index),
    Duration duration:const Duration(milliseconds: 500),
  }){
    assert(null != children);
    this.children = children;
    this.height = height <=0 ? _minHeight:height;
    this._callback = callback;
    _duration = duration;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AntBannerState();
  }

}

class _AntBannerState extends State<AntBanner> with SingleTickerProviderStateMixin{

  PageController _pageController;
  int _selPageIndex = 0;
  Timer _timerController;
  bool _isTouchBanner = false;
  int _number = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = new PageController();


    startLoop();
  }

  void startLoop(){
    if(null != _timerController && _timerController.isActive){
      return;
    }
    _timerController = new Timer.periodic(widget._duration, (timer){
      if(!_isTouchBanner){

        _number++;
        _selPageIndex = ++_selPageIndex % itemCount;
//        print("--------------tick " + _selPageIndex.toString());
        if(0 == _selPageIndex){
          _pageController.jumpToPage(_selPageIndex);
        }else{
          _pageController.animateToPage(_selPageIndex, duration: new Duration(milliseconds: 1000), curve: Curves.ease);
        }
      }
    });
  }

  void _cancelLoop(){
    _timerController.isActive?_timerController.cancel():null;
  }

  int get itemCount{
    return widget.children.length;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cancelLoop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget widgets = new NotificationListener(
        child: new Stack(
          children: <Widget>[
            new PageView(
              onPageChanged: (int index){
                _selPageIndex = index;
                this.setState((){});
              },
              controller: _pageController,
              children: widget.children.map((child){
                return new InkWell(
                  child: child,
                  onTap: (){
                    if(null != widget._callback){
                      widget._callback(_selPageIndex);
                    }
                  },
                );
              }).toList(),
            ),//
            _renderIndex(),
          ],
        ),
      onNotification: (ScrollNotification scrollNotification){
          if(scrollNotification is ScrollEndNotification || scrollNotification is UserScrollNotification){
            this._isTouchBanner = false;
          }else{
            this._isTouchBanner = true;
          }
          return false;
      },
    );

    return new Container(
      height: widget.height,
      width: double.infinity,
      child: widgets,
    );
  }

  Widget _renderIndex(){
    return new Container(
      alignment: Alignment.bottomCenter,
      padding: new EdgeInsets.only(bottom: 20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _makeIndicator(),
      ),
    );
  }

  List<Widget> _makeIndicator(){
    List<Widget> list = [];
    for(int index = 0; index < itemCount; index++){
      list.add(new Container(
        width: 10.0, height: 10.0,
        margin: const EdgeInsets.all(2.0),
        decoration: new BoxDecoration(
            color: index == _selPageIndex?Colors.red:Colors.grey,
            shape: BoxShape.circle
        ),
      ),);
    }
    return list;
  }

}
