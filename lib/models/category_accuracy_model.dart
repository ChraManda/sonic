class CategoryAccuracy {
  final String category;
  final double accuracy;
  final int attempts;
  CategoryAccuracy({
    required this.category,
    required this.accuracy,
    required this.attempts,
  });

  factory CategoryAccuracy.fromJson(Map<String, dynamic> json) {
    return CategoryAccuracy(
      category: json['category'] ?? '',
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      attempts: json['attempts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'accuracy': accuracy,
    'attempts': attempts,
  };
}
