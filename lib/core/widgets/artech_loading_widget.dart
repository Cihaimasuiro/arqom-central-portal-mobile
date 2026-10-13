import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated ARTECH loading indicator based accurately on the original
/// ARTECH loading animation prototype in `logo/ARTECH_Animasi_Loading_Akurat.html`.
///
/// Features:
/// - Smooth 3.2s looping animation cycle
/// - Sweeping conic reveal of the orange/blue ring (`logo/artech_ring.png`)
/// - Sliding & scaling central symbol emblem (`logo/artech_symbol.png`)
/// - Sliding & scaling branded text (`logo/artech_text.png`)
/// - Dynamic orange ambient halo glow
/// - Finish pulse effect on the full logo (`logo/artech_full.png`)
class ArtechLoadingWidget extends StatefulWidget {
  /// Dimension (width & height) of the loading logo stage.
  final double size;

  /// Optional message displayed below the animated logo.
  final String? message;

  /// Custom text style for the optional message.
  final TextStyle? messageStyle;

  /// Whether to render the ambient orange halo behind the logo.
  final bool showHalo;

  /// Whether to render the ARTECH text layer (can be false for tiny inline badges).
  final bool showText;

  /// Custom message color.
  final Color? messageColor;

  /// When true, renders with a fullscreen soft background.
  final bool isFullScreen;

  /// Custom background color when [isFullScreen] is true.
  final Color? backgroundColor;

  const ArtechLoadingWidget({
    super.key,
    this.size = 80.0,
    this.message,
    this.messageStyle,
    this.showHalo = true,
    this.showText = true,
    this.messageColor,
    this.isFullScreen = false,
    this.backgroundColor,
  });

  /// Compact/small preset for inline badges, buttons, or tight list items.
  const ArtechLoadingWidget.small({
    super.key,
    this.size = 28.0,
    this.message,
    this.messageStyle,
    this.showHalo = false,
    this.showText = false,
    this.messageColor,
  })  : isFullScreen = false,
        backgroundColor = null;

  /// Full screen loading screen with subtle radial backdrop.
  const ArtechLoadingWidget.fullScreen({
    super.key,
    this.size = 110.0,
    this.message = 'Memuat...',
    this.messageStyle,
    this.showHalo = true,
    this.showText = true,
    this.messageColor,
    this.backgroundColor,
  }) : isFullScreen = true;

  /// Shows a modal dialog containing the ARTECH animated loading widget.
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Memproses...',
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ArtechLoadingWidget(
                  size: 84.0,
                  showHalo: true,
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Closes the active loading dialog if open.
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  State<ArtechLoadingWidget> createState() => _ArtechLoadingWidgetState();
}

class _ArtechLoadingWidgetState extends State<ArtechLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Cubic curves matching the HTML/CSS specification
  static const Curve _ringDrawCurve = Cubic(0.45, 0.0, 0.2, 1.0);
  static const Curve _symbolInCurve = Cubic(0.22, 1.0, 0.36, 1.0);
  static const Curve _textInCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    // 3.2s infinite animation loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    final stageSize = widget.size;

    Widget coreStage = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // ── 1. HALO (Ambient Orange Glow) ──
        double haloOpacity = 0.0;
        double haloScale = 0.78;
        if (widget.showHalo) {
          if (t < 0.45) {
            haloOpacity = 0.0;
            haloScale = 0.78;
          } else if (t < 0.60) {
            final p = (t - 0.45) / 0.15;
            haloOpacity = _lerp(0.0, 0.55, p);
            haloScale = _lerp(0.78, 1.00, p);
          } else if (t < 0.72) {
            final p = (t - 0.60) / 0.12;
            haloOpacity = _lerp(0.55, 0.24, p);
            haloScale = _lerp(1.00, 0.93, p);
          } else if (t < 0.82) {
            final p = (t - 0.72) / 0.10;
            haloOpacity = _lerp(0.24, 0.52, p);
            haloScale = _lerp(0.93, 1.01, p);
          } else {
            final p = (t - 0.82) / 0.18;
            haloOpacity = _lerp(0.52, 0.0, p);
            haloScale = _lerp(1.01, 1.06, p);
          }
        }

        // ── 2. RING REVEAL & DRAW ──
        double ringOpacity = 0.0;
        double ringSweep = 0.0; // 0.0 to 1.0 (0 to 360 deg)
        double ringScale = 0.985;
        if (t <= 0.06) {
          ringOpacity = 0.0;
          ringSweep = 0.0;
          ringScale = 0.985;
        } else if (t < 0.08) {
          final p = (t - 0.06) / 0.02;
          ringOpacity = _lerp(0.0, 1.0, p);
          ringSweep = 0.0;
          ringScale = _lerp(0.985, 0.990, p);
        } else if (t < 0.36) {
          final p = (t - 0.08) / 0.28;
          final curvedP = _ringDrawCurve.transform(p);
          ringOpacity = 1.0;
          ringSweep = curvedP;
          ringScale = _lerp(0.990, 1.0, curvedP);
        } else if (t <= 0.82) {
          ringOpacity = 1.0;
          ringSweep = 1.0;
          ringScale = 1.0;
        } else {
          final p = (t - 0.82) / 0.18;
          ringOpacity = _lerp(1.0, 0.0, p);
          ringSweep = 1.0;
          ringScale = 1.0;
        }

        // ── 3. SYMBOL IN ──
        double symbolOpacity = 0.0;
        double symbolTranslateY = 22.0 * (stageSize / 420.0);
        double symbolScale = 0.92;
        if (t < 0.28) {
          symbolOpacity = 0.0;
        } else if (t < 0.42) {
          final p = (t - 0.28) / 0.14;
          final curvedP = _symbolInCurve.transform(p);
          symbolOpacity = _lerp(0.0, 1.0, curvedP);
          symbolTranslateY = _lerp(22.0, -2.0, curvedP) * (stageSize / 420.0);
          symbolScale = _lerp(0.92, 1.01, curvedP);
        } else if (t < 0.52) {
          final p = (t - 0.42) / 0.10;
          symbolOpacity = 1.0;
          symbolTranslateY = _lerp(-2.0, 0.0, p) * (stageSize / 420.0);
          symbolScale = _lerp(1.01, 1.0, p);
        } else if (t <= 0.82) {
          symbolOpacity = 1.0;
          symbolTranslateY = 0.0;
          symbolScale = 1.0;
        } else {
          final p = (t - 0.82) / 0.18;
          symbolOpacity = _lerp(1.0, 0.0, p);
          symbolTranslateY = 0.0;
          symbolScale = 1.0;
        }

        // ── 4. TEXT IN ──
        double textOpacity = 0.0;
        double textTranslateY = 16.0 * (stageSize / 420.0);
        double textScale = 0.98;
        if (widget.showText) {
          if (t < 0.44) {
            textOpacity = 0.0;
          } else if (t < 0.58) {
            final p = (t - 0.44) / 0.14;
            final curvedP = _textInCurve.transform(p);
            textOpacity = _lerp(0.0, 1.0, curvedP);
            textTranslateY = _lerp(16.0, -1.0, curvedP) * (stageSize / 420.0);
            textScale = _lerp(0.98, 1.005, curvedP);
          } else if (t < 0.66) {
            final p = (t - 0.58) / 0.08;
            textOpacity = 1.0;
            textTranslateY = _lerp(-1.0, 0.0, p) * (stageSize / 420.0);
            textScale = _lerp(1.005, 1.0, p);
          } else if (t <= 0.82) {
            textOpacity = 1.0;
            textTranslateY = 0.0;
            textScale = 1.0;
          } else {
            final p = (t - 0.82) / 0.18;
            textOpacity = _lerp(1.0, 0.0, p);
            textTranslateY = 0.0;
            textScale = 1.0;
          }
        }

        // ── 5. FINISH PULSE ──
        double pulseOpacity = 0.0;
        double pulseScale = 1.0;
        if (t < 0.58) {
          pulseOpacity = 0.0;
          pulseScale = 1.0;
        } else if (t < 0.68) {
          final p = (t - 0.58) / 0.10;
          pulseOpacity = _lerp(0.0, 0.14, p);
          pulseScale = _lerp(1.0, 1.016, p);
        } else if (t < 0.78) {
          final p = (t - 0.68) / 0.10;
          pulseOpacity = _lerp(0.14, 0.03, p);
          pulseScale = _lerp(1.016, 0.998, p);
        } else if (t < 0.84) {
          final p = (t - 0.78) / 0.06;
          pulseOpacity = _lerp(0.03, 0.12, p);
          pulseScale = _lerp(0.998, 1.012, p);
        } else {
          final p = (t - 0.84) / 0.16;
          pulseOpacity = _lerp(0.12, 0.0, p);
          pulseScale = _lerp(1.012, 1.0, p);
        }

        return SizedBox(
          width: stageSize,
          height: stageSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Layer 0: Halo Glow
              if (widget.showHalo && haloOpacity > 0.001)
                Transform.scale(
                  scale: haloScale,
                  child: Opacity(
                    opacity: haloOpacity.clamp(0.0, 1.0),
                    child: Container(
                      width: stageSize * 0.85,
                      height: stageSize * 0.85,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0x3BFE961D), // rgba(254,150,29, .23)
                            Color(0x1FFE961D), // rgba(254,150,29, .12)
                            Color(0x00FE961D), // transparent
                          ],
                          stops: [0.0, 0.38, 0.75],
                        ),
                      ),
                    ),
                  ),
                ),

              // Layer 1: Conic Ring Reveal
              if (ringOpacity > 0.001)
                Transform.scale(
                  scale: ringScale,
                  child: Opacity(
                    opacity: ringOpacity.clamp(0.0, 1.0),
                    child: _buildMaskedRing(ringSweep, stageSize),
                  ),
                ),

              // Layer 2: Symbol In
              if (symbolOpacity > 0.001)
                Transform.translate(
                  offset: Offset(0, symbolTranslateY),
                  child: Transform.scale(
                    scale: symbolScale,
                    child: Opacity(
                      opacity: symbolOpacity.clamp(0.0, 1.0),
                      child: Image.asset(
                        'logo/artech_symbol.png',
                        width: stageSize,
                        height: stageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // Layer 3: Text In
              if (widget.showText && textOpacity > 0.001)
                Transform.translate(
                  offset: Offset(0, textTranslateY),
                  child: Transform.scale(
                    scale: textScale,
                    child: Opacity(
                      opacity: textOpacity.clamp(0.0, 1.0),
                      child: Image.asset(
                        'logo/artech_text.png',
                        width: stageSize,
                        height: stageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // Layer 4: Finish Pulse (Full Logo overlay)
              if (pulseOpacity > 0.001)
                Transform.scale(
                  scale: pulseScale,
                  child: Opacity(
                    opacity: pulseOpacity.clamp(0.0, 1.0),
                    child: Image.asset(
                      'logo/artech_full.png',
                      width: stageSize,
                      height: stageSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    // If message is provided, arrange in column
    Widget content = coreStage;
    if (widget.message != null && widget.message!.isNotEmpty) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          coreStage,
          const SizedBox(height: 12),
          Text(
            widget.message!,
            textAlign: TextAlign.center,
            style: widget.messageStyle ??
                TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: widget.messageColor ?? AppColors.onSurfaceVariant,
                ),
          ),
        ],
      );
    }

    if (widget.isFullScreen) {
      return Container(
        color: widget.backgroundColor ?? const Color(0xFFFAFBFE),
        alignment: Alignment.center,
        child: content,
      );
    }

    return content;
  }

  /// Builds the ring layer with sweep mask corresponding to the CSS:
  /// `-webkit-mask-image: conic-gradient(from -152deg, #000 0deg, #000 var(--sweep), transparent calc(var(--sweep) + 0.8deg), transparent 360deg)`
  Widget _buildMaskedRing(double sweepProgress, double stageSize) {
    final ringImage = Image.asset(
      'logo/artech_ring.png',
      width: stageSize,
      height: stageSize,
      fit: BoxFit.contain,
    );

    // When fully drawn (sweep >= 0.999), avoid shader mask overhead
    if (sweepProgress >= 0.999) {
      return ringImage;
    }
    if (sweepProgress <= 0.001) {
      return const SizedBox.shrink();
    }

    // Mask with conic sweep gradient starting from -152 degrees
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        final sweep = sweepProgress.clamp(0.0, 1.0);
        return SweepGradient(
          transform: const GradientRotation(-152 * math.pi / 180),
          colors: const [
            Color(0xFF000000),
            Color(0xFF000000),
            Color(0x00000000),
            Color(0x00000000),
          ],
          stops: [
            0.0,
            sweep,
            (sweep + 0.008).clamp(0.0, 1.0),
            1.0,
          ],
        ).createShader(bounds);
      },
      child: ringImage,
    );
  }
}
