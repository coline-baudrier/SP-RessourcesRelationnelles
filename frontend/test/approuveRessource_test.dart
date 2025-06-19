import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/approuveRessource_utils.dart';

void main() {
  test('approveResourceLogic retourne null en cas de succès', () async {
    final result = await approveResourceLogic(
      resourceId: 1,
      token: 'token',
      approveFn: (id, token) async {},
    );
    expect(result, isNull);
  });

  test(
    'approveResourceLogic retourne un message d\'erreur en cas d\'échec',
    () async {
      final result = await approveResourceLogic(
        resourceId: 1,
        token: 'token',
        approveFn: (id, token) async {
          throw Exception('échec');
        },
      );
      expect(result, 'Erreur: Exception: échec');
    },
  );
}
