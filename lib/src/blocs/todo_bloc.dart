import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject, Rx;
import 'package:todo/src/api/todo_api.dart';
import 'package:todo/src/blocs/cache_bloc.dart';
import 'package:todo/src/model/todo_model.dart';
import 'package:todo/src/validators/todo_validator.dart';

class TodoBloc with TodoValidator {
  final api = TodoApi();
  final uid = cache.currentUid;

  final _instance = FirebaseFirestore.instance.collection('todo');

  //todo holds all the data of todo lists
  final BehaviorSubject<List<TodoModel>> _listController = BehaviorSubject();

  //to hold the status of the button's child
  final _loadingController = BehaviorSubject<bool>();

  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _dateController = BehaviorSubject<DateTime>();

  //used to set the currently active todo
  final _editingTodoController = BehaviorSubject<TodoModel?>();

  Function(bool val) get changeLoadingStatus => _loadingController.sink.add;

  Function(String val) get changeName => _nameController.sink.add;
  Function(String val) get changeDescription => _descriptionController.sink.add;
  Function(DateTime val) get changeDate => _dateController.sink.add;

  //adding value to the currently active todo
  Function(TodoModel? todo) get setEditingTodo =>
      _editingTodoController.sink.add;

  Future<void> addNewTodo() async {
    _instance.doc(uid).collection(uid!).add(currentTodo.toJson());
  }

  void updateTodo() {
    _instance
        .doc(uid)
        .collection(uid!)
        .doc(editingTodo!.id)
        .set(currentTodo.toJson());
  }

  void deleteTodo(TodoModel todo) {
    _instance.doc(uid).collection(uid!).doc(todo.id!).delete();
  }

  //stream getters

  Stream<String> get nameStream =>
      _nameController.stream.transform(nameValidator);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(descriptionValidator);

  Stream<DateTime> get dateStream =>
      _dateController.stream.transform(dateValidator);

  Stream<bool> get loadingStatusStream => _loadingController.stream;

  // combine 4 streams for signup button
  Stream<bool> get buttonStream => Rx.combineLatest3(
      nameStream, descriptionStream, dateStream, (a, b, c) => true);

  //get the current active todo
  TodoModel? get editingTodo =>
      _editingTodoController.hasValue ? _editingTodoController.value : null;

  TodoModel get currentTodo => TodoModel(
      date: _dateController.value,
      name: _nameController.value,
      desc: _descriptionController.value);

  void dispose() {
    _loadingController.close();
    _nameController.close();
    _descriptionController.close();
    _dateController.close();
    _editingTodoController.close();
    _listController.close();
  }

  Stream<QuerySnapshot<Object?>> getAllTodos() {
    Stream<QuerySnapshot> snapshot =
        _instance.doc(uid).collection(uid!).snapshots();
    snapshot.isEmpty.then((value) {
      print("The snapshot is now empty here $value");
    });
    return snapshot;
    // return snapshot.map((event) {
    //   print("Is this list empty or not ${event.docs.isEmpty}");
    //   if (event.docs.isEmpty) return [];
    //   return event.docs.map((QueryDocumentSnapshot e) {
    //     return TodoModel.fromJson(e.data() as Map<String, dynamic>, e.id);
    //   }).toList();
    // });
  }
}
