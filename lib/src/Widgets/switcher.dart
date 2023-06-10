import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const CustomSwitch({Key key, this.value, this.onChanged, this.activeColor})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 46.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? Colors.grey
                    : widget.activeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _circleAnimation.value == Alignment.centerRight
                    ? Padding(
                        padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                      )
                    : Container(),
                Align(
                  alignment: _circleAnimation.value,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
                _circleAnimation.value == Alignment.centerLeft
                    ? Container(
                        padding: const EdgeInsets.only(left: 6.0, right: 14.0),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}