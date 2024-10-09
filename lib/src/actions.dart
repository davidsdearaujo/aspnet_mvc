typedef ActionMap$Callback<TResponse, TAction> = TResponse Function(
    TAction action);

abstract class ActionMvc {
  const ActionMvc();
  const factory ActionMvc.navigate(String route) = _NavigateAction;
  const factory ActionMvc.push(String route) = _PushRouteAction;

  T mapOrElse<T>({
    ActionMap$Callback<T, _NavigateAction>? navigate,
    ActionMap$Callback<T, _PushRouteAction>? pushRoute,
    required T Function() orElse,
  }) {
    return switch (this) {
      _NavigateAction action => navigate?.call(action) ?? orElse(),
      _PushRouteAction action => pushRoute?.call(action) ?? orElse(),
      _ => orElse(),
    };
  }
}

class _NavigateAction extends ActionMvc {
  final String route;
  const _NavigateAction(this.route);
}

class _PushRouteAction extends ActionMvc {
  final String route;
  const _PushRouteAction(this.route);
}
