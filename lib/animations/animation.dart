import 'package:flutter/material.dart';

// animation settings
const _dismissDuration = Duration(milliseconds: 700);

const _swipeDismissOffset = Offset(-2.0, 0.0);
const _swipeVelocityThreshold = 250.0;

// animation scale values
const _scaleStart = 1.0;
const _scaleEnd = 0.5;

// animation opacity values
const _opacityStart = 1.0;
const _opacityEnd = 0.0;

// clipper values
const _bezierMultiplier = 1.2;
const _clipVerticalCenter = 0.5;

// clipping base values
const _clipStartX = 0.0;
const _clipStartY = 0.0;
const _clipEndFactor = 1.0;


class DropletDismissible extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final VoidCallback onMarked;
  final VoidCallback onTap;
  final Key key;

  const DropletDismissible({
    required this.child,
    required this.onDismissed,
    required this.onMarked,
    required this.onTap,
    required this.key,
  }) : super(key: key);

  @override
  State<DropletDismissible> createState() => _DropletDismissibleState();
}

class _DropletDismissibleState extends State<DropletDismissible>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _dismissDuration,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: _swipeDismissOffset,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
        begin: _scaleStart,
        end: _scaleEnd,
    )
        .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
        begin: _opacityStart,
        end: _opacityEnd,
    )
        .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
    ));
  }

  void _handleDismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;

    await _controller.forward();
    widget.onDismissed();
  }

  void _handleMark() {
    widget.onMarked();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! < -_swipeVelocityThreshold) {
          _handleDismiss();
        } else if (details.primaryVelocity! > _swipeVelocityThreshold) {
          _handleMark();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: FractionalTranslation(
                translation: _offsetAnimation.value,
                child: ClipPath(
                  clipper: DropletClipper(progress: _controller.value),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DropletClipper extends CustomClipper<Path> {
  final double progress;

  DropletClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(_clipStartX, _clipStartY);
    path.lineTo(size.width * (_clipEndFactor - progress), _clipStartY);
    path.quadraticBezierTo(
      size.width * (_clipEndFactor - progress * _bezierMultiplier),
      size.height * _clipVerticalCenter,
      size.width * (_clipEndFactor - progress),
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(DropletClipper oldClipper) =>
      oldClipper.progress != progress;
}