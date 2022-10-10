import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const Badge({
    Key key,
    @required this.value,
    this.color,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 4,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color!=null?color:Theme.of(context).accentColor
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16),
            child: Text(value,
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,)),
        )
      ],
    );
  }
}
