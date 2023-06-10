import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/home/session_seach_bloc.dart';
import 'package:suns_med/src/product/detailproduct_screen.dart';

class SearchAllScreen extends StatefulWidget {
  // final String value;

  @override
  _SearchAllScreenState createState() => _SearchAllScreenState();
}

class _SearchAllScreenState extends State<SearchAllScreen> {
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final sessionBloc = SessionBloc();
  final searchBloc = SearchBloc();
  // final servicePackageBloc = ServicePackageBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: AppColor.orangeColorDeep,
        title: _buildCustomSearchBar(
          'Tên gói khám, dịch vụ...',
          controller: _searchController,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (_searchController.text.length >= 2) {
                searchBloc
                    .dispatch(EventInputKey(keyword: _searchController.text));
              }
            },
          ),
        ],
      ),
      body: _getCompany(),
    );
  }

  _getCompany() {
    return BlocProvider<SearchEvent, SearchState, SearchBloc>(
      bloc: searchBloc,
      builder: (state) {
        return state.servicePackage == null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 21),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6)
                        ]),
                    child: Text('Lưu ý: Cần nhập 2 ký tự trở lên để tìm kiếm.',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset("assets/images/searchImg.png"),
                ],
              )
            : state.servicePackage.isEmpty
                ? Center(
                    child: Container(
                      child: Text('Chưa có dữ liệu về từ khoá này'),
                    ),
                  )
                : BlocProvider<SearchEvent, SearchState, SearchBloc>(
                    bloc: searchBloc,
                    builder: (state) {
                      var servicePackages = state.servicePackage;
                      return ListView.builder(
                        itemCount: servicePackages?.length ?? 0,
                        itemBuilder: (context, index) {
                          var servicePackagePopular = servicePackages[index];
                          return ProductItem(
                              isButton: true,
                              genderN: servicePackagePopular?.gender,
                              fromAge: servicePackagePopular?.fromAge,
                              toAge: servicePackagePopular?.toAge,
                              description: servicePackagePopular?.description,
                              exam: servicePackagePopular?.exam,
                              title: servicePackagePopular?.name,
                              image: servicePackagePopular?.image,
                              price: servicePackagePopular?.price?.toDouble(),
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProductScreen(
                                      companyModel:
                                          sessionBloc.state.doctorCheck,
                                      companyType: CompanyType.Clinic,
                                      serviceId: servicePackagePopular,
                                    ),
                                  ),
                                );
                              },
                              test: servicePackagePopular?.test);
                        },
                      );
                    },
                  );
      },
    );
  }

  _buildCustomSearchBar(
    String hintText, {
    Function(String) onChange,
    TextEditingController controller,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: const EdgeInsets.only(left: 20),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent &&
              (event.logicalKey.keyId == 54)) {
            if (_searchController.text.length >= 2) {
              searchBloc
                  .dispatch(EventInputKey(keyword: _searchController.text));
            }
          }
        },
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          onChanged: onChange,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            if (_searchController.text.length >= 2) {
              searchBloc
                  .dispatch(EventInputKey(keyword: _searchController.text));
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () => controller.clear()),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
