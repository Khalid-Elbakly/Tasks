import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/shared/components/components.dart';
import 'package:tasks/shared/cubit/cubit.dart';
import 'package:tasks/shared/cubit/states.dart';

class archivedScreen extends StatelessWidget {
  const archivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,states){},
      builder: (context,states) {
        var tasks = AppCubit.get(context).archivedTasks;
       return taskBuilder(tasks);
      }
    );
  }
}
