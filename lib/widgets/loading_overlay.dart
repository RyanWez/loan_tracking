import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Loading overlay widget for async operations
class LoadingOverlay {
  static OverlayEntry? _overlay;

  /// Show loading overlay with optional message
  static void show(BuildContext context, [String message = 'Loading...']) {
    hide(); // Remove any existing overlay

    _overlay = OverlayEntry(
      builder: (context) => _LoadingOverlayWidget(message: message),
    );

    Overlay.of(context).insert(_overlay!);
  }

  /// Hide the loading overlay
  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }

  /// Execute an async function with loading overlay
  static Future<T> wrap<T>(
    BuildContext context,
    Future<T> Function() asyncFunction, {
    String message = 'Loading...',
  }) async {
    show(context, message);
    try {
      final result = await asyncFunction();
      return result;
    } finally {
      hide();
    }
  }
}

class _LoadingOverlayWidget extends StatefulWidget {
  final String message;

  const _LoadingOverlayWidget({required this.message});

  @override
  State<_LoadingOverlayWidget> createState() => _LoadingOverlayWidgetState();
}

class _LoadingOverlayWidgetState extends State<_LoadingOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _SpinnerWidget(),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinnerWidget extends StatefulWidget {
  const _SpinnerWidget();

  @override
  State<_SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<_SpinnerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: RotationTransition(
        turns: _controller,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                AppTheme.primaryDark.withValues(alpha: 0.1),
                AppTheme.primaryDark,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.darkCard,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
