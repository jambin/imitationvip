import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AntRouterAnim extends MaterialPageRoute{
  Duration _duration = new Duration(seconds: 1);

  AntRouterAnim({@required WidgetBuilder builder, RouteSettings settings}):super(builder:builder, settings:settings){
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => _duration;//super.transitionDuration;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
//    return super.buildTransitions(context, animation, secondaryAnimation, child);

    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );

//    Animation<Offset> animationEx = new Tween<Offset>(
//      begin: const Offset(-1.0, 0.0),
//      end: Offset.zero,
//    ).animate(animation);
//    return new SlideTransition(position: animationEx,
//      child: child,);
  }

}
