import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Mirrors the `.card` component: panel background, border, 16px radius.
class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;

  const SbCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// Mirrors `.avatar` — circular initials badge.
class SbAvatar extends StatelessWidget {
  final String initials;
  final double size;
  const SbAvatar({super.key, required this.initials, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.panel3, AppColors.panel2],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.34,
        ),
      ),
    );
  }
}

/// Mirrors `.tag` pills used for status labels.
class SbTag extends StatelessWidget {
  final String label;
  final bool secondary;
  const SbTag(this.label, {super.key, this.secondary = false});

  @override
  Widget build(BuildContext context) {
    final fg = secondary ? AppColors.secondaryLight : AppColors.primaryLight;
    final bg = secondary ? AppColors.secondarySoft : AppColors.primarySoft;
    final border = secondary ? AppColors.secondary : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border.withValues(alpha: 0.35)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Mirrors `.chip` used in filter rows.
class SbChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const SbChip(this.label, {super.key, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primarySoft : AppColors.panel2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.primaryLight : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

/// Mirrors `.field` — labeled row used for pickup/destination/date fields.
class SbField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  const SbField({super.key, required this.label, required this.value, this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.muted2,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mirrors `.icon-btn` — round icon button on a panel background.
class SbIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  const SbIconButton({super.key, required this.icon, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.panel2,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 18, color: color ?? AppColors.text),
        ),
      ),
    );
  }
}

/// Mirrors `.map-placeholder` — grid-lined dark panel standing in for a map.
class SbMapPlaceholder extends StatelessWidget {
  final double height;
  final Widget? child;
  const SbMapPlaceholder({super.key, required this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFF101312)),
          CustomPaint(painter: _GridPainter()),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1E1B)
      ..strokeWidth = 1;
    const step = 34.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Full-width primary button, mirrors `.btn.btn-orange.btn-block`.
class SbPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const SbPrimaryButton({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 17), const SizedBox(width: 8)],
            Text(label),
          ],
        ),
      ),
    );
  }
}

/// Full-width outline button, mirrors `.btn.btn-outline.btn-block`.
class SbOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool block;
  const SbOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.block = true,
  });

  @override
  Widget build(BuildContext context) {
    final btn = OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 15), const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
    return block ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

/// One entry in the bottom navigation bar, mirrors `.bn-item`.
class SbNavItem {
  final IconData icon;
  final String label;
  const SbNavItem(this.icon, this.label);
}

/// Mirrors `.bottom-nav` — 4-item bottom bar with an active state.
class SbBottomNav extends StatelessWidget {
  final List<SbNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onTap;
  const SbBottomNav({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xF0121513),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == activeIndex;
          final item = items[i];
          return InkWell(
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 20,
                    color: active ? AppColors.primary : AppColors.muted2),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: active ? AppColors.primary : AppColors.muted2,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// A small uppercase eyebrow/section label, mirrors `.eyebrow`.
class SbEyebrow extends StatelessWidget {
  final String text;
  const SbEyebrow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
