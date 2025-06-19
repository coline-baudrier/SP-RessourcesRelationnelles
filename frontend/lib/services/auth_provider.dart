import 'package:flutter/foundation.dart';
import 'package:frontend/models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;

  String? get token => _token;
  User? get user => _user;

  void login(String token, User user) {
    _token = token;
    _user = user;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  bool get isAuthenticated => _token != null;

  // Vérifie si l'utilisateur a un rôle spécifique
  bool hasRole(List<String> roles) {
    return _user != null && roles.contains(_user!.role);
  }
}
