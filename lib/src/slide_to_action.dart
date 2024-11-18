import 'package:flutter/material.dart';

class SlideToAction extends StatefulWidget {
  const SlideToAction({super.key, required this.controller});
  final SlideController controller;

  @override
  State<SlideToAction> createState() => _SlideToActionState();
}

class _SlideToActionState extends State<SlideToAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _avatarPosition = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {
          _avatarPosition = _animation.value;
        });
      });
    // Listen for reset and loading events from the controller
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

  void _animateTo(double targetPosition) {
    _animation = Tween<double>(begin: _avatarPosition, end: targetPosition)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

  void _resetSlider() {
    setState(() {
      widget.controller.isLoading = false;
      // widget.controller.isSuccess = false;
      _avatarPosition = 0;
    });
    _animateTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: 77,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                // Dynamically sized green background container
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:
                        widget.controller.isLoading ? 77 : constraints.maxWidth,
                    height: 77,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                // Show loading icon
                if (widget.controller.isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),

                // Show success icon
                if (widget.controller.isSuccess)
                  const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                // Show slider only when not loading or success
                if (!widget.controller.isLoading)
                  Positioned(
                    left: _avatarPosition,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _avatarPosition += details.delta.dx;

                          if (_avatarPosition < 0) {
                            _avatarPosition = 0;
                          } else if (_avatarPosition >
                              constraints.maxWidth - 77) {
                            _avatarPosition = constraints.maxWidth - 77;
                          }
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        if (_avatarPosition >= constraints.maxWidth - 77) {
                          // Trigger loading
                          widget.controller.isLoading = true;
                          widget.controller._listener();
                          Future.delayed(const Duration(seconds: 2), () {
                            widget.controller.isLoading = false;
                            // widget.controller.isSuccess = true;
                            widget.controller._listener();
                          });
                        } else {
                          _animateTo(0.0);
                        }
                      },
                      child: const CircleAvatar(
                        radius: 77 / 2,
                        child: Center(
                          child: Icon(Icons.arrow_forward_ios_outlined),
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

class SlideController {
  late VoidCallback _listener;

  bool shouldReset = false;
  bool isLoading = false;
  bool isSuccess = false;

  SlideController();

  void reset() {
    shouldReset = true;
    _listener();
  }

  void loading() {
    isLoading = true;
    _listener();
  }

  void _addListener(VoidCallback listener) {
    _listener = listener;
  }
}
