class QuestionOption {
  final String? note;
  final String? image;
  final String? sound;

  QuestionOption({this.note, this.image, this.sound});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      note: json['note'],
      image: json['image'],
      sound: json['sound'],
    );
  }

  Map<String, dynamic> toJson() => {
    'note': note,
    'image': image,
    'sound': sound,
  };
}

class Question {
  final String id;
  final String? category;
  final String? questionText;
  final String? correctAnswerImg;
  final String? correctAnswerSound;
  final int? correctOptionIndex;
  final List<QuestionOption>? options;

  Question({
    required this.id,
    this.category,
    this.questionText,
    this.correctAnswerImg,
    this.correctAnswerSound,
    this.correctOptionIndex,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      category: json['category'],
      questionText: json['questionText'],
      correctAnswerImg: json['correctAnswerImg'],
      correctAnswerSound: json['correctAnswerSound'],
      correctOptionIndex: json['correctOptionIndex'],
      options: (json['options'] as List?)
          ?.map((e) => QuestionOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'category': category,
    'questionText': questionText,
    'correctAnswerImg': correctAnswerImg,
    'correctAnswerSound': correctAnswerSound,
    'correctOptionIndex': correctOptionIndex,
    'options': options?.map((e) => e.toJson()).toList(),
  };
}