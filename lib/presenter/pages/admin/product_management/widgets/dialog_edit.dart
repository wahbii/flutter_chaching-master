import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/usecases/products/crud_product_usecase.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../../data/entities/product.dart';
import '../../../../../data/states/providers/product_bloc.dart';
import '../../../../widgets/modal.dart';

class RoundedDialog extends StatefulWidget {
  final Product? product;
  final Function onSubmit;

  RoundedDialog({required this.product, required this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RoundedDialogState();
  }
}

class RoundedDialogState extends State<RoundedDialog> {
  File? _image;

  ProductBloc get productBloc => context.read<ProductBloc>();

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  final TextEditingController nameEngController = TextEditingController();
  final TextEditingController nameFrController = TextEditingController();
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController descFrController = TextEditingController();
  final TextEditingController descEngController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imagesController = TextEditingController();

  late ProductCat selectedCategory;

  bool showError = false;
  bool showLoader = false;
  final _formKey = GlobalKey<FormState>();

  // You'll need to implement image uploading functionality separately

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEngController.text = widget.product?.nameEng ?? "";
    nameArController.text = widget.product?.nameAr ?? "";
    nameFrController.text = widget.product?.nameFr ?? "";
    descEngController.text = widget.product?.descEng ?? "";
    descArController.text = widget.product?.descAr ?? "";
    descFrController.text = widget.product?.descFr ?? "";
    unitController.text = widget.product?.units.toString() ?? "";
    priceController.text = widget.product?.price.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(BuildContext context) {
    return SingleChildScrollView(
        child: Modal(
            child: Container(
                padding: EdgeInsets.all(20)
                    .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: MultiBlocListener(
                    listeners: [
                      BlocListener<ProductBloc, ProductState>(
                        listener: (context, state) {
                          if (state is ProductLoadingState) {
                            setState(() {
                              showLoader = true;
                            });

                          } else if (state is CrudProductLoadedState) {
                            print("hello");
                            setState(() {
                              showLoader = false;
                            });
                            Navigator.of(context).pop();
                            widget.onSubmit.call();
                          } else if (state is ProductErrorState) {
                            setState(() {
                              showLoader = false;
                            });
                          }
                        },
                      ),
                    ],
                    child: Material(
                        child: Stack(children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            height: getFullHeight(context) * 0.8,
                            child: SingleChildScrollView(
                                child: Form(
                                    key: _formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: nameEngController,
                                                decoration: InputDecoration(
                                                  labelText: 'NameEng',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: nameFrController,
                                                decoration: InputDecoration(
                                                  labelText: 'nameFr',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: nameArController,
                                                decoration: InputDecoration(
                                                  labelText: 'NameAr',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: descEngController,
                                                decoration: InputDecoration(
                                                  labelText: 'DescEng',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: descFrController,
                                                decoration: InputDecoration(
                                                  labelText: 'descFr',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: descArController,
                                                decoration: InputDecoration(
                                                  labelText: 'descAr',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: unitController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Unit',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                focusNode: FocusNode(),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill the input';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {},
                                                controller: priceController,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  labelText: 'Price',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0)),
                                                      child: (widget.product ==
                                                                  null &&
                                                              _image == null)
                                                          ? Image.asset(
                                                              "assets/images/placeholder.jpg",
                                                              height: 100,
                                                              width: getFullWigth(
                                                                      context) *
                                                                  0.4,
                                                              // Adjust image height as needed
                                                              fit: BoxFit.cover,
                                                            )
                                                          : _image != null
                                                              ? Image.file(
                                                                  _image!,
                                                                  width: getFullWigth(
                                                                          context) *
                                                                      0.4,
                                                                  height: 100,
                                                                  // Adjust image height as needed
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.memory(
                                                                  base64Decode(widget
                                                                      .product!
                                                                      .images),
                                                                  height: 100,
                                                                  width: getFullWigth(
                                                                          context) *
                                                                      0.4,
                                                                  // Adjust image height as needed
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                  InkWell(
                                                      onTap: () {
                                                        getImage();
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          'Select image',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                          ],
                                        ))))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                width: getFullWigth(context) * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    if(_formKey.currentState?.validate()==true){
                                      if (widget.product != null) {
                                        print("update");
                                        updateProduct();
                                      } else {
                                        addNewProduct();
                                      }
                                    }


                                  },
                                  child: Text('Submit'),
                                ))),
                      ]),
                          if (showLoader)
                            Positioned.fill(
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                    ]))))));
  }

  void addNewProduct() async {
    List<int> imageBytes = await _image!.readAsBytes();

    if (_image != null) {
      var product = Product(
        id: "",
        nameAr: nameArController.text,
        nameEng: nameEngController.text,
        nameFr: nameFrController.text,
        descAr: descArController.text,
        descEng: descEngController.text,
        descFr: descFrController.text,
        images: base64Encode(imageBytes),
        price: double.parse(priceController.text),
        units: int.parse(unitController.text),
      );
      productBloc.add(CrudProductEvent(
          ArgProduct(apiActions: ApiActions.ADD, product: product)));
    }
  }

  void updateProduct() async {
    List<int> imageBytes;
    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    } else
      imageBytes = [];
    var arg =
        ArgProduct(apiActions: ApiActions.UPDATE, product: widget.product!);
    arg.nameFr = nameFrController.text;
    arg.nameEng = nameEngController.text;
    arg.nameAr = nameArController.text;
    arg.descFr = descFrController.text;
    arg.descAr = descArController.text;
    arg.descEng = descEngController.text;
    arg.price = double.parse(unitController.text);
    arg.images = imageBytes.isEmpty ? null : base64Encode(imageBytes);
    productBloc.add(CrudProductEvent(arg));
  }
}
