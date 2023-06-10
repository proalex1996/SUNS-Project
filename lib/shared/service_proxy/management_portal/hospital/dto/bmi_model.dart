class BMIModel {
  String updatedAt;
  List<WeightHeightBlood> weightHeightBlood;
  List<SinhHieu> sinhHieu;
  WeightHeightBlood diUng;

  BMIModel({this.updatedAt, this.weightHeightBlood, this.sinhHieu, this.diUng});

  BMIModel.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated_at'];
    if (json['weight_height_blood'] != null) {
      weightHeightBlood = new List<WeightHeightBlood>();
      json['weight_height_blood'].forEach((v) {
        weightHeightBlood.add(new WeightHeightBlood.fromJson(v));
      });
    }
    if (json['sinh_hieu'] != null) {
      sinhHieu = new List<SinhHieu>();
      json['sinh_hieu'].forEach((v) {
        sinhHieu.add(new SinhHieu.fromJson(v));
      });
    }
    diUng = json['di_ung'] != null
        ? new WeightHeightBlood.fromJson(json['di_ung'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_at'] = this.updatedAt;
    if (this.weightHeightBlood != null) {
      data['weight_height_blood'] =
          this.weightHeightBlood.map((v) => v.toJson()).toList();
    }
    if (this.sinhHieu != null) {
      data['sinh_hieu'] = this.sinhHieu.map((v) => v.toJson()).toList();
    }
    if (this.diUng != null) {
      data['di_ung'] = this.diUng.toJson();
    }
    return data;
  }
}

class SinhHieu {
  String key;
  String value;
  String avatar;

  SinhHieu({this.key, this.value, this.avatar});

  SinhHieu.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['avatar'] = this.avatar;
    return data;
  }
}

class WeightHeightBlood {
  String key;
  String value;
  String avatar;

  WeightHeightBlood({this.key, this.value, this.avatar});

  WeightHeightBlood.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['avatar'] = this.avatar;
    return data;
  }
}
