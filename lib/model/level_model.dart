import 'dart:convert';

class LevelModel {
  late String name;
  late bool isLocked;
  late bool isActive;

  LevelModel({
    required this.name,
    this.isLocked = false,
    this.isActive = false,
  });

  LevelModel.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        isActive = data['isActive'],
        isLocked = data['isLocked'];

  LevelModel.fromJsonEncodedString(String data) {
    Map mapData = jsonDecode(data);
    name = mapData['name'];
    isLocked = mapData['isLocked'];
    isActive = mapData['isActive'];
  }

  Map toJson() {
    return {
      "name": name,
      "isLocked": isLocked,
      "isActive": isActive,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
