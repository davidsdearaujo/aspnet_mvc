import 'package:aspnet_mvc/aspnet_mvc.dart';

import 'custom_actions_snackbar.dart';

export 'custom_actions_snackbar.dart';

final customActions = <ValidationCallback, ExecutionCallback>{
  ShowSnackBarAction.validate: ShowSnackBarAction.execute,
};
