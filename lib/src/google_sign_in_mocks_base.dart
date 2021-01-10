import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignInAccount _currentUser;

  @override
  GoogleSignInAccount get currentUser => _currentUser;

  @override
  Future<GoogleSignInAccount> signIn() {
    _currentUser = MockGoogleSignInAccount();
    return Future.value(_currentUser);
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
