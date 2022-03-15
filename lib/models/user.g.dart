// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      employeeNumber: fields[0] as String,
      fullName: fields[1] as String,
      grade: fields[2] as String,
      gradeType: fields[3] as String,
      positionTitle: fields[4] as String,
      department: fields[5] as String,
      hireDate: fields[6] as DateTime,
      email: fields[7] as String?,
      servicePeriod: fields[8] as String,
      location: fields[9] as String?,
      supervisorName: fields[10] as String?,
      supervisorCode: fields[11] as String?,
      tokenId: fields[12] as String?,
      firstName: fields[13] as String,
      gender: fields[14] == null ? 'M' : fields[14] as String?,
      reimbursementFlag: fields[15] == null ? false : fields[15] as bool,
      claimFlag: fields[16] == null ? false : fields[16] as bool,
      taxiFlag: fields[17] == null ? false : fields[17] as bool,
      nightStayFlag: fields[18] == null ? false : fields[18] as bool,
      travellingAmountFlag: fields[19] == null ? false : fields[19] as bool,
      diningAmountFlag: fields[20] == null ? false : fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.employeeNumber)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.grade)
      ..writeByte(3)
      ..write(obj.gradeType)
      ..writeByte(4)
      ..write(obj.positionTitle)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.hireDate)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.servicePeriod)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.supervisorName)
      ..writeByte(11)
      ..write(obj.supervisorCode)
      ..writeByte(12)
      ..write(obj.tokenId)
      ..writeByte(13)
      ..write(obj.firstName)
      ..writeByte(14)
      ..write(obj.gender)
      ..writeByte(15)
      ..write(obj.reimbursementFlag)
      ..writeByte(16)
      ..write(obj.claimFlag)
      ..writeByte(17)
      ..write(obj.taxiFlag)
      ..writeByte(18)
      ..write(obj.nightStayFlag)
      ..writeByte(19)
      ..write(obj.travellingAmountFlag)
      ..writeByte(20)
      ..write(obj.diningAmountFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      employeeNumber: json['employeeNumber'] as String,
      fullName: json['fullName'] as String,
      grade: json['grade'] as String,
      gradeType: json['gradeType'] as String,
      positionTitle: json['positionTitle'] as String,
      department: json['department'] as String,
      hireDate:
          const DateTimeEpochConverter().fromJson(json['hireDate'] as int),
      email: json['email'] as String?,
      servicePeriod: json['servicePeriod'] as String,
      location: json['location'] as String?,
      supervisorName: json['supervisorName'] as String?,
      supervisorCode: json['supervisorCode'] as String?,
      tokenId: json['tokenId'] as String?,
      firstName: json['firstName'] as String,
      gender: json['gender'] as String? ?? 'M',
      reimbursementFlag: json['reimbursementFlag'] as bool? ?? false,
      claimFlag: json['claimFlag'] as bool? ?? false,
      taxiFlag: json['taxiFlag'] as bool? ?? false,
      nightStayFlag: json['nightStayFlag'] as bool? ?? false,
      travellingAmountFlag: json['travellingAmountFlag'] as bool? ?? false,
      diningAmountFlag: json['diningAmountFlag'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'employeeNumber': instance.employeeNumber,
      'fullName': instance.fullName,
      'grade': instance.grade,
      'gradeType': instance.gradeType,
      'positionTitle': instance.positionTitle,
      'department': instance.department,
      'hireDate': const DateTimeEpochConverter().toJson(instance.hireDate),
      'email': instance.email,
      'servicePeriod': instance.servicePeriod,
      'location': instance.location,
      'supervisorName': instance.supervisorName,
      'supervisorCode': instance.supervisorCode,
      'tokenId': instance.tokenId,
      'firstName': instance.firstName,
      'gender': instance.gender,
      'reimbursementFlag': instance.reimbursementFlag,
      'claimFlag': instance.claimFlag,
      'taxiFlag': instance.taxiFlag,
      'nightStayFlag': instance.nightStayFlag,
      'travellingAmountFlag': instance.travellingAmountFlag,
      'diningAmountFlag': instance.diningAmountFlag,
    };
