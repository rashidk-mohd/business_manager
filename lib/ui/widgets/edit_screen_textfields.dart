import 'package:flutter/material.dart';

class EditScreentextFields extends StatelessWidget {
  final String? title;
  void Function(String?)? onSaved;
  String? initialValue;
  String? Function(String?)? validator;
  void Function()? onTap;
  TextInputAction? textInputAction;
  void Function(String)? onFieldSubmitted;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputType? keyboardType;
  String? hintext;
  bool isSuffixIcon;
  Widget? suffixIcon;
  EditScreentextFields(
      {Key? key,
      this.title,
      this.onSaved,
      this.initialValue,
      this.validator,
      this.onTap,
      this.keyboardType,
      this.onFieldSubmitted,
      this.textInputAction,
      this.focusNode,
      this.controller,
      this.hintext,
      this.isSuffixIcon = false,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .56,
          //height: MediaQuery.of(context).size.height,
          child: TextFormField(
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              suffixIcon: isSuffixIcon == true ? suffixIcon : null,
              hintText: hintext,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              hintStyle: Theme.of(context).textTheme.subtitle1,
            ),
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            onTap: onTap,
            controller: controller,
            keyboardType: keyboardType,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
