import 'package:quiz/const/const.dart';
import 'package:sqflite/sqflite.dart';

class Question {
  int? questionId, categoryId, isImageQuestion;
  String? questionText,
      questionImage,
      answerA,
      answerB,
      answerC,
      answerD,
      correctAnswer;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnQuestionId: questionId,
      columnQuestionImage: questionImage,
      columnQuestionText: questionText,
      columnQuestionAnswerA: answerA,
      columnQuestionAnswerB: answerB,
      columnQuestionAnswerC: answerC,
      columnQuestionAnswerD: answerD,
      columnQuestionCorrectAnswer: correctAnswer,
      columnQuestionIsImage: isImageQuestion,
      columnQuestionCategoryId: categoryId
    };
    return map;
  }

  Question();

  Question.fromMap(Map<String, dynamic> map) {
    questionId = map[columnQuestionId];
    questionText = map[columnQuestionText];
    questionImage = map[columnQuestionImage];
    isImageQuestion = map[columnQuestionIsImage];
    answerA = map[columnQuestionAnswerA];
    answerB = map[columnQuestionAnswerB];
    answerC = map[columnQuestionAnswerC];
    answerD = map[columnQuestionAnswerD];
    correctAnswer = map[columnQuestionCorrectAnswer];
    categoryId = map[columnQuestionCategoryId];
  }
}

class QuestionProvider {
  Future<Question?> getQuestionById(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          columnQuestionId,
          columnQuestionText,
          columnQuestionImage,
          columnQuestionAnswerA,
          columnQuestionAnswerB,
          columnQuestionAnswerC,
          columnQuestionAnswerD,
          columnQuestionCorrectAnswer,
          columnQuestionIsImage,
          columnQuestionCategoryId
        ],
        where: '$columnQuestionId=?',
        whereArgs: [id]);
    if (maps.length > 0) return Question.fromMap(maps.first);
    return null;
  }

  Future<List<Question>?> getQuestionByCategoryId(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          columnQuestionId,
          columnQuestionText,
          columnQuestionImage,
          columnQuestionAnswerA,
          columnQuestionAnswerB,
          columnQuestionAnswerC,
          columnQuestionAnswerD,
          columnQuestionCorrectAnswer,
          columnQuestionIsImage,
          columnQuestionCategoryId
        ],
        where: '$columnQuestionCategoryId=?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return maps.map((question) => Question.fromMap(question)).toList();
    }
    return null;
  }

  Future<List<Question>?> getQuestions(Database db) async {
    var maps = await db.query(tableQuestionName, columns: [
      columnQuestionId,
      columnQuestionText,
      columnQuestionImage,
      columnQuestionAnswerA,
      columnQuestionAnswerB,
      columnQuestionAnswerC,
      columnQuestionAnswerD,
      columnQuestionCorrectAnswer,
      columnQuestionIsImage,
      columnQuestionCategoryId
    ]);
    if (maps.length > 0) {
      return maps.map((question) => Question.fromMap(question)).toList();
    }
    return null;
  }
}
