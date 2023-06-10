class PrescriptionModel {
  PrescriptionModel({
    this.imageFile,
  });

  String imageFile;

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionModel(
        imageFile: json["imageFile"],
      );

  Map<String, dynamic> toJson() => {
        "imageFile": imageFile,
      };
}
