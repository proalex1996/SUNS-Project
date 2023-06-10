import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageResultService extends StatelessWidget {
  final String img, service;
  const ImageResultService({Key key, this.img, this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColor.deepBlue,
      //   title: Text(
      //     "Hình ảnh kết quả $service",
      //     style:TextStyle(
      //             fontFamily: 'Montserrat-M',color: Colors.white),
      //   ),
      // ),
      appBar: const TopAppBar(),
      body: Column(
        children: [
          CustomAppBar(title: AppLocalizations.of(context).resultImage),
          Expanded(
            child: Center(
                child: img != null
                    ? Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: PhotoView(imageProvider: NetworkImage(img)))
                    // ? Image.network(img)
                    : Container(
                        child: Center(
                          child: Text('Không có dữ liệu'),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
