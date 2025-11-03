import 'package:go_router/go_router.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_creation/room_creation_screen.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_detail/room_detail_screen.dart';
import 'package:portes_ouvertes/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:portes_ouvertes/src/features/user/presentation/user_login/user_login_screen.dart';

enum RouteNames { home, details, creation, user }

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home.name,
      builder: (context, state) => const RoomListScreen(),
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
        GoRoute(
          path: '/user',
          name: RouteNames.user.name,
          builder: (context, state) => const UserLoginScreen(),
        ),
      ],
    ),
  ],
);
