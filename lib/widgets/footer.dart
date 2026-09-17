import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
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
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppTheme.dividerGrey, thickness: 1),
          const SizedBox(height: 36),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhoneSection(),
                const SizedBox(height: 24),
                _buildEmailSection(),
                const SizedBox(height: 24),
                _buildSocialSection(),
                const SizedBox(height: 24),
                _buildCopyrightSection(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildPhoneSection()),
                Expanded(child: _buildEmailSection()),
                Expanded(child: _buildSocialSection()),
                Expanded(child: _buildCopyrightSection()),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _launch('tel:${AppConstants.phone.replaceAll(' ', '')}'),
          child: Text(
            AppConstants.phone,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _launch('mailto:${AppConstants.email}'),
          child: Text(
            AppConstants.email,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow Me',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _FooterSocialIcon(
              icon: FontAwesomeIcons.linkedinIn,
              url: AppConstants.linkedIn,
            ),
            const SizedBox(width: 16),
            _FooterSocialIcon(
              icon: FontAwesomeIcons.github,
              url: AppConstants.github,
            ),
            const SizedBox(width: 16),
            _FooterSocialIcon(
              icon: FontAwesomeIcons.whatsapp,
              url: AppConstants.whatsApp,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCopyrightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '© ${DateTime.now().year} By ${AppConstants.name}.',
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Crafted with Flutter Web',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

class _FooterSocialIcon extends StatefulWidget {
  const _FooterSocialIcon({required this.icon, required this.url});
  final FaIconData icon;
  final String url;

  @override
  State<_FooterSocialIcon> createState() => _FooterSocialIconState();
}

class _FooterSocialIconState extends State<_FooterSocialIcon> {
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
        child: AnimatedScale(
          scale: _hovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: FaIcon(
            widget.icon,
            size: 18,
            color: _hovered ? AppTheme.accentYellow : AppTheme.textBlack,
          ),
        ),
      ),
    );
  }
}
