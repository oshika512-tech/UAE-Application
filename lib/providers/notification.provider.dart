import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_center/data/models/notification.model.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

// add new notification

  Future<bool> addNewNotification(
    String title,
    String body,
  ) async {
    final docRef = _firestore.collection('notifications').doc();

    final notification = NotificationModel(
      id: docRef.id,
      title: title,
      body: body,
      userID: userId,
      dateTime: DateTime.now(),
    );

    try {
      // create dummy post
      await docRef.set({...notification.toJson()});
      notifyListeners();

      return true;
    } catch (e) {
      print('Error creating notification: $e');
      notifyListeners();
      return false;
    }
  }

// get notification by user id
  Future<List<NotificationModel>> getNotificationsByUserId(
      String userID) async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('userID', isEqualTo: userID)
        .get();

    final notifications = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return NotificationModel.fromJson({
        ...data,
      });
    }).toList();

    return notifications;
  }

// delete notification by id
  Future<void> deleteNotificationById(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
    notifyListeners();
  }

  // delete all notifications by user id
  Future<void> deleteAllNotificationsByUserId(String userId) async {
    await _firestore
        .collection('notifications')
        .where('userID', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    notifyListeners();
  }
}
