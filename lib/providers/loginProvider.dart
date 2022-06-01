import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





final loginProvider = StateNotifierProvider<LoginProvider, bool>((ref) => LoginProvider(true));

class LoginProvider extends StateNotifier<bool>{
  LoginProvider(super.state);



  void toggle(){
    state = !state;
  }

}

final isViewPro = ChangeNotifierProvider((ref) => IsViewProvider());

class IsViewProvider extends ChangeNotifier{

    bool isView = true;
    void toggle(){
      isView = !isView;
      notifyListeners();
    }

}