class Report {
  final String reportId;
  final String reportType;
  final String? foundSubCategory;
  final String personName;
  final String personAge;
  final String personGender;
  final String personDescription;
  final String contactName;
  final String contactRelation;
  final String contact;
  final String dateLastSeen;
  final String locationLastSeen;
  final String city;
  final String personImage;
  final String reportedBy;
  //final DateTime createdAt;

  String get personGenderLowerCase => personGender.toLowerCase();

  Report({
    required this.reportId,
    required this.reportType,
    required this.foundSubCategory,
    required this.personName,
    required this.personAge,
    required this.personGender,
    required this.personDescription,
    required this.contactName,
    required this.contactRelation,
    required this.contact,
    required this.dateLastSeen,
    required this.locationLastSeen,
    required this.city,
    required this.personImage,
    required this.reportedBy,
   //required this.createdAt,
  });
  Report copyWith({
    String? personName,
    String? personAge,
    String? personGender,
    String? personDescription,
    String? dateLastSeen,
    String? contactName,
    String? contactRelation,
    String? contact,
    String? city,
    String? locationLastSeen,
    String? personImage,
    String? reportedBy,
  }) {
    return Report(
      reportId: reportId,
      reportType: reportType,
      foundSubCategory: foundSubCategory,
      personName: personName ?? this.personName,
      personAge: personAge ?? this.personAge,
      personGender: personGender ?? this.personGender,
      personDescription: personDescription ?? this.personDescription,
      dateLastSeen: dateLastSeen ?? this.dateLastSeen,
      contactName: contactName ?? this.contactName,
      contactRelation: contactRelation ?? this.contactRelation,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      locationLastSeen: locationLastSeen ?? this.locationLastSeen,
      personImage: personImage ?? this.personImage,
      reportedBy: reportedBy ?? this.reportedBy,
      //createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personName': personName,
      'personGender': personGender,
      'personAge': personAge,
      'contact':contact,
      'contactName': contactName,
      'locationLastSeen': locationLastSeen,
      'city':city,
      'dateLastSeen': dateLastSeen,

    };
  }
}