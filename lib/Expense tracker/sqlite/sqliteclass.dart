
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../model/sqlitemodel.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();


  static Database? _database;

  NotesDatabase._init();

  

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  

  Future<Database> _initDB(String filePath) async {
     final textType = 'TEXT NOT NULL';
     final dbPath = await getDatabasesPath();
     final path = '$dbPath/$filePath';
      print(path);
      return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
          final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
          final textType = 'TEXT NOT NULL';
          final boolType = 'BOOLEAN NOT NULL';
          final integerType = 'INTEGER NOT NULL';
    return await db.execute('''CREATE TABLE $tableNotes (${DownloadsValueFields.id} $textType,${DownloadsValueFields.amount} $textType,${DownloadsValueFields.category} $textType,${DownloadsValueFields.timestamp} $integerType)''');
  }

  Future<DownloadsModel> create(DownloadsModel note, String ids) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: ids);
  }

  Future<DownloadsModel?> readNote(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: DownloadsValueFields.values,
      where: '${DownloadsValueFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DownloadsModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<DownloadsModel?> readExactNote(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: DownloadsValueFields.values,
      where: '${DownloadsValueFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DownloadsModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletenullrow() async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: "ID IS NULL", whereArgs: null
    );
  }

  Future<List<DownloadsModel>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${DownloadsValueFields.timestamp} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => DownloadsModel.fromJson(json)).toList();
  }

  Future update(DownloadsModel note) async {
    final db = await instance.database;
    var batch = db.batch();
    batch.update( tableNotes,
      note.toJson(),
      where: '${DownloadsValueFields.id} = ?',
      whereArgs: [note.id],);
    return await batch.commit(exclusive: true);
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${DownloadsValueFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }


}

