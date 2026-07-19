import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/repository_providers.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  ProductDetails? _product;
  bool _loadingProduct = true;
  bool _purchasing = false;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final billing = ref.read(billingServiceProvider);
    ProductDetails? product;
    try {
      if (await billing.isAvailable()) {
        product = await billing.queryPremiumProduct();
      }
    } catch (_) {
      product = null;
    }
    if (!mounted) return;
    setState(() {
      _product = product;
      _loadingProduct = false;
    });
  }

  Future<void> _buy(AppLocalizations l10n) async {
    final billing = ref.read(billingServiceProvider);
    setState(() => _purchasing = true);
    try {
      final product = _product;
      if (product == null) {
        _showSnack(l10n.paywallStoreUnavailable);
        return;
      }
      await billing.buyPremium(product);
    } catch (_) {
      if (mounted) _showSnack(l10n.paywallPurchaseError);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore(AppLocalizations l10n) async {
    final billing = ref.read(billingServiceProvider);
    setState(() => _restoring = true);
    try {
      await billing.restorePurchases();
    } catch (_) {
      if (mounted) _showSnack(l10n.paywallPurchaseError);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;

    ref.listen(premiumUnlockedProvider, (previous, next) {
      final wasUnlocked = previous?.value ?? false;
      final isUnlocked = next.value ?? false;
      if (!wasUnlocked && isUnlocked && context.mounted) {
        _showSnack(l10n.paywallAlreadyUnlocked);
        context.pop();
      }
    });

    final price = _product?.price ?? l10n.paywallDefaultPrice;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            Center(
              child: Container(
                width: 84,
                height: 84,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(24)),
                alignment: Alignment.center,
                child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFF7A5C0A), size: 44),
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.paywallTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              l10n.paywallSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  _FeatureRow(icon: Icons.groups_rounded, text: l10n.paywallFeatureGroups),
                  _FeatureRow(icon: Icons.history_rounded, text: l10n.paywallFeatureHistory),
                  _FeatureRow(icon: Icons.picture_as_pdf_rounded, text: l10n.paywallFeatureExport),
                  _FeatureRow(icon: Icons.insights_rounded, text: l10n.paywallFeatureCharts),
                  _FeatureRow(icon: Icons.cloud_sync_rounded, text: l10n.paywallFeatureDrive),
                  _FeatureRow(icon: Icons.repeat_rounded, text: l10n.paywallFeatureRecurring, showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (premium)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.teal600),
                    const SizedBox(width: 8),
                    Text(l10n.paywallAlreadyUnlocked, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_purchasing || _loadingProduct) ? null : () => _buy(l10n),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.honey500,
                    foregroundColor: const Color(0xFF3D2C05),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800),
                  ),
                  child: _purchasing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.paywallUnlockButton(price)),
                ),
              ),
            const SizedBox(height: 14),
            Center(
              child: Column(
                children: [
                  Text(l10n.paywallOneTimeNote, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: _restoring ? null : () => _restore(l10n),
                    child: _restoring
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(l10n.paywallRestorePurchase),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text, this.showDivider = true});

  final IconData icon;
  final String text;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary),
          title: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
