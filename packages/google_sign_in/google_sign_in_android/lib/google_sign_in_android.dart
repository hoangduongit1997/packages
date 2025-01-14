// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:credential_manager/credential_manager.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

import 'src/credential_util.dart';

/// Android implementation of [GoogleSignInPlatform].
class GoogleSignInAndroid extends GoogleSignInPlatform {
  /// Creates a new plugin implementation instance.
  GoogleSignInAndroid();

  /// Registers this class as the default instance of [GoogleSignInPlatform].
  static void registerWith() {
    GoogleSignInPlatform.instance = GoogleSignInAndroid();
  }

  @override
  Future<void> init({
    List<String> scopes = const <String>[],
    SignInOption signInOption = SignInOption.standard,
    String? hostedDomain,
    String? clientId,
  }) {
    return initWithParams(SignInInitParameters(
      signInOption: signInOption,
      scopes: scopes,
      hostedDomain: hostedDomain,
      clientId: clientId,
    ));
  }

  @override
  Future<void> initWithParams(SignInInitParameters params) {
    return CredentialUtil.instance.init(googleClientId: params.clientId);
  }

  @override
  Future<GoogleSignInUserData?> signIn() async {
    final GoogleIdTokenCredential? rs =
        await CredentialUtil.instance.saveGoogleCredential();
    if (rs == null) {
      return null;
    }
    return GoogleSignInUserData(
      email: rs.email,
      id: '',
      displayName: rs.displayName,
      photoUrl: rs.profilePictureUri.toString(),
      idToken: rs.idToken,
      serverAuthCode: '',
    );
  }

  @override
  Future<void> signOut() {
    return CredentialUtil.instance.logout();
  }

  @override
  Future<void> disconnect() {
    return CredentialUtil.instance.logout();
  }

  @override
  Future<bool> isSignedIn() {
    return CredentialUtil.instance.isSignedIn();
  }

  @override
  Future<GoogleSignInTokenData> getTokens({
    required String email,
    bool? shouldRecoverAuth,
  }) {
    return CredentialUtil.instance.getTokens();
  }
}
