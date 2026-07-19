import 'package:flutter/material.dart';

/// Maps the icon name strings stored in the `categories` table to Material icons.
/// Extend as new categories/icons are introduced in later milestones.
const _icons = <String, IconData>{
  'shopping_basket': Icons.shopping_basket_rounded,
  'home': Icons.home_rounded,
  'bolt': Icons.bolt_rounded,
  'wifi': Icons.wifi_rounded,
  'cleaning_services': Icons.cleaning_services_rounded,
  'propane_tank': Icons.propane_tank_rounded,
  'build': Icons.build_rounded,
  'category': Icons.category_rounded,
};

IconData lookupIcon(String name) => _icons[name] ?? Icons.category_rounded;
