import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

import 'CityScreen.dart';
import '../views/AntRouterAnim.dart';
import '../config/City.dart';
import 'VIPSearchScreen.dart';
import 'VIPUserInfoScreen.dart';

import '../utils/Utiltool.dart';
import '../config/TestData.dart';
import 'package:imitationvip/views/AntBanner.dart';

import '../views/AntDivider.dart';
//import '../config/TDataCate.dart';


//import '../../networks/NetWorkUtils.dart';

const Color testColor = const Color(0xFFFFEBCD);

class VIPMainScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _VIPMainScreenState();
  }

}

const String _TOPMENU = "TOPMENU";
const String _TOPMAINCATE = "_TOPMainCate";
const String _MAINHOME_LETOUT = "mainhome_letout";
const String _LOAD_DATA_TIME = "_LOAD_DATA_TIME";

class _VIPMainScreenState extends State<VIPMainScreen>{


  City _selCity;
  PageController _pageController;
  ScrollController _scrollController;
  Size _screenSize;

  List topMenu;
  List mainHomeTopCate;
  List mainHomeLetoutData;

  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = new PageController();

    _scrollController = new ScrollController();


    _loadTopMenu();

    _loadTopCate();

    _loadLetout();
  }

  Future _loadTopMenu() async{
    if(null != topMenu && 0 < topMenu.length){
      return;
    }

    _sharedPreferences = await SharedPreferences.getInstance();
    String jsonMenu = _sharedPreferences.getString(_TOPMENU);
    if(null != jsonMenu && "".compareTo(jsonMenu) < 0 ){
      topMenu = json.decode(jsonMenu);
      this.setState((){});
      return;
    }

    await http.post(VIP_TOPMENU_URL, headers: HEADERS, body: json.encode(VIP_TOPMENU_BODY)).then((http.Response response){
      Map data = json.decode(response.body);
      String jsonData = decodeBase64(data['data']);
      topMenu = json.decode(jsonData);
      this.setState((){});
      _sharedPreferences.setString(_TOPMENU, jsonData);
    }).catchError((){
      return "error";
    }).whenComplete((){});

  }

  Future _loadTopCate() async{
    if(null != mainHomeTopCate && 0 < mainHomeTopCate.length){
      return;
    }
    _sharedPreferences = await SharedPreferences.getInstance();
    String jsonMenu = _sharedPreferences.getString(_TOPMAINCATE);
    if(null != jsonMenu && "".compareTo(jsonMenu) < 0 ){
      mainHomeTopCate = json.decode(jsonMenu);
      this.setState((){});
      return;
    }

    await http.post(VIP_TOPMAINCATE_URL, headers: HEADERS, body: json.encode(VIP_TOPMAINCATE_BODY)).then((http.Response response){
      Map data = json.decode(response.body);
      String jsonData = decodeBase64(data['data']);
      mainHomeTopCate = json.decode(jsonData);
      this.setState((){});
      _sharedPreferences.setString(_TOPMAINCATE, jsonData);
    }).catchError((){
      return "error";
    }).whenComplete((){});
  }

  Future _loadLetout() async{
    if(null != mainHomeLetoutData && 0 < mainHomeLetoutData.length){
      return;
    }
    _sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = _sharedPreferences.getString(_MAINHOME_LETOUT);
    if(null != jsonData && "".compareTo(jsonData) < 0 ){
      mainHomeLetoutData = json.decode(jsonData);
      this.setState((){});
      return;
    }

    await http.post(VIP_MAINHOME_LETOUT_URL, headers: HEADERS, body: json.encode(VIP_MAINHOME_LETOUT_BODY))
        .then((http.Response response){
      Map data = json.decode(response.body);
      String jsonData = decodeBase64(data['data']);
      mainHomeLetoutData = json.decode(jsonData);
      this.setState((){});
      _sharedPreferences.setString(_MAINHOME_LETOUT, jsonData);
    }).catchError((){
    });
  }

  void _clickSearch(){
    print("---------click search");
    Navigator.push(context, new AntRouterAnim(builder: (context)=>new VIPSearchScreen()));
  }

  void _clickCity(){
    print("---------click city");
    Navigator.push(context, new AntRouterAnim(builder: (context)=>new CityScreen()))
    .then((c){
      this.setState((){
        _selCity = c;
      });
    });
  }

  void _onClickProCate(String name, int index){

  }

  void _closeDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: _renderAppBar(context),
      body: _makeMainView(),
      drawer: new Drawer(child: _makeDrawer(),),
      floatingActionButton: _renderFloatingButton(context),
    );
  }

  /**
   * 标题栏
   */
  AppBar _renderAppBar(BuildContext context){
    return new AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(builder: (context){
        return new IconButton(
          icon: const Icon(Icons.menu, color: Colors.grey,),
          onPressed: (){
            _closeDrawer(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      }),
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("VIP", style: new TextStyle(color: Colors.red, fontSize: 20.0),),
          new Padding(padding: new EdgeInsets.only(left: 10.0)),
          new GestureDetector(child: new Row(
            children: <Widget>[
              new Text(null == _selCity?"地址":_selCity.cityName, style: new TextStyle(color: Colors.black, fontSize: 12.0),
                textAlign: TextAlign.right,
              ),
              new Icon(Icons.arrow_drop_down, color: Colors.black,),
            ],
          ),
            onTap: _clickCity,
          ),
        ],
      ),//title
      actions: <Widget>[
        new IconButton(
            icon: new Image.asset("imgs/vips/search_icon_empty.png", width: 20.0, height: 20.0, fit: BoxFit.fill,),
            onPressed: _clickSearch),
      ],
    );
  }

  /**
   * 浮动按钮
   */
  Widget _renderFloatingButton(BuildContext context){
    return new Container(
      margin: new EdgeInsets.only(left: 30.0, right: 200.0),
      padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
      height: 40.0,
      width: 150.0,
      alignment: Alignment.bottomCenter,
      decoration: new BoxDecoration(
        color: Colors.black,
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new InkWell(
            child: new Image.asset("imgs/vips/icon_float_user_normal.png", width: 35.0, height: 35.0,),
            onTap: (){
              _floatBtnClick(0);
            },
          ),
          new InkWell(
            child: new Image.asset("imgs/vips/icon_float_collect_normal.png", width: 35.0, height: 35.0,),
            onTap: (){
              _floatBtnClick(1);
            },
          ),
          new InkWell(
            child: new Image.asset("imgs/vips/icon_float_shoppingcar_normal.png", width: 35.0, height: 35.0,),
            onTap: (){
              _floatBtnClick(2);
            },
          ),
        ],
      ),
    );
  }

  void _floatBtnClick(int index){
    if(0 == index){
      Navigator.push(context, new AntRouterAnim(builder: (context)=>new VIPUserInfoScreen()));
    }
  }

  Widget _makeMainView(){
    List<Widget> adList = listAdFlow.map((item){
      return new Image.network(item, fit: BoxFit.fill,);
    }).toList();

    Widget resWidget = new Container(
      child: new Column(
        children: <Widget>[
          _makeScrollCate(),
          new Expanded(
              child:new SingleChildScrollView(
                physics: new ScrollPhysics(),
                child: new Column(
                  children: <Widget>[
                    new AntBanner(children: <Widget>[
                    ]..addAll(adList),duration: new Duration(seconds: 3),height: 150.0, callback: (int i){
                      print("----pageview---" + i.toString());
                    },),
                    _renderMainScreenCate(0),

                  ]..addAll(_rendHomeMainBlock())
                    ..addAll(_rendLetout())
                    ..addAll(_rendLetOutBrand())
                    ..add(new Container(height: 80.0, color: greyColor,)),
                ),
              ),//
            flex: 2,),
        ],
      ),
    );

    return resWidget;
  }

  /**
   * 首页顶部分类
   */
  Widget _renderMainScreenCate(int rowIndex){
    if(null == mainHomeTopCate || mainHomeTopCate.length <= 0){
      return new Container();
    }

    //mainHomeListCateData
    List homeTopScreenData = mainHomeTopCate[0]['result']['data']['data']['content'];
//    print("-----------" + homeTopScreenData.length.toString());
//
    double widthStep = (_screenSize.width) / 100.0;
    double heightStep = _screenSize.height / 100.0;

    String backgroundURL = homeTopScreenData[0]['data']['backgroundPic'];

    List listColumn = homeTopScreenData[0]['data']['block'];
//    print("------------block size:" + listColumn.length.toString());

    List<Widget> listRetWidget = [];
    for(int index = 0, len = listColumn.length; index < len; index++){
      Map column = listColumn[index];
      double height = column["size"] * heightStep;

      List childrents = column['child'];
//      print("------------childrents size:" + childrents.length.toString());

      List<Widget> listRow = childrents.map((child){
        String picURL = child['data']['imageUrl'];
        double cWidth = child['size'] * widthStep;
        return new Expanded(child: new CachedNetworkImage(imageUrl: picURL,  fit: BoxFit.fill,),flex: 1,);
      }).toList();

      Container container = new Container(
//        height: height,
        alignment: Alignment.center,
        padding: new EdgeInsets.all(0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[]..addAll(listRow),
        ),
      );
      listRetWidget.add(container);
    }

    if("".compareTo(backgroundURL) != 0){
      return new Container(
        decoration: _renderBgPic(backgroundURL),
        child: new Column(
          children: <Widget>[]..addAll(listRetWidget),
        )
      );
    }else{
      return new Column(
        children: <Widget>[]..addAll(listRetWidget),
      );
    }
  }

  List<Widget> _rendHomeMainBlock(){
    List<Widget> listMainBlock = [];
    if(null == mainHomeTopCate || 0 >= mainHomeTopCate.length){
      return listMainBlock;
    }
//    List homeTopScreenData = mainHomeListCateData[0]['result']['data']['data']['content'];
    List homeTopScreenData = mainHomeTopCate[0]['result']['data']['data']['content'];
    for(int index = 1, len = homeTopScreenData.length; index < len; index++){
      listMainBlock..addAll(_renderRowBlockProxy(homeTopScreenData[index]));
    }

    return listMainBlock;
  }

  /**
   * 渲染顶部分类下面的布局
   */
  List<Widget> _renderRowBlockProxy(Map subject){
    Map subData = subject['data'];

    List listBlock = subData['block'];
    List<Widget> listBlockView = [];
    for(int index = 0, len = listBlock.length; index < len; index++){
      Map block = listBlock[index];
      String cell = block['cell'];
      double size = block['size']*1.0;
      double wapsize = block['wapsize']*1.0;

      List<Widget> listItem = [];
      List blockChildList = block['child'];
      double widthItem = _screenSize.width / wapsize;

      for(int i = 0, l = blockChildList.length; i < l; i++){
        Map item = blockChildList[i];
        Map d = item['data'];
        String pic = d['imageUrl'];

        Widget img = new Image.network(pic, width: widthItem * item['size'],);
        listItem.add(img);
      }
      listBlockView.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[]..addAll(listItem),
      ));
    }
    return listBlockView;
  }

  /**
   * 渲染推荐折扣
   */
  List<Widget> _rendLetout(){
    List<Widget> listViews = [];
    if(null == mainHomeTopCate || 0 >= mainHomeTopCate.length){
      return listViews;
    }
//    List homeTopScreenData = mainHomeListCateData[1]['result']['data']['data'];
    List homeTopScreenData = mainHomeTopCate[1]['result']['data']['data'];


    for(int index = 0, len = homeTopScreenData.length; index < len; index++){
      Map rowMap = homeTopScreenData[index];
      String template = rowMap['template'];

      if(0 == "three".compareTo(template)){
        listViews.add(_renderThreeTemplate(rowMap));
      }else if(0 == "small".compareTo(template)){
        listViews.add(_renderSmallTemplate(rowMap));
      }else if(0 == "none".compareTo(template)){
        listViews.add(_renderBrandWallBig(rowMap));

      }else{
        listViews.add(_renderRecommendCategory(rowMap));
//        List childList = rowMap['contents'];
//        print("----------- $index ->" + childList.length.toString());
      }
    }


    return listViews;
  }

  /**
   * 渲染一行3个图片墙
   */
  Widget _renderThreeTemplate(Map rowMap){
//    Map rowMap = homeTopScreenData[0];
//
    List childList = rowMap['contents'];

    Decoration decoration = null;
    String sliderBackgroudPic = rowMap['sliderBackgroudPic'];
    if(null != sliderBackgroudPic && 0 != "".compareTo(sliderBackgroudPic)){
      decoration = new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        image: new DecorationImage(image: new NetworkImage(sliderBackgroudPic), fit: BoxFit.fill),
      );
    }

    List<Widget> listRowView = [];
    for(int index = 0, len = childList.length; index < len; index++){
      String pic = childList[index]['pic'];
      Widget img = new Image.network(pic, width: _screenSize.width/3-10, fit: BoxFit.fill,);
      listRowView.add(img);
    }
    return new Container(
      decoration: decoration,
      alignment: Alignment.center,
      padding: new EdgeInsets.only(top: 45.0,bottom: 10.0, left: 5.0, right: 5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[]..addAll(listRowView),
      ),
    );
  }

  /**
   * 渲染一行滑动图片墙
   */
  Widget _renderSmallTemplate(Map rowMap){

    List childList = rowMap['contents'];
    List<Widget> listRowView = [];
    for(int index = 0, len = childList.length; index < len; index++){
      String pic = childList[index]['pic'];
      Widget img = new Image.network(pic, width: 100.0, fit: BoxFit.fill,);
      listRowView.add(img);
    }

    return new Container(
      alignment: Alignment.center,
      width: _screenSize.width,
      height: 140.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[]..addAll(listRowView),
      ),
    );
  }

  /**
   * 渲染有背景导航的图片墙
   */
  Widget _renderRecommendCategory(Map rowMap){
    List childList = rowMap['contents'];

    Decoration decoration = null;
    String sliderBackgroudPic = rowMap['sliderBackgroudPic'];
    if(null != sliderBackgroudPic && 0 != "".compareTo(sliderBackgroudPic)){
      decoration = new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        image: new DecorationImage(image: new NetworkImage(sliderBackgroudPic), fit: BoxFit.fill),
      );
    }

    List<Widget> listRowView = [];
    double itemWidth = _screenSize.width / 4 - 15;
    listRowView.add(new Container(width: itemWidth+45,));
    for(int index = 0, len = childList.length; index < len; index++){
      String pic = childList[index]['pic'];
      Widget img = new Image.network(pic, width: itemWidth, fit: BoxFit.cover,);
      listRowView.add(img);
    }
    return new Container(
      decoration: decoration,
      alignment: Alignment.center,
//      height: 140.0,
//      padding: new EdgeInsets.only(top: 45.0,bottom: 10.0, left: 5.0, right: 5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[]..addAll(listRowView),
      ),
    );
  }

  /**
   * 渲染品牌
   */
  Widget _renderBrandWallBig(Map rowMap){
    List childList = rowMap['contents'];

    Decoration decoration = null;
    String sliderBackgroudPic = rowMap['sliderBackgroudPic'];
    if(null != sliderBackgroudPic && 0 != "".compareTo(sliderBackgroudPic)){
      decoration = new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        image: new DecorationImage(image: new NetworkImage(sliderBackgroudPic), fit: BoxFit.fill),
      );
    }

    List<Widget> listRowView = [];
    double itemWidth = _screenSize.width / childList.length-20;
    for(int index = 0, len = childList.length; index < len; index++){
      String pic = childList[index]['brandStoreLogoPic'];
      Widget img = new Image.network(pic, width:itemWidth,fit: BoxFit.fill,);
      listRowView.add(img);
    }
    return new Container(
      decoration: decoration,
      alignment: Alignment.center,
      height: 100.0,
      padding: new EdgeInsets.only(left: 15.0, right: 15.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[]..addAll(listRowView),
      ),
    );
  }

  /**
   * 渲染品牌折扣
   */
  List<Widget> _rendLetOutBrand(){
    if(null == mainHomeLetoutData || 0 >= mainHomeLetoutData.length){
      return [new Container()];
    }
    //mainHomeListLetOutData
    Map allData = mainHomeLetoutData[0]['result']['data']['data'];
    List listData = allData['list'];

    String baseURl = "https://a1.vimage1.com//upload/brand/";
    List<Widget> listViews = [];
    if(null == listData){
      return listViews;
    }
    for(int index = 0, len = listData.length; index < len; index++){
      String picUrl = listData[index]['mobile_image_one'];
      if(picUrl.indexOf("http") != 0){
        picUrl = baseURl + picUrl;
      }
      String name = listData[index]['brand_name'];
      String agio = listData[index]['agio'];
      String tAgio = "";
//      String tAgio = agio.substring(22, 25);
//      tAgio = tAgio + agio.substring(32);
      String sell_time_from = listData[index]['sell_time_from'];
      String sell_time_to = listData[index]['sell_time_to'];
      String tip = "购物即享8.8折，限10号10:00-11号10:00";
//      print("--------------"+picUrl);
      Widget child = new InkWell(
          onTap: null,
          child: new Column(
            children: <Widget>[
              new Container(height: 15.0, color: greyColor, alignment: Alignment.center,),
//              new Image.network(picUrl),
              new CachedNetworkImage(imageUrl: picUrl),
              new Container(
                padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(flex: 2,
                      child: new Text(tAgio + " " + name, style: const TextStyle(fontSize: 16.0,color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                    new Text("剩2小时", style: const TextStyle(fontSize: 12.0,color: Colors.grey),),
                  ],
                ),//Row
              ),
              new Container(
                padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                alignment: Alignment.center,
                child: new Text(tip, style: const TextStyle(fontSize: 12.0,color: const Color(0xFF7D9EC0), fontWeight: FontWeight.bold),),
              ),
            ],
          ),
      );

      listViews.add(child);
    }
    return listViews;
  }

  /**
   * 顶部水平导航栏
   */
  Widget _makeScrollCate(){

    return new Container(
      alignment: Alignment.centerLeft,
      height: 40.0,
      color: Colors.white,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              child: new Container(
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: _renderCate(),
                )
              ),
            flex: 2,
          ),
          new Container(
            color: Colors.white,
            height: 40.0,
            width: 50.0,
            child: new IconButton(icon: new Icon(Icons.keyboard_arrow_down), onPressed: null),
          ),
        ],
      ),
    );
  }

  //=======================================================================================
  /**
   * 顶部导航item
   */
  List<Widget> _renderCate(){
      if(null == topMenu || 0 >= topMenu.length){
        return [new Container()];
      }
//    List list = topMenuList[0]['result']['data']['data']['top_menus'];
    List list = topMenu[0]['result']['data']['data']['top_menus'];

    return list.map((item){
      String menuName = item['name'];
//      print("------------->" + json.encode(item));
      return new Container(
        alignment: Alignment.center,
        constraints: new BoxConstraints(minWidth: 50.0),
        color: item.toString().compareTo("今日推荐") == 0 ? Colors.red:Colors.white,
        height: 40.0,
        padding: new EdgeInsets.only(left: 5.0, right: 5.0),
        child: new Text(menuName, style: const TextStyle(color: Colors.black, fontSize: 16.0),),
      );
    }).toList();

  }

  //=================================================================================
  Widget _makeDrawerCate(){
    List<Widget> list = [];

    for(int index = 3; index < drawerList.length; index++){
      Map item = drawerList[index];
      Widget view = new InkWell(child: new Card(elevation: 3.0,
        color: Colors.transparent,
        child: new Center(
          heightFactor: 2.0,
          child: new Column(
            children: <Widget>[
              new Expanded(child: new Image.network(item["pic"],), flex: 2,),
              new Container(padding: new EdgeInsets.only(top: 15.0), child: new Text(item['name'], style: const TextStyle(color: Colors.white, fontSize: 14.0),),),
            ],
          ),
        ),//Center
      ), onTap: (){_onClickProCate(item["name"], index);},);
      list.add(view);
    }

    Widget resWidget = new Container(
      height: 400.0,
      child: new GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 25.0),
          children: list,
      ),//GridView
    );

    return resWidget;
  }

  Widget _makeDrawer(){
    return new Container(
      color: Colors.black,
      padding: new EdgeInsets.only(top: 24.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.network(drawerList[0]['pic'], width: 30.0, height: 30.0,),
              new Padding(
                  padding: new EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                  child: new Text(drawerList[0]['name'], style: const TextStyle(color: Colors.white, fontSize: 16.0),),
              ),
            ],
          ),//Row
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Image.network(drawerList[1]['pic'], width: 30.0, height: 30.0,),
              new Padding(
                padding: new EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: new Text(drawerList[1]['name'], style: const TextStyle(color: Colors.white, fontSize: 16.0),),
              ),
            ],
          ),//Row
          new Row(
            children: <Widget>[
              new Image.network(drawerList[2]['pic'], width: 30.0, height: 30.0,),
              new Padding(
                padding: new EdgeInsets.only(left: 10.0,top: 20.0, bottom: 10.0),
                child: new Text(drawerList[2]['name'], style: const TextStyle(color: Colors.white, fontSize: 16.0),),
              ),
            ],
          ),//Row
          new Expanded(child: _makeDrawerCate(), flex: 2,),
          new Container(
            margin: new EdgeInsets.only(top: 20.0),
            decoration: new BoxDecoration(
              border: new Border(
                top: AntDivider.createBorderSide(context,color: greyColor, width: 1.0),

              ),
            ),
            height: 50.0,
            alignment: Alignment.center,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text("个人中心", style: const TextStyle(color: Colors.white, fontSize: 14.0),),
                new Container(height: 50.0,color: greyColor,width: 1.0,),
                new Text("品牌收藏", style: const TextStyle(color: Colors.white, fontSize: 14.0),),
              ],
            ),//row
          ),
        ],
      ),//Column
    );
  }

  BoxDecoration _renderBgPic(String bgpic){
    Decoration decoration = null;
    if(null != bgpic && 0 != "".compareTo(bgpic)){
      decoration = new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        image: new DecorationImage(image: new NetworkImage(bgpic), fit: BoxFit.fill),
      );
    }
    return decoration;
  }
}