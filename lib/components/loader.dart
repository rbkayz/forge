import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math show pow;
import 'package:forge/utilities/constants.dart';

class ForgeLoader extends StatelessWidget {
  const ForgeLoader({Key? key}) : super(key: key);

  final double loaderSize = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ForgeSpinKitRipple(size: loaderSize)),
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


class ForgeSpinKitPumpingHeart extends StatefulWidget {
  const ForgeSpinKitPumpingHeart({
    Key? key,
    this.color = Constants.kPrimaryColor,
    required this.size,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
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
  _ForgeSpinKitPumpingHeartState createState() => _ForgeSpinKitPumpingHeartState();
}

class _ForgeSpinKitPumpingHeartState extends State<ForgeSpinKitPumpingHeart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
    _animation = Tween(begin: 1.0, end: 1.25)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: SpinKitPumpCurve())));
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
    return ScaleTransition(scale: _animation, child: _itemBuilder(0));
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : SizedBox(width: widget.size, height: widget.size, child: Image.asset(Constants.forgeLogo));
//Icon(Icons.favorite, color: widget.color, size: widget.size);
}

class SpinKitPumpCurve extends Curve {
  const SpinKitPumpCurve();

  static const magicNumber = 4.54545454;

  @override
  double transform(double t) {
    if (t >= 0.0 && t < 0.22) {
      return math.pow(t, 1.0) * magicNumber;
    } else if (t >= 0.22 && t < 0.44) {
      return 1.0 - (math.pow(t - 0.22, 1.0) * magicNumber);
    } else if (t >= 0.44 && t < 0.5) {
      return 0.0;
    } else if (t >= 0.5 && t < 0.72) {
      return math.pow(t - 0.5, 1.0) * (magicNumber / 2);
    } else if (t >= 0.72 && t < 0.94) {
      return 0.5 - (math.pow(t - 0.72, 1.0) * (magicNumber / 2));
    }
    return 0.0;
  }
}
