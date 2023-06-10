class PagingQuery {
  int pageNumber;
  int pageSize;
  Map<String, dynamic> dataFilter;
  PagingQuery({this.pageNumber = 1, this.pageSize = 10, this.dataFilter});
  @override
  String toString() {
    var queryString = "?pageNumber=$pageNumber&pageSize=$pageSize";

    if (dataFilter != null && dataFilter.isNotEmpty) {
      dataFilter.forEach((key, value) {
        var data = "";
        if (value != null) {
          if (value is DateTime) {
            data = "&$key=${value.toIso8601String()}";
          } else if (value is List) {
            value.forEach((element) {
              if (element != null) {
                if (element is DateTime) {
                  data += "&$key=${element.toIso8601String()}";
                } else {
                  data += "&$key=${_ensureEncodeData(element)}";
                }
              }
            });
          } else {
            data += "&$key=${_ensureEncodeData(value)}";
          }
          queryString += data;
        }
      });
    }

    return queryString;
  }

  _ensureEncodeData(value) {
    if (value is String) {
      return Uri.encodeComponent(value);
    }

    return value;
  }
}
