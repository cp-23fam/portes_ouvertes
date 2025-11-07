import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/features/game/presentation/game_screen.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_creation/room_creation_screen.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/room_detail_screen.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_create/user_creation_screen.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_login/user_login_screen.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_settings/user_settings_screen.dart';

enum RouteNames { home, details, creation, login, signup, user, game }

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home.name,
      builder: (context, state) =>
          const RoomListScreen(), //GameScreen(gameId: 'abcd'),
      routes: [
        GoRoute(
          path: '/details/:id',
          name: RouteNames.details.name,
          builder: (context, state) =>
              RoomDetailScreen(roomId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/create',
          name: RouteNames.creation.name,
          builder: (context, state) => const RoomCreationScreen(),
        ),
        // GoRoute(
        //   path: '/login',
        //   name: RouteNames.login.name,
        //   builder: (context, state) => const UserLoginScreen(),
        // ),
        GoRoute(
          path: '/signup',
          name: RouteNames.signup.name,
          builder: (context, state) => const UserCreationScreen(),
        ),
        GoRoute(
          path: '/user',
          name: RouteNames.user.name,
          builder: (context, state) => FirebaseAuth.instance.currentUser == null
              ? const UserLoginScreen()
              : const UserSettingsScreen(),
        ),
        GoRoute(
          path: '/game/:id',
          name: RouteNames.game.name,
          builder: (context, state) => GameScreen(gameId: 'abcd'),
        ),
      ],
    ),
  ],
);
