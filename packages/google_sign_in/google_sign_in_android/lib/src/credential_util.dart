// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:credential_manager/credential_manager.dart';

class CredentialUtil {
  const CredentialUtil._internal();
  static CredentialUtil get instance => _instance;
  static const CredentialUtil _instance = CredentialUtil._internal();
  static final CredentialManager _credentialManager = CredentialManager();

  Future<void> init({
    bool preferImmediatelyAvailableCredentials = false,
    String? googleClientId,
  }) async {
    await _credentialManager.init(
      preferImmediatelyAvailableCredentials:
          preferImmediatelyAvailableCredentials,
      googleClientId: googleClientId,
    );
  }

  Future<GoogleIdTokenCredential?> saveGoogleCredential() async {
    try {
      return await _credentialManager.saveGoogleCredential();
    } catch (e) {
      log('Error $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      return await _credentialManager.logout();
    } catch (e) {
      log('Error $e');
    }
  }

  Future<bool> isSignedIn() async {
    try {
      final Credentials credential = await _credentialManager.getCredentials();
      return credential.googleIdTokenCredential != null ||
          credential.passwordCredential != null ||
          credential.publicKeyCredential != null;
    } catch (e) {
      log('Error $e');
      return false;
    }
  }
}
