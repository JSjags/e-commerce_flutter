import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  static Future addUserDetails(
      {required String uid,
      required String fullName,
      required String email}) async {
    try {
      final users = FirebaseFirestore.instance.collection('users');
      final loggedInUser = FirebaseAuth.instance.currentUser;

      final docRef = users.doc(FirebaseAuth.instance.currentUser!.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        if (!doc.exists) {
          users.doc(loggedInUser!.uid).set({
            'uid': uid,
            'full_name': fullName,
            'email': email,
            'phone-Number': '',
            'date_of_birth': null,
            'wishlist': [],
            'cart': [],
            'address': {
              'country': '',
              'state': '',
              'address1': '',
              'address2': '',
            }
          });
        } else {
          print("User data already exists");
        }
      }, onError: (e) => throw e);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future createOrder({required String uid, required List items}) async {
    try {
      final users = FirebaseFirestore.instance.collection('users');
      final orders = FirebaseFirestore.instance.collection('orders');
      final loggedInUser = FirebaseAuth.instance.currentUser;

      final userRef = users.doc(FirebaseAuth.instance.currentUser!.uid);
      final orderRef = orders.doc(FirebaseAuth.instance.currentUser!.uid);

      // create order
      await orderRef.get().then((DocumentSnapshot doc) {
        if (!doc.exists) {
          print("No order doc start");
          orders.doc(loggedInUser!.uid).set({
            'orders': [
                {
                  'order_id': 'jbi-${loggedInUser!.uid}-${DateTime.now()}',
                  'order_items': items,
                  'created_at': DateTime.now()
                }
              ]
          });
          print("No order doc end");
        } else {
          print("Beans start");
          orders.doc(loggedInUser!.uid).update({
            'orders': FieldValue.arrayUnion([
                {
                  'order_id': 'jbi-${loggedInUser!.uid}-${DateTime.now()}',
                  'order_items': items,
                  'created_at': DateTime.now()
                }
              ])
          });
          print("Beans end");
        }
      }, onError: (e) => throw e);

      //  clear cart
      await userRef.get().then((DocumentSnapshot doc) {
        if (!doc.exists) {
          print("No user cart to clear");
        } else {
          users.doc(loggedInUser!.uid).update({'cart': []});
        }
      }, onError: (e) => throw e);
    } catch (e) {
      throw e.toString();
    }
  }
}
