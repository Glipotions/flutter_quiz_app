import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:quiz/database/category_provider.dart';
import 'package:quiz/database/db_helper.dart';
import 'package:quiz/database/question_provider.dart';
// import 'package:quiz/database/question_provider.dart';
import 'package:quiz/models/user_answer_model.dart';
import 'package:quiz/states/state_manager.dart';
import 'package:quiz/utils/utils.dart';
import 'package:quiz/widgets/question_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReadModePage extends StatefulWidget {
  const MyReadModePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<StatefulWidget> createState() => _MyReadModePageState();
}

class _MyReadModePageState extends State<MyReadModePage> {
  SharedPreferences? prefs;
  int indexPage = 0;
  CarouselController buttonCarouselController = CarouselController();
  List<UserAnswer> userAnswers = List<UserAnswer>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPersistentFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      indexPage = await prefs!.getInt(
          '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}')!;
      Future.delayed(const Duration(milliseconds: 500)).then((value) =>
          buttonCarouselController
              .animateToPage(indexPage == null ? 0 : indexPage));
    });
  }

  @override
  Widget build(BuildContext context) {
    var questionModule = context.read(questionCategoryState).state;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(questionModule.name!),
            leading: GestureDetector(
              onTap: () => showCloseDialog(questionModule),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: FutureBuilder<List<Question>>(
              future: getQuestionByCategory(questionModule.ID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, bottom: 4, top: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                QuestionBody(
                                  context: context,
                                  userAnswers: userAnswers,
                                  carouselController: buttonCarouselController,
                                  questions: snapshot.data!,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () => showAnswer(context),
                                          child: const Text('Show Answer'))
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        onWillPop: () async {
          showCloseDialog(questionModule);
          return true;
        });
  }

  showCloseDialog(Category questionModule) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Close'),
              content: const Text('Do you want to save this question index ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      prefs!.setInt(
                          '${context.read(questionCategoryState).state.name}_${context.read(questionCategoryState).state.ID}',
                          context.read(currentReadPage).state);

                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  Future<List<Question>> getQuestionByCategory(int? id) async {
    var db = await copyDb();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id!);
    return result!;
  }
}
