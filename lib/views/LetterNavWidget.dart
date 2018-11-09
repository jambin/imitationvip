
import 'package:flutter/material.dart';
import 'WidgetPosition.dart';

const List<String> DEFAULT_LETTER = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"];
//const List<String> DEFAULT_LETTER = ["A", "B", "C", "D", "E", "F", ];

typedef void ChangeLetter({int index, String letter, int status});

/**
 * 字母导航控件
 */
class LetterNavWidget extends StatelessWidget {
  List<String> listLetter;
  double _itemHeight;
  int _currentLetterIndex = 0;
  GlobalKey posKey = WidgetPosition.defaultKey();

  Rect _letterSize;
  int _letterLength = 0;
  TextStyle letterStyle;
  ChangeLetter changeLetter;

  LetterNavWidget({Key key,this.listLetter:DEFAULT_LETTER, this.changeLetter,
    this.letterStyle:const TextStyle(color: Colors.black, fontSize: 16.0)}):super(key:key){
    _letterLength = listLetter.length;
  }

  @override
  Widget build(BuildContext context) {
    return new WidgetPosition(
        key: posKey,
        child: new GestureDetector(
          onVerticalDragDown: _onPanDown,
          onVerticalDragUpdate: (detail){
            _onPanUpdate(detail, context);
          },
          onVerticalDragEnd: _onPandDragEnd,
          child: new Container(color: Colors.grey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: _makeLetter(),
            ),//
          ),//
        )
    );
  }
  List<Widget> _makeLetter(){
    return listLetter.map((letter){
      return new Expanded(
          flex: 1,
          child: new Container(
            alignment: Alignment.center,
            child: new Text(letter, style: this.letterStyle),
          ));
    }).toList();
  }

  void _onPanDown(DragDownDetails detail){
    if(null == _letterSize){
      _letterSize = WidgetPosition.getRect(posKey);
    }
    _itemHeight = _letterSize.height / _letterLength;
    if(null != changeLetter){
      changeLetter(status:0);
    }
    print("--------down-->$_itemHeight");
  }

  void _onPanUpdate(DragUpdateDetails detail, BuildContext buildContext){
    RenderBox box = buildContext.findRenderObject();
    Offset local = box.globalToLocal(detail.globalPosition);

    int index = (local.dy/_itemHeight).floor();
    print("--------update-->$index");
    if(0 <= index && index < _letterLength && null != changeLetter && index != _currentLetterIndex){
      _currentLetterIndex = index;
      changeLetter(index:_currentLetterIndex, letter:listLetter[_currentLetterIndex], status:1);
    }
  }

  void _onPandDragEnd(DragEndDetails detail){
    print("--------end-->$_itemHeight");
    if(null != changeLetter){
      changeLetter(index:_currentLetterIndex, letter:listLetter[_currentLetterIndex], status:-1);
    }
  }
}