import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex/presenter/pages/items/items.dart';
import 'package:pokedex/presenter/pages/menuHome/menu_home.dart';
import 'package:pokedex/presenter/pages/pokemon_info/pokemon_info.dart';
import 'package:pokedex/presenter/pages/productList/product_list.dart';
import 'package:pokedex/presenter/pages/splash/splash.dart';
import 'package:pokedex/presenter/pages/types/types.dart';

import '../pages/admin/commande_managment/CommandeManagment.dart';
import '../pages/admin/give_away_managment/gv_away_mn_screen.dart';
import '../pages/admin/home_admin.dart';
import '../pages/admin/product_management/product_mn_screen.dart';
import '../pages/admin/user_management/users_management.dart';
import '../pages/cart/cart_screen.dart';
import '../pages/commandes/commandes_page.dart';
import '../pages/detail_product/product_detail.dart';
import '../pages/onboarding/onboearding.dart';
import '../pages/settings/setting_page.dart';
import '../pages/sign_in/sign_in_screen.dart';
import '../pages/sign_up/sign_up_screen.dart';
import '../pages/winner/winner_screnn.dart';

part 'navigation.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: SplashRoute.page),
        AutoRoute(path: '/onboarding', page: OnboardingRoute.page),
        AutoRoute(path: "/signin/:from", page: SignInRoute.page),
        AutoRoute(path: "/signup/:from", page: SignUpRoute.page),
        AutoRoute(path: '/products/:id', page: ProductListRoute.page),
        AutoRoute(path: "/detailProduct/:id", page: ProductDetailRoute.page),
        AutoRoute(
            path: '/pokemons/:id/:id_tombola', page: PokemonInfoRoute.page),
        AutoRoute(path: '/types', page: TypeEffectRoute.page),
        AutoRoute(path: '/items', page: ItemsRoute.page),
        AutoRoute(path: '/cart', page: CartRoute.page),
        AutoRoute(path: '/admin', page: MainAdminRoute.page),
        AutoRoute(path: '/admin/users', page: UserManagmentRoute.page),
        AutoRoute(path: '/admin/products', page: ProductsMnRoute.page),
        AutoRoute(path: '/admin/giveaways', page: GiveAwayMnRoute.page),
        AutoRoute(path: '/settings', page: SettingRoute.page),
        AutoRoute(path: '/commandes', page: CommadesRoute.page),
        AutoRoute(path: '/commandesMn', page: CommandeManagmentRoute.page),
        AutoRoute(path: '/MenuHome', page: MenuHomeRoute.page),
        AutoRoute(path: '/winner/:idvideo/:jetons', page: WinnerRoute.page),
      ];

  @override
  RouteType get defaultRouteType => const RouteType.custom(
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
}
