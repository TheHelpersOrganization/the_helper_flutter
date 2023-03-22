import 'dart:convert';

class FileModel {
  final int id;
  final String name;
  final String mimetype;

  const FileModel({
    required this.id,
    required this.name,
    required this.mimetype,
  });

  FileModel copyWith({
    int? id,
    String? name,
    String? mimetype,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mimetype: mimetype ?? this.mimetype,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'mimetype': mimetype,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] as int,
      name: map['name'] as String,
      mimetype: map['mimetype'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FileModel(id: $id, name: $name, mimetype: $mimetype)';

  @override
  bool operator ==(covariant FileModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.mimetype == mimetype;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ mimetype.hashCode;
}
