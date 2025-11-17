import 'package:flutter/material.dart';

/// FAQ Item model
class FAQItem {
  final String category;
  final String question;
  final String answer;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

/// Frequently Asked Questions page
class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Account',
    'Profile',
    'Privacy',
    'Subscription',
    'Safety',
  ];

  final List<FAQItem> _faqItems = [
    // Account FAQs
    FAQItem(
      category: 'Account',
      question: 'How do I create an account?',
      answer:
          'To create an account, tap "Sign Up" on the login page, choose your role (Player, Scout, or Coach), and follow the registration process. You\'ll need to verify your phone number.',
    ),
    FAQItem(
      category: 'Account',
      question: 'I forgot my password. How can I reset it?',
      answer:
          'On the login page, tap "Forgot Password" and enter your email address. We\'ll send you a link to reset your password.',
    ),
    FAQItem(
      category: 'Account',
      question: 'Can I change my account type?',
      answer:
          'Currently, you cannot change your account type after registration. If you need to switch roles, please contact our support team.',
    ),

    // Profile FAQs
    FAQItem(
      category: 'Profile',
      question: 'How do I make my profile stand out?',
      answer:
          'Complete all profile sections with accurate information, upload high-quality photos and videos showcasing your skills, keep your statistics up to date, and ensure your profile photo is professional.',
    ),
    FAQItem(
      category: 'Profile',
      question: 'What videos should I upload?',
      answer:
          'Upload videos that showcase your best skills, match highlights, training sessions, and technical abilities. Keep videos under 2 minutes and ensure good video quality.',
    ),
    FAQItem(
      category: 'Profile',
      question: 'How often should I update my stats?',
      answer:
          'Update your statistics after each match or at least monthly to keep your profile current and accurate.',
    ),

    // Privacy FAQs
    FAQItem(
      category: 'Privacy',
      question: 'Who can see my profile?',
      answer:
          'You can control your profile visibility in Privacy Settings. Options include Public (everyone), Scouts Only (verified scouts), or Private (only you and people you approve).',
    ),
    FAQItem(
      category: 'Privacy',
      question: 'What is parental consent?',
      answer:
          'For users under 16 years old, a parent or guardian must approve account creation and profile visibility. This is required by law to protect minors.',
    ),
    FAQItem(
      category: 'Privacy',
      question: 'How do I block someone?',
      answer:
          'Visit the user\'s profile, tap the menu (three dots), and select "Block User". Blocked users cannot view your profile or contact you.',
    ),

    // Subscription FAQs
    FAQItem(
      category: 'Subscription',
      question: 'Is ScoutMena free to use?',
      answer:
          'ScoutMena offers both free and premium tiers. Free accounts include basic profile features, while premium accounts unlock advanced analytics, priority visibility, and direct messaging.',
    ),
    FAQItem(
      category: 'Subscription',
      question: 'How do I upgrade to premium?',
      answer:
          'Go to Settings > Subscription and choose a premium plan that fits your needs. You can pay monthly or annually.',
    ),
    FAQItem(
      category: 'Subscription',
      question: 'Can I cancel my subscription?',
      answer:
          'Yes, you can cancel anytime from Settings > Subscription. Your premium features will remain active until the end of your billing period.',
    ),

    // Safety FAQs
    FAQItem(
      category: 'Safety',
      question: 'How does ScoutMena protect minors?',
      answer:
          'We require parental consent for users under 16, moderate all content from minor accounts, restrict direct messaging for young users, and allow parents to oversee their child\'s account.',
    ),
    FAQItem(
      category: 'Safety',
      question: 'How do I report inappropriate content?',
      answer:
          'Tap the menu (three dots) on any profile or content and select "Report". Our team reviews all reports within 24 hours.',
    ),
    FAQItem(
      category: 'Safety',
      question: 'Is my data secure?',
      answer:
          'Yes, we use industry-standard encryption to protect your data. We never share your personal information with third parties without your consent.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFAQs = _getFilteredFAQs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search FAQs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Category Filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: filteredFAQs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No FAQs found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Try a different search term or category'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFAQs.length,
              itemBuilder: (context, index) {
                return _FAQCard(faq: filteredFAQs[index]);
              },
            ),
    );
  }

  List<FAQItem> _getFilteredFAQs() {
    var filtered = _faqItems;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((faq) => faq.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (faq) =>
                faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }
}

class _FAQCard extends StatefulWidget {
  final FAQItem faq;

  const _FAQCard({required this.faq});

  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.faq.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.faq.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.faq.answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
