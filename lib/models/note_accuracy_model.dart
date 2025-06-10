class NoteAccuracy {
  final String note;
  final double accuracy;

  NoteAccuracy({
    required this.note,
    required this.accuracy,
  });

  factory NoteAccuracy.fromJson(Map<String, dynamic> json) {
    return NoteAccuracy(
      note: json['note'] ?? '',
      accuracy: (json['accuracy'] ?? 0).toDouble(),
    );
  }
}
