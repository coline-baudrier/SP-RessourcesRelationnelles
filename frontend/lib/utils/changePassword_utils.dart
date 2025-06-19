/// Renvoie un message d'erreur ou de succès, ou null si tout s'est bien passé.
Future<String?> changePasswordLogic({
  required String email,
  required String newPassword,
  required String confirmPassword,
  required Future<void> Function(String email, String password) resetPassword,
}) async {
  if (newPassword != confirmPassword) {
    return 'Les mots de passe ne correspondent pas';
  }

  try {
    await resetPassword(email, newPassword);
    return 'Mot de passe changé avec succès';
  } catch (e) {
    return 'Erreur: ${e.toString()}';
  }
}
