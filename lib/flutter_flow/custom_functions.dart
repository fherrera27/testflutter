import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

int? newCustomFunction() {
  // Returns milliseconds remaining until a constant future date from current time.
  DateTime futureDate = DateTime(2024, 08, 12);
  DateTime now = DateTime.now();
  Duration remainingTime = futureDate.difference(now);
  return remainingTime.inMilliseconds;
}

bool? isUserAllowed() {
  // validate parameter input  email, from collection allowed_users, return boolean async funtion
  Future<bool?> isUserAllowed(String email) async {
    final allowedUsers = FirebaseFirestore.instance.collection('allowed_users');
    final querySnapshot =
        await allowedUsers.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }
}
