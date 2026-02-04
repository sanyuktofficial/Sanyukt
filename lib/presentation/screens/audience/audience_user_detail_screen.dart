import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_theme.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/audience_repository.dart';
import '../../widgets/responsive_scaffold.dart';

class AudienceUserDetailScreen extends StatelessWidget {
  const AudienceUserDetailScreen({super.key, required this.userId});

  static const routePath = '/audience/user/:userId';
  static const routeName = 'audience-user-detail';

  final String userId;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Member details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: context.read<AudienceRepository>().getUserDetail(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }
          final user = snapshot.data ?? {};
          final canSeeSensitive = user['canSeeSensitive'] as bool? ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user),
                const SizedBox(height: 20),
                if (!canSeeSensitive) _buildSensitiveBanner(),
                if (!canSeeSensitive) const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Core identity & location',
                  icon: Icons.person_outline,
                  items: _coreIdentityItems(user, canSeeSensitive),
                ),
                _buildSection(
                  context,
                  title: 'Community & lineage',
                  icon: Icons.groups_outlined,
                  items: _communityItems(user),
                ),
                _buildSection(
                  context,
                  title: 'Education',
                  icon: Icons.school_outlined,
                  items: _educationItems(user),
                ),
                _buildSection(
                  context,
                  title: 'Professional & business',
                  icon: Icons.work_outline,
                  items: _professionalItems(user),
                ),
                _buildSection(
                  context,
                  title: 'Family',
                  icon: Icons.family_restroom_outlined,
                  items: _familyItems(user),
                ),
                if (canSeeSensitive)
                  _buildSection(
                    context,
                    title: 'Contact & social',
                    icon: Icons.contact_phone_outlined,
                    items: _contactItems(context, user),
                  )
                else
                  _buildContactLockedContainer(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> user) {
    final name = user['fullName']?.toString() ?? user['name']?.toString() ?? 'Unknown';
    final industry = user['industry']?.toString();
    final fieldOfStudy = user['fieldOfStudy']?.toString();
    final designation = user['designation']?.toString();
    final companyName = user['companyName']?.toString();
    final photoUrl = user['photoUrl']?.toString();
    final completion = (user['profileCompletion'] as num?)?.toDouble() ?? 0.0;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: appPrimary.withOpacity(0.1),
              backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : null,
              child: photoUrl == null || photoUrl.isEmpty
                  ? Icon(Icons.person_rounded, size: 36, color: appPrimary)
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (industry != null || fieldOfStudy != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      industry ?? fieldOfStudy ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: appPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (designation != null || companyName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      [designation, companyName]
                          .where((e) => e != null && e.toString().isNotEmpty)
                          .join(' · '),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: appPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${completion.clamp(0.0, 100.0).toStringAsFixed(0)}% complete',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: appPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensitiveBanner() {
    return Card(
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.amber.shade700, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Complete at least ${ProfileModel.profileCompletionThresholdForContact}% of your profile to view contact details.',
                style: TextStyle(color: Colors.amber.shade900, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactLockedContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.lock_outline, size: 28, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Complete at least ${ProfileModel.profileCompletionThresholdForContact}% of your profile to view contact & social details.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_DetailItem> _coreIdentityItems(Map<String, dynamic> user, bool canSeeSensitive) {
    final items = <_DetailItem>[
      _DetailItem('Full name', _str(user['fullName']) ?? _str(user['name'])),
      _DetailItem('Gender', _str(user['gender'])),
      _DetailItem('Date of birth', _formatDate(user['dateOfBirth'])),
      _DetailItem('Blood group', _str(user['bloodGroup'])),
      _DetailItem('Aadhaar / Passport', _str(user['aadhaarOrPassport'])),
    ];
    if (canSeeSensitive) {
      items.addAll([
        _DetailItem('Country', _str(user['country'])),
        _DetailItem('State', _str(user['state'])),
        _DetailItem('City', _str(user['city'])),
        _DetailItem('Pincode', _str(user['pincode'])),
        _DetailItem('Address', _str(user['fullResidentialAddress'])),
      ]);
    }
    items.addAll([
      _DetailItem('Native place – District', _str(user['nativePlaceDistrict'])),
      _DetailItem('Native place – State', _str(user['nativePlaceState'])),
    ]);
    return items;
  }

  List<_DetailItem> _communityItems(Map<String, dynamic> user) {
    return [
      _DetailItem('Jain sect', _str(user['jainSect'])),
      _DetailItem('Gadh / Gachh / Sampradaya', _str(user['gadhGachhSampradaya'])),
      _DetailItem('Mother tongue', _str(user['motherTongue'])),
      _DetailItem('Local Sangh / Samiti', _str(user['localSanghSamitiName'])),
    ];
  }

  List<_DetailItem> _educationItems(Map<String, dynamic> user) {
    return [
      _DetailItem('Current status', _str(user['currentEducationStatus'])),
      _DetailItem('Highest qualification', _str(user['highestQualification'])),
      _DetailItem('Field of study', _str(user['fieldOfStudy'])),
      _DetailItem('Institution', _str(user['institutionName'])),
      _DetailItem('Year of passing', _str(user['yearOfPassing'])),
      _DetailItem('Achievements', _str(user['academicAchievements'])),
      _DetailItem('Special skills', _str(user['specialSkills'])),
    ];
  }

  List<_DetailItem> _professionalItems(Map<String, dynamic> user) {
    final isEmployer = user['isEmployer'];
    return [
      _DetailItem('Employment type', _str(user['employmentType'])),
      _DetailItem('Industry', _str(user['industry']) ?? _str(user['industrySector'])),
      _DetailItem('Company', _str(user['companyName'])),
      _DetailItem('Designation', _str(user['designation'])),
      _DetailItem('Work experience', _str(user['workExperience'])),
      _DetailItem('Work address', _str(user['workAddressCity'])),
      _DetailItem('Business keywords', _str(user['businessKeywords'])),
      _DetailItem('Employer', isEmployer == true ? 'Yes' : isEmployer == false ? 'No' : null),
    ];
  }

  List<_DetailItem> _familyItems(Map<String, dynamic> user) {
    return [
      _DetailItem('Marital status', _str(user['maritalStatus'])),
      _DetailItem('Father\'s name', _str(user['fatherName'])),
      _DetailItem('Father\'s occupation', _str(user['fatherOccupation'])),
      _DetailItem('Mother\'s name', _str(user['motherName'])),
      _DetailItem('Mother\'s occupation', _str(user['motherOccupation'])),
      _DetailItem('Spouse\'s name', _str(user['spouseName'])),
      _DetailItem('Spouse\'s occupation', _str(user['spouseOccupation'])),
      _DetailItem('Number of children', user['numberOfChildren']?.toString()),
      _DetailItem('Family size', user['familySize']?.toString()),
      _DetailItem('Family ID', _str(user['familyId'])),
    ];
  }

  List<_DetailItem> _contactItems(BuildContext context, Map<String, dynamic> user) {
    final phone = _str(user['primaryPhone']) ?? _str(user['alternateContactNumber']);
    final email = _str(user['primaryEmail']) ?? _str(user['additionalEmail']);
    final address = _str(user['fullResidentialAddress']);
    final city = _str(user['city']);
    final state = _str(user['state']);
    final country = _str(user['country']);
    final locationParts = [city, state, country].where((e) => e != null && e.isNotEmpty);
    final location = locationParts.isNotEmpty ? locationParts.join(', ') : address;

    final items = <_DetailItem>[
      _DetailItem('Primary phone', phone, onTap: phone != null ? () => _launchUri(Uri.parse('tel:$phone')) : null),
      _DetailItem('Primary email', email, onTap: email != null ? () => _launchUri(Uri.parse('mailto:$email')) : null),
      _DetailItem('Alternate contact', _str(user['alternateContactNumber'])),
      _DetailItem('Additional email', _str(user['additionalEmail'])),
      _DetailItem('Address', location, onTap: location != null && location.isNotEmpty
          ? () => _launchUri(Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}'))
          : null),
      _DetailItem('LinkedIn', _str(user['linkedInProfileLink']), onTap: _str(user['linkedInProfileLink']) != null
          ? () => _launchUrl(_str(user['linkedInProfileLink'])!)
          : null),
      _DetailItem('Instagram', _str(user['instagramSocialLinks']), onTap: _str(user['instagramSocialLinks']) != null
          ? () => _launchUrl(_str(user['instagramSocialLinks'])!)
          : null),
      _DetailItem('Facebook', _str(user['facebook']), onTap: _str(user['facebook']) != null
          ? () => _launchUrl(_str(user['facebook'])!)
          : null),
      _DetailItem('Twitter', _str(user['twitter']), onTap: _str(user['twitter']) != null
          ? () => _launchUrl(_str(user['twitter'])!)
          : null),
    ];
    return items;
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_DetailItem> items,
  }) {
    final entries = items
        .where((e) => e.value != null && e.value!.trim().isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 24, color: appPrimary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Text(
                  'No information added yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                )
              else
                ...entries.map((e) => _DetailRow(item: e)),
            ],
          ),
        ),
      ),
    );
  }

  String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  String? _formatDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) {
      return '${v.day.toString().padLeft(2, '0')}/${v.month.toString().padLeft(2, '0')}/${v.year}';
    }
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    try {
      final d = DateTime.parse(s);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return s;
    }
  }

  Future<void> _launchUrl(String url) async {
    var u = url;
    if (!u.startsWith('http://') && !u.startsWith('https://')) u = 'https://$u';
    await _launchUri(Uri.parse(u));
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value, {this.onTap});
  final String label;
  final String? value;
  final VoidCallback? onTap;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    final isTappable = item.onTap != null &&
        item.value != null &&
        item.value != 'Hidden' &&
        item.value != 'Hidden — complete 75% of your profile to view';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: isTappable ? item.onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  item.value ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isTappable ? appPrimary : null,
                        fontWeight: isTappable ? FontWeight.w500 : FontWeight.normal,
                        decoration: isTappable ? TextDecoration.underline : TextDecoration.none,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUri(Uri uri) async {
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: avoid_print
    print('Could not launch $uri');
  }
}
