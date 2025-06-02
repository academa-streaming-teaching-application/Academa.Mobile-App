import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/class_entity.dart';
import '../../home/provider/class_repository_provider.dart';

final fetchClassByIdProvider =
    FutureProvider.family.autoDispose<ClassEntity, String>((ref, id) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getClassById(id);
});
