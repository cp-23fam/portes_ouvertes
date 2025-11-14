import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portes_ouvertes/firebase_options.dart';
import 'package:portes_ouvertes/src/app.dart';
import 'package:portes_ouvertes/src/features/user/data/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  if (const String.fromEnvironment('USER').isNotEmpty) {
    const user = String.fromEnvironment('USER');

    try {
      final usc = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'user-$user@ceff.ch',
        password: 'Pa\$\$w0rd',
      );

      await UserRepository().createUser(usc.user!.uid, 'User-$user');
    } on FirebaseAuthException {
      //
    }

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'user-$user@ceff.ch',
      password: 'Pa\$\$w0rd',
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}
