class TodoModel {
  String? name;
  String? desc;
  DateTime? date;

  TodoModel({required this.date, required this.name, required this.desc});

  TodoModel.fromJson(Map<String, dynamic> map) {
    name = map["name"];
    desc = map["desc"];
    date = DateTime.parse(map["date"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desc': desc,
      'date': date,
    };
  }
}
