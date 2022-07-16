import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/shared/cubit/cubit.dart';
import 'package:tasks/shared/cubit/states.dart';

Widget defaultFormField(
    {required TextEditingController controller,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validate,
    required String label,
    required IconData prefix,
    Function? onTap}) {
  keyboardType = TextInputType.text;
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validate,
    decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        )),
    onTap: () {
      return onTap!();
    },
  );
}

Widget buildTaskItem(Map model,context) {
  return Dismissible(
    key: Key(model['name']),
    onDismissed: (direction){
      AppCubit.get(context).DeleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text("${model['time']}"),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${model['date']}",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              AppCubit.get(context).UpdateData(id: model['id'], status: 'done');
            },
          ),

          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {
              AppCubit.get(context).UpdateData(id: model['id'], status: 'archive');
            },
          )
        ],
      ),
    ),
  );
}

Widget taskBuilder(tasks){
  return ConditionalBuilder(
    condition: tasks.length> 0,
    builder: (context) => ListView.separated(
              itemBuilder: (context, index) {
                tasks = tasks;
                return buildTaskItem(tasks[index],context);
              },
              separatorBuilder: (context, index) => Container(
                color: Colors.grey[200],
                width: double.infinity,
                height: 2,
              ),
              itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 100,color: Colors.grey,),
          Text('No Tasks Yet, Please Add Some Tasks',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey),),
        ],
      ),
    ),
  );
}
