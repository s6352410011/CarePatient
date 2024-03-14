import 'dart:convert';

class Event {
  String id;
  String name;
  bool editable;

  Event({required this.id, required this.name, this.editable = true});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'editable': editable,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      editable: map['editable'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
