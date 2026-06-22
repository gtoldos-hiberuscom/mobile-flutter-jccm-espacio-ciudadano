import 'dart:typed_data';

final class SupportRequest {
  const SupportRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.privacyConsentAccepted,
    this.attachment,
  });

  final String name;
  final String email;
  final String subject;
  final String message;
  final bool privacyConsentAccepted;
  final SupportRequestAttachment? attachment;
}

final class SupportRequestAttachment {
  const SupportRequestAttachment({
    required this.fileName,
    required this.bytes,
  });

  final String fileName;
  final Uint8List bytes;
}
