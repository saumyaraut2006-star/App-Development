// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanTransactionAdapter extends TypeAdapter<LoanTransaction> {
  @override
  final int typeId = 1;

  @override
  LoanTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanTransaction(
      id: fields[0] as String,
      contactId: fields[1] as String,
      contactName: fields[2] as String,
      amount: fields[3] as double,
      type: fields[4] as String,
      interestRate: fields[5] as double,
      startDate: fields[6] as DateTime,
      dueDate: fields[7] as DateTime?,
      status: fields[8] as String,
      paidAmount: fields[9] as double,
      notes: fields[10] as String?,
      interestType: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoanTransaction obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contactId)
      ..writeByte(2)
      ..write(obj.contactName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.interestRate)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.paidAmount)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.interestType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
