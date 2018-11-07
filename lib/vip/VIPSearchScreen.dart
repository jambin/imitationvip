import 'package:flutter/material.dart';

import 'VIPAllBrandScreen.dart';
import '../views/AntRouterAnim.dart';
import 'VIPSearchScreenT.dart';

const Color colorSearch = const Color(0xFFE8E8E8);
const Color colorCate = const Color(0xFFE8E8E8);

class VIPSearchScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VIPSearchScreenState();
  }

}


class _VIPSearchScreenState extends State<VIPSearchScreen> with TickerProviderStateMixin{

  TabController _controller;
  int _selCateMenu = 0;
  int _selCateProducts = 0;

  List listCate = [ {"name":"母婴产品", "index":0},{"name":"女装", "index":1}, {"name":"男装", "index":2} ,{"name":"女鞋", "index":3} ,{"name":"男鞋", "index":4} ,{"name":"箱包", "index":6} ,{"name":"手表", "index":7},
  {"name":"水果蔬菜", "index":8}, {"name":"米面", "index":9}, {"name":"厨房用具", "index":10}, {"name":"生活家电", "index":11}, {"name":"个人护理", "index":12}, {"name":"床上用品", "index":13},];

  List listProduct = [{"name":"奶粉","index":0, "pic":"imgs/vips/new_ailise.png"},{"name":"奶粉","index":0, "pic":"imgs/vips/new_ailise.png"},
  {"name":"奶粉","index":0, "pic":"imgs/vips/new_ailise.png"},{"name":"奶粉","index":0, "pic":"imgs/vips/new_ailise.png"},];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(initialIndex: 0, length: 2, vsync: this);
    _controller.addListener((){
      if(_selCateMenu != _controller.index){
        this.setState((){
          _selCateMenu = _controller.index;
        });
      }
    });
  }

  void _back(){
    Navigator.of(context).pop();
  }

  void _search(){
    Navigator.push(context, new AntRouterAnim(builder: (context)=>new VIPSearchScreenT()));
  }

  void _allBrand(){
    Navigator.push(context, new AntRouterAnim(builder: (context)=>new VIPAllBrandScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        titleSpacing: 0.0,
        elevation: 2.0,
        leading: new InkWell(
          child: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back, color: Colors.black,),
          onTap: _back,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: new Padding(padding: new EdgeInsets.only(top: 7.0, bottom: 7.0, right: 20.0),
          child: new Container(
              padding: new EdgeInsets.only(left: 5.0, right: 5.0),
              alignment: Alignment.centerLeft,
              decoration: new BoxDecoration(
              color: colorSearch,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new InkWell(
                      child: new Row(
                        children: <Widget>[
                          new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
                          new Text("查询信息", style: new TextStyle(color: Colors.grey, fontSize: 16.0),),
                        ],
                      ),
                      onTap: _search,
                    ),//
                    flex: 2,
                ),//


                new Expanded(
                    child: new Align(
                      alignment: Alignment.centerRight,
                      child: new InkWell(
                        child: new Text("全部品牌", style: new TextStyle(color: const Color(0xFF666666), fontSize: 16.0),),
                        onTap: _allBrand,
                      ),
                    ),
                  flex: 1,
                ),//
              ],
            ),
          ),
        ),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.only(left: 100.0, right: 100.0),
                child: new TabBar(tabs: [
                  new Tab(child: new Text("分类", style: new TextStyle(color: 0 == _selCateMenu?Colors.red:Colors.grey, fontSize: 16.0),),),
                  new Tab(child: new Text("旗舰店", style: new TextStyle(color: 1 == _selCateMenu?Colors.red:Colors.grey, fontSize: 16.0),),),
                ], controller: _controller, indicatorColor: Colors.red,),
            ),//
            new Expanded(
                child: _makeCatePage(),
              flex: 2,
            ),//
          ],
        ),
      ),
    );
  }

  Widget _makeCatePage(){

    Iterable<Widget> list= listProduct.map((item){
      return new InkWell(child: new Card(elevation: 3.0,
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Expanded(child: new Image.asset(item["pic"],), flex: 2,),
              new Container(padding: new EdgeInsets.all(5.0), child: new Text(item['name'], style: const TextStyle(color: Colors.black, fontSize: 14.0),),),
            ],
          ),
        ),//Center
      ), onTap: (){_onClickProCate(item["name"], item["index"]);},);
    }).toList();

    return new Row(
      children: <Widget>[
        new Container(
          color: colorCate,
          width: 80.0,
          child: new ListView(
            children: this.listCate.map((item){
              return new InkWell(
                onTap: (){_onClickCateMenu(item["name"], item["index"]);},
                child: new Row(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      width: 5.0,
                      color: _selCateProducts == item["index"]? Colors.red: colorCate,
                    ),//
                    new Expanded(flex: 2,
                      child: new Center(child: new Text(item["name"], style: new TextStyle(color: const Color(0xFF666666), fontSize: 16.0),)),
                    ),//
                  ],
                ),//row
              );
            }).toList(),
          ),
        ),//
        new Expanded(
            child: new GridView(
              padding: new EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              children: list,
            ),//
          flex: 2,
        ),//

      ],
    );
  }

  void _onClickCateMenu(String name, int index){
    if(_selCateProducts == index){
      return;
    }
    this.setState((){
      _selCateProducts = index;
    });
  }

  void _onClickProCate(String name, int index){

  }

}