<p>
<a href="https://pub.dev/packages/smart_slider/score"><img src="https://img.shields.io/pub/likes/smart_slider" alt="likes"></a>
<a href="https://pub.dev/packages/smart_slider"><img src="https://img.shields.io/pub/v/smart_slider.svg?style=flat?logo=dart" alt="pub.dev"></a>
<a href="https://pub.dev/packages/smart_slider/score"><img src="https://img.shields.io/pub/popularity/smart_slider" alt="popularity"></a>
<a href="https://pub.dev/packages/smart_slider/score"><img src="https://img.shields.io/pub/points/smart_slider" alt="pub points"></a>
</p>

<h2 class="hash-header" id="examples">Example </h2>
<img src="https://drive.google.com/uc?id=1yyYogp0Ph440tgKOOHT6WN_y7ZvOElte" alt="My GIF" width="500">

<h3  id="examples">How to use </h3>

```dart
SmartSlider(
    controller: controller,
    onSlideComplete: () async {
      controller.loading();
      await Future.delayed(Duration(seconds: 2)).then(
        (value) {
          controller.success();
          _incrementCounter();
        },
      );
      await Future.delayed(Duration(seconds: 2)).then(
        (value) {
          controller.reset();
        },
      );
    },
);
```
<h3 class="hash-header">If you like this package, please leave a like there on <a href ='https://pub.dev/packages/smart_slider'> pub.dev </a> and star on <a href="https://github.com/SouravSouru/smart_slider" rel="ugc">GitHub</a></h3>
