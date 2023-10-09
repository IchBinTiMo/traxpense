// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeProviderAdapter extends TypeAdapter<ThemeProvider> {
  @override
  final int typeId = 2;

  @override
  ThemeProvider read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeProvider().._themeData = fields[0] as ThemeData;
  }

  @override
  void write(BinaryWriter writer, ThemeProvider obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._themeData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
