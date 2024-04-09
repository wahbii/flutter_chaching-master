import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokedex/data/entities/giveaway.dart';
import 'package:pokedex/data/usecases/giveaway/crud_giveaway_use_case.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../../data/states/providers/giveAwayBloc.dart';
import '../../../../widgets/modal.dart';

class EditGiveAwayDialog extends StatefulWidget {
  final GiveAway? product;

  final Function() onsubmit;

  EditGiveAwayDialog({required this.product, required this.onsubmit});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditGiveAwayDialogState();
  }
}

class EditGiveAwayDialogState extends State<EditGiveAwayDialog> {
  File? _image;

  GiveAwayBloc get giveAwayBloc => context.read<GiveAwayBloc>();

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

  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.product?.dateRest.toDate() ?? selectedDate,
      firstDate: DateTime(2024,1,1),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool showLoader = false;

  bool formValide = true;

  final TextEditingController nameEngController = TextEditingController();
  final TextEditingController nameFrController = TextEditingController();
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController descArController = TextEditingController();
  final TextEditingController descFrController = TextEditingController();
  final TextEditingController descEngController = TextEditingController();
  final TextEditingController linkWinner = TextEditingController();
  final TextEditingController winner = TextEditingController();
  final TextEditingController prixMin = TextEditingController();
  final TextEditingController prixMax = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameEngController.text = widget.product?.titleEng ?? "";
    nameArController.text = widget.product?.titleAr ?? "";
    nameFrController.text = widget.product?.titleFr ?? "";
    descEngController.text = widget.product?.descEng ?? "";
    descArController.text = widget.product?.descAr ?? "";
    descFrController.text = widget.product?.descFr ?? "";
    linkWinner.text = widget.product?.Url ?? "";
    winner.text = widget.product?.idWinner ?? "";
    selectedDate = widget.product?.dateRest.toDate() ?? DateTime.now();
    prixMax.text = widget.product?.prixMax.toString() ?? "0";
    prixMin.text = widget.product?.prixMin.toString() ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Modal(
            child: Container(
                padding: EdgeInsets.all(20)
                    .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<GiveAwayBloc, GiveAwayState>(
                      listener: (context, state) {
                        if (state is GiveAwayLoadingState) {
                          setState(() {
                            showLoader = true;
                          });
                        } else if (state is CrudGiveAwayState) {
                          setState(() {
                            showLoader = false;
                          });
                          Navigator.of(context).pop();
                          widget.onsubmit.call();
                        } else if (state is GiveAwayErrorState) {
                          setState(() {
                            showLoader = false;
                          });
                        }
                      },
                    ),
                  ],
                  child: contentBox(context),
                ))));
  }

  void addNewGiveAway() async {
    List<int> imageBytes = await _image!.readAsBytes();

    if (widget.product == null &&
        nameFrController.text.isNotEmpty &&
        _image != null) {
      var giveaway = GiveAway(
          id: "",
          titleFr: nameFrController.text,
          titleEng: nameEngController.text,
          titleAr: nameArController.text,
          descFr: descFrController.text,
          descEng: descEngController.text,
          descAr: descArController.text,
          participante: 0,
          commandesId: [],
          img: base64Encode(imageBytes),
          dateRest: Timestamp.fromDate(selectedDate),
          prixMax: double.parse(prixMax.text),
          prixMin: double.parse(prixMin.text));
      giveAwayBloc.add(CrudGiveAwayEvent(
          ArgGiveAway(action: ApiActions.ADD, giveAway: giveaway)));
      setState(() {
        formValide = false;
      });
    } else {
      setState(() {
        formValide = true;
      });
    }
  }

  Widget contentBox(BuildContext context) {
    return Material(
      child: Stack(
        children: [

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: getFullHeight(context) * 0.8,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: nameFrController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill the input';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'Namefr',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: nameArController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill the input';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'NameAr',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: descEngController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill the input';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'DescEng',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: descFrController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill the input';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'DescFr',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: descArController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill the input';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'DescAr',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please fill the input';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                                focusNode: FocusNode(),
                                controller: prixMin,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'PrixMin',
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.parse(prixMax.text) <
                                          double.parse(prixMin.text.isNotEmpty
                                              ? prixMin.text
                                              : "0")) {
                                    return 'Please fill the input';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                                focusNode: FocusNode(),
                                controller: prixMax,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'PrixMax',
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: linkWinner,
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'Link',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              focusNode: FocusNode(),
                              controller: winner,
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                labelText: 'Set id of winner',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                    child: (widget.product == null &&
                                        _image == null)
                                        ? Image.asset(
                                      "assets/images/placeholder.jpg",
                                      height: 100,
                                      width: getFullWigth(context) * 0.4,
                                      // Adjust image height as needed
                                      fit: BoxFit.cover,
                                    )
                                        : _image != null
                                        ? Image.file(
                                      _image!,
                                      width: getFullWigth(context) * 0.4,
                                      height:
                                      100, // Adjust image height as needed
                                      fit: BoxFit.cover,
                                    )
                                        : Image.memory(
                                      base64Decode(widget.product!.img),
                                      height: 100,
                                      width: getFullWigth(context) * 0.4,
                                      // Adjust image height as needed
                                      fit: BoxFit.cover,
                                    )),
                                InkWell(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Select image',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            focusNode: FocusNode(),
                                            textInputAction: TextInputAction.none,
                                            keyboardType: TextInputType.datetime,
                                            decoration: const InputDecoration(
                                              labelText: 'Date expiration',
                                              border: OutlineInputBorder(),
                                            ),
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text:
                                              '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () => _selectDate(context),
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(height: 10),
                          // Your form fields and other widgets here

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: getFullWigth(context) * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        if (widget.product == null) {
                          addNewGiveAway();
                        } else {
                          updateGiveAway();
                        }
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
          if (showLoader)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }


  void updateGiveAway() async {
    List<int> imageBytes;
    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    } else
      imageBytes = [];
    var arg = ArgGiveAway(
      action: ApiActions.UPDATE,
      giveAway: widget.product!,
    );
    arg.titleFr = nameFrController.text;
    arg.titleEng = nameEngController.text;
    arg.titleAr = nameArController.text;
    arg.descEng = descEngController.text;
    arg.descFr = descFrController.text;
    arg.descAr = descArController.text;
    arg.idWinner = winner.text;
    arg.Url = linkWinner.text;
    arg.prixMax = double.parse(prixMax.text);
    arg.prixMin = double.parse(prixMin.text);
    arg.img = imageBytes.isEmpty ? null : base64Encode(imageBytes);
    arg.dateRest = Timestamp.fromDate(selectedDate);
    giveAwayBloc.add(CrudGiveAwayEvent(arg));
  }
}
