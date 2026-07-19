import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../domain/models/meal_slot.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

String resolveSlotName(AppLocalizations l10n, String? defaultKey, String fallback) {
  switch (defaultKey) {
    case 'breakfast':
      return l10n.mealSlotBreakfast;
    case 'lunch':
      return l10n.mealSlotLunch;
    case 'dinner':
      return l10n.mealSlotDinner;
    default:
      return fallback;
  }
}

class MealSlotsScreen extends ConsumerWidget {
  const MealSlotsScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    final slots = ref.watch(slotsOfSelectedGroupProvider);
    final canManage = ref.watch(canProvider(MemberPermission.mealsManage));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.mealSlotsTitle),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: slots.when(
        data: (rows) => rows.isEmpty
            ? EmptyState(icon: Icons.restaurant_rounded, title: l10n.mealSlotEmpty)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                itemBuilder: (context, i) => _SlotTile(slot: rows[i], l10n: l10n, canManage: canManage),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorPrefix(e.toString()))),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSlotSheet(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.mealSlotAdd),
            )
          : null,
    );
  }

  Future<void> _showAddSlotSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SlotEditSheet(groupId: groupId),
    );
  }
}

class _SlotTile extends ConsumerWidget {
  const _SlotTile({required this.slot, required this.l10n, required this.canManage});

  final MealSlot slot;
  final AppLocalizations l10n;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: slot.active ? 1 : 0.5,
        child: ListTile(
          leading: const Icon(Icons.restaurant_rounded),
          title: Text(resolveSlotName(l10n, slot.defaultKey, slot.name), style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${l10n.mealSlotWeight}: ${slot.weight.toStringAsFixed(slot.weight % 1 == 0 ? 0 : 2)}', style: const TextStyle(fontSize: 12)),
          trailing: canManage
              ? PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') {
                      showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => _SlotEditSheet(groupId: slot.groupId, existing: slot));
                    } else if (v == 'toggle') {
                      ref.read(mealSlotsRepositoryProvider).setActive(slot.id, !slot.active);
                      triggerBackgroundSync(ref, slot.groupId);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(l10n.commonEdit)),
                    PopupMenuItem(value: 'toggle', child: Text(slot.active ? l10n.mealSlotDeactivate : l10n.mealSlotReactivate)),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}

class _SlotEditSheet extends ConsumerStatefulWidget {
  const _SlotEditSheet({required this.groupId, this.existing});

  final String groupId;
  final MealSlot? existing;

  @override
  ConsumerState<_SlotEditSheet> createState() => _SlotEditSheetState();
}

class _SlotEditSheetState extends ConsumerState<_SlotEditSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late final _weightController = TextEditingController(text: widget.existing?.weight.toString() ?? '1');
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final weight = double.tryParse(_weightController.text.trim()) ?? 1;
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(mealSlotsRepositoryProvider);
    if (widget.existing != null) {
      await repo.updateSlot(widget.existing!.copyWith(name: name, weight: weight));
    } else {
      await repo.addSlot(groupId: widget.groupId, name: name, weight: weight);
    }
    triggerBackgroundSync(ref, widget.groupId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.existing != null ? l10n.commonEdit : l10n.mealSlotAdd, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.mealSlotName)),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            decoration: InputDecoration(labelText: l10n.mealSlotWeight, hintText: l10n.mealSlotWeightHint),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
