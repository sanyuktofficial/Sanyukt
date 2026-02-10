import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/location_data.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

/// Highest qualification options: 10th or below + professional courses
const List<String> _highestQualificationOptions = [
  '10th or below 10th',
  'Professional courses',
  '12th Pass',
  'Diploma',
  'ITI',
  'Undergraduate (UG)',
  'Postgraduate (PG)',
  'PhD / Doctorate',
  'Other',
];

/// Employment type options as per requirement
const List<String> _employmentTypeOptions = [
  'Private Sector Job',
  'Business (Self Employed)',
  'Government Sector Job',
  'Student',
  'Other',
];

/// Alphabets and spaces only (for names, city)
final _alphabetsOnly = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

/// Aadhaar formatter: xxxx xxxx xxxx (adds space after every 4 digits)
class _AadhaarFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 12) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String _formatAadhaar(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length <= 4) return digits;
  if (digits.length <= 8) return '${digits.substring(0, 4)} ${digits.substring(4)}';
  return '${digits.substring(0, 4)} ${digits.substring(4, 8)} ${digits.substring(8, digits.length > 12 ? 12 : digits.length)}';
}

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
      'aadhaarOrPassport': _formatAadhaar(p.aadhaarOrPassport ?? ''),
      'country': p.country ?? '',
      'state': p.state ?? '',
      'city': p.city ?? '',
      'pincode': p.pincode ?? '',
      'fullResidentialAddress': p.fullResidentialAddress ?? '',
      'jainSect': p.jainSect ?? '',
      'jainSectOther': p.jainSectOther ?? '',
      'motherTongue': p.motherTongue ?? '',
      'motherTongueOther': p.motherTongueOther ?? '',
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
    final aadhaarRaw = (_data['aadhaarOrPassport']?.toString() ?? '').replaceAll(RegExp(r'\s'), '');
    body['aadhaarOrPassport'] = aadhaarRaw;
    set('country', _data['country']);
    set('state', _data['state']);
    set('city', _data['city']);
    set('pincode', _data['pincode']);
    set('fullResidentialAddress', _data['fullResidentialAddress']);
    set('jainSect', _data['jainSect']);
    set('jainSectOther', _data['jainSectOther']);
    set('motherTongue', _data['motherTongue']);
    set('motherTongueOther', _data['motherTongueOther']);
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
    final isSingle = (_data['maritalStatus']?.toString().trim().toLowerCase() ?? '') == 'single';
    if (!isSingle) {
      set('spouseName', _data['spouseName']);
      set('spouseOccupation', _data['spouseOccupation']);
      final nChildrenStr = _data['numberOfChildren']?.toString().trim() ?? '';
      if (nChildrenStr.isNotEmpty) {
        final nc = int.tryParse(nChildrenStr);
        if (nc != null) body['numberOfChildren'] = nc;
      }
    }
    final fSizeStr = _data['familySize']?.toString().trim() ?? '';
    if (fSizeStr.isNotEmpty) {
      final fs = int.tryParse(fSizeStr);
      if (fs != null) body['familySize'] = fs;
    }
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

  Widget _field(
    String key,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return CustomTextField(
      label: label,
      initialValue: _data[key]?.toString() ?? '',
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (v) => setState(() => _data[key] = v),
      validator: validator,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
    );
  }

  bool get _isMaritalStatusSingle {
    return (_data['maritalStatus']?.toString().trim().toLowerCase() ?? '') == 'single';
  }

  bool get _isEmploymentJobOrBusiness {
    final v = (_data['employmentType']?.toString() ?? '').toLowerCase();
    return v.contains('job') || v.contains('business') || v.contains('self employe');
  }

  List<String> _yearOptions() {
    final currentYear = DateTime.now().year;
    return List.generate(currentYear - 1950 + 1, (i) => (currentYear - i).toString());
  }

  String? _validateUrl(String? v, String label) {
    if (v == null || v.trim().isEmpty) return null;
    final trimmed = v.trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return '$label: Only valid links (paste http or https URL)';
    }
    try {
      Uri.parse(trimmed);
      return null;
    } catch (_) {
      return '$label: Enter a valid URL';
    }
  }

  Widget _dropdown(String key, String label, List<String> options) {
    return CustomDropdown(
      label: label,
      options: options,
      value: _data[key]?.toString(),
      onChanged: (v) => setState(() => _data[key] = v ?? ''),
    );
  }

  /// Cascading location: country -> state -> city. Clearing state clears city; clearing country clears state and city.
  Widget _locationDropdowns() {
    final countryList = countries;
    final selectedCountry = _data['country']?.toString().trim() ?? '';
    final selectedState = _data['state']?.toString().trim() ?? '';
    final stateList = selectedCountry.isNotEmpty ? getStates(selectedCountry) : <String>[];
    final cityList = selectedCountry.isNotEmpty && selectedState.isNotEmpty
        ? getCities(selectedCountry, selectedState)
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          label: 'Country',
          options: countryList,
          value: selectedCountry.isNotEmpty ? selectedCountry : null,
          onChanged: (v) {
            setState(() {
              _data['country'] = v ?? '';
              _data['state'] = '';
              _data['city'] = '';
            });
          },
        ),
        CustomDropdown(
          label: 'State',
          options: stateList,
          value: selectedState.isNotEmpty && stateList.contains(selectedState) ? selectedState : null,
          onChanged: (v) {
            setState(() {
              _data['state'] = v ?? '';
              _data['city'] = '';
            });
          },
        ),
        CustomDropdown(
          label: 'City',
          options: cityList,
          value: (_data['city']?.toString().trim() ?? '').isNotEmpty &&
                  cityList.contains(_data['city']?.toString().trim())
              ? _data['city']?.toString().trim()
              : null,
          onChanged: (v) => setState(() => _data['city'] = v ?? ''),
        ),
      ],
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
    final scheme = Theme.of(context).colorScheme;
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
              borderSide: BorderSide(color: scheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
            suffixIcon: Icon(Icons.calendar_today_outlined, color: scheme.primary),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              color: date != null ? scheme.onSurface : scheme.onSurfaceVariant,
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

  bool get _isBusinessSelected {
    final v = (_data['employmentType']?.toString() ?? '').toLowerCase();
    return v.contains('business') || v.contains('self employe');
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(icon, color: primary, size: 24),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: primary,
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
              _field('fullName', 'Full name (as per Govt ID)',
                  inputFormatters: [_alphabetsOnly],
                  validator: (v) => (v?.trim().isEmpty ?? true) ? null : RegExp(r'^[a-zA-Z\s]+$').hasMatch(v!.trim()) ? null : 'Only alphabets allowed'),
              _dropdown('gender', 'Gender', _opt('gender')),
              _dateOfBirthField(),
              _dropdown('bloodGroup', 'Blood group', _opt('bloodGroup')),
              _field('aadhaarOrPassport', 'Aadhaar Card Number (optional)',
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  inputFormatters: [_AadhaarFormatter()],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final digits = v.replaceAll(RegExp(r'\s'), '');
                    if (digits.length != 12) return 'Must be exactly 12 digits (xxxx xxxx xxxx)';
                    if (!RegExp(r'^\d{12}$').hasMatch(digits)) return 'Only digits allowed';
                    return null;
                  }),
              _locationDropdowns(),
              _field('pincode', 'Pincode',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    if (v.length != 6) return 'Must be exactly 6 digits';
                    if (!RegExp(r'^\d{6}$').hasMatch(v)) return 'Only digits allowed';
                    return null;
                  }),
              _field('fullResidentialAddress', 'Full address', maxLines: 3),
            ]),
            _section('Community & lineage', Icons.groups_outlined, [
              _dropdownWithOther('jainSect', 'Jain sect', _opt('jainSect'), 'jainSectOther', 'Specify Jain sect (required when Other)'),
              _dropdownWithOther('motherTongue', 'Mother tongue', _opt('motherTongue'), 'motherTongueOther', 'Specify mother tongue (required when Other)'),
            ]),
            _section('Education', Icons.school_outlined, [
              _dropdownWithOther('highestQualification', 'Highest qualification', _highestQualificationOptions, 'highestQualificationOther', 'Specify (required when Other)'),
              _dropdownWithOther('fieldOfStudy', 'Field of study', _opt('fieldOfStudy'), 'fieldOfStudyOther', 'Specify (required when Other)'),
              _field('institutionName', 'Institution / University'),
              _dropdown('yearOfPassing', 'Year of passing', _yearOptions()),
              _field('academicAchievements', 'Academic achievements'),
              _field('specialSkills', 'Special skills'),
            ]),
            _section('Professional & business', Icons.work_outline, [
              _dropdownWithOther('employmentType', 'Job or business?', _employmentTypeOptions, 'employmentTypeOther', 'Specify (required when Other)'),
              if (_isEmploymentJobOrBusiness) ...[
                _dropdownWithOther('industrySector', 'Industry you work in', _opt('industrySector'), 'industrySectorOther', 'Specify industry (required when Other)'),
                _field('companyName', 'Company / firm name'),
                _field('designation', 'Position / designation'),
                _field('workExperience', 'Work experience (e.g. 5 years)'),
                _field('workAddressCity', 'Work address / city'),
                if (_isBusinessSelected) _field('businessKeywords', 'Business keywords (for search)'),
              ],
              if (_isBusinessSelected) _dropdown('isEmployer', 'Are you an employer?', _opt('isEmployer')),
            ]),
            _section('Family', Icons.family_restroom_outlined, [
              _dropdown('maritalStatus', 'Marital status', _opt('maritalStatus')),
              _field('fatherName', 'Father\'s name',
                  inputFormatters: [_alphabetsOnly],
                  validator: (v) => (v?.trim().isEmpty ?? true) ? null : RegExp(r'^[a-zA-Z\s]+$').hasMatch(v!.trim()) ? null : 'Only alphabets allowed'),
              _field('fatherOccupation', 'Father\'s occupation'),
              _field('motherName', 'Mother\'s name',
                  inputFormatters: [_alphabetsOnly],
                  validator: (v) => (v?.trim().isEmpty ?? true) ? null : RegExp(r'^[a-zA-Z\s]+$').hasMatch(v!.trim()) ? null : 'Only alphabets allowed'),
              _field('motherOccupation', 'Mother\'s occupation'),
              if (!_isMaritalStatusSingle) ...[
                _field('spouseName', 'Spouse\'s name',
                    inputFormatters: [_alphabetsOnly],
                    validator: (v) => (v?.trim().isEmpty ?? true) ? null : RegExp(r'^[a-zA-Z\s]+$').hasMatch(v!.trim()) ? null : 'Only alphabets allowed'),
                _field('spouseOccupation', 'Spouse\'s occupation'),
                _field('numberOfChildren', 'Number of children',
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      if (v.length > 1) return 'Single digit (0-9) only';
                      if (!RegExp(r'^[0-9]$').hasMatch(v)) return 'Only 0-9 allowed';
                      return null;
                    }),
              ],
              _field('familySize', 'Total Family Members',
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 0 || n > 99) return 'Enter 0–99';
                    return null;
                  }),
            ]),
            _section('Contact & social', Icons.contact_phone_outlined, [
              _readOnly('Primary email', widget.profile.primaryEmail),
              _readOnly('Primary phone', widget.profile.primaryPhone),
              _field('alternateContactNumber', 'Alternate contact',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    if (!RegExp(r'^[0-9+\-\s]{10,15}$').hasMatch(v.trim())) return 'Enter valid phone number';
                    return null;
                  }),
              _field('additionalEmail', 'Additional email',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    if (!RegExp(r'^[\w\-.]+@[\w\-]+(\.[\w\-]+)*$').hasMatch(v.trim())) return 'Enter valid email';
                    return null;
                  }),
              _field('linkedInProfileLink', 'LinkedIn (paste link only)',
                  validator: (v) => _validateUrl(v, 'LinkedIn')),
              _field('instagramSocialLinks', 'Instagram (paste link only)',
                  validator: (v) => _validateUrl(v, 'Instagram')),
              _field('facebook', 'Facebook (paste link only)',
                  validator: (v) => _validateUrl(v, 'Facebook')),
              _field('twitter', 'Twitter (paste link only)',
                  validator: (v) => _validateUrl(v, 'Twitter')),
            ]),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_saving ? 'Saving...' : 'Save profile'),
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
