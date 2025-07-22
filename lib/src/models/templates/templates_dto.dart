class TemplateDTO {
  final int templateId;
  final String name;
  final String description;
  final String templateType;
  final bool isActive;
  final String imageUrl;

  TemplateDTO({
    required this.templateId,
    required this.name,
    required this.description,
    required this.templateType,
    required this.isActive,
    required this.imageUrl,
  });

  factory TemplateDTO.fromJson(Map<String, dynamic> json) {
    return TemplateDTO(
      templateId: json['TemplateID'],
      name: json['Name'],
      description: json['Description'],
      templateType: json['TemplateType'],
      isActive: json['IsActive'],
      imageUrl: json['ImageURL'],
    );
  }
}
