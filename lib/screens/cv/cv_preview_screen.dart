import 'package:flutter/material.dart';
import '../../models/cv_models.dart';

class CVPreviewScreen extends StatelessWidget {
  final CV cv;

  const CVPreviewScreen({
    super.key,
    required this.cv,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: ${cv.title}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          double maxWidth;
          EdgeInsets padding;

          if (width >= 1000) {
            maxWidth = 800;
            padding = const EdgeInsets.all(32);
          } else if (width >= 600) {
            maxWidth = 600;
            padding = const EdgeInsets.all(24);
          } else {
            maxWidth = double.infinity;
            padding = const EdgeInsets.all(16);
          }

          final content = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: width >= 1000
                ? Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: _buildCVContent(),
                    ),
                  )
                : _buildCVContent(),
          );

          return SingleChildScrollView(
            padding: padding,
            child: Center(child: content),
          );
        },
      ),
    );
  }

  Widget _buildCVContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSummary(),
        const SizedBox(height: 24),
        _buildSection('Work Experience', _buildWorkExperience()),
        const SizedBox(height: 24),
        _buildSection('Education', _buildEducation()),
        const SizedBox(height: 24),
        _buildSection('Skills', _buildSkills()),
        if (cv.personalInfo.website != null ||
            cv.personalInfo.linkedin != null ||
            cv.personalInfo.github != null) ...[
          const SizedBox(height: 24),
          _buildSection('Online Presence', _buildOnlinePresence()),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cv.personalInfo.firstName} ${cv.personalInfo.lastName}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        if (cv.personalInfo.phone.isNotEmpty)
          Text(
            cv.personalInfo.phone,
            style: const TextStyle(fontSize: 16),
          ),
        if (cv.personalInfo.email.isNotEmpty)
          Text(
            cv.personalInfo.email,
            style: const TextStyle(fontSize: 16),
          ),
        if (cv.personalInfo.address.isNotEmpty)
          Text(
            '${cv.personalInfo.address}, ${cv.personalInfo.city}, ${cv.personalInfo.country}',
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Professional Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cv.personalInfo.summary,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildWorkExperience() {
    if (cv.workExperience.isEmpty) {
      return const Text('No work experience added yet.');
    }

    return Column(
      children: cv.workExperience.map((experience) {
        return _buildExperienceCard(experience);
      }).toList(),
    );
  }

  Widget _buildExperienceCard(WorkExperience experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  experience.position,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${experience.startDate} - ${experience.current ? 'Present' : experience.endDate}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            experience.company,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            experience.description,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          if (experience.achievements.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...experience.achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      achievement,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildEducation() {
    if (cv.education.isEmpty) {
      return const Text('No education added yet.');
    }

    return Column(
      children: cv.education.map((education) {
        return _buildEducationCard(education);
      }).toList(),
    );
  }

  Widget _buildEducationCard(Education education) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.degree,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            education.institution,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${education.field} • ${education.startDate} - ${education.endDate}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (education.gpa != null) ...[
            const SizedBox(height: 4),
            Text(
              'GPA: ${education.gpa}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkills() {
    if (cv.skills.isEmpty) {
      return const Text('No skills added yet.');
    }

    final skillsByCategory = <String, List<Skill>>{};
    for (final skill in cv.skills) {
      if (!skillsByCategory.containsKey(skill.category)) {
        skillsByCategory[skill.category] = [];
      }
      skillsByCategory[skill.category]!.add(skill);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skillsByCategory.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entry.value.map((skill) {
                return Chip(
                  label: Text(skill.name),
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: Colors.blue),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOnlinePresence() {
    return Column(
      children: [
        if (cv.personalInfo.website != null)
          _buildOnlineLink(Icons.language, 'Website', cv.personalInfo.website!),
        if (cv.personalInfo.linkedin != null)
          _buildOnlineLink(Icons.work, 'LinkedIn', cv.personalInfo.linkedin!),
        if (cv.personalInfo.github != null)
          _buildOnlineLink(Icons.code, 'GitHub', cv.personalInfo.github!),
      ],
    );
  }

  Widget _buildOnlineLink(IconData icon, String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            '$label: $url',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
