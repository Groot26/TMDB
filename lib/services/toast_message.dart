import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessgage {
  static toastMessgage(String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade500,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class CustomToast {
  static SnackBar customSnackBar({required String message}) {
    return SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      showCloseIcon: true,
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 6,
    );
  }
}

// class CustomToast {
//   static void customToast({
//     required BuildContext context,
//     required String message,
//   }) {
//     final snackBar = SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(color: Colors.white),
//       ),
//       showCloseIcon: true,
//       backgroundColor: Colors.black87,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.all(16),
//       elevation: 6,
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
