import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/usecases/giveaway/crud_cat_giveaway_usecase.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../../data/entities/product.dart';
import '../../../../../data/states/providers/giveAwayBloc.dart';

class DialogEditCatGiveAway extends StatefulWidget {
  final CatGiveAway? catGiveAway;
  final Function() onsubmit;



  DialogEditCatGiveAway({required this.onsubmit, required this.catGiveAway});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RoundedDialogState();
  }
}

class RoundedDialogState extends State<DialogEditCatGiveAway> {
  final TextEditingController nameEngController = TextEditingController();
  final TextEditingController nameFrController = TextEditingController();

  final TextEditingController nameArController = TextEditingController();

  bool showLoader = false ;

  GiveAwayBloc get giveAwayBloc => context.read<GiveAwayBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEngController.text = widget.catGiveAway?.titleEng ?? "";
    nameArController.text = widget.catGiveAway?.titleAr ?? "";

    nameFrController.text = widget.catGiveAway?.titleFr ?? "";


  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: MultiBlocListener(
          listeners: [
            BlocListener<GiveAwayBloc, GiveAwayState>(
              listener: (context, state) {
                if (state is GiveAwayLoadingState) {
                    setState(() {
                      showLoader = true;
                    });
                } else if (state is CrudGiveAwayCatState) {
                  setState(() {
                    showLoader = false;
                  });
                  Navigator.of(context).pop();
                  widget.onsubmit.call();
                }else if (state is GiveAwayErrorState) {
                  setState(() {
                    showLoader = false;
                  });
                }
              },
            ),
          ],
          child: contentBox(context),
        ));
  }

  Widget contentBox(BuildContext context) {
    return
      Container(
        height: getFullHeight(context) * 0.45,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child:Stack(children: [ Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameEngController,
                decoration: const InputDecoration(
                  labelText: 'NameEng',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameFrController,
                decoration: const InputDecoration(
                  labelText: 'NameFr',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameArController,
                decoration: const InputDecoration(
                  labelText: 'NameAr',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                giveAwayBloc.add(CrudGiveAwayCatEvent(argCatGiveAway: ArgCatGiveAway(
                  action: widget.catGiveAway !=null ? ApiActions.UPDATE  : ApiActions.ADD,
                  catGiveAway: CatGiveAway(

                    id: widget.catGiveAway?.id??"" ,
                    titleFr: nameFrController.text,
                    titleAr: nameArController.text,
                    titleEng: nameEngController.text
                  )
                )));
              },
              child: Text('Submit'),
            ),
          ],
        ),Visibility(
            visible: showLoader,
            child: const Center(child: CircularProgressIndicator(),))
        ]
      ),
     );
  }
}
