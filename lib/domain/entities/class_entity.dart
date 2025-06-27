class ClassEntity {
  final String id;
  final String title;
  final String? description;
  final String? type;
  final String? teacherId;
  final List<String>? studentIds;
  final bool isFollowed;

  ClassEntity({
    required this.id,
    required this.title,
    this.description,
    this.type,
    this.teacherId,
    this.studentIds,
    this.isFollowed = false,
  });
}
