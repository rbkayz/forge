import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forge/utilities/constants.dart';

class ForgeLoader extends StatelessWidget {
  const ForgeLoader({Key? key}) : super(key: key);

  final double loaderSize = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ForgeSpinKitRipple(size: loaderSize)
      ),
    );
  }
}



class ForgeSpinKitRipple extends StatefulWidget {
  const ForgeSpinKitRipple({
    Key? key,
    this.color = Constants.kPrimaryColor,
    required this.size,
    this.borderWidth = 6.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1800),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final double borderWidth;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _ForgeSpinKitRippleState createState() => _ForgeSpinKitRippleState();
}

class _ForgeSpinKitRippleState extends State<ForgeSpinKitRipple> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.75, curve: Curves.linear)));
    _animation2 = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.25, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 1.0 - _animation1.value,
            child: Transform.scale(scale: _animation1.value, child: _itemBuilder(0)),
          ),
          Opacity(
            opacity: 1.0 - _animation2.value,
            child: Transform.scale(scale: _animation2.value, child: _itemBuilder(1)),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: widget.itemBuilder != null
          ? widget.itemBuilder!(context, index)
          : Image.asset(Constants.forgeLogo)
    );
  }
}

/*
ForgeSpinKitDoubleBounce

Source is: https://github.com/jogboms/flutter_spinkit/blob/master/lib/src/double_bounce.dart;
 */


class ForgeSpinKitDoubleBounce extends StatefulWidget {
  const ForgeSpinKitDoubleBounce({
    Key? key,
    this.color = Constants.kWhiteColor,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2000),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _ForgeSpinKitDoubleBounceState createState() => _ForgeSpinKitDoubleBounceState();
}

class _ForgeSpinKitDoubleBounceState extends State<ForgeSpinKitDoubleBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _animation = Tween(begin: -1.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: List.generate(2, (i) {
          return Transform.scale(
            scale: (1.0 - i - _animation.value.abs()).abs(),
            child: SizedBox.fromSize(size: Size.square(widget.size), child: _itemBuilder(i)),
          );
        }),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(image: const DecorationImage(image: AssetImage(Constants.forgeLogo)), color: widget.color!.withOpacity(0.6)));
}