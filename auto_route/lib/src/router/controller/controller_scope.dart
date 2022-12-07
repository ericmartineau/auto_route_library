import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

class RouterScopeData {
  final RoutingController controller;
  final NavigatorObserversBuilder inheritableObserversBuilder;
  final int stateHash;
  final List<NavigatorObserver> navigatorObservers;

  const RouterScopeData(
      {required this.controller,
      required this.inheritableObserversBuilder,
      required this.stateHash,
      required this.navigatorObservers});

  T? firstObserverOfType<T extends NavigatorObserver>() {
    final typedObservers = navigatorObservers.whereType<T>();
    if (typedObservers.isNotEmpty) {
      return typedObservers.first;
    } else {
      return null;
    }
  }
}

@protected
class RouterScope extends InheritedWidget {
  final RouterScopeData data;
  const RouterScope.from({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(child: child, key: key);

  RouterScope({
    Key? key,
    required Widget child,
    required RoutingController controller,
    required NavigatorObserversBuilder inheritableObserversBuilder,
    required int stateHash,
    required List<NavigatorObserver> navigatorObservers,
  })  : data = RouterScopeData(
          controller: controller,
          inheritableObserversBuilder: inheritableObserversBuilder,
          stateHash: stateHash,
          navigatorObservers: navigatorObservers,
        ),
        super(child: child, key: key);

  static RouterScopeData of(BuildContext context, {bool watch = false}) {
    RouterScopeData? scope;
    if (watch) {
      scope = context.dependOnInheritedWidgetOfExactType<RouterScope>()?.data;
    } else {
      scope = context.findAncestorWidgetOfExactType<RouterScope>()?.data;
    }
    assert(() {
      if (scope == null) {
        throw FlutterError(
            'RouterScope operation requested with a context that does not include a RouterScope.\n'
            'The context used to retrieve the Router must be that of a widget that '
            'is a descendant of a RouterScope widget.');
      }
      return true;
    }());
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant RouterScope oldWidget) {
    return data.stateHash != oldWidget.data.stateHash;
  }
}

class StackRouterScope extends InheritedWidget {
  final StackRouter controller;
  final int stateHash;

  const StackRouterScope({
    Key? key,
    required Widget child,
    required this.controller,
    required this.stateHash,
  }) : super(child: child, key: key);

  static StackRouterScope? of(BuildContext context, {bool watch = false}) {
    if (watch) {
      return context.dependOnInheritedWidgetOfExactType<StackRouterScope>();
    }
    return context.findAncestorWidgetOfExactType<StackRouterScope>();
  }

  @override
  bool updateShouldNotify(covariant StackRouterScope oldWidget) {
    return stateHash != oldWidget.stateHash;
  }
}

class TabsRouterScope extends InheritedWidget {
  final TabsRouter controller;
  final int stateHash;

  const TabsRouterScope({
    Key? key,
    required Widget child,
    required this.stateHash,
    required this.controller,
  }) : super(child: child, key: key);

  static TabsRouterScope? of(BuildContext context, {bool watch = false}) {
    if (watch) {
      return context.dependOnInheritedWidgetOfExactType<TabsRouterScope>();
    }
    return context.findAncestorWidgetOfExactType<TabsRouterScope>();
  }

  @override
  bool updateShouldNotify(covariant TabsRouterScope oldWidget) {
    return stateHash != oldWidget.stateHash;
  }
}
