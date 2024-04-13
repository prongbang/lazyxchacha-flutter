# lazyxchacha

Lazy XChaCha20-Poly1305 in Flutter base on [cryptography](https://pub.dev/packages/cryptography)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/prongbang)

### Algorithm details

- Key exchange: X25519
- Encryption: XChaCha20
- Authentication: Poly1305

## Usage

- pubspec.yml

```yaml
dependencies:
  lazyxchacha: ^1.0.0
```

- Dart

```dart
final lazyxchacha = LazyXChaCha.instance
```

## How to use

- Generate KeyPair

```dart
final keyPair = await KeyPair.newKeyPair();
```

- Key Exchange & Shared Key

```dart
final clientKeyPair = await KeyPair.newKeyPair();
final serverKeyPair = await KeyPair.newKeyPair();

final clientSharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
```

- Encrypt

```dart
final lazyXChaCha = LazyXChaCha.instance;
final sharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
const plaintext = '{"message": "Hi"}';

final ciphertext = await lazyXChaCha.encrypt(plaintext, sharedKey);
```

- Decrypt

```dart
final lazyXChaCha = LazyXChaCha.instance;
final sharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
const ciphertext = '1ec54672d8ef2cca351';

final plaintext = await lazyXChaCha.decrypt(ciphertext, sharedKey);
```