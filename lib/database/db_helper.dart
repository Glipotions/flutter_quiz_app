import 'dart:io';

import 'package:flutter/services.dart';
import 'package:quiz/const/const.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> copyDb() async {
  var dbPath = await getDatabasesPath();
  var path = join(dbPath, db_name);

  var exists = await databaseExists(path);
  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}
    ByteData data = await rootBundle.load(join(
        "assets/db", db_name)); //assets klasöründeki veri tabanını alma yeri
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print("Db already exists");
  }
  return await openDatabase(path, readOnly: true);
}
