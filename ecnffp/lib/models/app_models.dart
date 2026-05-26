class Province {
  final int? id;
  final String name;
  final String code;

  Province({this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};
  factory Province.fromMap(Map<String, dynamic> map) => Province(id: map['id'], name: map['name'], code: map['code']);
}

class Specialty {
  final int? id;
  final String name;
  final String code;

  Specialty({this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};
  factory Specialty.fromMap(Map<String, dynamic> map) => Specialty(id: map['id'], name: map['name'], code: map['code']);
}

class ManagementType {
  final int? id;
  final String name;
  final String code;

  ManagementType({this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};
  factory ManagementType.fromMap(Map<String, dynamic> map) => ManagementType(id: map['id'], name: map['name'], code: map['code']);
}

class Candidate {
  final int? id;
  final String lastName;
  final String postName;
  final String firstName;
  final String birthDate;
  final String center;
  final String centerCode;
  final String school;
  final String schoolCode;
  final String provinceName;
  final String provinceCode;
  final String specialtyName;
  final String specialtyCode;
  final String managementTypeName;
  final String managementTypeCode;
  final String gender;
  final String? photoPath;
  final String? studentCode;
  final int isDeleted; // 0 or 1
  final int isCodified; // 0 or 1
  final int orderNumber;

  Candidate({
    this.id,
    required this.lastName,
    required this.postName,
    required this.firstName,
    required this.birthDate,
    required this.center,
    required this.centerCode,
    required this.school,
    required this.schoolCode,
    required this.provinceName,
    required this.provinceCode,
    required this.specialtyName,
    required this.specialtyCode,
    required this.managementTypeName,
    required this.managementTypeCode,
    required this.gender,
    this.photoPath,
    this.studentCode,
    this.isDeleted = 0,
    this.isCodified = 0,
    required this.orderNumber,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'lastName': lastName,
    'postName': postName,
    'firstName': firstName,
    'birthDate': birthDate,
    'center': center,
    'centerCode': centerCode,
    'school': school,
    'schoolCode': schoolCode,
    'provinceName': provinceName,
    'provinceCode': provinceCode,
    'specialtyName': specialtyName,
    'specialtyCode': specialtyCode,
    'managementTypeName': managementTypeName,
    'managementTypeCode': managementTypeCode,
    'gender': gender,
    'photoPath': photoPath,
    'studentCode': studentCode,
    'isDeleted': isDeleted,
    'isCodified': isCodified,
    'orderNumber': orderNumber,
  };

  factory Candidate.fromMap(Map<String, dynamic> map) => Candidate(
    id: map['id'],
    lastName: map['lastName'],
    postName: map['postName'],
    firstName: map['firstName'],
    birthDate: map['birthDate'],
    center: map['center'],
    centerCode: map['centerCode'],
    school: map['school'],
    schoolCode: map['schoolCode'],
    provinceName: map['provinceName'],
    provinceCode: map['provinceCode'],
    specialtyName: map['specialtyName'],
    specialtyCode: map['specialtyCode'],
    managementTypeName: map['managementTypeName'],
    managementTypeCode: map['managementTypeCode'],
    gender: map['gender'],
    photoPath: map['photoPath'],
    studentCode: map['studentCode'],
    isDeleted: map['isDeleted'],
    isCodified: map['isCodified'],
    orderNumber: map['orderNumber'],
  );
}

class ExamScore {
  final int? id;
  final int candidateId;
  // Hors Session
  final double? redaction;
  final double? sipDpo;
  // Session Ordinaire
  final double? day1;
  final double? day2;
  final double? day3;
  final double? day4;

  ExamScore({
    this.id,
    required this.candidateId,
    this.redaction,
    this.sipDpo,
    this.day1,
    this.day2,
    this.day3,
    this.day4,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'candidateId': candidateId,
    'redaction': redaction,
    'sipDpo': sipDpo,
    'day1': day1,
    'day2': day2,
    'day3': day3,
    'day4': day4,
  };

  factory ExamScore.fromMap(Map<String, dynamic> map) => ExamScore(
    id: map['id'],
    candidateId: map['candidateId'],
    redaction: map['redaction'],
    sipDpo: map['sipDpo'],
    day1: map['day1'],
    day2: map['day2'],
    day3: map['day3'],
    day4: map['day4'],
  );
}
