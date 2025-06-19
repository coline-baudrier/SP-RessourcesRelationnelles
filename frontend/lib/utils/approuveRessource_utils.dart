Future<String?> approveResourceLogic({
  required int resourceId,
  required String token,
  required Future<void> Function(int, String) approveFn,
}) async {
  try {
    await approveFn(resourceId, token);
    return null;
  } catch (e) {
    return 'Erreur: ${e.toString()}';
  }
}
