import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;

  // final String? Function(String?)? validator;
  // final void Function(String?)? onSaved;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.isPassword,
    // required this.validator,
    // required this.onSaved,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        obscureText: widget.isPassword ? _isObscure : false,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : const Icon(
                  Icons.abc,
                  color: Colors.white,
                ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        validator: widget.isPassword
            ? (value) {
                RegExp regex = RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return "La contraseña no puede estar vacía";
                }
                else if (!regex.hasMatch(value)) {
                  return ("La contraseña debe de tener mínimo 6 caracteres");
                } else {
                  return null;
                }
              }
            : (value) {
                RegExp regex = RegExp(r"^[a-zA-Z\d+_.-]+@[a-zA-Z\d.-]+.[a-z]");
                if (value!.isEmpty) {
                  return "El correo electrónico no puede estar vacío";
                }
                else if (!regex.hasMatch(value)) {
                  return ("El formato del correo electrónico es inválido");
                } else {
                  return null;
                }
              },
        onSaved: (value) {
          widget.controller?.text = value!;
        },
        keyboardType:
            widget.isPassword ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }
}
