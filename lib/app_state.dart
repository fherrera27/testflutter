import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _urlDefault =
      'https://firebasestorage.googleapis.com/v0/b/birthday-oe5ij0.appspot.com/o/Icono_AkitaTu.png?alt=media&token=aead70a7-1b95-46fa-be1c-a4ea219ed9c5';
  String get urlDefault => _urlDefault;
  set urlDefault(String value) {
    _urlDefault = value;
  }

  int _timerDays = 0;
  int get timerDays => _timerDays;
  set timerDays(int value) {
    _timerDays = value;
  }

  int _timerHours = 0;
  int get timerHours => _timerHours;
  set timerHours(int value) {
    _timerHours = value;
  }

  int _timerMinutes = 0;
  int get timerMinutes => _timerMinutes;
  set timerMinutes(int value) {
    _timerMinutes = value;
  }

  int _timerSeconds = 0;
  int get timerSeconds => _timerSeconds;
  set timerSeconds(int value) {
    _timerSeconds = value;
  }
}
