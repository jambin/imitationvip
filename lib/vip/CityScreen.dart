import 'package:flutter/material.dart';

import '../config/City.dart';


class CityScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CityScreenState();
  }

}

class _CityScreenState extends State<CityScreen> with TickerProviderStateMixin{
  TabController _controller;
  int _selIndex = 0;
  ProvinceList provinceList;

  Province selProvince;
  City _selCity;

  ScrollController _scontroller;
  String preProvinceCode = "";
  String preCityCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = new TabController(initialIndex: 0, length: 2, vsync: this);
    _controller.addListener((){
      if(_selIndex != _controller.index){
        _selIndex = _controller.index;
        print("-------_controller previousIndex  " + _controller.previousIndex.toString());
        print("-------_controller index  " + _selIndex.toString());
        this.setState((){});
      }
    });

    provinceList = ProvinceList.initData();

    _scontroller = new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _scontroller.addListener((){

      print("-------ScrollController" + _scontroller.offset.toString() + "---" + _scontroller.position.pixels.toString());
    });
  }

  void _cancel(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("-------_controller index  " + _selIndex.toString());
    return new Scaffold(
      
      body: new Container(
        padding: new EdgeInsets.only(top: 24.0,),
        child: new Column(
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Padding(
                          padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Text("取消", style: new TextStyle(color: const Color.fromARGB(255, 102, 102, 102), fontSize: 14.0),),
                      ),
                    onTap: _cancel,
                  ),

                  new Expanded(child: new Center(child: new Text("选择收货地址", style: new TextStyle(color: const Color.fromARGB(255, 102, 102, 102), fontSize: 18.0),),), flex: 2,)
                ],
              ),//row
            ),//Padding
            new Center(heightFactor: 2.0,child: new Text("选择你要的收货地址，送货更快哦", style: new TextStyle(fontSize: 14.0),),),
            new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.only(left: 10.0),
              color: new Color(0xFFE8E8E8),
              height: 30.0,
              child: new Text("您的位置", style: new TextStyle(fontSize: 14.0),),
            ),//Container
            new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.only(left: 10.0),
              height: 30.0,
              child: new Text(getSelTarget(), style: new TextStyle(fontSize: 14.0),),
            ),//Container
            new Container(height: 5.0, color: new Color(0xFFE8E8E8),),
            new TabBar(tabs: [
                new Tab(child: new Text("省份", style: new TextStyle(color: 0 == _selIndex?Colors.red:Colors.grey, fontSize: 16.0),),),
                new Tab(child: new Text("地市", style: new TextStyle(color: 1 == _selIndex?Colors.red:Colors.grey, fontSize: 16.0),),),
              ],
              controller: _controller,
              indicator: new UnderlineTabIndicator(borderSide: new BorderSide(width: 2.0, color: Colors.red)),
            ),
            new Expanded(
                flex: 2,
                child: new TabBarView(
                    children: [
                      new ListView(
                        controller: _scontroller,
                        children: provinceList.list.map((Province item){
                          return _buildItem(0,item.name, item.code, item.letter);
                        }).toList(),
                      ),
                      new ListView(
                        children: null == selProvince?<Widget>[
                          new Container(
                            alignment: Alignment.center,
                            child: new Text("请选择省份"),
                          ),
                        ]:selProvince.listCity.map((City city){
                          return _buildItem(1,city.cityName, city.cityCode, city.letter);
                        }).toList(),
                      ),
                    ],
                    controller: _controller,
                ),
            ),//
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int type, String name, String code, String letter){

    Widget childView = new Container(
        height: 60.0,
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: new Padding(
          padding: new EdgeInsets.only(left: 20.0, right: 20.0),
          child:  new Text(name, style: new TextStyle(fontSize: 18.0, color: Colors.black),),
        )
    );

    Widget widgetLetter = new Container(
      alignment: Alignment.centerLeft,
      height: 25.0, color: new Color(0xFFE8E8E8),
      child: new Padding(padding: new EdgeInsets.only(left: 20.0), child: new Text(letter, style: new TextStyle(fontWeight: FontWeight.bold),),),
    );

    Widget item = new GestureDetector(
      child: new Column(
        children: <Widget>[
          childView,
          new Container(height: 2.0, color: new Color(0xFFE8E8E8),),
        ],
      ),
      onTap: (){
        if(0 == type){
          _clickProvince(code);
        }else{
          _clickCity(code);
        }
        this.setState((){});
      },
    );

    bool isShow = false;
    if(0 == type){
      isShow = 0 == preProvinceCode.compareTo(letter)?false:true;
      preProvinceCode = letter;
    }else{
      isShow = 0 == preCityCode.compareTo(letter)?false:true;
      preCityCode = letter;
    }

    List<Widget> list = [];
    if(isShow){
      list.add(widgetLetter);
    }

    list.add(item);

    return new Column(
      children: list,
    );
  }

  void _clickProvince(String code){
    selProvince = provinceList.getByCode(code);
  }
  void _clickCity(String code){
    _selCity = selProvince.getByCode(code);
    Navigator.of(context).pop(_selCity);
  }

  String  getSelTarget(){
    if(null == selProvince && null == _selCity){
      return "(您还没选择地址)";
    }
    String p = null == selProvince?"":selProvince.name;
    String c = null == _selCity?"":_selCity.cityName;
    return p + " " + c;
  }
}

