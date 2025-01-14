// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:credential_manager/credential_manager.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

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

  Future<GoogleIdTokenCredential?> saveGoogleCredential({
    bool useButtonFlow = true,
  }) async {
    try {
      return await _credentialManager.saveGoogleCredential(
        useButtonFlow: useButtonFlow,
      );
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

  Future<GoogleSignInTokenData> getTokens() async {
    try {
      final Credentials credential = await _credentialManager.getCredentials();
      return GoogleSignInTokenData(
        accessToken: credential.googleIdTokenCredential?.idToken,
        idToken: credential.googleIdTokenCredential?.idToken,
        serverAuthCode: '',
      );
    } catch (e) {
      log('Error $e');
      return GoogleSignInTokenData();
    }
  }
}
