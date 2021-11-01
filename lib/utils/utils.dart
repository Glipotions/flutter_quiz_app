import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:quiz/database/question_provider.dart';
import 'package:quiz/models/user_answer_model.dart';
import 'package:quiz/states/state_manager.dart';

void setUserAnswer(BuildContext context, MapEntry<int, Question> e, value) {
  context.read(userListAnswer).state[e.key] =
      context.read(userAnswerSelected).state = UserAnswer(
          questionId: e.value.questionId,
          answered: value,
          isCorrect: value.toString().isNotEmpty
              ? value.toString().toLowerCase() ==
                  e.value.correctAnswer!.toLowerCase()
              : false);
}

void showAnswer(BuildContext context) {
  context.read(isEnableShowAnswer).state = true;
}
