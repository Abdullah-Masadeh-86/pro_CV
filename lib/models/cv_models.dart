import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final String? website;
  final String? linkedin;
  final String? github;
  final String summary;

  const PersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    this.website,
    this.linkedin,
    this.github,
    required this.summary,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        address,
        city,
        country,
        postalCode,
        website,
        linkedin,
        github,
        summary,
      ];

  PersonalInfo copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? website,
    String? linkedin,
    String? github,
    String? summary,
  }) {
    return PersonalInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'website': website,
      'linkedin': linkedin,
      'github': github,
      'summary': summary,
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'] ?? '',
      website: map['website'],
      linkedin: map['linkedin'],
      github: map['github'],
      summary: map['summary'] ?? '',
    );
  }
}

class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final String startDate;
  final String endDate;
  final String? gpa;
  final String? description;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    required this.endDate,
    this.gpa,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        institution,
        degree,
        field,
        startDate,
        endDate,
        gpa,
        description,
      ];

  Education copyWith({
    String? id,
    String? institution,
    String? degree,
    String? field,
    String? startDate,
    String? endDate,
    String? gpa,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      field: field ?? this.field,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institution': institution,
      'degree': degree,
      'field': field,
      'startDate': startDate,
      'endDate': endDate,
      'gpa': gpa,
      'description': description,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      id: map['id'] ?? '',
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      field: map['field'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      gpa: map['gpa'],
      description: map['description'],
    );
  }
}

class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String startDate;
  final String endDate;
  final bool current;
  final String description;
  final List<String> achievements;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.current,
    required this.description,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        id,
        company,
        position,
        startDate,
        endDate,
        current,
        description,
        achievements,
      ];

  WorkExperience copyWith({
    String? id,
    String? company,
    String? position,
    String? startDate,
    String? endDate,
    bool? current,
    String? description,
    List<String>? achievements,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      current: current ?? this.current,
      description: description ?? this.description,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'current': current,
      'description': description,
      'achievements': achievements,
    };
  }

  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      id: map['id'] ?? '',
      company: map['company'] ?? '',
      position: map['position'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      current: map['current'] ?? false,
      description: map['description'] ?? '',
      achievements: List<String>.from(map['achievements'] ?? []),
    );
  }
}

class Skill extends Equatable {
  final String id;
  final String name;
  final String level;
  final String category;

  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, level, category];

  Skill copyWith({
    String? id,
    String? name,
    String? level,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      level: map['level'] ?? '',
      category: map['category'] ?? '',
    );
  }
}

class CV extends Equatable {
  final String id;
  final String userId;
  final String title;
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<WorkExperience> workExperience;
  final List<Skill> skills;
  final String template;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CV({
    required this.id,
    required this.userId,
    required this.title,
    required this.personalInfo,
    required this.education,
    required this.workExperience,
    required this.skills,
    required this.template,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        personalInfo,
        education,
        workExperience,
        skills,
        template,
        isPublic,
        createdAt,
        updatedAt,
      ];

  CV copyWith({
    String? id,
    String? userId,
    String? title,
    PersonalInfo? personalInfo,
    List<Education>? education,
    List<WorkExperience>? workExperience,
    List<Skill>? skills,
    String? template,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CV(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      skills: skills ?? this.skills,
      template: template ?? this.template,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'personalInfo': personalInfo.toMap(),
      'education': education.map((x) => x.toMap()).toList(),
      'workExperience': workExperience.map((x) => x.toMap()).toList(),
      'skills': skills.map((x) => x.toMap()).toList(),
      'template': template,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CV.fromMap(Map<String, dynamic> map) {
    return CV(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      personalInfo: PersonalInfo.fromMap(map['personalInfo']),
      education: List<Education>.from(
          map['education']?.map((x) => Education.fromMap(x)) ?? []),
      workExperience: List<WorkExperience>.from(
          map['workExperience']?.map((x) => WorkExperience.fromMap(x)) ?? []),
      skills: List<Skill>.from(
          map['skills']?.map((x) => Skill.fromMap(x)) ?? []),
      template: map['template'] ?? '',
      isPublic: map['isPublic'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
