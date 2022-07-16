import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class tasksScreen extends StatelessWidget {
  const tasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(

        listener: (context, states) {},
        builder: (context, states) {
          var tasks = AppCubit.get(context).newTasks;
          return taskBuilder(tasks);
        });
  }
}
