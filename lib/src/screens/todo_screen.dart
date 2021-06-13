import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/src/blocs/todo_bloc.dart';
import 'package:todo/src/blocs/todo_bloc_provider.dart';
import 'package:todo/src/model/todo_model.dart';
import 'package:todo/src/screens/create_or_update_todo.dart';
import 'package:todo/src/widgets/shared/app_colors.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoBlocProvider(
      child: Builder(builder: (context) {
        final TodoBloc bloc = TodoBlocProvider.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text("Your todos", style: TextStyle(color: blackColor87)),
            backgroundColor: whiteColor,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 40,
                  color: blackColor87,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return CreateOrUpdateTodo(
                      bloc: bloc,
                    );
                  }));
                },
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
          body: _buildBody(bloc),
        );
      }),
    );
  }

  Widget _buildBody(TodoBloc bloc) {
    return StreamBuilder(
        stream: bloc.fetchAllTodos(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return _buildGetStarted(context, bloc);
          }
          if (snapshot.data!.docs.isEmpty) {
            return _buildGetStarted(context, bloc);
          }
          final list = snapshot.data!.docs.map((e) {
            return TodoModel.fromJson(e.data(), e.id);
          }).toList();
          return _buildTodoList(context, bloc, list);
        });
  }

  Widget _buildGetStarted(BuildContext context, TodoBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create your first Todo",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CreateOrUpdateTodo(bloc: bloc);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      primary: blueColor),
                  child: Text(
                    "Add New Todo",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: whiteColor),
                  ))),
        ],
      ),
    );
  }

  Widget _buildTodoList(
      BuildContext context, TodoBloc bloc, List<TodoModel> list) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, int index) {
        final single = list[index];
        return _buildSingleTodoItem(single, bloc, context);
      },
    );
  }

  Widget _buildSingleTodoItem(
      TodoModel single, TodoBloc bloc, BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Update',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () {
            bloc.setEditingTodo(single);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return CreateOrUpdateTodo(bloc: bloc);
            }));
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            bloc.deleteTodo(single);
          },
        ),
      ],
      child: Card(
        child: ListTile(
          title: Text(single.name!),
          subtitle: Text(single.desc!),
          trailing: Text(single.date!.toIso8601String().substring(0, 10)),
          onTap: () {},
        ),
      ),
    );
  }
}
