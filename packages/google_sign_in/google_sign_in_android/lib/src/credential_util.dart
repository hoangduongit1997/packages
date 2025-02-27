// ignore_for_file: public_member_api_docs, avoid_setters_without_getters

import 'dart:developer';

import 'package:credential_manager/credential_manager.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class CredentialUtil {
  CredentialUtil._internal();
  static CredentialUtil get instance => _instance;
  static final CredentialUtil _instance = CredentialUtil._internal();
  static final CredentialManager _credentialManager = CredentialManager();
  GoogleIdTokenCredential? _googleIdTokenCredential;

  Future<void> init({
    bool preferImmediatelyAvailableCredentials = true,
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
      await _credentialManager.logout();
      _googleIdTokenCredential = null;
    } catch (e) {
      log('Error $e');
    }
  }

  Future<bool> isSignedIn() async {
    try {
      return _googleIdTokenCredential != null;
    } catch (e) {
      log('Error $e');
      return false;
    }
  }

  Future<GoogleSignInTokenData> getTokens() async {
    try {
      return GoogleSignInTokenData(
        accessToken: _googleIdTokenCredential?.idToken,
        idToken: _googleIdTokenCredential?.idToken,
        serverAuthCode: '',
      );
    } catch (e) {
      log('Error $e');
      return GoogleSignInTokenData();
    }
  }

  set saveGoogleIdTokenCredential(GoogleIdTokenCredential credential) {
    _googleIdTokenCredential = credential;
  }

  Future<GoogleSignInUserData?> signIn() async {
    try {
      final GoogleIdTokenCredential? rs = await saveGoogleCredential();
      if (rs == null) {
        return null;
      }
      saveGoogleIdTokenCredential = rs;
      return GoogleSignInUserData(
        email: rs.email,
        id: rs.email,
        displayName: rs.displayName,
        photoUrl: rs.profilePictureUri.toString(),
        idToken: rs.idToken,
        serverAuthCode: '',
      );
    } catch (e) {
      log('Error $e');
      return null;
    }
  }

  Future<GoogleSignInUserData?> signInSilently() async {
    try {
      return GoogleSignInUserData(
        email: _googleIdTokenCredential?.email ?? '',
        id: _googleIdTokenCredential?.email ?? '',
        displayName: _googleIdTokenCredential?.displayName,
        photoUrl: _googleIdTokenCredential?.profilePictureUri.toString(),
        idToken: _googleIdTokenCredential?.idToken,
        serverAuthCode: '',
      );
    } catch (e) {
      log('Error $e');
      return null;
    }
  }
}
