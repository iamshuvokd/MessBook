import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/engines/balance_engine.dart';

void main() {
  _lowBalanceTests();

  group('BalanceEngine.compute', () {
    test('equal three-way split with no deposits/settlements sums to zero', () {
      // Rahim pays 3000 for an expense split equally among 3 members.
      final balances = BalanceEngine.compute(
        memberIds: ['rahim', 'karim', 'sabbir'],
        totalPaidByMember: {'rahim': 3000},
        totalShareByMember: {'rahim': 1000, 'karim': 1000, 'sabbir': 1000},
      );

      expect(balances.length, 3);
      final byId = {for (final b in balances) b.memberId: b};
      expect(byId['rahim']!.net, 2000); // paid 3000, owes 1000 → owed 2000
      expect(byId['karim']!.net, -1000);
      expect(byId['sabbir']!.net, -1000);
      expect(balances.fold<int>(0, (a, b) => a + b.net), 0);
    });

    test('missing member entries default to zero rather than throwing', () {
      final balances = BalanceEngine.compute(
        memberIds: ['a', 'b'],
        totalPaidByMember: {'a': 500},
        totalShareByMember: {'a': 250, 'b': 250},
      );
      final b = balances.firstWhere((m) => m.memberId == 'b');
      expect(b.totalPaid, 0);
      expect(b.net, -250);
    });

    test('deposits increase a member net without affecting others', () {
      final balances = BalanceEngine.compute(
        memberIds: ['a', 'b'],
        totalPaidByMember: {'a': 1000},
        totalShareByMember: {'a': 500, 'b': 500},
        depositsByMember: {'b': 300},
      );
      final byId = {for (final b in balances) b.memberId: b};
      expect(byId['a']!.net, 500); // 1000 paid - 500 share
      expect(byId['b']!.net, -200); // -500 share + 300 deposit
      // Group sum equals total deposits when no expense is funded by the pool yet.
      expect(balances.fold<int>(0, (a, b) => a + b.net), 300);
    });

    test('carried-forward opening balances shift net without affecting other members', () {
      final balances = BalanceEngine.compute(
        memberIds: ['a', 'b'],
        totalPaidByMember: {'a': 100},
        totalShareByMember: {'a': 100, 'b': 0},
        carriedForwardByMember: {'a': -540}, // owed 540 from last month's close
      );
      final byId = {for (final b in balances) b.memberId: b};
      expect(byId['a']!.net, -540); // 100 paid - 100 share - 540 carried
      expect(byId['b']!.net, 0);
    });

    test('settlements move net between the paying and receiving member', () {
      // a owes b 500; a settles in full.
      final balances = BalanceEngine.compute(
        memberIds: ['a', 'b'],
        totalPaidByMember: {'b': 500},
        totalShareByMember: {'a': 500},
        settlementsPaidByMember: {'a': 500},
        settlementsReceivedByMember: {'b': 500},
      );
      final byId = {for (final b in balances) b.memberId: b};
      expect(byId['a']!.net, 0); // -500 share + 500 settlement paid
      expect(byId['b']!.net, 0); // +500 paid - 500 settlement received
    });
  });
}

void _lowBalanceTests() {
  group('isLowBalance (mess warning threshold)', () {
    test('flags a member whose remaining balance is under the threshold', () {
      expect(isLowBalance(remainingPaisa: 5000, thresholdPaisa: 20000), isTrue);
    });

    test('does not flag a member at or above the threshold', () {
      expect(isLowBalance(remainingPaisa: 20000, thresholdPaisa: 20000), isFalse);
      expect(isLowBalance(remainingPaisa: 30000, thresholdPaisa: 20000), isFalse);
    });

    test('a negative balance (overspent) is always low', () {
      expect(isLowBalance(remainingPaisa: -5000, thresholdPaisa: 20000), isTrue);
    });

    test('threshold 0 means the mess never set one, so nobody is flagged', () {
      expect(isLowBalance(remainingPaisa: -99999, thresholdPaisa: 0), isFalse);
    });
  });
}
