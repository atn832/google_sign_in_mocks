import 'package:google_sign_in/google_sign_in.dart';
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

  test('authenticationEvents emits on successful authentication', () async {
    final events = <GoogleSignInAuthenticationEvent>[];
    final subscription = googleSignIn.authenticationEvents.listen(events.add);
    await googleSignIn.authenticate();
    // Allow event loop to process (auto-generated but may not be necessary):
    // await Future.delayed(Duration.zero);
    expect(events.length, 1);
    expect(events.first, isA<GoogleSignInAuthenticationEventSignIn>());
    expect((events.first as GoogleSignInAuthenticationEventSignIn).user,
        isNotNull);
    await subscription.cancel();
  });

  test('authenticationEvents emits error on cancelled authentication',
      () async {
    final errors = [];
    final subscription =
        googleSignIn.authenticationEvents.listen(null, onError: errors.add);

    googleSignIn.setIsCancelled(true);
    expect(() => googleSignIn.authenticate(), throwsA('Cancelled'));

    // Allow event loop to process (necessary).
    await Future.delayed(Duration.zero);

    expect(errors.length, 1);
    expect(errors.first, 'Cancelled');
    await subscription.cancel();
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
