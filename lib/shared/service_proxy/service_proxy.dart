import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/momo_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/payment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/vnpay_payment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/management_common_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/hospital_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/news_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/category_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/clinic/clinic_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/common_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/company/company_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/contact_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/conversation_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/department_special/department_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/doctor/doctor_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/equipment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/hospital/hospital_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/like/like_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/medicalexamiation_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/news_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news_comment/news_comment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/notification_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/order_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/province/province_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/report/report_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/servicepackage_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/staff_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/suns_api_portal/message/messenger_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/common_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/user_service_proxy.dart';
import 'package:suns_med/src/medicine/provider/medicine_service_proxy.dart';

import 'management_portal_new/doctor_check/doctorcheck_service_proxy.dart';

class ServiceProxy {
  String _remoteServiceBaseUrl;
  String _managementBaseUrl;
  String _logBaseUrl;
  String _managementBaseUrlNew;
  String _messageBaseUrl;
  AppAuthService _appAuthService;

  static final ServiceProxy _instance = ServiceProxy._internal();

  ServiceProxy._internal() {
    _remoteServiceBaseUrl = AppConfig().remoteServiceBaseUrl;
    _managementBaseUrl = AppConfig().managementBaseUrl;
    _logBaseUrl = AppConfig().logBaseUrl;
    _managementBaseUrlNew = AppConfig().managementBaseUrlNew;
    _messageBaseUrl = AppConfig().messengerBaseUrl;
    _appAuthService = AppAuthService();
  }

  factory ServiceProxy() {
    return _instance;
  }

  UserServiceProxy _userService;
  UserServiceProxy get userService =>
      _userService ??
      (_userService = UserServiceProxy(
        baseUrl: _remoteServiceBaseUrl,
        appAuthService: _appAuthService,
      ));

  CommonServiceProxy _commonService;
  CommonServiceProxy get commonService =>
      _commonService ??
      (_commonService = CommonServiceProxy(
          appAuthService: _appAuthService, baseUrl: _remoteServiceBaseUrl));

  HospitalServiceProxy _hospitalService;
  HospitalServiceProxy get hospitalService =>
      _hospitalService ??
      (_hospitalService = HospitalServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrl));

  ManagementCommonServiceProxy _managementCommonServiceProxy;
  ManagementCommonServiceProxy get managementCommonService =>
      _managementCommonServiceProxy ??
      (_managementCommonServiceProxy = ManagementCommonServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrl));

  NewsServiceProxy _newsServiceProxy;
  NewsServiceProxy get newsServiceProxy =>
      _newsServiceProxy ??
      (_newsServiceProxy = NewsServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrl));

  PaymentServiceProxy _paymentServiceProxy;
  PaymentServiceProxy get paymentServiceProxy =>
      _paymentServiceProxy ??
      (_paymentServiceProxy = PaymentServiceProxy(
          baseUrl: _logBaseUrl, appAuthService: _appAuthService));

  MomoServiceProxy _momoServiceProxy;
  MomoServiceProxy get momoServiceProxy =>
      _momoServiceProxy ??
      (_momoServiceProxy = MomoServiceProxy(
          baseUrl: _logBaseUrl, appAuthService: _appAuthService));

  VNPayServiceProxy _vnPayServiceProxy;
  VNPayServiceProxy get vnPayServiceProxy =>
      _vnPayServiceProxy ??
      (_vnPayServiceProxy = VNPayServiceProxy(
          baseUrl: _logBaseUrl, appAuthService: _appAuthService));
// API moi

  ProvinceServiceProxy _provinceServiceProxy;
  ProvinceServiceProxy get provinceServiceProxy =>
      _provinceServiceProxy ??
      (_provinceServiceProxy = ProvinceServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  DepartmentServiceProxy _departmentServiceProxy;
  DepartmentServiceProxy get departmentServiceProxy =>
      _departmentServiceProxy ??
      (_departmentServiceProxy = DepartmentServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  AppointmentServiceProxy _appointmentServiceProxy;
  AppointmentServiceProxy get appointmentServiceProxy =>
      _appointmentServiceProxy ??
      (_appointmentServiceProxy = AppointmentServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  CategoryServiceProxy _categoryServiceProxy;
  CategoryServiceProxy get categoryServiceProxy =>
      _categoryServiceProxy ??
      (_categoryServiceProxy = CategoryServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  ClinicServiceProxy _clinicServiceProxy;
  ClinicServiceProxy get clinicServiceProxy =>
      _clinicServiceProxy ??
      (_clinicServiceProxy = ClinicServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  NewCommonServiceProxy _newCommonServiceProxy;
  NewCommonServiceProxy get newCommonServiceProxy =>
      _newCommonServiceProxy ??
      (_newCommonServiceProxy = NewCommonServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  ContactSeviceProxy _contactSeviceProxy;
  ContactSeviceProxy get contactSeviceProxy =>
      _contactSeviceProxy ??
      (_contactSeviceProxy = ContactSeviceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  LikeServiceProxy _likeServiceProxy;
  LikeServiceProxy get likeServiceProxy =>
      _likeServiceProxy ??
      (_likeServiceProxy = LikeServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  MedicalExaminationServiceProxy _medicalExaminationServiceProxy;
  MedicalExaminationServiceProxy get medicalExaminationSeviceProxy =>
      _medicalExaminationServiceProxy ??
      (_medicalExaminationServiceProxy = MedicalExaminationServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  DoctorServiceProxy _doctorServiceProxy;
  DoctorServiceProxy get doctorServiceProxy =>
      _doctorServiceProxy ??
      (_doctorServiceProxy = DoctorServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  EquipmentServiceProxy _equipmentServiceProxy;
  EquipmentServiceProxy get equipmentServiceProxy =>
      _equipmentServiceProxy ??
      (_equipmentServiceProxy = EquipmentServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  HospitalNewServiceProxy _hospitalNewServiceProxy;
  HospitalNewServiceProxy get hospitalNewServiceProxy =>
      _hospitalNewServiceProxy ??
      (_hospitalNewServiceProxy = HospitalNewServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  PostNewsServiceProxy _postNewsServiceProxy;
  PostNewsServiceProxy get postNewsServiceProxy =>
      _postNewsServiceProxy ??
      (_postNewsServiceProxy = PostNewsServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  NotificationServiceProxy _notificationServiceProxy;
  NotificationServiceProxy get notificationServiceProxy =>
      _notificationServiceProxy ??
      (_notificationServiceProxy = NotificationServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  OrderServiceProxy _orderServiceProxy;
  OrderServiceProxy get orderServiceProxy =>
      _orderServiceProxy ??
      (_orderServiceProxy = OrderServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  ReportServiceProxy _reportServiceProxy;
  ReportServiceProxy get reportServiceProxy =>
      _reportServiceProxy ??
      (_reportServiceProxy = ReportServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  PackageServiceProxy _packageServiceProxy;
  PackageServiceProxy get packageServiceProxy =>
      _packageServiceProxy ??
      (_packageServiceProxy = PackageServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  StaffServiceProxy _staffServiceProxy;
  StaffServiceProxy get staffServiceProxy =>
      _staffServiceProxy ??
      (_staffServiceProxy = StaffServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  CompanyServiceProxy _companyServiceProxy;
  CompanyServiceProxy get companyServiceProxy =>
      _companyServiceProxy ??
      (_companyServiceProxy = CompanyServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  DoctorCheckServiceProxy _doctorCheckServiceProxy;
  DoctorCheckServiceProxy get doctorCheckServiceProxy =>
      _doctorCheckServiceProxy ??
      (_doctorCheckServiceProxy = DoctorCheckServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  MessageServiceProxy _messageServiceProxy;
  MessageServiceProxy get messageServiceProxy =>
      _messageServiceProxy ??
      (_messageServiceProxy = MessageServiceProxy(
          appAuthService: _appAuthService, baseUrl: _messageBaseUrl));

  NewsCommentServiceProxy _newsCommentServiceProxy;
  NewsCommentServiceProxy get newsCommentServiceProxy =>
      _newsCommentServiceProxy ??
      (_newsCommentServiceProxy = NewsCommentServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  ConversationSeviceProxy _conversationServiceProxy;
  ConversationSeviceProxy get conversationServiceProxy =>
      _conversationServiceProxy ??
      (_conversationServiceProxy = ConversationSeviceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  ConversationMessageSeviceProxy _conversationMessageSeviceProxy;
  ConversationMessageSeviceProxy get conversationMessageSeviceProxy =>
      _conversationMessageSeviceProxy ??
      (_conversationMessageSeviceProxy = ConversationMessageSeviceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));

  MedicineServiceProxy _medicineServiceProxy;
  MedicineServiceProxy get medicineSeviceProxy =>
      _medicineServiceProxy ??
      (_medicineServiceProxy = MedicineServiceProxy(
          appAuthService: _appAuthService, baseUrl: _managementBaseUrlNew));
}
