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
final lazysecret = LazySecret.instance;
```

## Function