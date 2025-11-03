import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class BackArrow extends StatefulWidget {
  const BackArrow({super.key});

  @override
  State<BackArrow> createState() => _BackArrowState();
}

class _BackArrowState extends State<BackArrow> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {},
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHover = false;
            });
          },
          child: CircleAvatar(
            backgroundColor: isHover
                ? AppColors.thirdColor
                : AppColors.secondeColor,
            radius: 30.0,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.iconColor,
              size: 45.0,
            ),
          ),
        ),
      ),
    );
  }
}
