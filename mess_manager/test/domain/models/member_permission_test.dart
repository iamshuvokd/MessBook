import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/models/member.dart';
import 'package:mess_manager/domain/models/member_permission.dart';

Member _member({
  required MemberRole role,
  Set<MemberPermission> permissions = const {},
}) =>
    Member(
      id: 'm1',
      groupId: 'g1',
      name: 'Test',
      joinDate: DateTime(2026, 1, 1),
      active: true,
      role: role,
      permissions: permissions,
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  group('MemberRole.fromDb', () {
    test('parses each known role', () {
      expect(MemberRole.fromDb('appAdmin'), MemberRole.appAdmin);
      expect(MemberRole.fromDb('subAdmin'), MemberRole.subAdmin);
      expect(MemberRole.fromDb('member'), MemberRole.member);
    });

    test('falls back to the LEAST privileged role for junk, never to admin', () {
      for (final bad in ['', 'admin', 'APPADMIN', 'owner', 'null']) {
        expect(MemberRole.fromDb(bad), MemberRole.member,
            reason: 'unknown role "$bad" must fail closed to member');
      }
    });
  });

  group('MemberPermission key mapping', () {
    test('every permission has a unique stable key', () {
      final keys = MemberPermission.values.map((p) => p.key).toList();
      expect(keys.toSet().length, MemberPermission.values.length, reason: 'keys must be unique');
    });

    test('fromKey round-trips every permission', () {
      for (final p in MemberPermission.values) {
        expect(MemberPermission.fromKey(p.key), p);
      }
    });

    test('fromKey returns null for an unknown key rather than guessing', () {
      expect(MemberPermission.fromKey('meals.destroy'), isNull);
      expect(MemberPermission.fromKey(''), isNull);
    });
  });

  group('MemberPermission.setFromDb / setToDb', () {
    test('parses a comma-separated list', () {
      final set = MemberPermission.setFromDb('meals.manage,polls.create');
      expect(set, {MemberPermission.mealsManage, MemberPermission.pollsCreate});
    });

    test('an empty string grants nothing', () {
      expect(MemberPermission.setFromDb(''), isEmpty);
    });

    test('unknown keys are dropped, not treated as a grant', () {
      final set = MemberPermission.setFromDb('meals.manage,not.a.permission,*');
      expect(set, {MemberPermission.mealsManage});
    });

    test('tolerates whitespace around keys', () {
      expect(MemberPermission.setFromDb(' meals.manage , polls.create '),
          {MemberPermission.mealsManage, MemberPermission.pollsCreate});
    });

    test('setToDb round-trips through setFromDb', () {
      const original = {MemberPermission.expensesManage, MemberPermission.moneyManage};
      expect(MemberPermission.setFromDb(MemberPermission.setToDb(original)), original);
    });
  });

  group('Member.hasPermission — role-wise visibility', () {
    test('App Admin implicitly holds EVERY permission, with none listed', () {
      final admin = _member(role: MemberRole.appAdmin);
      for (final p in MemberPermission.values) {
        expect(admin.hasPermission(p), isTrue, reason: '${p.key} should be implicit for App Admin');
      }
    });

    test('a plain member holds NOTHING, even if permissions were somehow set', () {
      // Defensive: a stray permissions list on a plain member must not grant.
      final member = _member(role: MemberRole.member, permissions: MemberPermission.values.toSet());
      for (final p in MemberPermission.values) {
        expect(member.hasPermission(p), isFalse, reason: '${p.key} must not leak to a plain member');
      }
    });

    test('a sub-admin holds exactly what was granted and nothing more', () {
      final sub = _member(
        role: MemberRole.subAdmin,
        permissions: {MemberPermission.mealsManage, MemberPermission.pollsCreate},
      );
      expect(sub.hasPermission(MemberPermission.mealsManage), isTrue);
      expect(sub.hasPermission(MemberPermission.pollsCreate), isTrue);
      // Everything else denied:
      expect(sub.hasPermission(MemberPermission.pollsManage), isFalse);
      expect(sub.hasPermission(MemberPermission.expensesManage), isFalse);
      expect(sub.hasPermission(MemberPermission.moneyManage), isFalse);
      expect(sub.hasPermission(MemberPermission.membersManage), isFalse);
    });

    test('a sub-admin with no grants holds nothing', () {
      final sub = _member(role: MemberRole.subAdmin);
      for (final p in MemberPermission.values) {
        expect(sub.hasPermission(p), isFalse);
      }
    });

    test('isAppAdmin is true only for the App Admin role', () {
      expect(_member(role: MemberRole.appAdmin).isAppAdmin, isTrue);
      expect(_member(role: MemberRole.subAdmin).isAppAdmin, isFalse);
      expect(_member(role: MemberRole.member).isAppAdmin, isFalse);
    });
  });

  group('PermissionPreset bundles', () {
    test('Meal Admin can run meals and polls but not money or members', () {
      final p = PermissionPreset.mealAdmin.permissions;
      expect(p, contains(MemberPermission.mealsManage));
      expect(p, contains(MemberPermission.pollsCreate));
      expect(p, contains(MemberPermission.pollsManage));
      expect(p, isNot(contains(MemberPermission.moneyManage)));
      expect(p, isNot(contains(MemberPermission.membersManage)));
      expect(p, isNot(contains(MemberPermission.expensesManage)));
    });

    test('Expense Admin handles money but not meals or members', () {
      final p = PermissionPreset.expenseAdmin.permissions;
      expect(p, {MemberPermission.expensesManage, MemberPermission.moneyManage});
    });

    test('Poll Creator can only create polls, not manage them', () {
      expect(PermissionPreset.pollCreator.permissions, {MemberPermission.pollsCreate});
    });

    test('Member Admin only manages members', () {
      expect(PermissionPreset.memberAdmin.permissions, {MemberPermission.membersManage});
    });

    test('no preset silently grants membersManage except Member Admin', () {
      for (final preset in PermissionPreset.values) {
        if (preset == PermissionPreset.memberAdmin) continue;
        expect(preset.permissions, isNot(contains(MemberPermission.membersManage)),
            reason: '${preset.name} must not hand out member management');
      }
    });

    test('a sub-admin given a preset behaves exactly as the preset says', () {
      final mealAdmin = _member(role: MemberRole.subAdmin, permissions: PermissionPreset.mealAdmin.permissions);
      expect(mealAdmin.hasPermission(MemberPermission.mealsManage), isTrue);
      expect(mealAdmin.hasPermission(MemberPermission.moneyManage), isFalse);
    });
  });
}
