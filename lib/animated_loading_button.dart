library animated_loading_button;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum LoadingState { idle, loading, success, error, stop }

class LoadingButton extends StatefulWidget {
  final LoadingButtonController controller;

  /// The callback that is called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The button's label
    final Widget child;

  /// The primary color of the button
  final Color? color;

  /// The vertical extent of the button.
  final double height;

  /// The horizontal extent of the button.
  final double width;

  /// The size of the static icons
  final double iconSize;

  /// The stroke width of the CircularProgressIndicator
  final double loaderStrokeWidth;

  /// The color of the static icons
  final Color valueColor;

  /// The radius of the button border
  final double borderRadius;

  /// The elevation of the raised button
  final double? elevation;

  /// The color of the button when it is in the error state
  final Color? errorColor;

  /// The color of the button when it is in the success state
  final Color? successColor;

  /// The color of the button when it is disabled
  final Color? disabledColor;

  const LoadingButton(
      {required this.controller,
        required this.onPressed,
        required this.child,
        this.color,
        this.height = 50,
        this.width = 300,
        this.iconSize = 24.0,
        this.loaderStrokeWidth = 1.5,
        this.valueColor = Colors.white,
        this.borderRadius = 10,
        this.elevation = 0.7,
        this.errorColor = Colors.red,
        this.successColor = Colors.green,
        this.disabledColor});

  @override
  State<StatefulWidget> createState() => _LoadingButtonState();
}


// todo: add readme and publish
// https://dart.dev/tools/pub/publishing
// https://dart.dev/tools/pub/cmd/pub-uploader
// https://pub.dev/packages/rounded_loading_button

class _LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  final _state = BehaviorSubject<LoadingState>.seeded(LoadingState.idle);

  final duration = const Duration(milliseconds: 850);

  late AnimationController loadingAnimController;
  late Animation loadingAnimationScale;
  late Animation loadingAnimationOpacity;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final childStream = StreamBuilder(
      stream: _state,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250), child: buildState());
      },
    );

    final btn = SizedBox  (
      width: widget.width,
      height: widget.height,
      child: RaisedButton(
          padding: const EdgeInsets.all(0),
          child: childStream,
          color: _state.value == LoadingState.success
              ? widget.successColor ?? theme.primaryColor
              : _state.value == LoadingState.error
              ? widget.errorColor ?? theme.primaryColor
              : widget.color ?? theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          disabledColor: widget.disabledColor,
          elevation: widget.elevation,
          onPressed: widget.onPressed == null ? null : _btnPressed),
    );

    return Container(height: widget.height, child: Center(child: btn));
  }

  Widget? buildState() {
    switch (_state.value) {
      case LoadingState.idle:
        return widget.child;
      case LoadingState.loading:
        return Opacity(
          opacity: loadingAnimationOpacity.value,
          child: Container(
            width: loadingAnimationScale.value,
            height: loadingAnimationScale.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: widget.valueColor, width: widget.loaderStrokeWidth),
            ),
          ),
        );
      case LoadingState.success:
        return Container(
            alignment: FractionalOffset.center,
            width: widget.iconSize,
            height: widget.iconSize,
            child: Icon(Icons.check, color: widget.valueColor));
      case LoadingState.error:
        return Container(
            alignment: FractionalOffset.center,
            width: widget.iconSize,
            height: widget.iconSize,
            child: Icon(
                Icons.close,
                color: widget.valueColor)
        );
      default:
        return SizedBox(
            height: widget.iconSize,
            width: widget.iconSize,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
                strokeWidth: widget.loaderStrokeWidth));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListeners(_start, _stop, _success, _error, _reset);

    loadingAnimController = AnimationController(duration: duration, vsync: this);

    loadingAnimationScale = Tween<double>(begin: widget.height * 0.15, end: widget.height * 0.75)
        .animate(CurvedAnimation(
        parent: loadingAnimController, curve: Curves.ease));
    loadingAnimationScale.addListener(() {
      setState(() {});
    });
    loadingAnimationScale.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        loadingAnimController.repeat();
      }
    });

    loadingAnimationOpacity = Tween<double>(begin: 0.8, end: 0)
        .animate(CurvedAnimation(
        parent: loadingAnimController, curve: Curves.easeInOutCubic));
    loadingAnimationOpacity.addListener(() {
      setState(() {});
    });

  }

  @override
  void dispose() {
    _state.sink.add(LoadingState.stop);
    _state.close();
    loadingAnimController.dispose();
    super.dispose();
  }

  void _btnPressed() {
    _start();
    widget.onPressed!();
  }



  void _start() {
    _state.sink.add(LoadingState.loading);
    loadingAnimController.forward();
  }

  void _stop() {
    _state.sink.add(LoadingState.idle);
  }

  void _success() {
    _state.sink.add(LoadingState.success);
    Timer(const Duration(seconds: 2), () {
      _reset();
    });
  }

  void _error() {
    _state.sink.add(LoadingState.error);
    Timer(const Duration(seconds: 1), () {
      _reset();
    });
  }

  void _reset() {
    if(_state.value != LoadingState.stop){
      _state.sink.add(LoadingState.idle);
    }
  }
}

class LoadingButtonController {
  late VoidCallback _startListener;
  late VoidCallback _stopListener;
  late VoidCallback _successListener;
  late VoidCallback _errorListener;
  late VoidCallback _resetListener;

  void addListeners(
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      VoidCallback errorListener,
      VoidCallback resetListener) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  void start() {
    _startListener();
  }

  void stop() {
    _stopListener();
  }

  void success() {
    _successListener();
  }

  void error() {
    _errorListener();
  }

  void reset() {
    _resetListener();
  }
}
