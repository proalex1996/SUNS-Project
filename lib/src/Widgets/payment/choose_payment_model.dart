class PaymentModel {
  String image, name;
  int id;
  PaymentModel({this.image, this.name, this.id});
}

final List<PaymentModel> paymentModel = [
  PaymentModel(image: "assets/images/ic_wallet.png", name: "Ví", id: 0),
  PaymentModel(
      image: "assets/images/ic_momo.png", name: "Thanh toán bằng MoMo", id: 1),
  PaymentModel(
      image: "assets/images/logo_vnpay.png",
      name: "Thanh toán bằng VN Pay",
      id: 2),
];
