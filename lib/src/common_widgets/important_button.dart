import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/constants/app_sizes.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class ImportantButton extends StatefulWidget {
  const ImportantButton({
    required this.color,
    required this.text,
    required this.onPressed,
    super.key,
  });
  final String text;
  final Color color;
  final VoidCallback? onPressed;

  @override
  State<ImportantButton> createState() => _ImportantButtonState();
}

class _ImportantButtonState extends State<ImportantButton> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.p20),
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (event) {
          if (widget.onPressed != null) {
            setState(() {
              isHover = true;
            });
          }
        },
        onExit: (event) {
          if (widget.onPressed != null) {
            setState(() {
              isHover = false;
            });
          }
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p20)),
            color: isHover ? widget.color.withAlpha(200) : widget.color,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: Sizes.p24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
