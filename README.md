# animated_loading_button

[![Pub](https://img.shields.io/pub/v/country_code_picker.svg)](https://pub.dartlang.org/packages/country_code_picker)
![build](https://github.com/chrisedg87/flutter_rounded_loading_button/workflows/build/badge.svg)

AnimatedLoadingButton is a Flutter package with loading, success and error animations.

![](screenshots/loading-button.gif)

## Installation

   Add this to your pubspec.yaml:

```dart

    dependencies:
        animated_loading_button: ^0.0.1

```

## Usage

### Import

```dart

    import 'package:animated_loading_button/animated_loading_button.dart';

```

### Simple Implementation

```dart

    final LoadingButtonController _controller = new LoadingButtonController();

    void _doSomething() async {
        Timer(Duration(seconds: 2), () {
            _controller.success();
        });
    }

    LoadingButton(
        child: Text('Tap me!', style: TextStyle(color: Colors.white)),
        controller: _controller,
        onPressed: _doSomething,
    )

```

## Customization

Here is a list of properties available to customize your widget:

| Name | Type | Description |
|-----|-----|------|
|onPressed| VoidCallback | callback invoked when the button is tapped |
|child| Widget | the button's label |
|color| Color | primary color of the button |
|height| double | vertical extent of the button |
|width| double | horizontal extent of the button |
|iconSize| double | size of success and error icons |
|loaderStrokeWidth| double | stroke width of the animated loading circle |
|valueColor| Color | color of the static icons |
|borderRadius| double | radius of the button border |
|elevation| double | elevation of the raised button |
|errorColor| Color | color of the button when it is in the error state |
|successColor| Color | color of the button when it is in the success state |
|disabledColor| Color | color of the button when it is disabled |

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve animated_loading_button in any way you want, make a pull request, or open an issue.

