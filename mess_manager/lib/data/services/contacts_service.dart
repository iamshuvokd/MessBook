import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../repositories/members_repository.dart';

enum ContactsPermissionResult { granted, denied, permanentlyDenied }

class ContactsService {
  Future<ContactsPermissionResult> requestPermission() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) return ContactsPermissionResult.granted;
    if (status.isPermanentlyDenied) return ContactsPermissionResult.permanentlyDenied;
    return ContactsPermissionResult.denied;
  }

  Future<bool> hasPermission() => Permission.contacts.isGranted;

  /// Returns phone contacts sorted by display name, deduplicated by name+first phone.
  Future<List<ContactDraft>> loadContacts() async {
    final contacts = await FlutterContacts.getAll(properties: {ContactProperty.phone});
    final seen = <String>{};
    final drafts = <ContactDraft>[];
    for (final c in contacts) {
      final name = (c.displayName ?? '').trim();
      if (name.isEmpty) continue;
      final phone = c.phones.isNotEmpty ? c.phones.first.number : null;
      final key = '$name|$phone';
      if (!seen.add(key)) continue;
      drafts.add((name: name, phone: phone));
    }
    drafts.sort((a, b) => a.name.compareTo(b.name));
    return drafts;
  }
}
