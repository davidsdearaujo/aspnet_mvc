import 'package:aspnet_mvc/aspnet_mvc.dart';
import 'package:flutter/material.dart';

class ShowSnackBarAction extends ActionMvc {
  final SnackBar snackBar;
  const ShowSnackBarAction(this.snackBar);

  static bool validate(Object action) {
    return action is ShowSnackBarAction;
  }

  static void execute(BuildContext context, Object action) {
    final params = action as ShowSnackBarAction;
    ScaffoldMessenger.of(context).showSnackBar(params.snackBar);
  }
}
