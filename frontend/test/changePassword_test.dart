import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/changePassword_utils.dart';

void main() {
  test(
    'retourne une erreur si les mots de passe ne correspondent pas',
    () async {
      final result = await changePasswordLogic(
        email: 'test@mail.com',
        newPassword: '123',
        confirmPassword: '456',
        resetPassword: (email, pass) async {},
      );

      expect(result, 'Les mots de passe ne correspondent pas');
    },
  );

  test('retourne un message de succès si tout se passe bien', () async {
    final result = await changePasswordLogic(
      email: 'test@mail.com',
      newPassword: '123',
      confirmPassword: '123',
      resetPassword: (email, pass) async {},
    );

    expect(result, 'Mot de passe changé avec succès');
  });

  test('retourne une erreur si resetPassword échoue', () async {
    final result = await changePasswordLogic(
      email: 'test@mail.com',
      newPassword: '123',
      confirmPassword: '123',
      resetPassword: (email, pass) async {
        throw Exception('Échec serveur');
      },
    );

    expect(result, contains('Erreur:'));
    expect(result, contains('Échec serveur'));
  });
}
