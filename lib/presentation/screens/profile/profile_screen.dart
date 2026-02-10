import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../widgets/responsive_scaffold.dart';
import 'profile_update_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routePath = '/profile';
  static const routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _loading = true;
  String? _error;

  Future<void> _loadProfile() async {
    final repo = context.read<ProfileRepository>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await repo.getProfile();
      if (mounted) setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _openUpdate() async {
    if (_profile == null) return;
    final updated = await Navigator.of(context).push<ProfileModel>(
      MaterialPageRoute(
        builder: (_) => ProfileUpdateScreen(profile: _profile!),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _profile = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _profile == null ? null : _openUpdate,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    final p = _profile!;
    final completion = p.profileCompletion.clamp(0.0, 100.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          _buildHeader(p, completion),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Core identity & location',
            icon: Icons.person_outline,
            items: [
              ('Full name', p.fullName),
              ('Gender', p.gender),
              ('Date of birth', _formatDate(p.dateOfBirth)),
              ('Blood group', p.bloodGroup),
              ('Aadhaar / Passport', p.aadhaarOrPassport),
              ('Country', p.country),
              ('State', p.state),
              ('City', p.city),
              ('Pincode', p.pincode),
              ('Address', p.fullResidentialAddress),
            ],
          ),
          _buildSection(
            title: 'Community & lineage',
            icon: Icons.groups_outlined,
            items: [
              ('Jain sect', p.jainSect ?? p.jainSectOther),
              ('Mother tongue', p.motherTongue ?? p.motherTongueOther),
            ],
          ),
          _buildSection(
            title: 'Education',
            icon: Icons.school_outlined,
            items: [
              ('Highest qualification', p.highestQualification ?? p.highestQualificationOther),
              ('Field of study', p.fieldOfStudy ?? p.fieldOfStudyOther),
              ('Institution', p.institutionName),
              ('Year of passing', p.yearOfPassing),
              ('Achievements', p.academicAchievements),
              ('Special skills', p.specialSkills),
            ],
          ),
          _buildSection(
            title: 'Professional & business',
            icon: Icons.work_outline,
            items: [
              ('Employment type', p.employmentType ?? p.employmentTypeOther),
              ('Industry', p.industrySector ?? p.industrySectorOther),
              ('Company', p.companyName),
              ('Designation', p.designation),
              ('Work experience', p.workExperience),
              ('Work address', p.workAddressCity),
              ('Business keywords', p.businessKeywords),
              ('Employer', p.isEmployer == true ? 'Yes' : p.isEmployer == false ? 'No' : null),
            ],
          ),
          _buildSection(
            title: 'Family',
            icon: Icons.family_restroom_outlined,
            items: [
              ('Marital status', p.maritalStatus),
              ('Father\'s name', p.fatherName),
              ('Father\'s occupation', p.fatherOccupation),
              ('Mother\'s name', p.motherName),
              ('Mother\'s occupation', p.motherOccupation),
              if (p.maritalStatus?.toLowerCase() != 'single') ...[
                ('Spouse\'s name', p.spouseName),
                ('Spouse\'s occupation', p.spouseOccupation),
                ('Number of children', p.numberOfChildren?.toString()),
              ],
              ('Total Family Members', p.familySize?.toString()),
            ],
          ),
          _buildSection(
            title: 'Contact & social',
            icon: Icons.contact_phone_outlined,
            items: [
              ('Primary email', p.primaryEmail),
              ('Primary phone', p.primaryPhone),
              ('Alternate contact', p.alternateContactNumber),
              ('Additional email', p.additionalEmail),
              ('LinkedIn', p.linkedInProfileLink),
              ('Instagram', p.instagramSocialLinks),
              ('Facebook', p.facebook),
              ('Twitter', p.twitter),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _openUpdate,
              icon: const Icon(Icons.edit_rounded, size: 20),
              label: const Text('Update profile'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProfileModel p, double completion) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: completion / 100,
                strokeWidth: 6,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: primary.withOpacity(0.2),
              backgroundImage: p.photoUrl != null && p.photoUrl!.isNotEmpty
                  ? NetworkImage(p.photoUrl!)
                  : null,
              child: p.photoUrl == null || p.photoUrl!.isEmpty
                  ? Icon(Icons.person_rounded, size: 40, color: primary.withOpacity(0.7))
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          p.displayName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
          textAlign: TextAlign.center,
        ),
        if (p.displayDesignation != null) ...[
          const SizedBox(height: 2),
          Text(
            p.displayDesignation!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${completion.toStringAsFixed(0)}% complete',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<(String, String?)> items,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final entries = items
        .where((e) => e.$2 != null && e.$2.toString().trim().isNotEmpty)
        .map((e) => MapEntry(e.$1, e.$2!))
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
                      color: primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 24, color: primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Text(
                  'No information added yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              else
                ...entries.map((e) => _ProfileRow(label: e.key, value: e.value)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
