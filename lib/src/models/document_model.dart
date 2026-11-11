import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final String id;
  final String name;
  final String url;
  final String storagePath;
  final int? size;
  final String? contentType;
  final DateTime? timeCreated;

  Document({
    this.id = '',
    required this.name,
    this.url = '',
    this.storagePath = '',
    this.size,
    this.contentType,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'storagePath': storagePath,
        'size': size,
        'contentType': contentType,
        'createdAt': timeCreated != null
            ? Timestamp.fromDate(timeCreated!)
            : FieldValue.serverTimestamp(),
      };

  factory Document.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? const {};
    return Document(
      id: snapshot.id,
      name: (data['name'] ?? '') as String,
      url: (data['url'] ?? '') as String,
      storagePath: (data['storagePath'] ?? '') as String,
      size: (data['size'] as num?)?.toInt(),
      contentType: data['contentType'] as String?,
      timeCreated: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
