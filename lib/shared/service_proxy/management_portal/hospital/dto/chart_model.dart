class ChartModel {
  String createdDate;
  List<GetList> getList;

  ChartModel({this.createdDate, this.getList});

  ChartModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['created_date'];
    if (json['getList'] != null) {
      getList = new List<GetList>();
      json['getList'].forEach((v) {
        getList.add(new GetList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_date'] = this.createdDate;
    if (this.getList != null) {
      data['getList'] = this.getList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetList {
  String name;
  int value;

  GetList({this.name, this.value});

  GetList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
