class Notice {
  final String name;
  final DateTime? timeCreated;
  final String downloadUrl;

  Notice({required this.name, required this.downloadUrl, this.timeCreated});
}
