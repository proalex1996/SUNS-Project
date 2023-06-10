import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color emptyColor;
  final double size;
  final bool enable;
  final Function onPress;
  final bool showStar;
  const StarRating(
      {Key key,
      this.starCount = 5,
      this.enable = true,
      this.showStar = true,
      this.rating = 0.0,
      this.onRatingChanged,
      this.onPress,
      this.color,
      this.emptyColor = const Color.fromRGBO(183, 196, 203, 1),
      this.size})
      : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star,
        color: emptyColor,
        size: size ?? 25.0,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? 25.0,
      );
    }

    return GestureDetector(
      onTap: showStar == true
          ? onPress
          : () {
              if (enable == false) {
                return null;
              }
              if (this.onRatingChanged != null) onRatingChanged(index + 1.0);
            },
      onHorizontalDragUpdate: (dragDetails) {
        if (enable == false) {
          return null;
        }
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / size;
        var newRating = i.round().toDouble();
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (this.onRatingChanged != null) onRatingChanged(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          children:
              List.generate(starCount, (index) => buildStar(context, index))),
    );
  }
}
