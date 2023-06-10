import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle style;
  final Function onPressed;
  final BorderRadius radius;
  final String icon;
  CustomButton(
      {this.color = Colors.white,
      this.text = '',
      this.style,
      this.onPressed,
      this.radius,
      this.icon});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: 46,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          borderRadius: radius ?? BorderRadius.circular(11)),
      onPressed: onPressed,
      child: (icon == null)
          ? Text(
              text,
              style: style ??
                  Theme.of(context)
                      .textTheme
                      .overline
                      .copyWith(color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon ?? 'assets/images/Calendar2.png'),
                SizedBox(
                  width: 7,
                ),
                Text(
                  text,
                  style: style ??
                      Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white),
                )
              ],
            ),
      color: color,
    );
  }
}
