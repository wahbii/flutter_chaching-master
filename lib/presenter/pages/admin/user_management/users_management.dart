import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/states/providers/user_bloc.dart';
import 'package:pokedex/data/usecases/user/update_user_usecase.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../data/entities/user_data.dart';
import '../../../themes/colors.dart';
import '../../../widgets/app_bar.dart';

@RoutePage()
class UserManagmentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserManagmentState();
  }
}

class _UserManagmentState extends State<UserManagmentScreen> {
  List<UserData> data = [];

  UserBloc get userbloc => context.read<UserBloc>();

  List<bool> showPassword = [];
  bool showLoader = true ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userbloc.add(LoadUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PokeballScaffold(
        body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
                  AppMovingTitleSliverAppBar(title: 'Users'),
                ],
            body: MultiBlocListener(
              listeners: [
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) async {

                    if (state is LoadUsersState) {
                      setState(() {
                        data = state.userdata;
                        showLoader = false ;
                      });

                    } else if (state is DeleteUserEvent) {
                      userbloc.add(LoadUsersEvent());
                    } else if (state is UpdateUserState) {
                      setState(() {
                        data = [];
                        showLoader = true;
                      });
                      userbloc.add(LoadUsersEvent());
                    } else if (state is AddUserErrorState) {
                        setState(() {
                          showLoader = false;
                        });
                        print("error ${state.error}");
                    }
                  },
                ),
              ],
              child: Container(
                  child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: AppBar(
                          leading: null,
                          automaticallyImplyLeading: false,
                          toolbarHeight:20,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          bottom: TabBar(
                              unselectedLabelColor: Colors.redAccent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.redAccent,
                                    Colors.orangeAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.redAccent),
                              tabs: [
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Admin"),
                                  ),
                                ),
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Other"),
                                  ),
                                ),
                              ]),
                        ),
                        body: showLoader ? Center(child: CircularProgressIndicator(),):TabBarView(children: [
                          ListView.builder(
                              itemCount: data
                                  .where((element) => element.isAdmin)
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                showPassword.add(false);
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 4),
                                    child: _UserCard(
                                        data
                                            .where((element) => element.isAdmin)
                                            .toList()[index],
                                        index));
                              }),
                          ListView.builder(
                              itemCount: data
                                  .where((element) => !element.isAdmin)
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                showPassword.add(false);
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 4),
                                    child: _UserCard(
                                        data
                                            .where(
                                                (element) => !element.isAdmin)
                                            .toList()[index],
                                        index));
                              }),
                        ]),
                      ))),
            )));
  }

  Widget _UserCard(UserData userData, int index) {
    return Container(
      width: getFullHeight(context) * 0.9,
      height: getFullHeight(context) * 0.15,
      child: Card(
        elevation: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mail),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        userData.email,
                        textAlign: TextAlign.start,
                        style: context.typographies.body,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.password),
                      SizedBox(
                        width: 2,
                      ),
                      Text(showPassword[index] ? userData.password : "*****",
                          textAlign: TextAlign.start,
                          style: context.typographies.bodySmall),
                      const SizedBox(
                        width: 2,
                      ),
                      InkWell(
                        child: showPassword[index]
                            ? Icon(Icons.remove_red_eye)
                            : Icon(Icons.remove_red_eye_outlined),
                        onTap: () {
                          setState(() {
                            showPassword[index] = !showPassword[index];
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("IsAdmin",
                          textAlign: TextAlign.start,
                          style: context.typographies.bodySmall),
                      SizedBox(
                        width: 2,
                      ),
                      Checkbox(value: userData.isAdmin, onChanged: (value) {
                        setState(() {
                          showLoader = true;
                        });
                        userbloc.add(UpdateUserEvent(user: UserUpdated(userData: userData,isAdmin: value,password: null,email: null),action: ApiActions.UPDATE ));
                      })
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: AppColors.white,
                          ),
                          Text("Delete",
                              textAlign: TextAlign.start,
                              style: context.typographies.body
                                  .withColor(AppColors.white)),
                        ],
                      )),onTap: (){
                    setState(() {
                      showLoader = true ;

                    });
                    userbloc.add(UpdateUserEvent(user: UserUpdated(userData: userData,isAdmin: null,password: null,email: null),action: ApiActions.DELETE ));

                  },)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
