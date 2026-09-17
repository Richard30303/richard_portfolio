import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onNavigate,
  });

  final Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPadding = Responsive.contentPadding(context);

    return Container(
      width: double.infinity,
      color: AppTheme.bgLight,
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: isMobile ? 40 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(size: 260),
                    const SizedBox(height: 36),
                    _buildContent(context, isMobile: true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildAvatar(size: isTablet ? 300 : 380),
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      flex: 6,
                      child: _buildContent(context, isMobile: false),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD9D9D9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person,
                size: size * 0.45,
                color: AppTheme.textMuted,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Hello',
          style: TextStyle(
            fontSize: isMobile ? 54 : 76,
            fontWeight: FontWeight.w800,
            color: AppTheme.textBlack,
            letterSpacing: -1.5,
            height: 1.05,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 20),
        Text(
          'A Bit About Me',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.textBlack,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.aboutMe,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.75,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 36),

        // The 3 Signature Circular Buttons (Resume, Projects, Contact)
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 16,
          children: [
            _CircleActionButton(
              label: 'Resume',
              color: AppTheme.accentYellow,
              onTap: () => onNavigate(1),
            ),
            _CircleActionButton(
              label: 'Projects',
              color: AppTheme.accentRed,
              onTap: () => onNavigate(2),
            ),
            _CircleActionButton(
              label: 'Contact',
              color: AppTheme.accentBlue,
              onTap: () => onNavigate(3),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatefulWidget {
  const _CircleActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_CircleActionButton> createState() => _CircleActionButtonState();
}

class _CircleActionButtonState extends State<_CircleActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const double size = 120;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          transform: Matrix4.translationValues(0.0, _hovered ? -6.0 : 0.0, 0.0)
            ..multiply(Matrix4.diagonal3Values(
                _hovered ? 1.05 : 1.0, _hovered ? 1.05 : 1.0, 1.0)),
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.2),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
