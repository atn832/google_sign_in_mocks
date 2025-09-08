import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:test/test.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  setUp(() {
    googleSignIn = MockGoogleSignIn();
  });

  test('initializes', () async {
    expect(
        () => googleSignIn.initialize(clientId: 'client id'), returnsNormally);
  });

  test('should return idToken when authenticating', () async {
    final signInAccount = await googleSignIn.authenticate();
    final signInAuthentication = signInAccount.authentication;
    expect(signInAuthentication, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);
  });

  test('should cancel the Future when google login is cancelled by the user',
      () async {
    googleSignIn.setIsCancelled(true);
    expect(() {
      return googleSignIn.authenticate();
    }, throwsA('Cancelled'));
  });
  test(
      'testing google login twice, once cancelled, once not cancelled at the same test.',
      () async {
    googleSignIn.setIsCancelled(true);
    expect(() {
      return googleSignIn.authenticate();
    }, throwsA('Cancelled'));
    googleSignIn.setIsCancelled(false);
    final signInAccountSecondAttempt = await googleSignIn.authenticate();
    expect(signInAccountSecondAttempt, isNotNull);
  });
}
