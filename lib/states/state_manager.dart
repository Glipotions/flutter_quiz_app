import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/database/category_provider.dart';

final categoryListProvider =
    StateNotifierProvider((ref) => new CategoryList([]));
