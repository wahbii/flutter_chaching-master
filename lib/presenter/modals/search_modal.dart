import 'package:flutter/material.dart';
import 'package:pokedex/presenter/widgets/modal.dart';
import 'package:pokedex/presenter/widgets/input.dart';

class SearchBottomModal extends StatelessWidget {
  const SearchBottomModal({super.key,required this.onSearch});
  final Function(String? search) onSearch;



  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return Modal(
      child: Flexible(
        child: Padding(
          padding: EdgeInsets.fromLTRB(26, 14, 26, 14 + viewInsets + safeAreaBottom),
          child: AppSearchBar(
            hintText: 'Search for commande',
            onChanged: onSearch ,
          ),
        ),
      ),
    );
  }
}
