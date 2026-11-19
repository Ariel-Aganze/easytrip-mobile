import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/features/auth/domain/entities/auth_user.dart';

void main() {
  test('UserRole.fromApi maps backend role strings', () {
    expect(UserRole.fromApi('CUSTOMER'), UserRole.customer);
    expect(UserRole.fromApi('OPERATOR'), UserRole.operator);
    expect(UserRole.fromApi('AGENT'), UserRole.agent);
    expect(UserRole.fromApi('ADMIN'), UserRole.admin);
    expect(UserRole.fromApi('something-else'), UserRole.unknown);
  });
}