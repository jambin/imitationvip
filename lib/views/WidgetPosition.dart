import 'package:flutter/material.dart';

/**
 * 获取Widget的坐标，如果widget没有在界面显示返回null
 */
class WidgetPosition extends StatefulWidget{
  Widget child;
  GlobalKey<_WidgetPositionState> key;

  WidgetPosition({this.key, this.child}):super(key:key){

  }

  static GlobalKey<_WidgetPositionState> defaultKey(){
    return new GlobalKey<_WidgetPositionState>();
  }

  static Rect getRect(GlobalKey key){
    var object = key?.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    var size = object?.semanticBounds?.size;

    if (translation != null && size != null) {
      Rect rect= new Rect.fromLTWH(translation.x, translation.y, size.width, size.height);
//      print("----------->" + rect.top.toString() + "--" + rect.left.toString() + "--" + rect.bottom.toString());
//      print("---------->" + rect.toString());
      return rect;
    } else {
//      print("----------->" + "error");
      return null;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WidgetPositionState();
  }

}

class _WidgetPositionState extends State<WidgetPosition>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.child;
  }
}