
import 'package:flutter/material.dart';
import 'WidgetPosition.dart';

const List<String> DEFAULT_LETTER = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"];
//const List<String> DEFAULT_LETTER = ["A", "B", "C", "D", "E", "F", ];

typedef void ChangeLetter({int index, String letter, int status});

/**
 * 字母导航控件
 */
class LetterNavWidget extends StatefulWidget {

  List<String> listLetter;
  TextStyle letterStyle;
  ChangeLetter changeLetter;

  LetterNavWidget({Key key,this.listLetter:DEFAULT_LETTER, this.changeLetter,
    this.letterStyle:const TextStyle(color: Colors.black, fontSize: 16.0)}):super(key:key){
//    _letterLength = listLetter.length;
  }

  @override
  _LetterNavWidgetState createState() => new _LetterNavWidgetState();
}

class _LetterNavWidgetState extends State<LetterNavWidget> {
  GlobalKey posKey = WidgetPosition.defaultKey();
  Rect _letterSize;
  int _letterLength = 0;
  double _itemHeight = -1.0;
  int _currentLetterIndex = 0;
  RenderBox renderBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _letterLength = widget.listLetter.length;
  }

  @override
  Widget build(BuildContext context) {
    return new WidgetPosition(
        key: posKey,
        child: new GestureDetector(
          onVerticalDragDown: (detail){
            _onPanDown(detail, context);
          },
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
    return widget.listLetter.map((letter){
      return new Expanded(
          flex: 1,
          child: new Container(
            alignment: Alignment.center,
            child: new Text(letter, style: widget.letterStyle),
          ));
    }).toList();
  }

  int _calIndex(Offset offset, BuildContext buildContext){
    if(null == renderBox){
      renderBox = buildContext.findRenderObject();
    }
    Offset local = renderBox.globalToLocal(offset);

    int index = (local.dy/_itemHeight).floor();
    if(0 > index){
      index = 0;
    }else if(index >= _letterLength){
      index = _letterLength - 1;
    }
    return index;
  }

  void _onPanDown(DragDownDetails detail, BuildContext buildContext){
    if(null == _letterSize){
      _letterSize = WidgetPosition.getRect(posKey);
    }
    if(-1.0 == _itemHeight) {
      _itemHeight = _letterSize.height / _letterLength;
    }
    int index = _calIndex(detail.globalPosition, buildContext);

    if(null != widget.changeLetter && index != _currentLetterIndex){
      print("---->$index  $_currentLetterIndex");
      widget.changeLetter(index:_currentLetterIndex, letter:widget.listLetter[index], status:0);
    }
    _currentLetterIndex = index;
  }

  void _onPanUpdate(DragUpdateDetails detail, BuildContext buildContext){
    int index = _calIndex(detail.globalPosition, buildContext);
    if(null != widget.changeLetter && index != _currentLetterIndex){
      widget.changeLetter(index:_currentLetterIndex, letter:widget.listLetter[index], status:1);
    }
    _currentLetterIndex = index;
  }

  void _onPandDragEnd(DragEndDetails detail){
    if(null != widget.changeLetter){
      widget.changeLetter(index:_currentLetterIndex, letter:widget.listLetter[_currentLetterIndex], status:-1);
    }
  }
}