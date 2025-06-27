import 'package:flutter/material.dart';
import '../../../models/sort_option.dart';

const Duration _menuAnimDuration = Duration(milliseconds: 200);
const double _menuSlideOffsetY = -0.1;
const double _menuElevation = 4.0;
const double _menuBorderRadius = 8.0;
const double _menuVerticalSpacing = 4.0;

const double _itemPaddingHorizontal = 12.0;
const double _itemPaddingVertical = 10.0;

const double _buttonPaddingHorizontal = 12.0;
const double _buttonPaddingVertical = 8.0;
const double _iconSpacing = 4.0;

class SortDropdownButton extends StatefulWidget {
  final SortOption selected;
  final ValueChanged<SortOption> onSelected;

  const SortDropdownButton({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<SortDropdownButton> createState() => _SortDropdownButtonState();
}

class _SortDropdownButtonState extends State<SortDropdownButton>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _menuAnimDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, _menuSlideOffsetY),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _removeOverlay() async {
    await _controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + _menuVerticalSpacing),
          showWhenUnlinked: false,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Material(
                  elevation: _menuElevation,
                  borderRadius: BorderRadius.circular(_menuBorderRadius),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: SortOption.values
                        .where((option) => option != widget.selected)
                        .map((option) {
                      final label = option == SortOption.byDate
                          ? "New first"
                          : "Favorites first";

                      return InkWell(
                        onTap: () {
                          widget.onSelected(option);
                          _removeOverlay();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: _itemPaddingHorizontal,
                            vertical: _itemPaddingVertical,
                          ),
                          child: Text(label),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.selected == SortOption.byDate
        ? "New first"
        : "Favorites first";

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: _buttonPaddingHorizontal,
            vertical: _buttonPaddingVertical,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_menuBorderRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              const SizedBox(width: _iconSpacing),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}