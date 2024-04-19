import 'package:flutter/foundation.dart';
import 'package:lazyxchacha/keypair.dart';
import 'package:lazyxchacha/lazyxchacha.dart';

void main() async {
  final lazyxchacha = LazyXChaCha.instance;

  // Generate KeyPair
  final clientKeyPair = await KeyPair.newKeyPair();
  final serverKeyPair = await KeyPair.newKeyPair();

  // Key Exchange
  final clientSharedKey = await clientKeyPair.sharedKey(serverKeyPair.pk);
  final serverSharedKey = await serverKeyPair.sharedKey(clientKeyPair.pk);

  // Payload
  const message = 'Hello lazyxchacha';

  // Encrypt with client
  final ciphertext = await lazyxchacha.encrypt(message, clientSharedKey);

  // Decrypt with server
  final plaintext = await lazyxchacha.decrypt(ciphertext, serverSharedKey);

  // Output
  debugPrint('Output: $plaintext');
}
