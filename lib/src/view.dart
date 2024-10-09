import 'package:flutter/widgets.dart';

import 'actions.dart';
import 'controller.dart';

abstract class ViewMvc<TModel, TController extends ControllerMvc> extends ActionMvc {
  final TModel model;
  const ViewMvc(this.model);

  Widget build(TController controller);
}

abstract class ViewMvc$NoModel<TController extends ControllerMvc> extends ViewMvc<Null, TController> {
  const ViewMvc$NoModel() : super(null);

  @override
  Widget build(TController controller);
}
