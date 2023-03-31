import 'package:coffee_animation/coffee.dart';
import 'package:coffee_animation/coffee_bloc.dart';
import 'package:coffee_animation/coffee_concept_details.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 300);

class CoffeeConceptList extends StatefulWidget {
  const CoffeeConceptList({Key key}) : super(key: key);

  @override
  State<CoffeeConceptList> createState() => _CoffeeConceptListState();
}

class _CoffeeConceptListState extends State<CoffeeConceptList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = CoffeeProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned(
              left: 20,
              right: 20,
              bottom: -size.height * 0.22,
              height: size.height * 0.3,
              child: const DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      color: Colors.brown,
                      blurRadius: 90,
                      offset: Offset.zero,
                      spreadRadius: 45)
                ]),
              )),
          Transform.scale(
            scale: 1.6,
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<double>(
                valueListenable: bloc.currentPage,
                builder: (context, currentPage, _) {
                  return PageView.builder(
                      controller: bloc.pageCoffeeController,
                      itemCount: coffees.length + 1,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (value) {
                        if (value < coffees.length) {
                          bloc.pageTextController.animateToPage(value,
                              duration: _duration, curve: Curves.easeOut);
                        }
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox.shrink();
                        }
                        final coffee = coffees[index - 1];
                        final result = currentPage - index + 1;
                        final value = -0.4 * result + 1;
                        final opacity = value.clamp(0.0, 1.0);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 650),
                                pageBuilder: (context, animation, _) {
                                  return FadeTransition(
                                      opacity: animation,
                                      child:
                                          CoffeeConceptDetails(coffee: coffee));
                                }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Transform(
                                alignment: Alignment.bottomCenter,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..translate(0.0,
                                      size.height / 2.6 * (1 - value).abs())
                                  ..scale(value),
                                child: Opacity(
                                    opacity: opacity,
                                    child: Hero(
                                      tag: coffee.name,
                                      child: Image.asset(
                                        coffee.image,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ))),
                          ),
                        );
                      });
                }),
          ),
          const Positioned(
              left: 0, right: 0, top: 0, height: 100, child: _CoffeeHeader()),
        ],
      ),
    );
  }
}

class _CoffeeHeader extends StatelessWidget {
  const _CoffeeHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CoffeeProvider.of(context).bloc;
    final size = MediaQuery.of(context).size;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
            offset: Offset(0.0, -100 * value), child: child);
      },
      duration: _duration,
      child: ValueListenableBuilder<double>(
          valueListenable: bloc.textPage,
          builder: (context, _textPage, _) {
            return Column(
              children: [
                Expanded(
                    child: PageView.builder(
                        itemCount: coffees.length,
                        controller: bloc.pageTextController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final opacity =
                              (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                          return Opacity(
                              opacity: opacity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.2),
                                child: Hero(
                                  tag: "text_${coffees[index].name}",
                                  child: Material(
                                    child: Text(
                                      coffees[index].name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ));
                        })),
                const SizedBox(
                  height: 15,
                ),
                AnimatedSwitcher(
                  duration: _duration,
                  key: Key(coffees[_textPage.toInt()].name),
                  child: Text(
                    '\$${coffees[_textPage.toInt()].price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24),
                  ),
                )
              ],
            );
          }),
    );
  }
}
