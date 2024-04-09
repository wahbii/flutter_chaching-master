import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/usecases/giveaway/crud_cat_giveaway_usecase.dart';
import 'package:pokedex/data/usecases/products/crud_cat_product_usecase.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../../data/entities/product.dart';
import '../../../../../data/states/providers/giveAwayBloc.dart';
import '../../../../../data/states/providers/product_cat_bloc.dart';

class DialogEditCatProduct extends StatefulWidget {
  final ProductCat? productCat;
  final Function() onsubmit;



  DialogEditCatProduct ({required this.onsubmit, required this.productCat});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RoundedDialogState();
  }
}

class RoundedDialogState extends State<DialogEditCatProduct > {
  final TextEditingController nameEngController = TextEditingController();
  final TextEditingController nameFrController = TextEditingController();
  final TextEditingController nameArController = TextEditingController();
  bool showLoader = false ;

  ProductCatBloc get productCatBloc => context.read<ProductCatBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEngController.text = widget.productCat?.titleEng ?? "";
    nameArController.text = widget.productCat?.titleAr ?? "";
    nameFrController.text = widget.productCat?.titleFr?? "";

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
            BlocListener<ProductCatBloc, ProductCatState>(
              listener: (context, state) {
                if (state is ProductCatLoadingState) {
                    setState(() {
                      showLoader = true;
                    });
                } else if (state is CrudProductCatLoadedState) {
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
                print(widget.productCat!=null);
                productCatBloc.add(CrudProductCatEvent(argCatProduct: ArgCatProduct(
                  actions: widget.productCat !=null ? ApiActions.UPDATE  : ApiActions.ADD,
                  productCat: ProductCat(
                      id: widget.productCat?.id??"" ,
                     titleEng: nameEngController.text,
                      titleAr: nameArController.text,
                      titleFr: nameFrController.text
                      , isSlected: false)
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
