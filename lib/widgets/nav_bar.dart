import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
    required this.scaffoldKey,
  });

  final int currentIndex;
  final Function(int) onNavTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPadding = Responsive.contentPadding(context);

    return Container(
      width: double.infinity,
      height: 85,
      color: AppTheme.bgLight,
      padding: EdgeInsets.symmetric(horizontal: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo: Orange Dot + Name + Role
          InkWell(
            onTap: () => onNavTap(0),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentYellow,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textBlack,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppConstants.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textBlack, size: 28),
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavItem(
                  title: 'Resume',
                  isActive: currentIndex == 1,
                  onTap: () => onNavTap(1),
                ),
                const _NavDivider(),
                _NavItem(
                  title: 'Projects',
                  isActive: currentIndex == 2,
                  onTap: () => onNavTap(2),
                ),
                const _NavDivider(),
                _NavItem(
                  title: 'Contact',
                  isActive: currentIndex == 3,
                  onTap: () => onNavTap(3),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _NavDivider extends StatelessWidget {
  const _NavDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        '|',
        style: TextStyle(
          color: AppTheme.dividerGrey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? AppTheme.accentYellow
        : (_hovered ? AppTheme.accentYellow : AppTheme.textBlack);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontSize: 16,
            fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
            color: color,
            fontFamily: 'Outfit',
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int currentIndex;
  final Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.bgLight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentYellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppConstants.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textBlack),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppTheme.dividerGrey),
              const SizedBox(height: 24),
              _buildDrawerItem(
                context,
                title: 'Home',
                index: 0,
              ),
              const SizedBox(height: 16),
              _buildDrawerItem(
                context,
                title: 'Resume',
                index: 1,
              ),
              const SizedBox(height: 16),
              _buildDrawerItem(
                context,
                title: 'Projects',
                index: 2,
              ),
              const SizedBox(height: 16),
              _buildDrawerItem(
                context,
                title: 'Contact',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required int index,
  }) {
    final isActive = currentIndex == index;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onNavTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppTheme.accentYellow : AppTheme.textBlack,
          ),
        ),
      ),
    );
  }
}
