import 'package:flutter/cupertino.dart';

class Countprovider extends ChangeNotifier{

  int count = 1;

  increase(){
    count+=1;
    notifyListeners();
  }

  decrease(){
    count-=1;
    notifyListeners();
  }

}