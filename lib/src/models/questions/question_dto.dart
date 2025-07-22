/*


[
{
"id": 1,
"text": "What is your preferred technology?",
"type": "MultipleChoice",
"options": [
{ "id": 10, "text": "Web Development", "isCustom": false },
{ "id": 11, "text": "Mobile Development", "isCustom": false },
{ "id": 12, "text": "Other", "isCustom": true }
]
}
]

fields: 
id,
text,
type,
options: [
  {
    id,
    text,
    isCustom
  }

 */


class QuestionnaireDTO {
  final int id;
  final String text;
  final String type;
  final List<QuestionOption> options;

  QuestionnaireDTO({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
  });

  factory QuestionnaireDTO.fromJson(Map<String, dynamic> json) {
    return QuestionnaireDTO(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options: (json['options'] as List<dynamic>)
          .map((e) => QuestionOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class QuestionOption {
  final int id;
  final String text;
  final bool isCustom;

  QuestionOption({
    required this.id,
    required this.text,
    required this.isCustom,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      text: json['text'],
      isCustom: json['isCustom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCustom': isCustom,
    };
  }
}


