import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  Locale locale;
  bool isEnglish = true;
}

abstract class LanguageEvent {}

class EventLanguage extends LanguageEvent {}

class LanguageBloc extends BlocBase<LanguageEvent, LanguageState> {
  static final LanguageBloc _instance = LanguageBloc._internal();
  LanguageBloc._internal();

  factory LanguageBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = LanguageState();
    // _getPreferLanguage();
    super.initState();
  }

  // void _getPreferLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   this.state.isEnglish = (prefs.getBool('isEnglish'));
  // }

  @override
  Future<LanguageState> mapEventToState(LanguageEvent event) async {
    if (event is EventLanguage) {
      await _getEnglish();
    }
    return this.state;
  }

  Future _getEnglish() async {
    this.state.isEnglish = !this.state.isEnglish;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isEnglish', this.state.isEnglish);
  }
}
