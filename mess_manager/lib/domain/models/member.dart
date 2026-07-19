import 'member_permission.dart';

class Member {
  const Member({
    required this.id,
    required this.groupId,
    required this.name,
    this.phone,
    this.photoPath,
    required this.joinDate,
    this.leaveDate,
    required this.active,
    this.role = MemberRole.member,
    this.permissions = const {},
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String name;
  final String? phone;
  final String? photoPath;
  final DateTime joinDate;
  final DateTime? leaveDate;
  final bool active;
  final MemberRole role;

  /// Only meaningful when [role] is `subAdmin` — `appAdmin` implicitly has
  /// every permission, `member` has none.
  final Set<MemberPermission> permissions;
  final DateTime updatedAt;

  bool get isAppAdmin => role == MemberRole.appAdmin;

  bool hasPermission(MemberPermission permission) =>
      isAppAdmin || (role == MemberRole.subAdmin && permissions.contains(permission));

  Member copyWith({
    String? name,
    String? phone,
    String? photoPath,
    DateTime? leaveDate,
    bool? active,
    MemberRole? role,
    Set<MemberPermission>? permissions,
  }) {
    return Member(
      id: id,
      groupId: groupId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      joinDate: joinDate,
      leaveDate: leaveDate ?? this.leaveDate,
      active: active ?? this.active,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      updatedAt: DateTime.now(),
    );
  }
}
