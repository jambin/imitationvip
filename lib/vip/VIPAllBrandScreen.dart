import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/TestData.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/LetterNavWidget.dart';


class VIPAllBrandScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VIPAllBrandScreenState();
  }

}

class _VIPAllBrandScreenState extends State<VIPAllBrandScreen> with TickerProviderStateMixin{
  GlobalKey listViewKey = new GlobalKey();
  bool _isShowLetter = false;
  String _selLetter = "";
  int _selLetterIndex = 0;

  AppBar _appBar;

  double _itemHeight = 10.0;

  Animation _opacity;
  AnimationController _controller;
  ScrollController _scontrollerListView;
  Map allBrand;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isLoadPic = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(duration: new Duration(milliseconds: 1000), vsync: this);
    _opacity = new Tween(begin: 0.0, end: 1.0).animate(_controller);

    _scontrollerListView = new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _loadBrand();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _appBar = new AppBar(
      backgroundColor: Colors.white,
      leading: new IconButton(icon: new Icon(Icons.close, color: Colors.black,), onPressed: (){Navigator.of(context).pop();}),
      titleSpacing: 0.0,centerTitle: true,
      title: new Text("在售品牌", style: const TextStyle(color: Colors.black, fontSize: 18.0),),
    );
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new ListView(
              key: listViewKey,
              controller: _scontrollerListView,
              children: _makeBrand(),
            ),//

            new Positioned(
              width: 35.0,
              right: 10.0,top: 25.0,bottom: 20.0,
              child: new LetterNavWidget(changeLetter: changeLetter,),//
            ),//

            new Center(
              child: _isShowLetter?
                new Opacity(child:new Text(_selLetter, style: const TextStyle(color: Colors.black, fontSize: 80.0),),opacity: _opacity.value,)
                  :new Container(),
            ),//

          ],
        ),
      ),
    );
  }

  void changeLetter({int index, String letter, int status}){
    print("------->$index $letter $status");
    if(0 == status){
      _isLoadPic = false;
      _controller.forward();
      return;
    }
    if(1 == status){
      this.setState((){
        _isShowLetter = true;
        _selLetter = letter;
        _selLetterIndex = index;
      });
      return;
    }
    if(-1 == status){
      new Timer(new Duration(seconds: 1), (){
        this.setState((){
          _isShowLetter = false;
          _controller.reset();
        });
      });
      _jump2Letter();
      return;
    }

  }

  void _onPanDown(DragDownDetails detail){
//    print("------title bar height" + MediaQuery.of(context).padding.top.toString());
//    print("------screen size" + MediaQuery.of(context).size.toString());
//    print("------appbar size" + _appBar.preferredSize.toString());

    double screenHeight = MediaQuery.of(context).size.height;
    double letterHeight = screenHeight - 25 - 56.0 - 24.0 - 20;
    _itemHeight = letterHeight / 27;
    double item = (detail.globalPosition.dy - 25 - 56.0 - 24.0)/(letterHeight/27);

//    print("------------letterHeight : " + letterHeight.toString());
//    print("---------2---" + detail.globalPosition.toString());
//    print("---------item---" + item.toString());
    _isLoadPic = false;
    _controller.forward();

  }

  void _onPanUpdate(DragUpdateDetails detail){
//    print("------------" + detail.globalPosition.toString());
    double index1 = (detail.globalPosition.dy - 25 - 56.0 - 24.0)/_itemHeight;
    int index = index1.round();
    if(0 <= index && index < 27){
      this.setState((){
        _isShowLetter = true;
        _selLetter = listLetter[index];
        _selLetterIndex = index;
      });
    }
  }

  void _onPandDragEnd(DragEndDetails detail){

    new Timer(new Duration(seconds: 1), (){
      this.setState((){
        _isShowLetter = false;
        _controller.reset();
      });
    });

    _jump2Letter();
  }

  void _jump2Letter(){
    int number = 0;
    double dy = 0.0;
    bool count = true;
    do{
      if(null == allBrand || 0 == allBrand.length){
        break;
      }
      allBrand.forEach((key, value){
        if(_selLetterIndex == number){
          count = false;
        }
        if(count){
          List listBrands = value;
//          print("------->" + listBrands.length.toString());
          dy +=  listBrands.length * 102 + 25;
        }
        number++;
      });

      _scontrollerListView.animateTo(dy, duration: new Duration(milliseconds: 500), curve: Curves.ease).whenComplete((){
        _isLoadPic = true;
      });
    }while(1 == 0);
  }

  List<Widget> _makeBrand(){

    List<Widget> listWidget = [];

    if(null != allBrand){
      allBrand.forEach((key, value){
//        print("-------key:" + value.toString());
        List listBrands = value;
//        print("---------size:" + listBrands.length.toString());
        bool isTitle = true;
        String strSize = "(" + listBrands.length.toString() + ")";
        listBrands.forEach((item){
          String name = item['name'].toString();

          if(0 == "".compareTo(name)){
            name = item['name_eng'].toString();
          }
//          print("-----------" + item['logo'].toString());
          String pic = item['logo'].toString();
          if(null == pic || 0 == "".compareTo(pic)){
            pic = null;
          }
//          print("---------->${item['sn']} ---> $pic");
          listWidget.add(_makeItem(isTitle, key.toString() + strSize, name, pic));
          isTitle = false;
        });
      });//for
    }
    return listWidget;
  }

  Widget _makeItem(bool isTitle, String letter, String name, String pic){
      return new ColumnEx(name: name, isTitle: isTitle, pic: pic, letter: letter, isLoadPic: _isLoadPic,);
  }

  Future<Map> _loadBrand() async{

    SharedPreferences sp = await _prefs;
    String strBrands = sp.getString("AllBrands");
//    print("------------>${strBrands}");
    if(null != strBrands && 0 > "".compareTo(strBrands)){
      allBrand = json.decode(strBrands);
      return allBrand;
    }

    http.post("https://h5.vip.com/api/brandSearch/brandSearch/getBrandList/").then((response){
//      print("-----------" + response.body.toString());
      
      Map map = json.decode(response.body.toString());
      if(map['code'] != 0){
        return {};
      }
      allBrand = map['data']['sort_list'];
//      sp.setString("AllBrands", json.encode(allBrand));
//      allBrand.forEach((key, value){
//        List list = value;
//        list.forEach((item){
//          print("--------------" + item.toString());
//        });
//      });
//      print("--------------load brand end" + allBrand.length.toString());
      this.setState((){});
      return allBrand;
    },onError: (){
      return {};
    });
    return allBrand;
  }

}

class ColumnEx extends StatefulWidget {
  bool isTitle;
  String letter = "";
  String pic;
  bool isLoadPic;
  String name;
  ColumnEx({Key key, this.name:"", this.letter:"", this.isTitle:false, this.isLoadPic:false, this.pic:null}):super(key:key);

  @override
  _ColumnEx createState() => new _ColumnEx();
}

class _ColumnEx extends State<ColumnEx> {
  bool _isCanLoad = false;
  @override
  Widget build(BuildContext context) {
    Widget logo = null;
    if(null == widget.pic || !widget.isLoadPic || !_isCanLoad){
      logo = new Container(width: 80.0, height: 80.0,);
    }else{
      print("--------->load-->${widget.name}  $_isCanLoad");
      logo = new CachedNetworkImage(imageUrl: widget.pic, width: 80.0, height: 80.0,);
    }

    return new Column(
      children: <Widget>[
        widget.isTitle ?new Container(
          padding: new EdgeInsets.only(left: 20.0),
          color: new Color(0xFFE8E8E8),
          height: 25.0, alignment: Alignment.centerLeft,
          child: new Text(widget.letter),
        ):new Container(),//
        new Container(
          padding: new EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
          color: Colors.white, alignment: Alignment.centerLeft,
          child: new Row(
            children: <Widget>[
              logo,
              new Padding(padding: new EdgeInsets.only(left: 20.0), child: new Text(widget.name),),
            ],
          ),//
        ),//
        new Padding(padding: new EdgeInsets.only(left: 20.0),child: new Container(height: 2.0, color: new Color(0xFFE8E8E8),),),
      ],
    );
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _isCanLoad = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isCanLoad = false;
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _isCanLoad = false;
    super.deactivate();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
  }
}
