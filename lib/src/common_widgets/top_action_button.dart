import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class TopActionButton extends StatefulWidget {
  const TopActionButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  State<TopActionButton> createState() => _TopActionButtonState();
}

class _TopActionButtonState extends State<TopActionButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: CircleAvatar(
        backgroundColor: isHovered
            ? AppColors.thirdColor
            : AppColors.secondColor,
        radius: 30.0,
        child: IconButton(
          icon: Icon(widget.icon, color: AppColors.iconColor, size: 35.0),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
