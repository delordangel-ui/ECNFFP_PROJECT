import 'package:flutter_test/flutter_test.dart';
import 'package:ecnffp/providers/candidate_provider.dart';
import 'package:ecnffp/models/app_models.dart';

void main() {
  test('Codification logic should follow the national format', () {
    final provider = CandidateProvider();
    final candidate = Candidate(
      lastName: 'MUKENI',
      postName: 'KABAMBA',
      firstName: 'Jean',
      birthDate: '2000-01-01',
      center: 'C1',
      centerCode: '10',
      school: 'S1',
      schoolCode: '05',
      provinceName: 'Kasaï',
      provinceCode: '25',
      specialtyName: 'Mécanique',
      specialtyCode: '01',
      managementTypeName: 'Privé',
      managementTypeCode: '2',
      gender: 'M',
      orderNumber: 12,
    );

    final code = provider.generateStudentCode(candidate);
    // Expected: Prov(25)+Center(10)+Spec(01)+School(05)+Order(012)+Mgmt(2)
    expect(code, '251001050122');
  });
}
