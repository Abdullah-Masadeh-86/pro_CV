import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../models/cv_models.dart';
import '../../services/firebase_service.dart';

class CreateCVScreen extends StatelessWidget {
  final CV? cv;
  
  const CreateCVScreen({super.key, this.cv});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cv == null ? 'Create New CV' : 'Edit CV'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: CVFormScreen(isEditing: cv != null, cv: cv),
    );
  }
}

class CVFormScreen extends StatefulWidget {
  final bool isEditing;
  final CV? cv;

  const CVFormScreen({super.key, required this.isEditing, this.cv});

  @override
  State<CVFormScreen> createState() => _CVFormScreenState();
}

class _CVFormScreenState extends State<CVFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _summaryController = TextEditingController();

  // Dynamic lists for work experience, education, and skills
  final List<WorkExperience> _workExperiences = [];
  final List<Education> _education = [];
  final List<Skill> _skills = [];

  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.cv != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final cv = widget.cv!;
    _titleController.text = cv.title;
    _firstNameController.text = cv.personalInfo.firstName;
    _lastNameController.text = cv.personalInfo.lastName;
    _emailController.text = cv.personalInfo.email;
    _phoneController.text = cv.personalInfo.phone;
    _addressController.text = cv.personalInfo.address;
    _cityController.text = cv.personalInfo.city;
    _countryController.text = cv.personalInfo.country;
    _postalCodeController.text = cv.personalInfo.postalCode;
    _websiteController.text = cv.personalInfo.website ?? '';
    _linkedinController.text = cv.personalInfo.linkedin ?? '';
    _githubController.text = cv.personalInfo.github ?? '';
    _summaryController.text = cv.personalInfo.summary;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildContactInfoSection(),
            const SizedBox(height: 24),
            _buildOnlinePresenceSection(),
            const SizedBox(height: 24),
            _buildSummarySection(),
            const SizedBox(height: 24),
            _buildWorkExperienceSection(),
            const SizedBox(height: 24),
            _buildEducationSection(),
            const SizedBox(height: 24),
            _buildSkillsSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'CV Title',
                hintText: 'e.g., Software Engineer CV',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a CV title';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your country';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your postal code';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlinePresenceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Online Presence',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website (Optional)',
                hintText: 'https://yourwebsite.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkedinController,
              decoration: const InputDecoration(
                labelText: 'LinkedIn (Optional)',
                hintText: 'https://linkedin.com/in/yourprofile',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _githubController,
              decoration: const InputDecoration(
                labelText: 'GitHub (Optional)',
                hintText: 'https://github.com/yourusername',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _summaryController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Summary',
                hintText: 'Write a brief professional summary about yourself...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a professional summary';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _isLoading
              ? const ElevatedButton(
                  onPressed: null,
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: _saveCV,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.isEditing ? 'Update CV' : 'Create CV'),
                ),
        ),
      ],
    );
  }

  Future<void> _saveCV() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = (context.read<AuthBloc>().state as Authenticated).user;
      final personalInfo = PersonalInfo(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        linkedin: _linkedinController.text.trim().isEmpty
            ? null
            : _linkedinController.text.trim(),
        github: _githubController.text.trim().isEmpty
            ? null
            : _githubController.text.trim(),
        summary: _summaryController.text.trim(),
      );

      final cv = CV(
        id: widget.isEditing ? widget.cv!.id : '',
        userId: user.uid,
        title: _titleController.text.trim(),
        personalInfo: personalInfo,
        education: _education,
        workExperience: _workExperiences,
        skills: _skills,
        template: 'modern',
        isPublic: false,
        createdAt: widget.isEditing ? widget.cv!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.isEditing) {
        await _firebaseService.updateCV(cv);
      } else {
        await _firebaseService.createCV(cv);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditing ? 'CV updated successfully' : 'CV created successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildWorkExperienceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work Experience',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Add at least one work experience to appear in your CV preview.'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addSampleWorkExperience,
              icon: const Icon(Icons.add),
              label: const Text('Add Sample Work Experience'),
            ),
            if (_workExperiences.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._workExperiences.map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• ${exp.position} at ${exp.company}'),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Education',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Add at least one education entry to appear in your CV preview.'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addSampleEducation,
              icon: const Icon(Icons.add),
              label: const Text('Add Sample Education'),
            ),
            if (_education.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._education.map((edu) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• ${edu.degree} in ${edu.field} at ${edu.institution}'),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Add skills to appear in your CV preview.'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addSampleSkills,
              icon: const Icon(Icons.add),
              label: const Text('Add Sample Skills'),
            ),
            if (_skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _skills.map((skill) => Chip(
                  label: Text(skill.name),
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addSampleWorkExperience() {
    setState(() {
      _workExperiences.add(
        WorkExperience(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          company: 'Tech Company',
          position: 'Software Engineer',
          startDate: '2022-01',
          endDate: '2024-01',
          current: false,
          description: 'Developed and maintained mobile applications.',
          achievements: ['Improved performance by 30%', 'Led a team of 3 developers'],
        ),
      );
    });
  }

  void _addSampleEducation() {
    setState(() {
      _education.add(
        Education(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          institution: 'University of Technology',
          degree: 'Bachelor of Science',
          field: 'Computer Science',
          startDate: '2018-09',
          endDate: '2022-06',
          gpa: '3.8',
          description: 'Focused on software engineering and algorithms.',
        ),
      );
    });
  }

  void _addSampleSkills() {
    setState(() {
      _skills.addAll([
        Skill(id: '1', name: 'Dart', level: 'Advanced', category: 'Programming'),
        Skill(id: '2', name: 'Flutter', level: 'Advanced', category: 'Framework'),
        Skill(id: '3', name: 'Firebase', level: 'Intermediate', category: 'Backend'),
      ]);
    });
  }
}
