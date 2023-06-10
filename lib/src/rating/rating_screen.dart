import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/feedback.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/doctor/doctor_model.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'BS. Chuyên gia thiết kế nụ cười Khả Lệ',
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  '$_rating/5.0',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 30,
                      color: AppColor.deepBlue,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                StarRating(
                  rating: _rating,
                  color: Colors.amber,
                  emptyColor: Colors.grey,
                  enable: false,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  starCount: 5,
                ),
                SizedBox(
                  height: 11,
                ),
                Text(
                  '105 đánh giá',
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
                Divider(),
                Wrap(
                  children: List.generate(feedbacks.length, (index) {
                    return Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: <Widget>[
                          FeedbackItem(
                            image: feedbacks[index].image,
                            name: feedbacks[index].name,
                            rating: 4,
                            feedback: feedbacks[index].feedback,
                          ),
                          Divider(
                            indent: 80,
                            endIndent: 20,
                            thickness: 1,
                            height: 10,
                          )
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
