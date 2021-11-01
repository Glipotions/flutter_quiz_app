import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:quiz/database/category_provider.dart';
import 'package:quiz/database/db_helper.dart';
import 'package:quiz/states/state_manager.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<StatefulWidget> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: FutureBuilder<List<Category>>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              Category category = Category();
              category.ID = -1;
              category.name = "Exam";
              snapshot.data!.add(category);
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: snapshot.data!.map((category) {
                  return GestureDetector(
                    child: Card(
                      elevation: 2,
                      color: category.ID == -1 ? Colors.green : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: AutoSizeText(
                              '${category.name}',
                              style: TextStyle(
                                  color: category.ID == -1
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () => print('Click to ${category.name}'),
                  );
                }).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future<List<Category>> getCategories() async {
    var db = await copyDb();
    var result = await CategoryProvider().getCategories(db);
    // context.read(categoryListProvider).state = result!;
    return result!;
  }
}
