Mocks for [google_sign_in](https://pub.dev/packages/google_sign_in). Use this
package with `firebase_auth_mocks` to write unit tests involving Firebase
Authentication.

## Usage

A simple usage example:

```dart
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:test/test.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  setUpAll((){
    googleSignIn = MockGoogleSignIn();
  });

  test('should return idToken and accessToken when authenticating', () async {
    final signInAccount = await googleSignIn.signIn();
    final signInAuthentication = await signInAccount!.authentication;
    expect(signInAuthentication, isNotNull);
    expect(googleSignIn.currentUser, isNotNull);
    expect(signInAuthentication.accessToken, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);
  });

  test('should return null when google login is cancelled by the user', () async {
    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
  });

  test('shouldn\'t return null when google login is cancelled by the user', () async {
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNotNull);
  });
}

```

## Features and bugs

Please file feature requests and bugs at the issue tracker.
