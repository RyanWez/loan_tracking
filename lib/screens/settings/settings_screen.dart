import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_toast.dart';

// Import widgets
import 'widgets/theme_option_tile.dart';
import 'widgets/currency_info_card.dart';
import 'widgets/settings_item_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Appearance Section
              _buildAnimatedSection(
                index: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('APPEARANCE', isDark),
                    const SizedBox(height: 16),
                    Container(
                      decoration: AppTheme.cardDecoration(isDark),
                      child: Column(
                        children: [
                          ThemeOptionTile(
                            title: 'Dark Mode',
                            icon: Icons.dark_mode_rounded,
                            value: true,
                            themeProvider: themeProvider,
                            isDark: isDark,
                          ),
                          _buildDivider(isDark),
                          ThemeOptionTile(
                            title: 'Light Mode',
                            icon: Icons.light_mode_rounded,
                            value: false,
                            themeProvider: themeProvider,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Currency Section
              _buildAnimatedSection(
                index: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('CURRENCY', isDark),
                    const SizedBox(height: 16),
                    CurrencyInfoCard(isDark: isDark),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Data Section
              _buildAnimatedSection(
                index: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('DATA', isDark),
                    const SizedBox(height: 16),
                    Container(
                      decoration: AppTheme.cardDecoration(isDark),
                      child: Column(
                        children: [
                          SettingsItemTile(
                            title: 'Export Data',
                            subtitle: 'Export all data as JSON',
                            icon: Icons.download_rounded,
                            color: AppTheme.accentColor,
                            isDark: isDark,
                            onTap: () {
                              AppToast.showWarning(
                                context,
                                'Export feature coming soon',
                              );
                            },
                          ),
                          _buildDivider(isDark),
                          SettingsItemTile(
                            title: 'Import Data',
                            subtitle: 'Import data from backup',
                            icon: Icons.upload_rounded,
                            color: AppTheme.primaryDark,
                            isDark: isDark,
                            onTap: () {
                              AppToast.showWarning(
                                context,
                                'Import feature coming soon',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[500] : Colors.grey[600],
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.05),
    );
  }
}
