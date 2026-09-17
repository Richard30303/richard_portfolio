import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPadding = Responsive.contentPadding(context);

    final projects = AppConstants.projects;

    return Container(
      width: double.infinity,
      color: AppTheme.bgLight,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: isMobile ? 40 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects',
                style: TextStyle(
                  fontSize: isMobile ? 40 : 52,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textBlack,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A showcase of production Flutter applications deployed across Apple App Store and Google Play Store.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 17,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),

              // Stacked Projects List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Divider(
                    color: AppTheme.dividerGrey.withValues(alpha: 0.6),
                    thickness: 1,
                  ),
                ),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return _ProjectCard(
                    index: index + 1,
                    project: project,
                    isMobile: isMobile,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    required this.index,
    required this.project,
    required this.isMobile,
  });

  final int index;
  final Map<String, dynamic> project;
  final bool isMobile;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  late String _selectedImage;
  late List<String> _allImages;

  @override
  void initState() {
    super.initState();
    final primary = widget.project['image'] as String?;
    final screens = (widget.project['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final List<String> list = [];
    if (primary != null && primary.isNotEmpty) {
      list.add(primary);
    }
    for (final s in screens) {
      if (!list.contains(s)) {
        list.add(s);
      }
    }

    _allImages = list;
    _selectedImage = _allImages.isNotEmpty ? _allImages.first : '';
  }

  void _openLightbox(BuildContext context) {
    if (_allImages.isEmpty) return;

    final initialIdx = _allImages.indexOf(_selectedImage);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) {
        return _LightboxDialog(
          images: _allImages,
          initialIndex: initialIdx >= 0 ? initialIdx : 0,
          title: widget.project['name'] as String,
          onPageChanged: (idx) {
            setState(() {
              _selectedImage = _allImages[idx];
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.project['name'] as String;
    final subtitle = widget.project['subtitle'] as String;
    final tech = widget.project['tech'] as String;
    final points = widget.project['points'] as List<String>;
    final playStoreUrl = widget.project['playStoreUrl'] as String?;
    final appStoreUrl = widget.project['appStoreUrl'] as String?;
    final status = widget.project['status'] as String? ?? '';
    final subApps = widget.project['subApps'] as List<dynamic>?;

    final indexStr = widget.index < 10 ? '0${widget.index}' : '${widget.index}';

    if (widget.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShowcaseCard(name),
          const SizedBox(height: 28),
          _buildInfo(
            indexStr: indexStr,
            name: name,
            subtitle: subtitle,
            tech: tech,
            status: status,
            points: points,
            playStoreUrl: playStoreUrl,
            appStoreUrl: appStoreUrl,
            subApps: subApps,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Details & CTA
        Expanded(
          flex: 5,
          child: _buildInfo(
            indexStr: indexStr,
            name: name,
            subtitle: subtitle,
            tech: tech,
            status: status,
            points: points,
            playStoreUrl: playStoreUrl,
            appStoreUrl: appStoreUrl,
            subApps: subApps,
          ),
        ),
        const SizedBox(width: 50),
        // Right Column: Preview Image Showcase
        Expanded(
          flex: 6,
          child: _buildShowcaseCard(name),
        ),
      ],
    );
  }

  Widget _buildShowcaseCard(String title) {
    return _InteractiveShowcase(
      selectedImage: _selectedImage,
      allImages: _allImages,
      title: title,
      isMobile: widget.isMobile,
      onSelectImage: (img) => setState(() => _selectedImage = img),
      onTapZoom: () => _openLightbox(context),
    );
  }

  Widget _buildInfo({
    required String indexStr,
    required String name,
    required String subtitle,
    required String tech,
    required String status,
    required List<String> points,
    required String? playStoreUrl,
    required String? appStoreUrl,
    required List<dynamic>? subApps,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Project $indexStr',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentYellow,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            if (status.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textBlack,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 16),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7, right: 10),
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppTheme.textBlack,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Tech tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.split(',').map((t) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppTheme.dividerGrey,
                  width: 1,
                ),
              ),
              child: Text(
                t.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textBlack,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        // Store Buttons
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            if (playStoreUrl != null)
              _StoreButton(
                label: 'Google Play',
                icon: FontAwesomeIcons.googlePlay,
                url: playStoreUrl,
              ),
            if (appStoreUrl != null)
              _StoreButton(
                label: 'App Store',
                icon: FontAwesomeIcons.apple,
                url: appStoreUrl,
              ),
            if (subApps != null)
              ...subApps.expand((sub) {
                final subMap = sub as Map<String, dynamic>;
                final subName = subMap['name'] as String;
                final subPlay = subMap['playStoreUrl'] as String?;
                final subApp = subMap['appStoreUrl'] as String?;
                return [
                  if (subPlay != null && subPlay != playStoreUrl)
                    _StoreButton(
                      label: '$subName (Play Store)',
                      icon: FontAwesomeIcons.googlePlay,
                      url: subPlay,
                    ),
                  if (subApp != null && subApp != appStoreUrl)
                    _StoreButton(
                      label: '$subName (App Store)',
                      icon: FontAwesomeIcons.apple,
                      url: subApp,
                    ),
                ];
              }),
          ],
        ),
      ],
    );
  }
}

class _InteractiveShowcase extends StatefulWidget {
  const _InteractiveShowcase({
    required this.selectedImage,
    required this.allImages,
    required this.title,
    required this.isMobile,
    required this.onSelectImage,
    required this.onTapZoom,
  });

  final String selectedImage;
  final List<String> allImages;
  final String title;
  final bool isMobile;
  final ValueChanged<String> onSelectImage;
  final VoidCallback onTapZoom;

  @override
  State<_InteractiveShowcase> createState() => _InteractiveShowcaseState();
}

class _InteractiveShowcaseState extends State<_InteractiveShowcase> {
  bool _hovered = false;

  int get _currentIndex {
    final idx = widget.allImages.indexOf(widget.selectedImage);
    return idx >= 0 ? idx : 0;
  }

  void _prevImage() {
    if (widget.allImages.length <= 1) return;
    final prevIdx = (_currentIndex - 1 + widget.allImages.length) %
        widget.allImages.length;
    widget.onSelectImage(widget.allImages[prevIdx]);
  }

  void _nextImage() {
    if (widget.allImages.length <= 1) return;
    final nextIdx = (_currentIndex + 1) % widget.allImages.length;
    widget.onSelectImage(widget.allImages[nextIdx]);
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = widget.isMobile ? 400.0 : 490.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Main Showcase Card
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTapZoom,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: cardHeight,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _hovered ? Colors.black87 : AppTheme.dividerGrey,
                  width: _hovered ? 1.4 : 1.0,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  // Full uncropped image strictly bounded inside the card
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 16 : 28,
                        vertical: widget.isMobile ? 20 : 26,
                      ),
                      child: Center(
                        child: widget.selectedImage.isNotEmpty
                            ? Image.asset(
                                widget.selectedImage,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),

                  // Screenshot Counter Badge (Top-Left)
                  if (widget.allImages.isNotEmpty)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.allImages.length > 1
                              ? '${_currentIndex + 1} / ${widget.allImages.length}'
                              : 'Screen 1',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textBlack,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                  // Click to Expand Zoom Badge (Top-Right)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _hovered ? 1.0 : 0.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in,
                                color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Click to expand',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Previous Arrow Button (Left Edge)
                  if (widget.allImages.length > 1)
                    Positioned(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _ArrowButton(
                          icon: Icons.chevron_left,
                          onPressed: _prevImage,
                        ),
                      ),
                    ),

                  // Next Arrow Button (Right Edge)
                  if (widget.allImages.length > 1)
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _ArrowButton(
                          icon: Icons.chevron_right,
                          onPressed: _nextImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Thumbnail Strip if there are multiple screenshots
        if (widget.allImages.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.allImages.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final img = widget.allImages[i];
                final isSelected = img == widget.selectedImage;
                return InkWell(
                  onTap: () => widget.onSelectImage(img),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentYellow
                            : AppTheme.dividerGrey,
                        width: isSelected ? 2.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.accentYellow
                                    .withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(2.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.phone_iphone, size: 54, color: AppTheme.textMuted),
        const SizedBox(height: 8),
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatefulWidget {
  const _ArrowButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.black87
                : Colors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            border: Border.all(
              color: _hovered ? Colors.transparent : AppTheme.dividerGrey,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? Colors.white : Colors.black87,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _LightboxDialog extends StatefulWidget {
  const _LightboxDialog({
    required this.images,
    required this.initialIndex,
    required this.title,
    required this.onPageChanged,
  });

  final List<String> images;
  final int initialIndex;
  final String title;
  final ValueChanged<int> onPageChanged;

  @override
  State<_LightboxDialog> createState() => _LightboxDialogState();
}

class _LightboxDialogState extends State<_LightboxDialog> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _prev() {
    if (widget.images.length <= 1) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.images.length) % widget.images.length;
    });
    widget.onPageChanged(_currentIndex);
  }

  void _next() {
    if (widget.images.length <= 1) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.images.length;
    });
    widget.onPageChanged(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentImage = widget.images[_currentIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content Card
          Container(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.90,
              maxWidth: size.width * 0.90,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF141414),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top bar inside modal
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (widget.images.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentIndex + 1} of ${widget.images.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Main Image & Nav Arrows
                Flexible(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          currentImage,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      if (widget.images.length > 1) ...[
                        Positioned(
                          left: 4,
                          child: _ArrowButton(
                            icon: Icons.chevron_left,
                            onPressed: _prev,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: _ArrowButton(
                            icon: Icons.chevron_right,
                            onPressed: _next,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Thumbnail Strip inside Lightbox
                if (widget.images.length > 1) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 54,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.images.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final isSel = i == _currentIndex;
                        return InkWell(
                          onTap: () {
                            setState(() => _currentIndex = i);
                            widget.onPageChanged(i);
                          },
                          child: Container(
                            width: 36,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSel
                                    ? AppTheme.accentYellow
                                    : Colors.white24,
                                width: isSel ? 2 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                widget.images[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatefulWidget {
  const _StoreButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final FaIconData icon;
  final String url;

  @override
  State<_StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<_StoreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 14,
                color: _hovered ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

