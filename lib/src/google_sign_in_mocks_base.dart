import 'package:google_sign_in/google_sign_in.dart';

class MockGoogleSignIn implements GoogleSignIn {
  MockGoogleSignInAccount? _currentUser;

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
      return Future.error('Cancelled');
    }
    return Future.value(_currentUser);
  }

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
