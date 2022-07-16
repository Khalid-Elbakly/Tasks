import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/layout/archivedTasks.dart';
import 'package:tasks/layout/doneScreen.dart';
import 'package:tasks/layout/tasksScreen.dart';
import 'package:tasks/shared/components/components.dart';
import 'package:tasks/shared/cubit/cubit.dart';
import 'package:tasks/shared/cubit/states.dart';

import 'shared/constants/constants.dart';

class homeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(state is DataBaseInsertState){
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.title[cubit.currentIndex]),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.ChangeBottomNavIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archived"),
                ],
              ),
              body: cubit.Pages[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                  child: cubit.fabIcon,
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        cubit
                            .insertToDataBase(nameController.text,
                                dateController.text, timeController.text);
                        }
                      }
                     else {
                      scaffoldKey.currentState!
                          .showBottomSheet(
                            (context) => Container(
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                        controller: nameController,
                                        validate: (validate) {
                                          if (validate!.isEmpty) {
                                            return "Name must be not empty";
                                          }
                                          return null;
                                        },
                                        label: "TaskName",
                                        prefix: Icons.task),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    defaultFormField(
                                        controller: dateController,
                                        validate: (validate) {
                                          if (validate!.isEmpty) {
                                            return "Name must be not empty";
                                          }
                                          return null;
                                        },
                                        label: "Task Date",
                                        prefix: Icons.calendar_today,
                                        onTap: () {
                                          return showDatePicker(
                                                  firstDate: DateTime.now(),
                                                  context: context,
                                                  lastDate: DateTime(2025),
                                                  initialDate: DateTime.now())
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    defaultFormField(
                                        controller: timeController,
                                        validate: (validate) {
                                          if (validate!.isEmpty) {
                                            return "Name must be not empty";
                                          }
                                          return null;
                                        },
                                        label: "Task Time",
                                        prefix: Icons.lock_clock_sharp,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ),
                            elevation: 20,
                          )
                          .closed
                          .then((value) {
                        cubit.BottomSheetShown(isshown: false,icon: Icons.edit);
                      });
                      cubit.BottomSheetShown(isshown: true,icon: Icons.add);
                    }
                  }),
            );
          },
        ));
  }
}
