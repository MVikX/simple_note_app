import 'package:flutter/material.dart';
import 'swipe_action_constants.dart';

class SwipeActionCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final VoidCallback onMarked;
  final VoidCallback onTap;
  final Key key;

  const SwipeActionCard({
    required this.child,
    required this.onDismissed,
    required this.onMarked,
    required this.onTap,
    required this.key,
  }) : super(key: key);

  @override
  State<SwipeActionCard> createState() => _SwipeActionCardState();
}

class _SwipeActionCardState extends State<SwipeActionCard>
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
      duration: swipeDismissDuration,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: swipeDismissOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: scaleStart,
      end: scaleEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: opacityStart,
      end: opacityEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
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

        if (details.primaryVelocity! < -swipeVelocityThreshold) {
          _handleDismiss();
        } else if (details.primaryVelocity! > swipeVelocityThreshold) {
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
                  clipper: SwipeClipper(progress: _controller.value),
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

class SwipeClipper extends CustomClipper<Path> {
  final double progress;

  SwipeClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(clipStartX, clipStartY);
    path.lineTo(size.width * (clipEndFactor - progress), clipStartY);
    path.quadraticBezierTo(
      size.width * (clipEndFactor - progress * bezierMultiplier),
      size.height * clipVerticalCenter,
      size.width * (clipEndFactor - progress),
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SwipeClipper oldClipper) =>
      oldClipper.progress != progress;
}