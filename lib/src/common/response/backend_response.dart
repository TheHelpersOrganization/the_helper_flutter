class BackendResponse {
  final Map<String, dynamic> data;
  final Map<String, dynamic> meta;

  const BackendResponse({
    required this.data,
    required this.meta,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackendResponse &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          meta == other.meta);

  @override
  int get hashCode => data.hashCode ^ meta.hashCode;

  @override
  String toString() {
    return 'BackendResponse{ data: $data, meta: $meta,}';
  }

  BackendResponse copyWith({
    Map<String, dynamic>? data,
    Map<String, dynamic>? meta,
  }) {
    return BackendResponse(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'meta': meta,
    };
  }

  factory BackendResponse.fromMap(Map<String, dynamic> map) {
    return BackendResponse(
      data: map['data'] as Map<String, dynamic>,
      meta: map['meta'] as Map<String, dynamic>,
    );
  }
}
