import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

class MockGoogleSignIn implements GoogleSignIn {
  MockGoogleSignInAccount? _currentUser;
  final StreamController<GoogleSignInAuthenticationEvent> _authEventController =
      StreamController<GoogleSignInAuthenticationEvent>.broadcast();

  bool _isCancelled = false;
  GoogleSignInException? _exception;

  /// Used to simulate google login cancellation behaviour.
  void setIsCancelled(bool val) {
    _isCancelled = val;
  }

  /// Used to simulate user already being signed in to google.
  void enableLightweightAuthentication() {
    _currentUser = MockGoogleSignInAccount();
  }

  /// Used to simulate GoogleSignInException thrown.
  void setException(GoogleSignInException exception) {
    _exception = exception;
  }

  @override
  Future<GoogleSignInAccount> authenticate(
      {List<String> scopeHint = const <String>[]}) {
    if (_exception != null) {
      _authEventController.addError(_exception!);
      return Future.error(_exception!);
    }
    _currentUser = MockGoogleSignInAccount();
    if (_isCancelled) {
      _authEventController.addError(
        GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );
      return Future.error(
        GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );
    }
    _authEventController
        .add(GoogleSignInAuthenticationEventSignIn(user: _currentUser!));
    return Future.value(_currentUser);
  }

  @override
  Future<void> initialize(
      {String? clientId,
      String? serverClientId,
      String? nonce,
      String? hostedDomain}) {
    if (_exception != null) {
      _authEventController.addError(_exception!);
      return Future.error(_exception!);
    }
    return Future.value();
  }

  @override
  Future<GoogleSignInAccount?>? attemptLightweightAuthentication(
      {bool reportAllExceptions = false}) {
    if (_exception != null) {
      _authEventController.addError(_exception!);
      // https://github.com/flutter/packages/blob/b9e4c50d8d018040730e67bcd3d0d207e44dff67/packages/google_sign_in/google_sign_in/lib/google_sign_in.dart#L454
      final maybeIgnoredCodes = [
        GoogleSignInExceptionCode.canceled,
        GoogleSignInExceptionCode.interrupted,
        GoogleSignInExceptionCode.uiUnavailable,
      ];
      if (!reportAllExceptions &&
          maybeIgnoredCodes.contains(_exception!.code)) {
        return Future.value(null);
      }
      return Future.error(_exception!);
    }
    if (_currentUser != null) {
      _authEventController
          .add(GoogleSignInAuthenticationEventSignIn(user: _currentUser!));
    }
    return Future.value(_currentUser);
  }

  @override
  Future<GoogleSignInAccount?> signOut() {
    _currentUser = null;
    return Future.value(null);
  }

  @override
  Future<GoogleSignInAccount?> disconnect() {
    _currentUser = null;
    return Future.value(null);
  }

  @override
  Stream<GoogleSignInAuthenticationEvent> get authenticationEvents =>
      _authEventController.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGoogleSignInAccount implements GoogleSignInAccount {
  @override
  GoogleSignInAuthentication get authentication =>
      MockGoogleSignInAuthentication();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGoogleSignInAuthentication implements GoogleSignInAuthentication {
  @override
  String get idToken => 'idToken';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
