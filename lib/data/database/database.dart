import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pushnotification/data/database/migrations/Notification.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
part 'database.g.dart';

@DriftDatabase(
    tables: [Notification],
    daos: [
      NotificationDao
    ]
)
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database() : super(_openConnection());
  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<Database>((ref) => Database());