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
