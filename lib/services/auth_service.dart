
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartfri/features/screens/auth/pages/check_email.dart';
import 'package:dartfri/features/screens/auth/pages/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:status_alert/status_alert.dart';


import '../features/screens/auth/models/user.dart' as UserModel;
import '../features/screens/auth/models/user.dart';
import '../features/screens/dashboard/dashboard_page.dart';
import '../features/screens/home/location_page.dart';
import '../features/screens/notifications/models/notifications.dart';

///
class Auth{
  String? errorMessage;
  final _auth = FirebaseAuth.instance;

  Future signUp(String email, String password, Users userModel,context) async {
    // if (_formKey.currentState!.validate()) {
    // final directory = await getApplicationDocumentsDirectory();
    // box1 = await Hive.openBox('personaldata');


    try {
      showDialog(context: context,barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()));

      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => { postDetailsToFirestore(userModel,context)})
          .catchError((e) {
        Navigator.pop(context);
        BotToast.showText(text:e!.message);

      });
      // await verifyPhone(userModel, context);
    } on FirebaseAuthException catch (error) {

      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      BotToast.showText(text:errorMessage!);

      Navigator.pop(context);

      print(error.code);
    }
    // navigatorKey.currentState!.popUntil((route)=>route.isFirst);
  }
  postDetailsToFirestore(Users users,context) async {
    User? user=_auth.currentUser;
    // users.email = user!.email;
    users.uid = user!.uid;
    // users.photoUrl = user!.photoURL;

    // sendVerificationCode(context, userModel.email );

    //save uid of user in local storage
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('userid', '${user!.uid}');
    // await prefs.setString('username', '${users.name}');
    // await prefs.setString('photoUrl', '${user!.photoURL}');

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CheckMail(email : users.email))

    );
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // box1.put('userid', user!.uid);

    await firebaseFirestore
        .collection("users")
        .doc(users.uid)
        .set(users.toJson());
    BotToast.showText(text: "Account created successfully :) ");

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CheckMail(email : users.email))

    );
  }

  Future signIn(context,email,password) async {

    showDialog(context: context,barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password:password.trim());

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LocationPage())

      );
    } on FirebaseException catch(e){
      // navigatorKey.currentState!.popUntil((route)=>route.isFirst);
      Navigator.pop(context);
      if (kDebugMode) {
        print(e);
      }
      BotToast.showText(text: '${e.message}');

    }

    // navigatorKey.currentState!.popUntil((route)=>route.isFirst);
  }

  Future<void> passwordReset(String? email,context) async {
    showDialog(context: context,barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    final _auth = FirebaseAuth.instance;
    try {
      // _formKey.currentState?.save();

      await _auth.sendPasswordResetEmail(email: email!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return CheckMail(email: email);
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<Users> getUserDetails() async {
    late Users doc ;
    //     builder: (context) => const Center(child: CircularProgressIndicator()));
    // final prefs = await SharedPreferences.getInstance();
    // final userid = prefs.getString('userid');
    // final username = prefs.getString('username');
    // final photoUrl = prefs.getString('photoUrl');

    try{
      FirebaseFirestore mFirebaseFirestore = FirebaseFirestore.instance;

      await mFirebaseFirestore.collection('users')
          .where('uid', isEqualTo: _auth.currentUser?.uid)
          .get()
          .then((snapshot)  async {
        doc =  Users.fromJson(snapshot.docs[0].data()) ;
      });

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    // navigatorKey.currentState!.popUntil((route)=>route.);
    // print(doc['nin']);
    return doc;
  }

  Future<void> sendNotifications(Notifications notification) async {
   
    try{
      await FirebaseFirestore.instance
          .collection("notifications")
          .add(notification.toJson())
          .catchError((e){
        BotToast.showText(text: e!.message);
      });
    }catch(e){
      BotToast.showText(text:"Failed to post notification");
    }

    // Fluttertoast.showToast(msg: "Account created successfully :) ");

  }
  Future<List<Notifications>>  getNotifications(userId) async {
    List<Notifications>  notifications= [];
    try{
      await FirebaseFirestore.instance
          .collection("notifications").where(
          "userId" ,whereIn: <String>[userId, 'all'] )
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          Notifications notification = Notifications.fromJson(
              Map<String, dynamic>.from(doc.data()));
          notifications.add(notification);

        });
      })
          .catchError((e){
        BotToast.showText(text: e!.message);

      });
    }catch(e){
      BotToast.showText(text: "Failed to get appointments");

    }
    return notifications;
  }
  // Future<String> verifyPhone(Users userModel, BuildContext context) async {
  //   print('phoooooooooooooooooooooo${userModel.phone}');
  //   String code = "";
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: '${userModel.phone}',
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {},
  //     codeSent: (String verificationId, int? resendToken) {
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPage()));
  //       code = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  //
  //
  //   return code;
  // }
  //
  // Future<void> verifyCode(context, String code , String smsCode) async {
  //   try{
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: code, smsCode: smsCode);
  //     print("oneeeeeeeeee "+ code);
  //     print("oneeeeeeeeee "+ smsCode);
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
  //   }catch(e){
  //     print("Wrong Otp");
  //   }
  //
  //
  // }
}