import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/engines/balance_engine.dart';
import 'package:mess_manager/domain/engines/debt_simplifier.dart';

void main() {
  group('DebtSimplifier.simplify', () {
    test('two-person debt produces a single transaction', () {
      final tx = DebtSimplifier.simplify({'a': -500, 'b': 500});
      expect(tx, hasLength(1));
      expect(tx.first.fromMemberId, 'a');
      expect(tx.first.toMemberId, 'b');
      expect(tx.first.amountPaisa, 500);
    });

    test('all-zero balances produce no transactions', () {
      expect(DebtSimplifier.simplify({'a': 0, 'b': 0}), isEmpty);
    });

    test('minimizes transaction count vs. naive pairwise settling', () {
      // a owes 300, b owes 200, c is owed 500 total.
      // Naive pairwise (a->c, b->c) already needs 2; simplifier must not exceed that.
      final tx = DebtSimplifier.simplify({'a': -300, 'b': -200, 'c': 500});
      expect(tx.length, lessThanOrEqualTo(2));
      expect(tx.fold<int>(0, (a, t) => a + t.amountPaisa), 500);
    });

    test('six-member mess settles in at most 5 transactions (n-1 bound)', () {
      final balances = {
        'rahim': 620,
        'karim': -540,
        'sabbir': 180,
        'fahim': -260,
        'tanvir': 0,
        'imran': 0,
      };
      final tx = DebtSimplifier.simplify(balances);
      expect(tx.length, lessThanOrEqualTo(5));
      expect(tx.fold<int>(0, (a, t) => a + t.amountPaisa), 800); // sum of positives
    });

    test('sum of transaction amounts always equals the sum of positive balances', () {
      final cases = [
        {'a': -100, 'b': -200, 'c': 300},
        {'a': -50, 'b': 30, 'c': 20},
        {'a': -1, 'b': -1, 'c': -1, 'd': 3},
        {'a': -999, 'b': 999},
      ];
      for (final balances in cases) {
        final tx = DebtSimplifier.simplify(balances);
        final positiveSum = balances.values.where((v) => v > 0).fold<int>(0, (a, b) => a + b);
        final txSum = tx.fold<int>(0, (a, t) => a + t.amountPaisa);
        expect(txSum, positiveSum, reason: 'balances=$balances');
      }
    });

    test('applying the simplified transactions zeroes every balance exactly', () {
      final balances = {
        'rahim': 620,
        'karim': -540,
        'sabbir': 180,
        'fahim': -260,
        'tanvir': 400,
        'imran': -400,
      };
      final tx = DebtSimplifier.simplify(balances);

      final remaining = Map<String, int>.from(balances);
      for (final t in tx) {
        remaining[t.fromMemberId] = remaining[t.fromMemberId]! + t.amountPaisa;
        remaining[t.toMemberId] = remaining[t.toMemberId]! - t.amountPaisa;
      }
      expect(remaining.values.every((v) => v == 0), isTrue, reason: 'remaining=$remaining');
    });
  });

  group('integration: balance engine + debt simplifier reconcile to zero', () {
    test('a full settlement round zeroes out every member net', () {
      // Three expenses paid by different members, split equally across all.
      final balances = BalanceEngine.compute(
        memberIds: ['rahim', 'karim', 'sabbir', 'fahim'],
        totalPaidByMember: {'rahim': 4000, 'karim': 1200},
        totalShareByMember: {'rahim': 1300, 'karim': 1300, 'sabbir': 1300, 'fahim': 1300},
      );

      final netByMember = {for (final b in balances) b.memberId: b.net};
      expect(netByMember.values.fold<int>(0, (a, b) => a + b), 0);

      final settlements = DebtSimplifier.simplify(netByMember);

      // Now feed those settlements back into the balance engine as recorded
      // settlements and confirm every member's net becomes exactly zero.
      final settlementsPaid = <String, int>{};
      final settlementsReceived = <String, int>{};
      for (final s in settlements) {
        settlementsPaid[s.fromMemberId] = (settlementsPaid[s.fromMemberId] ?? 0) + s.amountPaisa;
        settlementsReceived[s.toMemberId] = (settlementsReceived[s.toMemberId] ?? 0) + s.amountPaisa;
      }

      final finalBalances = BalanceEngine.compute(
        memberIds: ['rahim', 'karim', 'sabbir', 'fahim'],
        totalPaidByMember: {'rahim': 4000, 'karim': 1200},
        totalShareByMember: {'rahim': 1300, 'karim': 1300, 'sabbir': 1300, 'fahim': 1300},
        settlementsPaidByMember: settlementsPaid,
        settlementsReceivedByMember: settlementsReceived,
      );

      for (final b in finalBalances) {
        expect(b.net, 0, reason: 'member=${b.memberId} did not reconcile to zero');
      }
    });
  });
}
