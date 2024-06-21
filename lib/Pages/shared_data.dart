import 'package:flutter/foundation.dart';

class SharedData extends ChangeNotifier {
  String idText = '';
  String _name = 'Igo Meow';
  String _address = 'Triangulo, Naga City, Camarines Sur';
  bool _isVerified = false;
  String _licensePlate = '';
  String _firstroute = '';
  String _secondroute = '';
  String beepneyAmount = '';
  String get name => _name;
  String get address => _address;
  bool get isVerified => _isVerified;

  void saveBeepneyAmount(String amount) {
    beepneyAmount = amount;
  }

  String get licensePlate => _licensePlate;
  set licensePlate(String value) {
    _licensePlate = value;
    notifyListeners();
  }

  String get firstroute => _firstroute;
  set firstroute(String value) {
    _firstroute = value;
    notifyListeners();
  }

  String get secondroute => _secondroute;
  set secondroute(String value) {
    _secondroute = value;
    notifyListeners();
  }

  void verify() {
    _isVerified = true;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set address(String value) {
    _address = value;
    notifyListeners();
  }
}
