import 'package:flutter/material.dart';

class SupportSection extends StatefulWidget {
  const SupportSection({super.key});

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  bool _isMonthly = true;
  int? _selectedMonthlyIndex;
  int? _selectedOneTimeIndex;
  final TextEditingController _customAmountController = TextEditingController(
    text: '50',
  );

  List<Map<String, String>> get _oneTimeOptions => const [
    {'amount': 'R25', 'label': 'Buy the team a coffee'},
    {'amount': 'R50', 'label': 'Fund crisis line for a day'},
    {'amount': 'R100', 'label': 'Support a week of services'},
    {'amount': 'R250', 'label': 'Fund professional training'},
    {'amount': 'R500', 'label': 'Major platform improvement'},
  ];

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2), // Light pink background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE4E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildToggle(),
          const SizedBox(height: 24),
          if (_isMonthly) _buildMonthlyView() else _buildOneTimeView(),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildMonthlyView() {
    return Column(
      children: [
        _buildSupportOption(
          index: 0,
          title: 'Supporter',
          subtitle: 'Help keep the lights on',
          price: 'R50',
          features: [
            'Support basic server costs',
            'Help maintain crisis hotlines',
            'Enable new user onboarding',
          ],
          icon: Icons.favorite_border,
          iconColor: Colors.blue,
          isPopular: false,
        ),
        const SizedBox(height: 16),
        _buildSupportOption(
          index: 1,
          title: 'Advocate',
          subtitle: 'Champion men\'s mental health',
          price: 'R100',
          features: [
            'All Supporter benefits',
            'Fund group moderator training',
            'Support WhatsApp crisis line',
            'Help expand to new regions',
          ],
          icon: Icons.shield_outlined,
          iconColor: Colors.green,
          isPopular: true,
        ),
        const SizedBox(height: 16),
        _buildSupportOption(
          index: 2,
          title: 'Champion',
          subtitle: 'Lead the movement',
          price: 'R200',
          features: [
            'All Advocate benefits',
            'Fund professional therapist partnerships',
            'Support 24/7 crisis response',
            'Help develop new features',
            'Priority support access',
          ],
          icon: Icons.star_border,
          iconColor: Colors.purple,
          isPopular: false,
        ),
        if (_selectedMonthlyIndex != null) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement payment flow
              },
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: const Text('Start Monthly Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOneTimeView() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Make a One-Time Contribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Every contribution makes a difference in someone\'s mental health journey',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_oneTimeOptions.length, (index) {
          final option = _oneTimeOptions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOneTimeOption(
              index: index,
              amount: option['amount']!,
              label: option['label']!,
            ),
          );
        }),
        const SizedBox(height: 12),
        const Text(
          'or',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Text(
                'Custom amount:  R',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_selectedOneTimeIndex != null) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement payment flow
              },
              icon: const Icon(Icons.favorite_border),
              label: Text(
                'Contribute ${_oneTimeOptions[_selectedOneTimeIndex!]['amount']}',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOneTimeOption({
    required int index,
    required String amount,
    required String label,
  }) {
    final isSelected = _selectedOneTimeIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedOneTimeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.local_atm_outlined,
              color: isSelected ? Colors.blue : Colors.blue.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite_border, color: Color(0xFFBE123C)),
            const SizedBox(width: 8),
            Text(
              'Support MentalPing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFBE123C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Help us keep this vital mental health resource free and accessible for all men',
          style: TextStyle(fontSize: 14, color: const Color(0xFF9F1239)),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isMonthly ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _isMonthly
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Monthly Support',
                    style: TextStyle(
                      fontWeight: _isMonthly
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _isMonthly ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isMonthly ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !_isMonthly
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'One-Time Gift',
                    style: TextStyle(
                      fontWeight: !_isMonthly
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: !_isMonthly ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required List<String> features,
    required IconData icon,
    required Color iconColor,
    required bool isPopular,
  }) {
    final isSelected = _selectedMonthlyIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedMonthlyIndex = index),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? iconColor.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: iconColor, width: 2)
                      : (isPopular
                            ? Border.all(color: Colors.blue, width: 1.5)
                            : Border.all(color: Colors.grey.shade200)),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? iconColor.withOpacity(0.1)
                          : Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: iconColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: constraints.maxWidth < 250
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: iconColor,
                              ),
                            ),
                            Text(
                              _isMonthly ? 'per month' : 'one-time',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 4, color: iconColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPopular)
                Positioned(
                  top: -10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Most Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildFooterItem(Icons.lock_outline, 'Secure payments'),
        _buildFooterItem(Icons.people_outline, 'Community funded'),
        _buildFooterItem(Icons.favorite_border, '100% for mental health'),
      ],
    );
  }

  Widget _buildFooterItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
      ],
    );
  }
}
