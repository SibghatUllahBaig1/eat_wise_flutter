import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

AppleAuthProvider _appleProvider() {
  final provider = AppleAuthProvider();
  provider.addScope('email');
  provider.addScope('name');
  return provider;
}

Future<AuthCredential> getAppleCredential() async {
  if (kIsWeb) {
    throw UnsupportedError(
      'getAppleCredential is not supported on web; use linkWithPopup instead.',
    );
  }

  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    throw UnsupportedError(
      'Use FirebaseAuth.instance.currentUser!.linkWithProvider on iOS/macOS.',
    );
  }

  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  final idToken = appleCredential.identityToken;
  final authCode = appleCredential.authorizationCode;

  if (idToken == null || idToken.isEmpty) {
    throw FirebaseAuthException(
      code: 'invalid-credential',
      message: 'Apple Sign-In did not return an identity token.',
    );
  }

  if (authCode.isEmpty) {
    throw FirebaseAuthException(
      code: 'invalid-credential',
      message: 'Apple Sign-In did not return an authorization code.',
    );
  }

  return OAuthProvider('apple.com').credential(
    idToken: idToken,
    rawNonce: rawNonce,
    accessToken: authCode,
  );
}

Future<UserCredential> appleSignIn() async {
  if (kIsWeb) {
    return FirebaseAuth.instance.signInWithPopup(_appleProvider());
  }

  // iOS/macOS: use Firebase's native Sign in with Apple flow (handles nonce,
  // authorization code, and full name correctly).
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    return FirebaseAuth.instance.signInWithProvider(_appleProvider());
  }

  return _appleSignInWithCredential();
}

/// Manual credential flow for platforms without native Firebase Apple UI.
Future<UserCredential> _appleSignInWithCredential() async {
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  final idToken = appleCredential.identityToken;
  final authCode = appleCredential.authorizationCode;

  if (idToken == null || idToken.isEmpty) {
    throw FirebaseAuthException(
      code: 'invalid-credential',
      message: 'Apple Sign-In did not return an identity token.',
    );
  }

  if (authCode.isEmpty) {
    throw FirebaseAuthException(
      code: 'invalid-credential',
      message: 'Apple Sign-In did not return an authorization code.',
    );
  }

  // Firebase Auth requires the authorization code as accessToken when using
  // signInWithCredential (firebase_auth 4.3+).
  final oauthCredential = OAuthProvider('apple.com').credential(
    idToken: idToken,
    rawNonce: rawNonce,
    accessToken: authCode,
  );

  final userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

  final displayName = [appleCredential.givenName, appleCredential.familyName]
      .where((name) => name != null && name.isNotEmpty)
      .join(' ');

  if (displayName.isNotEmpty && userCredential.user != null) {
    await userCredential.user!.updateDisplayName(displayName);
  }

  return userCredential;
}
