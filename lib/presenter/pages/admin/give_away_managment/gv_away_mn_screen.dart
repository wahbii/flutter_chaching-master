import 'dart:convert';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/data/entities/giveaway.dart';
import 'package:pokedex/data/states/providers/giveAwayBloc.dart';
import 'package:pokedex/presenter/pages/admin/give_away_managment/widget/dialog_edit_giveaway.dart';
import 'package:pokedex/presenter/pages/admin/give_away_managment/widget/fabMenu.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../data/usecases/giveaway/crud_giveaway_use_case.dart';
import '../../../../utils/size.dart';
import '../../../themes/colors.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/scaffold.dart';

@RoutePage()
class GiveAwayMnPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GiveAwayMnState();
  }
}

class _GiveAwayMnState extends State<GiveAwayMnPage> {
  GiveAwayBloc get giveAwayBloc => context.read<GiveAwayBloc>();
  List<GiveAway> giveawaystList = [];
  List<bool> isExpended = [];
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    giveAwayBloc.add(LoadGiveAwayEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
        body: Stack(children: [
      NestedScrollView(
        headerSliverBuilder: (_, __) => [
          AppMovingTitleSliverAppBar(title: 'Give Aways'),
        ],
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: MultiBlocListener(
            listeners: [
              BlocListener<GiveAwayBloc, GiveAwayState>(
                listener: (context, state) {
                  if (state is GiveAwayLoadingState) {
                    setState(() {
                      showLoader = true;
                    });
                  } else if (state is GiveAwayLoadedState) {
                    setState(() {
                      giveawaystList = state.data;
                      showLoader = false;
                    });
                  } else if (state is CrudGiveAwayState) {
                    giveAwayBloc.add(LoadGiveAwayEvent());
                  } else if (state is GiveAwayErrorState) {
                    setState(() {
                      showLoader = false;
                    });
                    print("error : ${state.error}");
                  }
                },
              ),
            ],
            child: Stack(children: [
              _buildItem(),
              showLoader
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox()
            ]),
          ),
        ),
      ),
      FabMenu(
        onSearch: (value) {},
        onSubmit: () {
          giveAwayBloc.add(LoadGiveAwayEvent());
        },
        destination: AdminScreen.MNGIVEAWAY,
      )
    ]));
  }

  Widget _buildItem() {
    return _bodyWigetItemList(giveawaystList);
  }

  Widget _expandedItem(GiveAway product) {
    return InkWell(
        onTap: () {},
        key: ValueKey('expandedItem_${product.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: Image.memory(base64Decode(product.img),
                            width: 100,
                            fit: BoxFit.cover,
                            gaplessPlayback: true)),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: getFullHeight(context) * 0.08,
                      width: getFullWigth(context) * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.titleEng,
                              style: context.typographies.bodySmall),
                          Text("Participant  : ${product.commandesId.length}",
                              style: context.typographies.bodySmall),
                          (product.dateRest
                                  .toDate()
                                  .difference(DateTime.now())
                                  .isNegative)
                              ? InkWell(
                                  onTap: () {
                                    var name =
                                        product.titleEng.replaceAll(' ', '');
                                    downloadListAsTxt(product.commandesId, name,context);
                                  },
                                  child: Text(
                                    "Get participant",
                                    style: context.typographies.body
                                        .withColor(AppColors.lightGreen)
                                        .withWeight(FontWeight.w500)
                                        .withSize(14),
                                  ))
                              : SlideCountdown(
                                  duration: Duration(
                                    days: product.dateRest
                                        .toDate()
                                        .difference(DateTime.now())
                                        .inDays,
                                    hours: product.dateRest
                                        .toDate()
                                        .difference(DateTime.now())
                                        .inHours,
                                    minutes: product.dateRest
                                        .toDate()
                                        .difference(DateTime.now())
                                        .inMinutes,
                                    seconds: product.dateRest
                                        .toDate()
                                        .difference(DateTime.now())
                                        .inSeconds,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: getFullHeight(context) * 0.1,
                        width: getFullWigth(context) * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  // Set the background color of the container
                                  borderRadius: BorderRadius.circular(
                                      20), // Set the radius of the corners
                                ),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => EditGiveAwayDialog(
                                          product: product,
                                          onsubmit: () {
                                            giveAwayBloc
                                                .add(LoadGiveAwayEvent());
                                          },
                                        ));
                              },
                            ),
                            InkWell(
                              onTap: () {
                                giveAwayBloc.add(CrudGiveAwayEvent(ArgGiveAway(
                                    action: ApiActions.DELETE,
                                    giveAway: product)));
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  // Set the background color of the container
                                  borderRadius: BorderRadius.circular(
                                      20), // Set the radius of the corners
                                ),
                                child: const Center(
                                  child: Text(
                                    'delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _bodyWigetItemList(List<GiveAway> products) {
    return ListView.builder(
      shrinkWrap: true, // Added this line
      physics: const NeverScrollableScrollPhysics(), // Added this line
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _expandedItem(products[index]),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: getFullWigth(context) * 0.8,
              height: 1,
              color: AppColors.paarl_lite,
            )
          ],
        );
      },
    );
  }
}
Future<void> downloadListAsTxt(List<String> strings,String name, BuildContext context) async {
  try {
    // Convert the list of strings to a single text string
    String textContent = strings.join('\n');

    // Get the documents directory
    final Directory? docDir = await getExternalStorageDirectory();

    // Define the file path for the text file
    final String txtPath = '${docDir?.path}/$name.txt';

    // Create the text file
    File txtFile = File(txtPath);
    await txtFile.writeAsString(textContent);

    // Show a dialog with download options
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Text File Created'),
          content: Text('Text file saved to Downloads folder.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Open the file using a file viewer
                OpenFile.open(txtPath);
              },
              child: Text('Open Text File'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}

