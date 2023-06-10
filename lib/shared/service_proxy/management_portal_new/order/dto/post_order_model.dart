class PostOrderModel {
  String appointmentId;
  String equipmentId;

  PostOrderModel({this.appointmentId, this.equipmentId});

  PostOrderModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    equipmentId = json['equipmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['equipmentId'] = this.equipmentId;
    return data;
  }
}
