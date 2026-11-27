import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String mobile;

  @HiveField(3)
  String? email;

  Contact({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
  });
}