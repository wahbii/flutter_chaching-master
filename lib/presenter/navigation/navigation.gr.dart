// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'navigation.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CartScreen(),
      );
    },
    CommadesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommadesScreen(),
      );
    },
    CommandeManagmentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommandeManagmentScreen(),
      );
    },
    GiveAwayMnRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GiveAwayMnPage(),
      );
    },
    ItemsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ItemsPage(),
      );
    },
    MainAdminRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MainAdminScreen(),
      );
    },
    MenuHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MenuHomeScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingPage(),
      );
    },
    PokemonInfoRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PokemonInfoRouteArgs>(
          orElse: () => PokemonInfoRouteArgs(id: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PokemonInfoPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ProductDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductDetailRouteArgs>(
          orElse: () => ProductDetailRouteArgs(
                id: pathParams.getString('id'),
                idTombola: pathParams.getString('id_tombola'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductDetailPage(
          id: args.id,
          idTombola: args.idTombola,
        ),
      );
    },
    ProductListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductListRouteArgs>(
          orElse: () =>
              ProductListRouteArgs(idGiveAway: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductListPage(idGiveAway: args.idGiveAway),
      );
    },
    ProductsMnRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductsMnPage(),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SettingScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      final args = routeData.argsAs<SignInRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignInScreen(
          key: args.key,
          from: args.from,
          idgiveAway: args.idgiveAway,
        ),
      );
    },
    SignUpRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SignUpRouteArgs>(
          orElse: () => SignUpRouteArgs(from: pathParams.getString('from')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignUpScreen(
          key: args.key,
          from: args.from,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TypeEffectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TypeEffectPage(),
      );
    },
    UserManagmentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserManagmentScreen(),
      );
    },
    WinnerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WinnerRouteArgs>(
          orElse: () => WinnerRouteArgs(
                jetons: pathParams.optString('jetons'),
                idVideo: pathParams.optString('idvideo'),
              ));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WinnerScreen(
          jetons: args.jetons,
          idVideo: args.idVideo,
        ),
      );
    },
  };
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CommadesScreen]
class CommadesRoute extends PageRouteInfo<void> {
  const CommadesRoute({List<PageRouteInfo>? children})
      : super(
          CommadesRoute.name,
          initialChildren: children,
        );

  static const String name = 'CommadesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CommandeManagmentScreen]
class CommandeManagmentRoute extends PageRouteInfo<void> {
  const CommandeManagmentRoute({List<PageRouteInfo>? children})
      : super(
          CommandeManagmentRoute.name,
          initialChildren: children,
        );

  static const String name = 'CommandeManagmentRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GiveAwayMnPage]
class GiveAwayMnRoute extends PageRouteInfo<void> {
  const GiveAwayMnRoute({List<PageRouteInfo>? children})
      : super(
          GiveAwayMnRoute.name,
          initialChildren: children,
        );

  static const String name = 'GiveAwayMnRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ItemsPage]
class ItemsRoute extends PageRouteInfo<void> {
  const ItemsRoute({List<PageRouteInfo>? children})
      : super(
          ItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ItemsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainAdminScreen]
class MainAdminRoute extends PageRouteInfo<void> {
  const MainAdminRoute({List<PageRouteInfo>? children})
      : super(
          MainAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainAdminRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MenuHomeScreen]
class MenuHomeRoute extends PageRouteInfo<void> {
  const MenuHomeRoute({List<PageRouteInfo>? children})
      : super(
          MenuHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PokemonInfoPage]
class PokemonInfoRoute extends PageRouteInfo<PokemonInfoRouteArgs> {
  PokemonInfoRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          PokemonInfoRoute.name,
          args: PokemonInfoRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'PokemonInfoRoute';

  static const PageInfo<PokemonInfoRouteArgs> page =
      PageInfo<PokemonInfoRouteArgs>(name);
}

class PokemonInfoRouteArgs {
  const PokemonInfoRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'PokemonInfoRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ProductDetailPage]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    required String id,
    required String idTombola,
    List<PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            id: id,
            idTombola: idTombola,
          ),
          rawPathParams: {
            'id': id,
            'id_tombola': idTombola,
          },
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static const PageInfo<ProductDetailRouteArgs> page =
      PageInfo<ProductDetailRouteArgs>(name);
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    required this.id,
    required this.idTombola,
  });

  final String id;

  final String idTombola;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{id: $id, idTombola: $idTombola}';
  }
}

/// generated route for
/// [ProductListPage]
class ProductListRoute extends PageRouteInfo<ProductListRouteArgs> {
  ProductListRoute({
    required String idGiveAway,
    List<PageRouteInfo>? children,
  }) : super(
          ProductListRoute.name,
          args: ProductListRouteArgs(idGiveAway: idGiveAway),
          rawPathParams: {'id': idGiveAway},
          initialChildren: children,
        );

  static const String name = 'ProductListRoute';

  static const PageInfo<ProductListRouteArgs> page =
      PageInfo<ProductListRouteArgs>(name);
}

class ProductListRouteArgs {
  const ProductListRouteArgs({required this.idGiveAway});

  final String idGiveAway;

  @override
  String toString() {
    return 'ProductListRouteArgs{idGiveAway: $idGiveAway}';
  }
}

/// generated route for
/// [ProductsMnPage]
class ProductsMnRoute extends PageRouteInfo<void> {
  const ProductsMnRoute({List<PageRouteInfo>? children})
      : super(
          ProductsMnRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsMnRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingScreen]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<SignInRouteArgs> {
  SignInRoute({
    Key? key,
    required String from,
    required String? idgiveAway,
    List<PageRouteInfo>? children,
  }) : super(
          SignInRoute.name,
          args: SignInRouteArgs(
            key: key,
            from: from,
            idgiveAway: idgiveAway,
          ),
          rawPathParams: {'from': from},
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const PageInfo<SignInRouteArgs> page = PageInfo<SignInRouteArgs>(name);
}

class SignInRouteArgs {
  const SignInRouteArgs({
    this.key,
    required this.from,
    required this.idgiveAway,
  });

  final Key? key;

  final String from;

  final String? idgiveAway;

  @override
  String toString() {
    return 'SignInRouteArgs{key: $key, from: $from, idgiveAway: $idgiveAway}';
  }
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    Key? key,
    required String from,
    List<PageRouteInfo>? children,
  }) : super(
          SignUpRoute.name,
          args: SignUpRouteArgs(
            key: key,
            from: from,
          ),
          rawPathParams: {'from': from},
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<SignUpRouteArgs> page = PageInfo<SignUpRouteArgs>(name);
}

class SignUpRouteArgs {
  const SignUpRouteArgs({
    this.key,
    required this.from,
  });

  final Key? key;

  final String from;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, from: $from}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TypeEffectPage]
class TypeEffectRoute extends PageRouteInfo<void> {
  const TypeEffectRoute({List<PageRouteInfo>? children})
      : super(
          TypeEffectRoute.name,
          initialChildren: children,
        );

  static const String name = 'TypeEffectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserManagmentScreen]
class UserManagmentRoute extends PageRouteInfo<void> {
  const UserManagmentRoute({List<PageRouteInfo>? children})
      : super(
          UserManagmentRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserManagmentRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WinnerScreen]
class WinnerRoute extends PageRouteInfo<WinnerRouteArgs> {
  WinnerRoute({
    required String? jetons,
    required String? idVideo,
    List<PageRouteInfo>? children,
  }) : super(
          WinnerRoute.name,
          args: WinnerRouteArgs(
            jetons: jetons,
            idVideo: idVideo,
          ),
          rawPathParams: {
            'jetons': jetons,
            'idvideo': idVideo,
          },
          initialChildren: children,
        );

  static const String name = 'WinnerRoute';

  static const PageInfo<WinnerRouteArgs> page = PageInfo<WinnerRouteArgs>(name);
}

class WinnerRouteArgs {
  const WinnerRouteArgs({
    required this.jetons,
    required this.idVideo,
  });

  final String? jetons;

  final String? idVideo;

  @override
  String toString() {
    return 'WinnerRouteArgs{jetons: $jetons, idVideo: $idVideo}';
  }
}
