class ClassEntity {
  final String id;
  final String title;
  final String? description;
  final String? type;
  final String? teacherId;
  final List<String>? studentIds;

  ClassEntity({
    required this.id,
    required this.title,
    this.description,
    this.type,
    this.teacherId,
    this.studentIds,
  });
}
