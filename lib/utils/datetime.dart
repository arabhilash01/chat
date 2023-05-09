import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // Convert the timestamp to a DateTime object
  DateTime dateTime = timestamp.toDate();

  // Format the DateTime object as a string
  String formattedDate = DateFormat('MM/dd/yyyy hh:mm a').format(dateTime);

  return formattedDate;
}
