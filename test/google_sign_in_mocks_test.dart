import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:test/test.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  setUp(() {
    googleSignIn = MockGoogleSignIn();
  });

  test('signIn should return idToken and accessToken when authenticating',
      () async {
    final signInAccount = await googleSignIn.signIn();
    final signInAuthentication = await signInAccount!.authentication;
    expect(signInAuthentication, isNotNull);
    expect(googleSignIn.currentUser, isNotNull);
    expect(signInAuthentication.accessToken, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);
  });

  test('signIn should return null when google login is cancelled by the user',
      () async {
    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
  });

  test(
      'testing signIn twice, once cancelled, once not cancelled at the same test.',
      () async {
    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
    googleSignIn.setIsCancelled(false);
    final signInAccountSecondAttempt = await googleSignIn.signIn();
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
