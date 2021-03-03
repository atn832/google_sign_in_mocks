import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignInAccount _currentUser;

  /// To simulate google login cancellation behaviour.
  bool _isCancelled = false;


  void setIsCancelled(bool val) {
    _isCancelled = val;
  }
  @override
  GoogleSignInAccount get currentUser => _currentUser;

  @override
  Future<GoogleSignInAccount> signIn() {
    _currentUser = MockGoogleSignInAccount();
    final returnVal = _isCancelled ? Future.value(null) : Future.value(_currentUser);
    _isCancelled = false;
    return returnVal;
  }
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  Future<GoogleSignInAuthentication> get authentication =>
      Future.value(MockGoogleSignInAuthentication());
}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {
  @override
  String get idToken => 'idToken';

  @override
  String get accessToken => 'accessToken';
}
