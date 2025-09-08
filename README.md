Mocks for [google_sign_in](https://pub.dev/packages/google_sign_in). Use this
package with `firebase_auth_mocks` to write unit tests involving Firebase
Authentication.

[![pub package](https://img.shields.io/pub/v/google_sign_in_mocks.svg)](https://pub.dartlang.org/packages/google_sign_in_mocks)
[![unit-tests](https://github.com/atn832/google_sign_in_mocks/actions/workflows/unit-tests.yaml/badge.svg)](https://github.com/atn832/google_sign_in_mocks/actions/workflows/unit-tests.yaml)
<a href="https://www.buymeacoffee.com/anhtuann" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="30px" width= "108px"></a>

## Usage

A simple usage example:

```dart
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:test/test.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  setUp(() {
    googleSignIn = MockGoogleSignIn();
  });

  test('should return idToken when authenticating', () async {
    final signInAccount = await googleSignIn.signIn();
    final signInAuthentication = await signInAccount!.authentication;
    expect(signInAuthentication, isNotNull);
    expect(googleSignIn.currentUser, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);
  });

  test('should return null when google login is cancelled by the user',
      () async {
    googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
  });
  test('testing google login twice, once cancelled, once not cancelled at the same test.', () async {
   googleSignIn.setIsCancelled(true);
    final signInAccount = await googleSignIn.signIn();
    expect(signInAccount, isNull);
    googleSignIn.setIsCancelled(false);
    final signInAccountSecondAttempt = await googleSignIn.signIn();
    expect(signInAccountSecondAttempt, isNotNull);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the issue tracker.
