import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../../../data/models/banner_model.dart';
import '../../../core/theme/app_theme.dart';

class CarrosselBanner extends StatefulWidget {
  final List<BannerModel> banners;

  const CarrosselBanner({super.key, required this.banners});

  @override
  State<CarrosselBanner> createState() => _CarrosselBannerState();
}

class _CarrosselBannerState extends State<CarrosselBanner> {
  final _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        final next = (_currentPage + 1) % widget.banners.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: widget.banners.length,
                itemBuilder: (_, i) =>
                    _BannerCard(banner: widget.banners[i]),
              ),
            ),
          ),
          if (widget.banners.length > 1) ...[
            const SizedBox(height: 12),
            SmoothPageIndicator(
              controller: _controller,
              count: widget.banners.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerModel banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: banner.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.primary.withOpacity(0.1)),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.primary.withOpacity(0.15),
            child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primary),
          ),
        ),
        // Gradiente de legibilidade
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),
        // Textos sobrepostos
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: AppTextStyles.heading.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (banner.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  banner.subtitle!,
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
