import 'package:flutter/material.dart';

import '../views/AntDivider.dart';
import '../config/TestData.dart';

class VIPUserInfoScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VIPUserInfoScreenState();
  }

}

class _VIPUserInfoScreenState extends State<VIPUserInfoScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget body = new SingleChildScrollView(
      physics: new ScrollPhysics(),
      child: new Column(
        children: <Widget>[
          new Container(
            height: 100.0,
            child: new Text("sss"),
          ),//Container
          new Container(
            padding: new EdgeInsets.only(left: 20.0),
            height: 30.0,
            color: greyColor,
            alignment: Alignment.centerLeft,
            child: new Text("关于修改地址温馨提示"),//
          ),//
          new Container(
            padding: new EdgeInsets.only(left: 20.0, right: 20.0),
            height: 100.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
                    new Text("待付款"),
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
                    new Text("待收货"),
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
                    new Text("全部订单"),
                  ],
                ),
              ],
            ),//
          ),//
          new AntDivider(height: 10.0, color: greyColor,),//
          new Container(
            height: 50.0,
            padding: new EdgeInsets.only(left: 20.0),
            alignment: Alignment.centerLeft,
            child: new Text("我的资产"),
          ),//
          new AntDivider(height: 10.0, color: greyColor,),//
          new Container(
            height: 50.0,
            alignment: Alignment.centerLeft,
            padding: new EdgeInsets.only(left: 20.0),
            child: new Text("我的特卖"),
          ),//
          new AntDivider(height: 10.0, color: greyColor,),//
          _renderMineRight(listRight),//
          new AntDivider(height: 10.0, color: greyColor,),//
          _renderMineRight(listVIPAPPSetting),//
          new AntDivider(height: 20.0, color: greyColor,),//
        ],
      ),//Column
    );

    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text("我的唯品会", style: const TextStyle(color: Colors.black, fontSize: 18.0),),
        actions: <Widget>[
          new Image.asset("imgs/vips/topbar_setup_normal.png", width: 20.0, height: 20.0,),
          new Padding(padding: new EdgeInsets.only(right: 10.0)),
        ],
      ),
      body: new Container(
        child: body,
      ),//body
    );
  }

  Widget _renderMineRight(List list){

    List listView = list.map((item){
      return new Container(
        padding: new EdgeInsets.only(left: 20.0),
        height: 50.0,
        decoration: new BoxDecoration(
          border: new Border(
            bottom: AntDivider.createBorderSide(context,color: greyColor, width: 1.0),
          ),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(child: new Text(item["name"], style: const TextStyle(color: Colors.black, fontSize: 14.0),),flex: 2,),
            new Text(item["des"], style: const TextStyle(color: Colors.grey, fontSize: 12.0),),
            new Icon(Icons.arrow_right, color: Colors.grey,),
          ],
        ),
      );
    }).toList();

    return  new Container(
      alignment: Alignment.centerLeft,
      child: new Column(
        children: listView,
      ),
    );
  }

}

