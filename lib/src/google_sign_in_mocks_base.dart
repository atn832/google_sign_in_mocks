import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignInAccount? _currentUser;

  bool _isCancelled = false;

  /// Used to simulate google login cancellation behaviour.
  void setIsCancelled(bool val) {
    _isCancelled = val;
  }

  @override
  GoogleSignInAccount? get currentUser => _currentUser;

  @override
  Future<GoogleSignInAccount?> signIn() {
    _currentUser = MockGoogleSignInAccount();
    final returnVal = _isCancelled ? Future.value(null) : Future.value(_currentUser);
    // [_isCancelled] is set back to false so to not affect other tests.
    _isCancelled = false;
    return returnVal;
  }
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  Future<GoogleSignInAuthentication> get authentication =>
      Future.value(MockGoogleSignInAuthentication());

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! GoogleSignInAccount) return false;
    final otherAccount = other;
    return displayName == otherAccount.displayName &&
        email == otherAccount.email &&
        id == otherAccount.id &&
        photoUrl == otherAccount.photoUrl;
  }
}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {
  @override
  String get idToken => 'idToken';

  @override
  String get accessToken => 'accessToken';
}
