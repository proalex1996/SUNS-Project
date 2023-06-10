class ExaminationModel {
  ExaminationModel({
    this.id,
    this.name,
    this.image,
    this.images,
    this.price,
    this.staffName,
    this.result,
    this.note,
  });

  String id;
  String name;
  String image;
  String images;
  int price;
  dynamic staffName;
  String result;
  String note;

  factory ExaminationModel.fromJson(Map<String, dynamic> json) =>
      ExaminationModel(
        id: json["id"],
        name: json["name"],
        image: json["image"] == null ? null : json["image"],
        images: json["images"] == null ? null : json["images"],
        price: json["price"],
        staffName: json["staffName"],
        result: json["result"] == null ? null : json["result"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image == null ? null : image,
        "images": images == null ? null : images,
        "price": price,
        "staffName": staffName,
        "result": result == null ? null : result,
        "note": note == null ? null : note,
      };
}
