import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

class MockGoogleSignIn implements GoogleSignIn {
  MockGoogleSignInAccount? _currentUser;
  final StreamController<GoogleSignInAuthenticationEvent> _authEventController =
      StreamController<GoogleSignInAuthenticationEvent>.broadcast();

  bool _isCancelled = false;

  /// Used to simulate google login cancellation behaviour.
  void setIsCancelled(bool val) {
    _isCancelled = val;
  }

  /// Used to simulate user already being signed in to google.
  void enableLightweightAuthentication() {
    _currentUser = MockGoogleSignInAccount();
  }

  @override
  Future<GoogleSignInAccount> authenticate(
      {List<String> scopeHint = const <String>[]}) {
    _currentUser = MockGoogleSignInAccount();
    if (_isCancelled) {
      _authEventController.addError('Cancelled');
      return Future.error('Cancelled');
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
    return Future.value();
  }

  @override
  Future<GoogleSignInAccount?>? attemptLightweightAuthentication(
      {bool reportAllExceptions = false}) {
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
