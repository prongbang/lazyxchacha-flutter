library lazyxchacha;

import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

abstract class LazyXChaCha {
  /// Constructs a LazyXChaCha.
  LazyXChaCha();

  static LazyXChaCha instance = LazyXChaCha20Poly1305();

  Future<String> encrypt(String plaintext, String key);

  Future<String> decrypt(String ciphertext, String key);

  /// Encrypts [plaintext] bytes with the raw [key] bytes and returns the
  /// nonce + ciphertext + mac concatenation as bytes.
  Future<Uint8List> encryptRaw(List<int> plaintext, List<int> key);

  /// Decrypts the nonce + ciphertext + mac concatenation in [ciphertext]
  /// with the raw [key] bytes and returns the plaintext bytes.
  Future<Uint8List> decryptRaw(List<int> ciphertext, List<int> key);
}

class LazyXChaCha20Poly1305 implements LazyXChaCha {
  final _xChaCha20 = Xchacha20.poly1305Aead();

  @override
  Future<String> encrypt(String plaintext, String key) async {
    final cipherBytes = await encryptRaw(utf8.encode(plaintext), hex.decode(key));
    return hex.encode(cipherBytes);
  }

  @override
  Future<String> decrypt(String ciphertext, String key) async {
    final plainBytes = await decryptRaw(hex.decode(ciphertext), hex.decode(key));
    return utf8.decode(plainBytes);
  }

  @override
  Future<Uint8List> encryptRaw(List<int> plaintext, List<int> key) async {
    final secretKey = SecretKey(key);
    final secretBox = await _xChaCha20.encrypt(plaintext, secretKey: secretKey);
    return Uint8List.fromList(secretBox.concatenation());
  }

  @override
  Future<Uint8List> decryptRaw(List<int> ciphertext, List<int> key) async {
    final secretKey = SecretKey(key);
    final secretBox = SecretBox.fromConcatenation(
      ciphertext,
      nonceLength: _xChaCha20.nonceLength,
      macLength: _xChaCha20.macAlgorithm.macLength,
    );
    final plainBytes =
        await _xChaCha20.decrypt(secretBox, secretKey: secretKey);
    return Uint8List.fromList(plainBytes);
  }
}
