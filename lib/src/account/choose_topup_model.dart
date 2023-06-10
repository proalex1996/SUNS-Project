class ChooseTopupModel {
  String image, name;
  int id;
  ChooseTopupModel({this.image, this.name, this.id});
}

final List<ChooseTopupModel> topupModel = [
  ChooseTopupModel(image: "assets/images/ic_momo.png", name: "MoMo", id: 0),
  ChooseTopupModel(image: "assets/images/logo_vnpay.png", name: "VNPay", id: 1),
  ChooseTopupModel(
      image: "assets/images/logo_visa.jpg", name: "ATM/Visa/Master", id: 2),
];
