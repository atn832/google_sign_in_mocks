A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

main() {
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final signinAuthentication = await signinAccount.authentication;
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
