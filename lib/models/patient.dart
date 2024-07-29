class Patient {
  final String identity;
  final String expedient;
  final String dateOfAttention;
  final String dateOfBirth;
  final double? birthWeightKg;
  final double? birthWeightLb;
  final String sex;
  final int isOlderThanTwoMonths;
  final int generateCuit;
  final String firstName;
  final String secondName;
  final String firstSurname;
  final String secondSurname;
  final String birthNumber;
  final int? ageYears;
  final int? ageMonths;
  final int? ageDays;
  final double? currentWeightKg;
  final double? currentWeightLb;
  final double? heightCm;
  final String problem;
  final String cephalicPerimeter;
  final String bloodPressure;
  final String pulse;
  final String oximetry;
  final double? temperature;
  final String consultationType;
  final String region;
  final String establishment;

  Patient({
    required this.identity,
    required this.expedient,
    required this.dateOfAttention,
    required this.dateOfBirth,
    this.birthWeightKg,
    this.birthWeightLb,
    required this.sex,
    required this.isOlderThanTwoMonths,
    required this.generateCuit,
    required this.firstName,
    required this.secondName,
    required this.firstSurname,
    required this.secondSurname,
    required this.birthNumber,
    this.ageYears,
    this.ageMonths,
    this.ageDays,
    this.currentWeightKg,
    this.currentWeightLb,
    this.heightCm,
    required this.problem,
    required this.cephalicPerimeter,
    required this.bloodPressure,
    required this.pulse,
    required this.oximetry,
    this.temperature,
    required this.consultationType,
    required this.region,
    required this.establishment,
  });

  Map<String, Object?> toMap(Patient patient) {
    return {
      'name': '${patient.firstName} ${patient.firstSurname}',
      'identity': patient.identity,
      'expedient': patient.expedient,
      'dateOfAttention': patient.dateOfAttention,
      'dateOfBirth': patient.dateOfBirth,
      'birthWeightKg': patient.birthWeightKg,
      'birthWeightLb': patient.birthWeightLb,
      'sex': patient.sex,
    };
  }
}
