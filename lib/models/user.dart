import 'package:hive/hive.dart';

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

/// TypeAdapter ditulis manual (isinya sama dengan hasil build_runner),
/// jadi tidak perlu menjalankan `dart run build_runner build`.
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }
}
