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
      'testing signIn twice, once cancelled, once not cancelled at the same test.',
      () async {
    googleSignIn.setIsCancelled(true);
    googleSignIn.setIsCancelled(true);
    expect(() {
      return googleSignIn.authenticate();
    }, throwsA('Cancelled'));
    googleSignIn.setIsCancelled(false);
    final signInAccountSecondAttempt = await googleSignIn.authenticate();
    expect(signInAccountSecondAttempt, isNotNull);
  });

  test('signInSilently should return user when user is already signed in',
      () async {
    final signInAccount = await googleSignIn.signIn();
    final silentSignInAccount = await googleSignIn.signInSilently();
    expect(silentSignInAccount, isNotNull);
    expect(silentSignInAccount, equals(signInAccount));
  });

  test('signInSilently should return user after calling enableSilentSignIn',
      () async {
    googleSignIn.enableSilentSignIn();
    final silentSignInAccount = await googleSignIn.signInSilently();
    expect(silentSignInAccount, isNotNull);
  });

  test('signInSilently should return null when user is not signed in',
      () async {
    final silentSignInAccount = await googleSignIn.signInSilently();
    expect(silentSignInAccount, isNull);
  });

  test('signOut should return null when user is signed out', () async {
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNotNull);
    final signOutAccount = await googleSignIn.signOut();
    expect(signOutAccount, isNull);
  });

  test('disconnect should return null when user is disconnected', () async {
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNotNull);
    final disconnectAccount = await googleSignIn.disconnect();
    expect(disconnectAccount, isNull);
  });
}
