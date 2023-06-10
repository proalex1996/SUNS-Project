class ProductDetail {
  final String image,
      title,
      description,
      gender,
      birthday,
      lab,
      hospital,
      price,
      price1;

  ProductDetail(
      {this.image,
      this.title,
      this.description,
      this.gender,
      this.birthday,
      this.lab,
      this.hospital,
      this.price,
      this.price1});
}

final List<ProductDetail> productdetail = [
  ProductDetail(
    image: 'assets/images/goikham.png',
    title: 'Gói kiểm tra sức khoẻ cơ bản',
    description:
        'Kiểm tra sức khoẻ cơ bản qua các xét nghiệm thường quy, điện tim và X-quang phổi…',
    gender: 'Nam và nữ',
    birthday: 'Mọi lứa tuổi',
    lab: '15 thí nghiệm',
    hospital: '5 hạng mục khám',
    price: '1.500.000đ',
  ),
  ProductDetail(
    image: 'assets/images/goikham.png',
    title: 'Gói kiểm tra sức khoẻ cơ bản',
    description:
        'Kiểm tra sức khoẻ cơ bản qua các xét nghiệm thường quy, điện tim và X-quang phổi…',
    gender: 'Nam và nữ',
    birthday: 'Mọi lứa tuổi',
    lab: '15 thí nghiệm',
    hospital: '5 hạng mục khám',
    price: '1.500.000đ',
  ),
];
final List<ProductDetail> medicaldetail = [
  ProductDetail(
    image: 'assets/images/ic_medical.png',
    title: 'Ống nghe Y Tế 2 mặt CK-601P',
    price1: '699.000đ',
    price: ' - 499.000đ',
  ),
];
