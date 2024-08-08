import 'package:api_curd/model/dataModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _databaseName = 'dataItem.db';
  static const String _tableName = 'dataItem';
  static const int _databaseVersion = 1;
  static Database? _database;

  static const userId ='userId';
  static const id ='id';
  static const title ='title';
  static const body ='body';

  DatabaseHelper._init();

  Future<Database> get createDatabase async{

  if(_database != null ) return _database!;
  _database = await _initDatabase();
  return _database!;
  }

static  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,_databaseName);
    return await openDatabase(path,version: _databaseVersion,onCreate: _onCreate);
  }

static  Future _onCreate(Database db,int version)async{
    await db.execute(""" 
     CREATE TABLE $_tableName(
        $id INTEGER PRIMARY KEY,
        $userId INTEGER,
        $title TEXT,
        $body TEXT
     )"""

    );
  }

  Future<int> insertData(DataModel dataModel) async{
    var db = await instance.createDatabase;
    return await db.insert(_tableName,dataModel.toJson(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }
/*
 static Future<List<Map<String, dynamic>>> getAll() async{
    final db =await createDatabase();
    return await db!.query(_tableName);
   // return res.map((e) => DataModel.fromJson(e)).toList();
  }*/

   Future<List<DataModel>>  getAll() async{
    final db =await instance.createDatabase;
   final List<Map<String, dynamic>> res = await db.query(_tableName);
     return res.map((e) => DataModel.fromJson(e)).toList();
  }

  Future<void> close() async {
    final db = await instance.createDatabase;
    db.close();
  }

}