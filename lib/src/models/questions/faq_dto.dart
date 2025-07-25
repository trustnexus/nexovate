class FaqDTO {
  final int id;
  final String question;
  final String answer;
  final int displayOrder;

  FaqDTO({
    required this.id,
    required this.question,
    required this.answer,
    required this.displayOrder,
  });

  factory FaqDTO.fromJson(Map<String, dynamic> json) {
    return FaqDTO(
      id: json['FAQID'] as int,
      question: json['Question'] ?? '',
      answer: json['Answer'] ?? '',
      displayOrder: json['DisplayOrder'] as int,
    );
  }
}
