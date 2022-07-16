import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/layout/archivedTasks.dart';
import 'package:tasks/layout/doneScreen.dart';
import 'package:tasks/layout/tasksScreen.dart';

import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) {
    return BlocProvider.of(context);
  }

  int currentIndex = 0;
  List<String> title = ["Tasks", "Done", "Archived"];
  List<Widget> Pages = [tasksScreen(), doneScreen(), archivedScreen()];

  void ChangeBottomNavIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void createDatabase() async {
    database =
        await openDatabase("todo.db", version: 1, onCreate: (db, version) {
      print("created");
      db.execute(
          "CREATE TABLE Tasks (id INTEGER PRIMARY KEY,name TEXT,date TEXT,time TEXT,status TEXT) ");
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print("database opened");
    }).then((value) {
      print(value);
      database = value;
      emit(DataBaseCreateState());
      return value;
    });
  }

  Future insertToDataBase(name, date, time) {
    return database
        .rawInsert(
            'INSERT INTO Tasks(name,date,time,status) VALUES("$name","$date","$time","new")')
        .then((value) {
      print(value);
      emit(DataBaseInsertState());
      getDataFromDataBase(database);
    });
  }

  void getDataFromDataBase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery("SELECT * FROM Tasks").then((value) {
      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
        emit(DataBaseGetState());
      });});}


  void UpdateData({required id,required String status}){
     database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
       emit(DataBaseUpdateState());
       getDataFromDataBase(database);
     });
  }

  void DeleteData({required id}){
    database.rawUpdate('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(DataBaseDeleteState());
      getDataFromDataBase(database);
    });
  }


  bool isBottomSheetShown = false;
  Icon fabIcon = Icon(Icons.edit);

  void BottomSheetShown({required IconData icon, required bool isshown}) {
    isBottomSheetShown = isshown;
    fabIcon = Icon(icon);
    emit(AppBottomSheetShownState());
  }
}
