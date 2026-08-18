import 'package:flutter/material.dart';

/// Placeholder sem dependência de assets, pronto para substituição futura.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 64});
  final double size;
  @override Widget build(BuildContext context) => Icon(Icons.local_gas_station_rounded, size: size, color: Theme.of(context).colorScheme.primary);
}
