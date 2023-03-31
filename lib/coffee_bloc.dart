import 'package:flutter/material.dart';

const _initialPage = 8.0;

class CoffeeBLoC {
  final pageCoffeeController = PageController(
    viewportFraction: 0.35,
    initialPage: _initialPage.toInt(),
  );
  final pageTextController = PageController(
    initialPage: _initialPage.toInt(),
  );
  final currentPage = ValueNotifier<double>(_initialPage);
  final textPage = ValueNotifier<double>(_initialPage);

  void _coffeeScrollListener() {
    currentPage.value = pageCoffeeController.page;
  }

  void _textScrollListener() {
    textPage.value = pageCoffeeController.page;
  }

  void init() {
    pageCoffeeController.addListener((_coffeeScrollListener));
    pageTextController.addListener(_textScrollListener);
  }

  void dispose() {
    pageCoffeeController.removeListener(_coffeeScrollListener);
    pageTextController.removeListener(_textScrollListener);
    pageCoffeeController.dispose();
    pageTextController.dispose();
  }
}

class CoffeeProvider extends InheritedWidget {
  final CoffeeBLoC bloc;
  const CoffeeProvider({Key key, @required this.bloc, Widget child})
      : super(key: key, child: child);

  static CoffeeProvider of(BuildContext context) =>
      context.findAncestorWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant CoffeeProvider oldWidget) => false;
}
