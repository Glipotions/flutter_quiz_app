import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/database/category_provider.dart';
import 'package:quiz/models/user_answer_model.dart';

final categoryListProvider = StateNotifierProvider((ref) => CategoryList([]));
final questionCategoryState = StateProvider((ref) => Category());
final isTestMode = StateProvider((ref) => false);
final currentReadPage = StateProvider((ref) => 0);
final userAnswerSelected = StateProvider((ref) => UserAnswer());
final isEnableShowAnswer = StateProvider((ref) => false);
final userListAnswer =
    StateProvider((ref) => List<UserAnswer>.empty(growable: true));
