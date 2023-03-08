import 'dart:ffi';

class ActivityData {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final Bool isAvailable;

  ActivityData({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.isAvailable,
  });

  factory ActivityData.fromMap(Map<String, dynamic> map) {
    final id = map['id'] as String;
    final name = map['name'] as String;
    final description = map['description'] as String;
    final shortDescription = map['shortDescription'] as String;
    final isAvailable = map['isAvailable'] as Bool;

    return ActivityData(
        id: id,
        name: name,
        description: description,
        shortDescription: shortDescription,
        isAvailable: isAvailable);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'isAvailable': isAvailable
    };
  }
}
