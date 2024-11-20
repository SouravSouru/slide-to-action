import 'package:flutter/material.dart';

/// A customizable "Slide to Action" widget that includes loading and success states.
class SmartSlider extends StatefulWidget {
  const SmartSlider({
    super.key,
    required this.controller,
    required this.onSlideComplete,
    this.backgroundColor,
    this.sliderColor,
    this.sliderIcon,
    this.label,
    this.text,
    this.height,
  });

  /// Controller to manage the slider's state (reset, loading, success).
  final SlideController controller;

  /// Background color for the slider track.
  final Color? backgroundColor;

  /// Color for the sliding knob.
  final Color? sliderColor;

  /// Icon for the sliding knob.
  final Icon? sliderIcon;

  /// Height of the slider.
  final double? height;

  /// Action triggered when the slide is completed.
  final VoidCallback onSlideComplete;

  /// Text label displayed on the slider.
  final String? label;

  /// Custom widget for the slider's center text.
  final Widget? text;

  @override
  State<SmartSlider> createState() => _SmartSliderState();
}

class _SmartSliderState extends State<SmartSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  /// Current horizontal position of the slider knob.
  double _sliderPosition = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for smooth slider animations.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Set up the animation to control the slider knob's position.
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {
          _sliderPosition = _animation.value;
        });
      });

    // Listen to the controller's state changes for reset/loading/success.
    widget.controller._addListener(() {
      if (widget.controller.shouldReset) {
        _resetSlider();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Animate the slider knob to the target position.
  void _animateTo(double targetPosition) {
    _animation = Tween<double>(begin: _sliderPosition, end: targetPosition)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

  /// Reset the slider to its initial position.
  void _resetSlider() {
    _sliderPosition = 0;
    _animateTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: widget.height ?? 77,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                // Background container that shrinks during loading or success.
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: (widget.controller.isLoading ||
                            widget.controller.isSuccess)
                        ? widget.height ?? 77
                        : constraints.maxWidth,
                    height: widget.height ?? 77,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ??
                          Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                // Display text or custom widget when not loading or in success state.
                if (!widget.controller.isLoading &&
                    !widget.controller.isSuccess)
                  Center(
                    child: widget.text ??
                        Text(
                          widget.label ?? "Slide to Unlock",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                  ),

                // Display a loading indicator during the loading state.
                if (widget.controller.isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),

                // Display a success icon during the success state.
                if (widget.controller.isSuccess)
                  const Center(
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                // Slider knob for user interaction, shown only in idle state.
                if (!widget.controller.isLoading &&
                    !widget.controller.isSuccess)
                  Positioned(
                    left: _sliderPosition,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _sliderPosition += details.delta.dx;

                          // Ensure the knob stays within bounds.
                          if (_sliderPosition < 0) {
                            _sliderPosition = 0;
                          } else if (_sliderPosition >
                              constraints.maxWidth - (widget.height ?? 77)) {
                            _sliderPosition =
                                constraints.maxWidth - (widget.height ?? 77);
                          }
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        // Trigger the action if the knob is fully dragged.
                        if (_sliderPosition >=
                            constraints.maxWidth - (widget.height ?? 77)) {
                          widget.onSlideComplete();
                        } else {
                          _animateTo(0.0); // Reset if not fully dragged.
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: widget.sliderColor ?? Colors.white,
                        radius: (widget.height ?? 77) / 2,
                        child: Center(
                          child: widget.sliderIcon ??
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: widget.sliderColor ?? Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A controller to manage the state of the [SlideToAction] widget.
class SlideController {
  late VoidCallback _listener;

  /// Whether the slider should reset.
  bool _shouldReset = false;
  bool get shouldReset => _shouldReset;

  /// Whether the slider is in the loading state.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Whether the slider is in the success state.
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  SlideController();

  /// Reset the slider to its initial state.
  void reset() {
    _shouldReset = true;
    _isLoading = false;
    _isSuccess = false;
    _listener();
  }

  /// Set the slider to the loading state.
  void loading() {
    _isLoading = true;
    _isSuccess = false;
    _listener();
  }

  /// Set the slider to the success state.
  void success() {
    _isSuccess = true;
    _isLoading = false;
    _listener();
  }

  /// Add a listener to handle state updates.
  void _addListener(VoidCallback listener) {
    _listener = listener;
  }
}
