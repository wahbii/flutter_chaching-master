// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:pokedex/data/repositories/card/card_repo_impl.dart' as _i9;
import 'package:pokedex/data/repositories/card/card_repository.dart' as _i8;
import 'package:pokedex/data/repositories/commande/comande_reposirory_impl.dart'
    as _i25;
import 'package:pokedex/data/repositories/commande/commande_repository.dart'
    as _i24;
import 'package:pokedex/data/repositories/giveAway/catGiveAwayRepository.dart'
    as _i14;
import 'package:pokedex/data/repositories/giveAway/catGiveAwayRepositoryImpl.dart'
    as _i15;
import 'package:pokedex/data/repositories/giveAway/giveawayRepository.dart'
    as _i17;
import 'package:pokedex/data/repositories/giveAway/giveawayRepositoryImpl.dart'
    as _i18;
import 'package:pokedex/data/repositories/item_repository.dart' as _i49;
import 'package:pokedex/data/repositories/item_repository.default.dart' as _i50;
import 'package:pokedex/data/repositories/pokemon_repository.dart' as _i46;
import 'package:pokedex/data/repositories/pokemon_repository.default.dart'
    as _i47;
import 'package:pokedex/data/repositories/product/productcarreposirory.dart'
    as _i6;
import 'package:pokedex/data/repositories/product/productcatrepositoryimpl.dart'
    as _i7;
import 'package:pokedex/data/repositories/product/productrepository.dart'
    as _i12;
import 'package:pokedex/data/repositories/product/ProductRepositoryImpl.dart'
    as _i13;
import 'package:pokedex/data/repositories/usernamangment/register_repository.dart'
    as _i26;
import 'package:pokedex/data/repositories/usernamangment/register_repository_impl.dart'
    as _i27;
import 'package:pokedex/data/repositories/usernamangment/user_data_repository.dart'
    as _i22;
import 'package:pokedex/data/repositories/usernamangment/user_repository_imp.dart'
    as _i23;
import 'package:pokedex/data/source/github/github_datasource.dart' as _i35;
import 'package:pokedex/data/source/github/network.dart' as _i30;
import 'package:pokedex/data/source/local/local_datasource.dart' as _i3;
import 'package:pokedex/data/states/item/item_bloc.dart' as _i56;
import 'package:pokedex/data/states/pokemon/pokemon_bloc.dart' as _i54;
import 'package:pokedex/data/states/providers/auth_bloc.dart' as _i53;
import 'package:pokedex/data/states/providers/cardManagment/card_bloc.dart'
    as _i32;
import 'package:pokedex/data/states/providers/commande/commande_bloc.dart'
    as _i37;
import 'package:pokedex/data/states/providers/giveAwayBloc.dart' as _i52;
import 'package:pokedex/data/states/providers/homeprovider.dart' as _i51;
import 'package:pokedex/data/states/providers/product_bloc.dart' as _i48;
import 'package:pokedex/data/states/providers/product_cat_bloc.dart' as _i16;
import 'package:pokedex/data/states/providers/user_bloc.dart' as _i45;
import 'package:pokedex/data/states/settings/settings_bloc.dart' as _i4;
import 'package:pokedex/data/usecases/card/add_to_card_usecase.dart' as _i19;
import 'package:pokedex/data/usecases/card/fetch_card_usecase.dart' as _i20;
import 'package:pokedex/data/usecases/card/modify_quantite_use_case.dart'
    as _i21;
import 'package:pokedex/data/usecases/commande/commande_use_case.dart' as _i31;
import 'package:pokedex/data/usecases/giveaway/crud_cat_giveaway_usecase.dart'
    as _i38;
import 'package:pokedex/data/usecases/giveaway/crud_giveaway_use_case.dart'
    as _i28;
import 'package:pokedex/data/usecases/giveaway/getCatgiveawaysUsecase.dart'
    as _i39;
import 'package:pokedex/data/usecases/giveaway/getGiveAwayUseCase.dart' as _i29;
import 'package:pokedex/data/usecases/item_usecases.dart' as _i57;
import 'package:pokedex/data/usecases/pokemon_usecases.dart' as _i55;
import 'package:pokedex/data/usecases/products/crud_cat_product_usecase.dart'
    as _i10;
import 'package:pokedex/data/usecases/products/crud_product_usecase.dart'
    as _i33;
import 'package:pokedex/data/usecases/products/get_product_usecase.dart'
    as _i34;
import 'package:pokedex/data/usecases/products/getproductcatusecase.dart'
    as _i11;
import 'package:pokedex/data/usecases/user/add_user_usecase.dart' as _i42;
import 'package:pokedex/data/usecases/user/get_users_usecase.dart' as _i36;
import 'package:pokedex/data/usecases/user/login_use_caase.dart' as _i40;
import 'package:pokedex/data/usecases/user/register_use_case.dart' as _i41;
import 'package:pokedex/data/usecases/user/remove_user_use_case.dart' as _i43;
import 'package:pokedex/data/usecases/user/update_user_usecase.dart' as _i44;
import 'package:pokedex/di.dart' as _i58;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i3.LocalDataSource>(
      () {
        final i = const _i3.LocalDataSource();
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i4.SettingsBloc>(() => _i4.SettingsBloc());
    gh.singleton<_i5.Dio>(() => registerModule.dio);
    gh.singleton<_i6.ProductCatRepository>(
        () => _i7.ProductCatRepositoryImpl());
    gh.singleton<_i8.CardRepository>(() => _i9.CardRepositoryImpl());
    gh.singleton<_i10.CrudCatProductUseCase>(() => _i10.CrudCatProductUseCase(
        itemRepository: gh<_i6.ProductCatRepository>()));
    gh.singleton<_i11.GetProductcatUsecase>(() => _i11.GetProductcatUsecase(
        itemRepository: gh<_i6.ProductCatRepository>()));
    gh.singleton<_i12.ProductRepository>(() => _i13.ProductRepositoryImpl());
    gh.singleton<_i14.CatGiveAwayRepository>(
        () => _i15.CatGiveAwayRepositoryImpl());
    gh.singleton<_i16.ProductCatBloc>(() => _i16.ProductCatBloc(
          gh<_i11.GetProductcatUsecase>(),
          gh<_i10.CrudCatProductUseCase>(),
        ));
    gh.singleton<_i17.GiveAwayRepository>(() => _i18.GiveAwayRepositoryImpl());
    gh.singleton<_i19.AddToCardUsercase>(
        () => _i19.AddToCardUsercase(cardRepository: gh<_i8.CardRepository>()));
    gh.singleton<_i20.FetchCardUseCase>(
        () => _i20.FetchCardUseCase(cardRepository: gh<_i8.CardRepository>()));
    gh.singleton<_i21.ModifyQuantiteUseCase>(() =>
        _i21.ModifyQuantiteUseCase(cardRepository: gh<_i8.CardRepository>()));
    gh.singleton<_i22.UserDataRepository>(() => _i23.UserRepositoryIml());
    gh.singleton<_i24.CommandeRepository>(() => _i25.CommandeRepositoryImpl());
    gh.singleton<_i26.RegisterRepository>(
        () => _i27.RegisterAndAuthRepositoryImlp());
    gh.singleton<_i28.CrudGiveAwayUseCase>(() => _i28.CrudGiveAwayUseCase(
        itemRepository: gh<_i17.GiveAwayRepository>()));
    gh.singleton<_i29.GetGiveAwayUseCase>(() =>
        _i29.GetGiveAwayUseCase(itemRepository: gh<_i17.GiveAwayRepository>()));
    gh.singleton<_i30.NetworkManager>(
        () => _i30.NetworkManager(dio: gh<_i5.Dio>()));
    gh.singleton<_i31.CommandeAUDUseCase>(() =>
        _i31.CommandeAUDUseCase(itemRepository: gh<_i24.CommandeRepository>()));
    gh.singleton<_i31.CommandeFetchUseCase>(() => _i31.CommandeFetchUseCase(
        itemRepository: gh<_i24.CommandeRepository>()));
    gh.singleton<_i32.CardBloc>(() => _i32.CardBloc(
          addToCardUsercase: gh<_i19.AddToCardUsercase>(),
          modifyQuantiteUseCase: gh<_i21.ModifyQuantiteUseCase>(),
          fetchCardUseCase: gh<_i20.FetchCardUseCase>(),
        ));
    gh.singleton<_i33.CrudProductUseCase>(() =>
        _i33.CrudProductUseCase(itemRepository: gh<_i12.ProductRepository>()));
    gh.singleton<_i34.GetProductUseCase>(() =>
        _i34.GetProductUseCase(itemRepository: gh<_i12.ProductRepository>()));
    gh.singleton<_i35.GithubDataSource>(
        () => _i35.GithubDataSource(networkManager: gh<_i30.NetworkManager>()));
    gh.singleton<_i36.GetUsersUseCase>(() => _i36.GetUsersUseCase(
        userDataRepository: gh<_i22.UserDataRepository>()));
    gh.singleton<_i37.CommandeBloc>(() => _i37.CommandeBloc(
          commandeFetchUseCase: gh<_i31.CommandeFetchUseCase>(),
          commandeAUDUseCase: gh<_i31.CommandeAUDUseCase>(),
        ));
    gh.singleton<_i38.CrudCatGiveAwayUseCase>(() => _i38.CrudCatGiveAwayUseCase(
        itemRepository: gh<_i14.CatGiveAwayRepository>()));
    gh.singleton<_i39.GetCatGiveAwaysUsecase>(() => _i39.GetCatGiveAwaysUsecase(
        itemRepository: gh<_i14.CatGiveAwayRepository>()));
    gh.singleton<_i40.LoginUseCase>(() =>
        _i40.LoginUseCase(registerRepository: gh<_i26.RegisterRepository>()));
    gh.singleton<_i41.RegisterUseCase>(() =>
        _i41.RegisterUseCase(itemRepository: gh<_i26.RegisterRepository>()));
    gh.singleton<_i42.AddUserUseCase>(
        () => _i42.AddUserUseCase(repository: gh<_i22.UserDataRepository>()));
    gh.singleton<_i43.RemoveUserUseCase>(() =>
        _i43.RemoveUserUseCase(repository: gh<_i22.UserDataRepository>()));
    gh.singleton<_i44.UpdateUserUsercase>(() =>
        _i44.UpdateUserUsercase(repository: gh<_i22.UserDataRepository>()));
    gh.singleton<_i45.UserBloc>(() => _i45.UserBloc(
          gh<_i42.AddUserUseCase>(),
          gh<_i36.GetUsersUseCase>(),
          gh<_i44.UpdateUserUsercase>(),
          gh<_i43.RemoveUserUseCase>(),
        ));
    gh.singleton<_i46.PokemonRepository>(() => _i47.PokemonDefaultRepository(
          githubDataSource: gh<_i35.GithubDataSource>(),
          localDataSource: gh<_i3.LocalDataSource>(),
        ));
    gh.singleton<_i48.ProductBloc>(() => _i48.ProductBloc(
          gh<_i34.GetProductUseCase>(),
          gh<_i33.CrudProductUseCase>(),
        ));
    gh.singleton<_i49.ItemRepository>(() => _i50.DefaultItemRepository(
          githubDataSource: gh<_i35.GithubDataSource>(),
          localDataSource: gh<_i3.LocalDataSource>(),
        ));
    gh.singleton<_i51.HomeProvider>(() => _i51.HomeProvider(
          getCatGiveAwaysUsecase: gh<_i39.GetCatGiveAwaysUsecase>(),
          getGiveAwaysUsecase: gh<_i29.GetGiveAwayUseCase>(),
        ));
    gh.singleton<_i52.GiveAwayBloc>(() => _i52.GiveAwayBloc(
          gh<_i29.GetGiveAwayUseCase>(),
          gh<_i39.GetCatGiveAwaysUsecase>(),
          gh<_i28.CrudGiveAwayUseCase>(),
          gh<_i38.CrudCatGiveAwayUseCase>(),
        ));
    gh.singleton<_i53.RegisterBloc>(() => _i53.RegisterBloc(
          gh<_i41.RegisterUseCase>(),
          gh<_i40.LoginUseCase>(),
        ));
    gh.singleton<_i54.PokemonBloc>(() =>
        _i54.PokemonBloc(pokemonRepository: gh<_i46.PokemonRepository>()));
    gh.singleton<_i55.GetAllPokemonsUseCase>(() => _i55.GetAllPokemonsUseCase(
        pokemonRepository: gh<_i46.PokemonRepository>()));
    gh.singleton<_i55.GetPokemonsUseCase>(() => _i55.GetPokemonsUseCase(
        pokemonRepository: gh<_i46.PokemonRepository>()));
    gh.singleton<_i55.GetPokemonUseCase>(() => _i55.GetPokemonUseCase(
        pokemonRepository: gh<_i46.PokemonRepository>()));
    gh.singleton<_i56.ItemBloc>(
        () => _i56.ItemBloc(itemRepository: gh<_i49.ItemRepository>()));
    gh.singleton<_i57.GetItemUseCase>(
        () => _i57.GetItemUseCase(itemRepository: gh<_i49.ItemRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i58.RegisterModule {}
