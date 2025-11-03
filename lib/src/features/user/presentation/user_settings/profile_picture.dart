import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          backgroundColor: !isHover
              ? AppColors.secondeColor
              : AppColors.thirdColor,
          radius: 80.0,
          child: Icon(
            !isHover ? Icons.person_outline : Icons.edit,
            color: AppColors.iconColor,
            size: !isHover ? 120.0 : 80.0,
          ),
        ),
      ),
    );
  }
}
