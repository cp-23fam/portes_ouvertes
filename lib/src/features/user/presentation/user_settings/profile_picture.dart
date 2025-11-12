import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/theme/theme.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    final String imageUrl = FirebaseAuth.instance.currentUser!.photoURL ?? '';

    return CircleAvatar(
      backgroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
      backgroundColor: AppColors.secondColor,
      radius: 80.0,
      child: imageUrl.isEmpty
          ? Icon(Icons.person_outline, color: AppColors.iconColor, size: 95.0)
          : null,
    );
  }
}
