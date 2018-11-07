import 'package:flutter/material.dart';

import '../config/TestData.dart';

const Color colorSearch = const Color(0xFFE8E8E8);
const Color colorCate = const Color(0xFFE8E8E8);

class VIPSearchScreenT extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VIPSearchScreenTState();
  }
}

class _VIPSearchScreenTState extends State<VIPSearchScreenT>{

  bool _isWord = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _search(){
    _isWord = true;
    this.setState((){});
  }

  void _onChanged(String text){
    _isWord = false;
    if(0 < text.length){
      _isWord = true;
    }
    this.setState((){});
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget inputWidget = new Container(
      padding: new EdgeInsets.only(left: 5.0, right: 5.0),
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: colorSearch,
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
      ),
      child: new Row(
        children: <Widget>[
          new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
//                        new Text("查询信息", style: new TextStyle(color: Colors.grey, fontSize: 16.0),),
          new Flexible(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "手机",
                border: InputBorder.none,
                contentPadding: new EdgeInsets.only(left: 10.0),
              ),//InputDecoration
              keyboardType: TextInputType.text,
              onChanged: _onChanged,
            ),//
          ),//
        ],
      ),
    );//Container

    return new Scaffold(
      appBar: new AppBar(
        leading:  new IconButton(icon: new Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){Navigator.of(context).pop();}),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: new Padding(padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
          child: new Row(
            children: <Widget>[
              new Expanded(child: inputWidget),
              new Container(width: 10.0,),
              new InkWell(
                onTap: _search,
                child: new Text("搜索", style: const TextStyle(color: Colors.black, fontSize: 16.0),),
              ),
            ],
          ),
        ),//title
      ),//appbar
      body: new Container(
        padding: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        child: new ListView(
          children: _buildItem(),
        ),
      ),
    );
  }

  List<Widget> _buildItem(){
    if(!_isWord){
      return [];
    }
    return listSearchWordT.map((item){
      return new Column(
        children: <Widget>[
          new Container(
            height: 60.0,
            alignment: Alignment.centerLeft,
            child: new Text(item, style: const TextStyle(color: Colors.grey, fontSize: 16.0),),
          ),
          new Container(height: 2.0,color: colorSearch,)
        ],
      );
    }).toList();
  }
}