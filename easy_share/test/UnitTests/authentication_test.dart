import 'package:flutter_test/flutter_test.dart';
import '../../lib/Screens/Login/authentication_service.dart';

void main(){

  // testes para o email
  test('empty email returns error string', (){

    var result = EmailValidator.validate('');

    expect(result, "Email can't be empty");
  });

  test('non-empty email returns null', (){

    var result = EmailValidator.validate('randomemail');

    expect(result, null);
  });

  // testes para a password
  test('empty password returns error string', (){

    var result = PasswordValidator.validate('');

    expect(result, "Password can't be empty");
  });

  test('non-empty password returns null', (){

    var result = PasswordValidator.validate('randomemail');

    expect(result, null);
  });

}