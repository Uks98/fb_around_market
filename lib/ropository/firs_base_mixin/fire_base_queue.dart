

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin FireBaseInitialize{
  final firestoreInit = FirebaseFirestore.instance;
  final fireBaseAuthInit = FirebaseAuth.instance;
  final userUid = FirebaseAuth.instance.currentUser?.uid;
}