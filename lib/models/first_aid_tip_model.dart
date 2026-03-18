import 'package:hive/hive.dart';

class FirstAidTip extends HiveObject {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> steps;
  final String iconName;
  final int colorValue;

  FirstAidTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.steps,
    required this.iconName,
    required this.colorValue,
  });

  factory FirstAidTip.fromMap(Map<String, dynamic> map) {
    return FirstAidTip(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      steps: List<String>.from(map['steps'] ?? []),
      iconName: map['icon_name'] ?? 'medical_services',
      colorValue: map['color_value'] ?? 0xFFF44336, // Default Red
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'steps': steps,
      'icon_name': iconName,
      'color_value': colorValue,
    };
  }
}

class FirstAidTipAdapter extends TypeAdapter<FirstAidTip> {
  @override
  final int typeId = 1;

  @override
  FirstAidTip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirstAidTip(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      steps: (fields[4] as List).cast<String>(),
      iconName: fields[5] as String,
      colorValue: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FirstAidTip obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.steps)
      ..writeByte(5)
      ..write(obj.iconName)
      ..writeByte(6)
      ..write(obj.colorValue);
  }
}
