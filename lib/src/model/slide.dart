import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/imgStartedScr.png',
    title: 'XÉT NGHIỆM TẠI NHÀ',
    description:
        'Mẫu xét nghiệm được lấy tại nhà. Cung cấp kết quả nhanh chóng và chính xác.',
  ),
  Slide(
    imageUrl: 'assets/images/imgStartedScr2.png',
    title: 'ĐẶT LỊCH KHÁM TRỰC TUYẾN',
    description:
        'Đặt hẹn và chọn phòng khám hoàn toàn chủ động. Không mất thời gian chờ đợi.',
  ),
  Slide(
    imageUrl: 'assets/images/imgStartedScr3.png',
    title: 'TƯ VẤN SỨC KHỎE',
    description:
        'Trò chuyện và nhận tư vấn về sức khỏe từ đội ngũ bác sĩ uy tín, giàu kinh nghiệm.',
  ),
  // Slide(
  //   imageUrl: 'assets/images/imgStartedScr4.png',
  //   title: 'LƯU TRỮ HỒ SƠ SỨC KHỎE',
  //   description: 'Hồ sơ sức khỏe cá nhân được lưu trữ và bảo mật tuyệt đối.',
  // ),
];
final List<Slide> slide = [
  Slide(
      imageUrl: 'assets/images/ic_medical.png', title: null, description: null),
  Slide(
      imageUrl: 'assets/images/ic_medical1.png',
      title: null,
      description: null),
  Slide(
      imageUrl: 'assets/images/ic_medical2.png', title: null, description: null)
];
