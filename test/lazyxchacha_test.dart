import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lazyxchacha/lazyxchacha.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LazyXChaCha lazyXChaCha;

  setUp(() {
    lazyXChaCha = LazyXChaCha.instance;
  });

  test('Should return ciphertext when encrypt success', () async {
    // Given
    const sharedKey =
        'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d';
    const plaintext =
        '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

    // When
    final actual = await lazyXChaCha.encrypt(plaintext, sharedKey);

    // Then
    expect(actual, isNotNull);
    debugPrint(actual);
  });

  test('Should return plaintext when decrypt success', () async {
    // Given
    const sharedKey =
        'edf9d004edae8335f095bb8e01975c42cf693ea60322b75cb7c6667dc836fd7e';
    const ciphertext =
        '1ec54672d8ef2cca35151428edfee29d3551fd81fc6a4ddedbd3c47bc42c8fc355b6a2cf666d83f45982fa5051943c12d3f65056d54f5c0c02d8112635dbaa52d41a58c067576ae1eba997464be721040704aa6454cefb2ccf099ccfc71c2809646231f4eec697325ea5e359b6c42eb3ff5041ce0edf92d5dbb42396ce3d0d16830fd5b490715f4fb17cf99878216d785931d9e92a';
    const plaintext =
        '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

    // When
    final actual = await lazyXChaCha.decrypt(ciphertext, sharedKey);

    // Then
    expect(actual, plaintext);
  });

  test(
    'Should return ciphertext and plaintext when encrypt and decrypt success',
    () async {
      // Given
      const sharedKey =
          'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d';
      const plaintext =
          '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

      // When
      final actualCipherText = await lazyXChaCha.encrypt(plaintext, sharedKey);
      final actualPlainText =
          await lazyXChaCha.decrypt(actualCipherText, sharedKey);

      // Then
      expect(actualPlainText, plaintext);
    },
  );

  test('Should return ciphertext bytes when encryptRaw success', () async {
    // Given
    final key = hex.decode(
      'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d',
    );
    final plaintext = Uint8List.fromList([0, 1, 2, 253, 254, 255]);

    // When
    final actual = await lazyXChaCha.encryptRaw(plaintext, key);

    // Then
    expect(actual, isNotNull);
    expect(actual.length, greaterThan(plaintext.length));
    debugPrint(hex.encode(actual));
  });

  test('Should return plaintext bytes when decryptRaw success', () async {
    // Given
    final key = hex.decode(
      'edf9d004edae8335f095bb8e01975c42cf693ea60322b75cb7c6667dc836fd7e',
    );
    final ciphertext = hex.decode(
      '1ec54672d8ef2cca35151428edfee29d3551fd81fc6a4ddedbd3c47bc42c8fc355b6a2cf666d83f45982fa5051943c12d3f65056d54f5c0c02d8112635dbaa52d41a58c067576ae1eba997464be721040704aa6454cefb2ccf099ccfc71c2809646231f4eec697325ea5e359b6c42eb3ff5041ce0edf92d5dbb42396ce3d0d16830fd5b490715f4fb17cf99878216d785931d9e92a',
    );
    const plaintext =
        '{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.rTCH8cLoGxAm_xw68z-zXVKi9ie6xJn9tnVWjd_9ftE"}';

    // When
    final actual = await lazyXChaCha.decryptRaw(ciphertext, key);

    // Then
    expect(actual, utf8.encode(plaintext));
  });

  test(
    'Should return the same bytes when encryptRaw and decryptRaw success',
    () async {
      // Given
      final key = hex.decode(
        'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d',
      );
      final plaintext = Uint8List.fromList(
        List<int>.generate(256, (index) => index),
      );

      // When
      final actualCipherBytes = await lazyXChaCha.encryptRaw(plaintext, key);
      final actualPlainBytes =
          await lazyXChaCha.decryptRaw(actualCipherBytes, key);

      // Then
      expect(actualPlainBytes, plaintext);
    },
  );

  test(
    'Should return the same plaintext when encryptRaw and decrypt success',
    () async {
      // Given
      const sharedKey =
          'e4f7fe3c8b4066490f8ffde56f080c70629ff9731b60838015027c4687303b1d';
      const plaintext = '{"message": "Hi"}';

      // When
      final actualCipherBytes = await lazyXChaCha.encryptRaw(
        utf8.encode(plaintext),
        hex.decode(sharedKey),
      );
      final actualPlainText = await lazyXChaCha.decrypt(
        hex.encode(actualCipherBytes),
        sharedKey,
      );

      // Then
      expect(actualPlainText, plaintext);
    },
  );
}
