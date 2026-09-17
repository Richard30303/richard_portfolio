import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'widgets/nav_bar.dart';
import 'widgets/footer.dart';
import 'sections/hero_section.dart';
import 'sections/resume_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Widget _getCurrentView() {
    switch (_currentIndex) {
      case 1:
        return const ResumeSection();
      case 2:
        return const ProjectsSection();
      case 3:
        return const ContactSection();
      case 0:
      default:
        return HeroSection(onNavigate: _switchTab);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.bgLight,
      endDrawer: NavDrawer(
        currentIndex: _currentIndex,
        onNavTap: _switchTab,
      ),
      body: Column(
        children: [
          // Sticky Top Navigation Bar
          NavBar(
            currentIndex: _currentIndex,
            onNavTap: _switchTab,
            scaffoldKey: _scaffoldKey,
          ),

          // Scrollable View Content + Footer
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<int>(_currentIndex),
                      child: _getCurrentView(),
                    ),
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
