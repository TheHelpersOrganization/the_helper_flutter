import 'package:flutter/foundation.dart';
import 'dart:convert';

@immutable
class ActivityModel {
  final int id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String shortDescription;
  final int status;

  const ActivityModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.shortDescription,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          description == other.description &&
          shortDescription == other.shortDescription &&
          status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      description.hashCode ^
      shortDescription.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'Activity{ id: $id, name: $name, startTime: $startTime, endTime: $endTime, description: $description, shortDescription: $shortDescription, status: $status,}';
  }

  ActivityModel copyWith({
    int? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? shortDescription,
    int? status,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'shortDescription': shortDescription,
      'status': status,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as int,
      name: map['name'] as String,
      startTime: map['startTime'] as DateTime,
      endTime: map['endTime'] as DateTime,
      description: map['description'] as String,
      shortDescription: map['shortDescription'] as String,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
