import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(size * .18),
        child: Image.asset(
          'assets/images/wk_app_icon.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      );
}
