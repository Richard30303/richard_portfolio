import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/responsive.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thank you! Your message has been sent successfully.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.accentYellow,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

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
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: isMobile ? 40 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo(isMobile: true),
                    const SizedBox(height: 48),
                    _buildForm(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildContactInfo(isMobile: false),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      flex: 6,
                      child: _buildForm(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContactInfo({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(
            fontSize: isMobile ? 40 : 52,
            fontWeight: FontWeight.w800,
            color: AppTheme.textBlack,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Looking forward to hearing from you',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        _buildInfoBlock(
          title: 'Phone',
          value: AppConstants.phone,
          onTap: () =>
              _launch('tel:${AppConstants.phone.replaceAll(' ', '')}'),
        ),
        const SizedBox(height: 28),
        _buildInfoBlock(
          title: 'Email',
          value: AppConstants.email,
          onTap: () => _launch('mailto:${AppConstants.email}'),
        ),
        const SizedBox(height: 28),
        _buildInfoBlock(
          title: 'Location',
          value: AppConstants.location,
        ),
        const SizedBox(height: 36),
        // Direct WhatsApp quick action
        InkWell(
          onTap: () => _launch(AppConstants.whatsApp),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 16,
                  color: Color(0xFF25D366),
                ),
                SizedBox(width: 8),
                Text(
                  'Chat on WhatsApp',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBlock({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Text(
            value,
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: 'First Name *',
                  controller: _firstNameController,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildFormField(
                  label: 'Last Name *',
                  controller: _lastNameController,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: 'Email *',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    if (!val.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildFormField(
                  label: 'Subject',
                  controller: _subjectController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFormField(
            label: 'Message',
            controller: _messageController,
            maxLines: 5,
          ),
          const SizedBox(height: 28),
          _SubmitButton(onPressed: _submitForm),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textBlack,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textBlack,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide:
                  const BorderSide(color: Colors.black, width: 1.1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide:
                  const BorderSide(color: AppTheme.accentYellow, width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.red, width: 1.1),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
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
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFD69002)
                : AppTheme.accentYellow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 1.2),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: const Center(
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
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
