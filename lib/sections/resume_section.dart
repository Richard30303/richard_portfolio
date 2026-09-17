import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  Future<void> _openResume() async {
    final uri = Uri.parse('assets/pdf/Richard_%20Flutter%20Developer.pdf');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPadding = Responsive.contentPadding(context);

    return Container(
      width: double.infinity,
      color: AppTheme.bgLight,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: isMobile ? 40 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title & Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Resume',
                    style: TextStyle(
                      fontSize: isMobile ? 40 : 52,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textBlack,
                      letterSpacing: -1,
                    ),
                  ),
                  _DownloadCVButton(onTap: _openResume),
                ],
              ),
              const SizedBox(height: 50),

              // 1. Work Experience Section
              _buildResumeRow(
                context,
                title: 'Work\nExperience',
                isMobile: isMobile,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AppConstants.experiences.map((exp) {
                    final points = exp['points'] as List<String>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exp['period'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  exp['role'] as String,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textBlack,
                                  ),
                                ),
                                Text(
                                  '${exp['company']} • ${exp['location']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...points.map((pt) => _buildBulletPoint(pt)),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    exp['period'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp['role'] as String,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${exp['company']} • ${exp['location']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...points.map(
                                          (pt) => _buildBulletPoint(pt)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    );
                  }).toList(),
                ),
              ),

              const Divider(color: AppTheme.dividerGrey, thickness: 1),
              const SizedBox(height: 40),

              // 2. Education Section
              _buildResumeRow(
                context,
                title: 'Education',
                isMobile: isMobile,
                content: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.education['period']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppConstants.education['degree']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textBlack,
                            ),
                          ),
                          Text(
                            '${AppConstants.education['institution']} | ${AppConstants.education['location']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Graduated with strong analytical foundation, transitioning into professional full-stack mobile development.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              AppConstants.education['period']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppConstants.education['degree']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textBlack,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppConstants.education['institution']} | ${AppConstants.education['location']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Graduated with strong analytical foundation, transitioning into professional full-stack mobile development.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 40),
              const Divider(color: AppTheme.dividerGrey, thickness: 1),
              const SizedBox(height: 40),

              // 3. Skills & Expertise Section
              _buildResumeRow(
                context,
                title: 'Skills\n& Expertise',
                isMobile: isMobile,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AppConstants.skills.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 12),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.textBlack,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textSecondary,
                                  height: 1.6,
                                  fontFamily: 'Outfit',
                                ),
                                children: [
                                  TextSpan(
                                    text: '${entry.key}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textBlack,
                                    ),
                                  ),
                                  TextSpan(
                                    text: entry.value.join(', '),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeRow(
    BuildContext context, {
    required String title,
    required bool isMobile,
    required Widget content,
  }) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.replaceAll('\n', ' '),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          content,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 240,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textBlack,
              letterSpacing: -0.5,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 10),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadCVButton extends StatefulWidget {
  const _DownloadCVButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_DownloadCVButton> createState() => _DownloadCVButtonState();
}

class _DownloadCVButtonState extends State<_DownloadCVButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.accentYellow : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 1.2),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 18,
                color: _hovered ? Colors.black : AppTheme.textBlack,
              ),
              const SizedBox(width: 8),
              Text(
                'Download CV',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? Colors.black : AppTheme.textBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
