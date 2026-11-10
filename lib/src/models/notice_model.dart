import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String name;
  final String downloadUrl;
  final DateTime? timeCreated;

  Notice({
    this.id = '',
    required this.name,
    this.downloadUrl = '',
    this.timeCreated,
  });

  Map<String, dynamic> toJson() => {
        'title': name,
        'url': downloadUrl,
        'createdAt': timeCreated != null
            ? Timestamp.fromDate(timeCreated!)
            : FieldValue.serverTimestamp(),
      };

  factory Notice.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? const {};
    return Notice(
      id: snapshot.id,
      name: (data['title'] ?? '') as String,
      downloadUrl: (data['url'] ?? '') as String,
      timeCreated: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
