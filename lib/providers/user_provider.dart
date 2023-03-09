import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../features/screens/auth/models/user.dart';
import '../services/auth_service.dart';


class UserProvider extends ChangeNotifier{

  late Users user;
  bool isLoaded = false;
  bool photonull = true;
  String username ='';
  String photoUrl='';
  String code = '';
  String phoneNumber = '';
  var _auth ;
   String currentAddress = '';
  late Position currentPosition;
  // AppointmentService appointmentService= AppointmentService();
  List appointments =[];
  List notifications =[];

  UserProvider(){
    _auth = Auth();
    isLoaded = false;
    getUserDetails();
  }
  void setPhone(String number){
    phoneNumber = number;
    notifyListeners();
  }
  void setPosition(Position position){
    currentPosition = position;
    notifyListeners();
  }
  void setAddress(String address){
    currentAddress = address;
    notifyListeners();
  }

  void getUserDetails() async {
    user = await _auth.getUserDetails() ;
    isLoaded = true;
    photonull = false;
    username  = user.name!;
    // photoUrl = user.photoUrl;
    if (kDebugMode) {
      print(isLoaded);
    }
    notifyListeners();
    // getAppointments(user.uid);
    getNotifications();

  }
  Future<void> verifyPhone(String number,context)async {
    code = await _auth.verifyPhone(number, context);
    notifyListeners();

  }

  Future<void> verifyCode(context, String smsCode) async {
    await _auth.verifyCode(context,code, smsCode);
    notifyListeners();
  }

  Future<List> getNotifications() async {
  notifications = await _auth.getNotifications(user.uid);
  // username = user.name!;
  notifyListeners();
  // print('apppppppppppppppppppppppp ${appointments.length}');
  return notifications;
}
  Future<void> sendNotification(notification) async {
    await _auth.sendNotifications(notification);
    // username = user.name!;
    getNotifications();
    notifyListeners();
  }


}