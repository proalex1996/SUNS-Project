import 'package:flutter/foundation.dart';

class PagingResult<T> {
  List<T> data;
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPage;
  bool hasPreviousPage;
  bool hasNextPage;

  PagingResult(
      {this.data,
      this.pageNumber,
      this.pageSize,
      this.totalCount,
      this.totalPage,
      this.hasPreviousPage,
      this.hasNextPage});

  PagingResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) convert,
  ) {
    var temp = json['data'];
    data = new List<T>();

    temp?.forEach((v) {
      data.add(convert(v));
    });

    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalPage = json['totalPage'];
    hasPreviousPage = json['hasPreviousPage'];
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) convert) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => convert(v)).toList();
    }

    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalCount'] = this.totalCount;
    data['totalPage'] = this.totalPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    data['hasNextPage'] = this.hasNextPage;

    return data;
  }
}

class MappingLoadOptions<TModel> {
  int pageNumber;
  int pageSize;

  TModel get filter {
    return this.filterConfig?.call();
  }

  TModel Function() filterConfig;

  MappingLoadOptions({
    this.pageNumber,
    this.pageSize,
    this.filterConfig,
  });
}

class DataSourceOption<TModel, TFilterModel> {
  MappingLoadOptions<TFilterModel> option;
  PagingResult<TModel> dataSource;

  final Future<PagingResult<TModel>> Function(MappingLoadOptions<TFilterModel>)
      getDataSource;

  DataSourceOption({
    @required this.getDataSource,
    this.dataSource,
    TFilterModel Function() filterConfig,
  }) {
    this.option = MappingLoadOptions<TFilterModel>(
        pageSize: 10, filterConfig: filterConfig);
  }

  Future load([int pageNumber = 1]) async {
    this.option.pageNumber = pageNumber;
    var result = await this.getDataSource(this.option);
    this.dataSource = result;
  }

  Future loadMore() async {
    PagingResult<TModel> result;

    if (this.dataSource == null) {
      //Todo load first
      this.option.pageNumber = 1;
      result = await this.getDataSource(this.option);
    } else if (this.dataSource.hasNextPage == true ||
        this.dataSource.pageNumber == null ||
        this.dataSource.pageNumber < 1) {
      //Load More
      if (this.dataSource.pageNumber != null) ++this.dataSource.pageNumber;

      this.option.pageNumber = this.dataSource.pageNumber;
      this.option.pageSize = this.dataSource.pageSize;
      result = await getDataSource(this.option);
    }

    if (result == null) return;

    var temp = this.dataSource?.data;

    if (temp?.isNotEmpty == true) {
      temp.addAll(result.data);
    } else {
      temp = result.data;
    }

    result.data = temp;
    this.dataSource = result;
  }

  Future clear() async {
    this.dataSource = null;
    this.option.pageNumber = 0;
  }
}
