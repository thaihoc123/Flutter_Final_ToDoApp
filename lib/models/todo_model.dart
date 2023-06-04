class ToDoModel {
  int? id;
  String? title;
  bool? isDone;

  ToDoModel({this.id, this.title, this.isDone = false});

    ToDoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }
}

List<ToDoModel> deleteList1 = [];