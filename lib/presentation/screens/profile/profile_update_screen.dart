import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_theme.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _data;
  bool _saving = false;
  Map<String, List<String>> _options = {};
  bool _optionsLoading = true;
  String? _optionsError;

  @override
  void initState() {
    super.initState();
    _data = _profileToMap(widget.profile);
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final repo = context.read<ProfileRepository>();
      final opts = await repo.getProfileOptions();
      if (mounted) {
        setState(() {
          _options = opts;
          _optionsLoading = false;
          _optionsError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _optionsLoading = false;
          _optionsError = e.toString();
        });
      }
    }
  }

  List<String> _opt(String key) => _options[key] ?? [];

  Map<String, dynamic> _profileToMap(ProfileModel p) {
    return {
      'fullName': p.fullName ?? '',
      'gender': p.gender ?? '',
      'dateOfBirth': p.dateOfBirth,
      'bloodGroup': p.bloodGroup ?? '',
      'aadhaarOrPassport': p.aadhaarOrPassport ?? '',
      'country': p.country ?? '',
      'state': p.state ?? '',
      'city': p.city ?? '',
      'pincode': p.pincode ?? '',
      'fullResidentialAddress': p.fullResidentialAddress ?? '',
      'nativePlaceDistrict': p.nativePlaceDistrict ?? '',
      'nativePlaceState': p.nativePlaceState ?? '',
      'jainSect': p.jainSect ?? '',
      'jainSectOther': p.jainSectOther ?? '',
      'gadhGachhSampradaya': p.gadhGachhSampradaya ?? '',
      'motherTongue': p.motherTongue ?? '',
      'motherTongueOther': p.motherTongueOther ?? '',
      'localSanghSamitiName': p.localSanghSamitiName ?? '',
      'currentEducationStatus': p.currentEducationStatus ?? '',
      'currentEducationStatusOther': p.currentEducationStatusOther ?? '',
      'highestQualification': p.highestQualification ?? '',
      'highestQualificationOther': p.highestQualificationOther ?? '',
      'fieldOfStudy': p.fieldOfStudy ?? '',
      'fieldOfStudyOther': p.fieldOfStudyOther ?? '',
      'institutionName': p.institutionName ?? '',
      'yearOfPassing': p.yearOfPassing ?? '',
      'academicAchievements': p.academicAchievements ?? '',
      'specialSkills': p.specialSkills ?? '',
      'employmentType': p.employmentType ?? '',
      'employmentTypeOther': p.employmentTypeOther ?? '',
      'industrySector': p.industrySector ?? '',
      'industrySectorOther': p.industrySectorOther ?? '',
      'designation': p.designation ?? '',
      'companyName': p.companyName ?? '',
      'workAddressCity': p.workAddressCity ?? '',
      'workExperience': p.workExperience ?? '',
      'businessKeywords': p.businessKeywords ?? '',
      'isEmployer': p.isEmployer,
      'maritalStatus': p.maritalStatus ?? '',
      'fatherName': p.fatherName ?? '',
      'fatherOccupation': p.fatherOccupation ?? '',
      'motherName': p.motherName ?? '',
      'motherOccupation': p.motherOccupation ?? '',
      'spouseName': p.spouseName ?? '',
      'spouseOccupation': p.spouseOccupation ?? '',
      'numberOfChildren': p.numberOfChildren,
      'familySize': p.familySize,
      'familyId': p.familyId ?? '',
      'alternateContactNumber': p.alternateContactNumber ?? '',
      'linkedInProfileLink': p.linkedInProfileLink ?? '',
      'instagramSocialLinks': p.instagramSocialLinks ?? '',
      'facebook': p.facebook ?? '',
      'twitter': p.twitter ?? '',
      'additionalEmail': p.additionalEmail ?? '',
    };
  }

  Map<String, dynamic> _buildUpdateBody() {
    final body = <String, dynamic>{};
    void set(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      body[key] = value;
    }

    set('fullName', _data['fullName']);
    set('gender', _data['gender']);
    if (_data['dateOfBirth'] != null) {
      body['dateOfBirth'] = (_data['dateOfBirth'] as DateTime).toIso8601String();
    }
    set('bloodGroup', _data['bloodGroup']);
    set('aadhaarOrPassport', _data['aadhaarOrPassport']);
    set('country', _data['country']);
    set('state', _data['state']);
    set('city', _data['city']);
    set('pincode', _data['pincode']);
    set('fullResidentialAddress', _data['fullResidentialAddress']);
    set('nativePlaceDistrict', _data['nativePlaceDistrict']);
    set('nativePlaceState', _data['nativePlaceState']);
    set('jainSect', _data['jainSect']);
    set('jainSectOther', _data['jainSectOther']);
    set('gadhGachhSampradaya', _data['gadhGachhSampradaya']);
    set('motherTongue', _data['motherTongue']);
    set('motherTongueOther', _data['motherTongueOther']);
    set('localSanghSamitiName', _data['localSanghSamitiName']);
    set('currentEducationStatus', _data['currentEducationStatus']);
    set('currentEducationStatusOther', _data['currentEducationStatusOther']);
    set('highestQualification', _data['highestQualification']);
    set('highestQualificationOther', _data['highestQualificationOther']);
    set('fieldOfStudy', _data['fieldOfStudy']);
    set('fieldOfStudyOther', _data['fieldOfStudyOther']);
    set('institutionName', _data['institutionName']);
    set('yearOfPassing', _data['yearOfPassing']);
    set('academicAchievements', _data['academicAchievements']);
    set('specialSkills', _data['specialSkills']);
    set('employmentType', _data['employmentType']);
    set('employmentTypeOther', _data['employmentTypeOther']);
    set('industrySector', _data['industrySector']);
    set('industrySectorOther', _data['industrySectorOther']);
    set('designation', _data['designation']);
    set('companyName', _data['companyName']);
    set('workAddressCity', _data['workAddressCity']);
    set('workExperience', _data['workExperience']);
    set('businessKeywords', _data['businessKeywords']);
    final emp = _data['isEmployer']?.toString().trim();
    if (emp != null && emp.isNotEmpty) body['isEmployer'] = emp == 'Yes';
    set('maritalStatus', _data['maritalStatus']);
    set('fatherName', _data['fatherName']);
    set('fatherOccupation', _data['fatherOccupation']);
    set('motherName', _data['motherName']);
    set('motherOccupation', _data['motherOccupation']);
    set('spouseName', _data['spouseName']);
    set('spouseOccupation', _data['spouseOccupation']);
    final nChildrenStr = _data['numberOfChildren']?.toString().trim() ?? '';
    if (nChildrenStr.isNotEmpty) {
      final nc = int.tryParse(nChildrenStr);
      if (nc != null) body['numberOfChildren'] = nc;
    }
    final fSizeStr = _data['familySize']?.toString().trim() ?? '';
    if (fSizeStr.isNotEmpty) {
      final fs = int.tryParse(fSizeStr);
      if (fs != null) body['familySize'] = fs;
    }
    set('familyId', _data['familyId']);
    set('alternateContactNumber', _data['alternateContactNumber']);
    set('linkedInProfileLink', _data['linkedInProfileLink']);
    set('instagramSocialLinks', _data['instagramSocialLinks']);
    set('facebook', _data['facebook']);
    set('twitter', _data['twitter']);
    final addEmail = (_data['additionalEmail']?.toString() ?? '').trim();
    if (addEmail.isNotEmpty) body['additionalEmail'] = addEmail;
    return body;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final repo = context.read<ProfileRepository>();
      final updated = await repo.updateProfile(_buildUpdateBody());
      if (mounted) Navigator.of(context).pop(updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(String key, String label, {int maxLines = 1, TextInputType? keyboardType}) {
    return CustomTextField(
      label: label,
      initialValue: _data[key]?.toString() ?? '',
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (v) => setState(() => _data[key] = v),
    );
  }

  Widget _dropdown(String key, String label, List<String> options) {
    return CustomDropdown(
      label: label,
      options: options,
      value: _data[key]?.toString(),
      onChanged: (v) => setState(() => _data[key] = v ?? ''),
    );
  }

  bool _isOtherSelected(String key) {
    final v = (_data[key]?.toString() ?? '').toLowerCase();
    return v == 'other';
  }

  Widget _dropdownWithOther(String key, String label, List<String> options, String otherKey, String otherLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown(key, label, options),
        if (_isOtherSelected(key))
          CustomTextField(
            label: otherLabel,
            initialValue: _data[otherKey]?.toString() ?? '',
            onChanged: (v) => setState(() => _data[otherKey] = v),
            validator: (v) => (v?.trim().isEmpty ?? true) ? 'Please specify when "Other" is selected' : null,
          ),
      ],
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _pickDateOfBirth() async {
    final current = _data['dateOfBirth'] is DateTime
        ? _data['dateOfBirth'] as DateTime
        : null;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _data['dateOfBirth'] = picked);
    }
  }

  Widget _dateOfBirthField() {
    final date = _data['dateOfBirth'] is DateTime
        ? _data['dateOfBirth'] as DateTime
        : null;
    final label = 'Date of birth';
    final displayText = date != null ? _formatDate(date) : 'Tap to select date';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _pickDateOfBirth,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: appPrimary, width: 1.5),
            ),
            // filled: true,
            suffixIcon: const Icon(Icons.calendar_today_outlined, color: appPrimary),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              color: date != null ? null : Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _readOnly(String label, String? value) {
    return CustomTextField(
      label: label,
      initialValue: value ?? '',
      readOnly: true,
      helperText: 'From login (not editable)',
    );
  }

  bool get _isJobOrBoth {
    final v = (_data['employmentType']?.toString() ?? '').toLowerCase();
    return v == 'job' || v.contains('job') && v.contains('business');
  }

  bool get _isBusinessOrBoth {
    final v = (_data['employmentType']?.toString() ?? '').toLowerCase();
    return v == 'business' || (v.contains('job') && v.contains('business'));
  }

  bool get _isBusinessSelected {
    final v = (_data['employmentType']?.toString() ?? '').toLowerCase();
    return v == 'business' || (v.contains('job') && v.contains('business'));
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(icon, color: appPrimary, size: 24),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: appPrimary,
              ),
        ),
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_optionsLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Update profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_optionsError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Update profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Could not load form options: $_optionsError', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _loadOptions,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update profile'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _section('Core identity & location', Icons.person_outline, [
              _field('fullName', 'Full name (as per Govt ID)'),
              _dropdown('gender', 'Gender', _opt('gender')),
              _dateOfBirthField(),
              _dropdown('bloodGroup', 'Blood group', _opt('bloodGroup')),
              _field('aadhaarOrPassport', 'Aadhaar / Passport (optional)'),
              _field('country', 'Country'),
              _field('state', 'State'),
              _field('city', 'City'),
              _field('pincode', 'Pincode', keyboardType: TextInputType.number),
              _field('fullResidentialAddress', 'Full address', maxLines: 3),
              _field('nativePlaceDistrict', 'Native place – District'),
              _field('nativePlaceState', 'Native place – State'),
            ]),
            _section('Community & lineage', Icons.groups_outlined, [
              _dropdownWithOther('jainSect', 'Jain sect', _opt('jainSect'), 'jainSectOther', 'Specify Jain sect (required when Other)'),
              _field('gadhGachhSampradaya', 'Gadh / Gachh / Sampradaya'),
              _dropdownWithOther('motherTongue', 'Mother tongue', _opt('motherTongue'), 'motherTongueOther', 'Specify mother tongue (required when Other)'),
              _field('localSanghSamitiName', 'Local Sangh / Samiti name'),
            ]),
            _section('Education', Icons.school_outlined, [
              _dropdownWithOther('currentEducationStatus', 'Current education status', _opt('currentEducationStatus'), 'currentEducationStatusOther', 'Specify (required when Other)'),
              _dropdownWithOther('highestQualification', 'Highest qualification', _opt('highestQualification'), 'highestQualificationOther', 'Specify (required when Other)'),
              _dropdownWithOther('fieldOfStudy', 'Field of study', _opt('fieldOfStudy'), 'fieldOfStudyOther', 'Specify (required when Other)'),
              _field('institutionName', 'Institution / University'),
              _field('yearOfPassing', 'Year of passing'),
              _field('academicAchievements', 'Academic achievements'),
              _field('specialSkills', 'Special skills'),
            ]),
            _section('Professional & business', Icons.work_outline, [
              _dropdownWithOther('employmentType', 'Job or business?', _opt('employmentType'), 'employmentTypeOther', 'Specify (required when Other)'),
              if (_isJobOrBoth || _isBusinessOrBoth) ...[
                _dropdownWithOther('industrySector', 'Industry you work in', _opt('industrySector'), 'industrySectorOther', 'Specify industry (required when Other)'),
                _field('companyName', 'Company / firm name'),
                _field('designation', 'Position / designation'),
                _field('workExperience', 'Work experience (e.g. 5 years)'),
                _field('workAddressCity', 'Work address / city'),
                if (_isBusinessOrBoth) _field('businessKeywords', 'Business keywords (for search)'),
              ],
              if (_isBusinessSelected) _dropdown('isEmployer', 'Are you an employer?', _opt('isEmployer')),
            ]),
            _section('Family', Icons.family_restroom_outlined, [
              _dropdown('maritalStatus', 'Marital status', _opt('maritalStatus')),
              _field('fatherName', 'Father\'s name'),
              _field('fatherOccupation', 'Father\'s occupation'),
              _field('motherName', 'Mother\'s name'),
              _field('motherOccupation', 'Mother\'s occupation'),
              _field('spouseName', 'Spouse\'s name (if applicable)'),
              _field('spouseOccupation', 'Spouse\'s occupation'),
              _field('numberOfChildren', 'Number of children', keyboardType: TextInputType.number),
              _field('familySize', 'Family size', keyboardType: TextInputType.number),
              _field('familyId', 'Family ID'),
            ]),
            _section('Contact & social', Icons.contact_phone_outlined, [
              _readOnly('Primary email', widget.profile.primaryEmail),
              _readOnly('Primary phone', widget.profile.primaryPhone),
              _field('alternateContactNumber', 'Alternate contact'),
              _field('additionalEmail', 'Additional email'),
              _field('linkedInProfileLink', 'LinkedIn'),
              _field('instagramSocialLinks', 'Instagram'),
              _field('facebook', 'Facebook'),
              _field('twitter', 'Twitter'),
            ]),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_saving ? 'Saving...' : 'Save profile', style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
