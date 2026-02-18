import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing legal and informational content
class LegalContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get legal content by document ID
  Future<Map<String, dynamic>?> getLegalContent(String documentId) async {
    try {
      final doc = await _firestore.collection('legal').doc(documentId).get();
      
      if (!doc.exists) return null;
      
      return doc.data();
    } catch (e) {
      debugPrint('Error getting legal content: $e');
      return null;
    }
  }

  /// Get all legal documents
  Future<List<Map<String, dynamic>>> getAllLegalDocuments() async {
    try {
      final snapshot = await _firestore.collection('legal').get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error getting all legal documents: $e');
      return [];
    }
  }

  /// Update legal content (admin only)
  Future<void> updateLegalContent({
    required String documentId,
    required String title,
    required String content,
  }) async {
    try {
      await _firestore.collection('legal').doc(documentId).set({
        'title': title,
        'content': content,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating legal content: $e');
      rethrow;
    }
  }

  /// Initialize default legal content
  Future<void> initializeDefaultContent() async {
    try {
      // Check if content already exists
      final existing = await getAllLegalDocuments();
      if (existing.isNotEmpty) return;

      // Terms of Service
      await updateLegalContent(
        documentId: 'terms_of_service',
        title: 'Terms of Service',
        content: _getTermsOfServiceContent(),
      );

      // Privacy Policy
      await updateLegalContent(
        documentId: 'privacy_policy',
        title: 'Privacy Policy',
        content: _getPrivacyPolicyContent(),
      );

      // About Us
      await updateLegalContent(
        documentId: 'about_us',
        title: 'About Us',
        content: _getAboutUsContent(),
      );

      // Contact Us
      await updateLegalContent(
        documentId: 'contact_us',
        title: 'Contact Us',
        content: _getContactUsContent(),
      );
    } catch (e) {
      debugPrint('Error initializing default content: $e');
    }
  }

  String _getTermsOfServiceContent() {
    return '''
# Terms of Service

**Last Updated:** ${DateTime.now().toString().split(' ')[0]}

## 1. Acceptance of Terms

By accessing and using EatWise ("the App"), you accept and agree to be bound by the terms and provision of this agreement.

## 2. Use License

Permission is granted to temporarily use the App for personal, non-commercial purposes. This is the grant of a license, not a transfer of title.

## 3. User Accounts

- You are responsible for maintaining the confidentiality of your account
- You are responsible for all activities that occur under your account
- You must notify us immediately of any unauthorized use

## 4. Health Data

- The App collects health data including weight, height, age, meals, and activities
- This data is used solely to provide personalized nutrition tracking
- You retain ownership of your health data
- You can request deletion of your data at any time

## 5. AI Services

- The App uses AI services (OpenAI) for food analysis
- AI-generated content is provided for informational purposes only
- Always consult healthcare professionals for medical advice

## 6. Subscription Terms

- Subscriptions are billed monthly
- 7-day free trial available for new users
- Cancel anytime through your account settings
- No refunds for partial months

## 7. Disclaimer

The App is provided "as is" without warranties. Nutritional information is for reference only and should not replace professional medical advice.

## 8. Limitation of Liability

EatWise shall not be liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of the App.

## 9. Changes to Terms

We reserve the right to modify these terms at any time. Continued use of the App constitutes acceptance of modified terms.

## 10. Contact

For questions about these Terms, contact us at support@eatwise.app
''';
  }

  String _getPrivacyPolicyContent() {
    return '''
# Privacy Policy

**Last Updated:** ${DateTime.now().toString().split(' ')[0]}

## 1. Information We Collect

### Personal Information
- Name and email address
- Age, gender, height, and weight
- Dietary preferences and goals

### Health Data
- Meal logs and food intake
- Activity and exercise data
- Step count and movement data
- Weight tracking history

### Usage Data
- App usage statistics
- Device information
- Log data

## 2. How We Use Your Information

We use collected information to:
- Provide personalized nutrition tracking
- Calculate calorie goals using the Mifflin-St Jeor formula
- Analyze food images using AI (OpenAI)
- Generate progress reports
- Improve our services

## 3. Data Storage

- All data is stored securely in Firebase (Google Cloud)
- Data is encrypted in transit and at rest
- We implement industry-standard security measures

## 4. Data Sharing

We do NOT sell your personal data. We share data only with:
- OpenAI (for food image analysis)
- USDA Food Data API (for nutritional information)
- Firebase/Google Cloud (for data storage)

## 5. Your Rights

You have the right to:
- Access your personal data
- Correct inaccurate data
- Request deletion of your data
- Export your data
- Opt-out of notifications

## 6. Data Retention

- Active account data is retained indefinitely
- Deleted account data is permanently removed within 30 days
- Backup data is retained for 90 days

## 7. Children's Privacy

The App is not intended for children under 13. We do not knowingly collect data from children.

## 8. Cookies and Tracking

We use minimal tracking for app functionality and analytics. You can disable analytics in settings.

## 9. Third-Party Services

- OpenAI API: Food image analysis
- USDA Food Data API: Nutritional information
- Firebase: Authentication and data storage
- RevenueCat: Subscription management

## 10. International Users

Data may be transferred to and processed in countries other than your own. By using the App, you consent to such transfers.

## 11. Changes to Privacy Policy

We will notify you of significant changes via email or in-app notification.

## 12. Contact Us

For privacy concerns, contact us at privacy@eatwise.app
''';
  }

  String _getAboutUsContent() {
    return '''
# About EatWise

## Our Mission

EatWise is dedicated to making nutrition tracking simple, accurate, and accessible for everyone. We believe that understanding what you eat is the first step toward a healthier lifestyle.

## What We Do

EatWise combines cutting-edge AI technology with proven nutritional science to help you:
- Track your meals effortlessly
- Understand your calorie intake
- Monitor your progress toward health goals
- Make informed dietary decisions

## Our Technology

### AI-Powered Food Analysis
We use advanced AI (OpenAI) to analyze food images and provide accurate nutritional information instantly.

### Science-Based Calculations
Our calorie recommendations are based on the Mifflin-St Jeor formula, a scientifically validated method for calculating daily energy needs.

### Comprehensive Tracking
- Meal and food logging
- Activity and exercise tracking
- Automatic step counting
- Water intake monitoring
- Weight progress tracking

## Our Values

**Privacy First**: Your health data belongs to you. We never sell your information.

**Accuracy**: We use verified nutritional databases (USDA) and validated formulas.

**Simplicity**: Nutrition tracking should be easy, not overwhelming.

**Transparency**: We're open about how we use your data and calculate your goals.

## Our Team

EatWise is built by a team of developers, nutritionists, and health enthusiasts passionate about making healthy living accessible to everyone.

## Get in Touch

We love hearing from our users! Contact us at hello@eatwise.app

---

**Version:** 1.0.0  
**Last Updated:** ${DateTime.now().toString().split(' ')[0]}
''';
  }

  String _getContactUsContent() {
    return '''
# Contact Us

We're here to help! Reach out to us through any of the following channels:

## Email Support

**General Inquiries:** hello@eatwise.app  
**Technical Support:** support@eatwise.app  
**Privacy Concerns:** privacy@eatwise.app  
**Business Inquiries:** business@eatwise.app

## Response Time

We typically respond within 24-48 hours during business days.

## Frequently Asked Questions

Before contacting us, you might find answers in our FAQ section (coming soon).

## Bug Reports

Found a bug? Please email support@eatwise.app with:
- Description of the issue
- Steps to reproduce
- Device and OS version
- Screenshots (if applicable)

## Feature Requests

We love hearing your ideas! Send feature suggestions to hello@eatwise.app

## Social Media

Follow us for updates, tips, and nutrition insights:
- Twitter: @eatwise_app
- Instagram: @eatwise_app
- Facebook: /eatwiseapp

## Mailing Address

EatWise Inc.  
123 Health Street  
San Francisco, CA 94102  
United States

---

**Note:** This is a sample contact page. Update with actual contact information before deployment.
''';
  }
}

void debugPrint(String message) {
  print(message);
}

