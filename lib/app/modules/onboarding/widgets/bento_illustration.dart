import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';

class BentoIllustration extends StatelessWidget {
  const BentoIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Abstract Background Decor
          Positioned(
            top: 20.h,
            right: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6BFE9C).withOpacity(0.2), // secondary-container
              ),
            ).blurred(sigma: 50),
          ),
          Positioned(
            bottom: 20.h,
            left: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A237E).withOpacity(0.1), // primary-container
              ),
            ).blurred(sigma: 50),
          ),

          // Grid Layout
          Padding(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Row(
              children: [
                // Left Column (Netflix, Spotify)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Netflix Card
                      Expanded(
                        flex: 1,
                        child: AnimatedFloatWidget(
                          child: _GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        color: Colors.red[600],
                                        borderRadius: BorderRadius.circular(AppSizes.radius8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                                    ),
                                    AppSizes.gapW8,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Netflix', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: AppColors.black)),
                                          Text('Entertainment', style: TextStyle(fontSize: 9.sp, color: AppColors.neutral)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('\$15.99', style: AppTextStyles.headline.copyWith(color: AppColors.primary, fontSize: 18.sp)),
                                      Text('Monthly', style: TextStyle(fontSize: 10.sp, color: AppColors.neutral)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppSizes.gapH12,
                      // Spotify Card
                      Expanded(
                        flex: 1,
                        child: AnimatedFloatWidget(
                          delay: const Duration(seconds: 2),
                          child: _GlassCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.music_note, color: const Color(0xFF4AE183), size: 20.w), // secondary-fixed-dim
                                ),
                                AppSizes.gapW12,
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Spotify Family', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: AppColors.black)),
                                      Text('\$16.99', style: AppTextStyles.headline.copyWith(color: AppColors.primary, fontSize: 16.sp)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSizes.gapW12,
                // Right Column (AWS, Status Cards)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // AWS Card
                      Expanded(
                        flex: 2,
                        child: AnimatedFloatWidget(
                          delay: const Duration(seconds: 1), // float-delayed
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF6BFE9C).withOpacity(0.2), // secondary-container
                              border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(AppSizes.radius12),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: AppSizes.p8,
                                  right: AppSizes.p8,
                                  child: Icon(Icons.check_circle, color: AppColors.secondary, size: 20.w),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(AppSizes.p16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 48.w,
                                        height: 48.w,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.cloud, color: Colors.orange, size: 24.w), // AWS placeholder icon
                                      ),
                                      AppSizes.gapH12,
                                      Text('AWS detected', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                      AppSizes.gapH16,
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4.r),
                                        child: LinearProgressIndicator(
                                          value: 0.66,
                                          backgroundColor: const Color(0xFFEFECF5),
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                                          minHeight: 4.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppSizes.gapH12,
                      // Tiny Status Cards
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AnimatedFloatWidget(
                                delay: const Duration(seconds: 1),
                                child: _GlassCard(
                                  child: Center(child: Icon(Icons.sync, color: AppColors.secondary, size: 28.w)),
                                ),
                              ),
                            ),
                            AppSizes.gapW12,
                            Expanded(
                              flex: 1,
                              child: AnimatedFloatWidget(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A237E), // primary-container
                                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                                  ),
                                  child: Center(child: Icon(Icons.security_update_good, color: const Color(0xFF8690EE), size: 28.w)), // on-primary-container
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radius12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(AppSizes.p12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.8)),
            borderRadius: BorderRadius.circular(AppSizes.radius12),
          ),
          child: child,
        ),
      ),
    );
  }
}

extension BlurredWidget on Widget {
  Widget blurred({required double sigma}) {
    return ImageFilterWidget(sigma: sigma, child: this);
  }
}

class ImageFilterWidget extends StatelessWidget {
  final double sigma;
  final Widget child;

  const ImageFilterWidget({super.key, required this.sigma, required this.child});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: child,
    );
  }
}

class AnimatedFloatWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedFloatWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<AnimatedFloatWidget> createState() => _AnimatedFloatWidgetState();
}

class _AnimatedFloatWidgetState extends State<AnimatedFloatWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _translateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -15.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50),
    ]).animate(_controller);

    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.035).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50), // 0.035 radians ~ 2 degrees
      TweenSequenceItem(tween: Tween(begin: 0.035, end: 0.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50),
    ]).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _translateAnimation.value, 0.0)
            ..rotateZ(_rotateAnimation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
