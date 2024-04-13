library lazyxchacha;

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

abstract class LazyXChaCha {
  /// Constructs a LazyXChaCha.
  LazyXChaCha();

  static LazyXChaCha instance = LazyXChaCha20Poly1305();

  Future<String> encrypt(String plaintext, String key);

  Future<String> decrypt(String ciphertext, String key);
}

class LazyXChaCha20Poly1305 implements LazyXChaCha {
  final _xChaCha20 = Xchacha20.poly1305Aead();

  @override
  Future<String> encrypt(String plaintext, String key) async {
    final secretKey = SecretKey(hex.decode(key));
    final secretBox =
        await _xChaCha20.encryptString(plaintext, secretKey: secretKey);
    return hex.encode(secretBox.concatenation());
  }

  @override
  Future<String> decrypt(String ciphertext, String key) async {
    final secretKey = SecretKey(hex.decode(key));
    final cipherBytes = hex.decode(ciphertext);
    final secretBox = SecretBox.fromConcatenation(
      cipherBytes,
      nonceLength: 24,
      macLength: 16,
    );
    final plaintext =
        await _xChaCha20.decryptString(secretBox, secretKey: secretKey);
    return plaintext;
  }
}
