import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database_create.dart'; // Ensure this path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agregar Paciente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Spanish, no country code
        // Add other supported locales here
      ],
      home: AgregarPaciente(),
    );
  }
}

class AgregarPaciente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Paciente'),
      ),
      body: PatientForm(),
    );
  }
}

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  void _updateCheckboxState(bool newValue) {
    setState(() {
      _isOlderThanTwoMonths = newValue;
    });
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _dateOfAttentionController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _expedientController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _firstSurnameController = TextEditingController();
  final TextEditingController _secondSurnameController =
      TextEditingController();
  final TextEditingController _birthNumberController = TextEditingController();
  /* edad */
  final TextEditingController _ageYearsController = TextEditingController();
  final TextEditingController _ageMonthsController = TextEditingController();
  final TextEditingController _ageDaysController = TextEditingController();
  /* edad */
  final TextEditingController _birthWeightKgController =
      TextEditingController();
  final TextEditingController _birthWeightLbController =
      TextEditingController();
  final TextEditingController _currentWeightKgController =
      TextEditingController();
  final TextEditingController _currentWeightLbController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _cephalicPerimeterController =
      TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _pulseController = TextEditingController();
  final TextEditingController _oximetryController = TextEditingController();
  final TextEditingController _establishmentController =
      TextEditingController();

  bool _isOlderThanTwoMonths = false;
  bool _generateCUIT = false;

  String _sex = 'Masculino';
  String _consultationType = 'Primera consulta';
  String _region = 'Seleccionar región';
  void _calculateAge(DateTime birthDate) {
    print('Calculating age');
    print(birthDate);

    DateTime today = DateTime.now();
    print(birthDate.year);
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    int days = today.day - birthDate.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(today.year, today.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    _ageYearsController.text = years.toString();
    _ageMonthsController.text = months.toString();
    _ageDaysController.text = days.toString();

    _isOlderThanTwoMonths =
        months >= 2 && today.day >= 15 && today.month >= today.year % 100 == 2
            ? true
            : false;

    _updateCheckboxState(_isOlderThanTwoMonths);
  }

  @override
  void initState() {
    super.initState();
    _birthWeightKgController.addListener(_updateBirthWeightLb);
    _birthWeightLbController.addListener(_updateBirthWeightKg);
    _currentWeightKgController.addListener(_updateCurrentWeightLb);
    _currentWeightLbController.addListener(_updateCurrentWeightKg);
  }

  @override
  void dispose() {
    _birthWeightKgController.removeListener(_updateBirthWeightLb);
    _birthWeightLbController.removeListener(_updateBirthWeightKg);
    _currentWeightKgController.removeListener(_updateCurrentWeightLb);
    _currentWeightLbController.removeListener(_updateCurrentWeightKg);
    _birthWeightKgController.dispose();
    _birthWeightLbController.dispose();
    _currentWeightKgController.dispose();
    _currentWeightLbController.dispose();
    super.dispose();
  }

  void _updateBirthWeightKg() {
    if (_birthWeightLbController.text.isNotEmpty) {
      final weightLb = double.tryParse(_birthWeightLbController.text);
      if (weightLb != null) {
        final weightKg = (weightLb / 2.20462).toStringAsFixed(2);

        _birthWeightKgController.removeListener(_updateBirthWeightLb);
        _birthWeightKgController.value =
            _birthWeightKgController.value.copyWith(
          text: weightKg,
          selection: TextSelection.collapsed(offset: weightKg.length),
        );
        _birthWeightKgController.addListener(_updateBirthWeightLb);
      }
    }
  }

  void _updateBirthWeightLb() {
    if (_birthWeightKgController.text.isNotEmpty) {
      final weightKg = double.tryParse(_birthWeightKgController.text);
      if (weightKg != null) {
        final weightLb = (weightKg * 2.20462).toStringAsFixed(2);

        _birthWeightLbController.removeListener(_updateBirthWeightKg);
        _birthWeightLbController.value =
            _birthWeightLbController.value.copyWith(
          text: weightLb,
          selection: TextSelection.collapsed(offset: weightLb.length),
        );
        _birthWeightLbController.addListener(_updateBirthWeightKg);
      }
    }
  }

  void _updateCurrentWeightKg() {
    if (_currentWeightLbController.text.isNotEmpty) {
      final weightLb = double.tryParse(_currentWeightLbController.text);
      if (weightLb != null) {
        final weightKg = (weightLb / 2.20462).toStringAsFixed(2);

        _currentWeightKgController.removeListener(_updateCurrentWeightLb);
        _currentWeightKgController.value =
            _currentWeightKgController.value.copyWith(
          text: weightKg,
          selection: TextSelection.collapsed(offset: weightKg.length),
        );
        _currentWeightKgController.addListener(_updateCurrentWeightLb);
      }
    }
  }

  void _updateCurrentWeightLb() {
    if (_currentWeightKgController.text.isNotEmpty) {
      final weightKg = double.tryParse(_currentWeightKgController.text);
      if (weightKg != null) {
        final weightLb = (weightKg * 2.20462).toStringAsFixed(2);

        _currentWeightLbController.removeListener(_updateCurrentWeightKg);
        _currentWeightLbController.value =
            _currentWeightLbController.value.copyWith(
          text: weightLb,
          selection: TextSelection.collapsed(offset: weightLb.length),
        );
        _currentWeightLbController.addListener(_updateCurrentWeightKg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDateField(
                  'Fecha de la atención', _dateOfAttentionController, null),
              buildTextField('Identidad del paciente', 'Identidad del paciente',
                  maxLength: 13, controller: _identityController),
              buildTextField('No. Expediente', 'No. Expediente',
                  controller: _expedientController),
              buildDateField('Fecha de nacimiento', _dateOfBirthController,
                  (DateTime birthDate) {
                _calculateAge(birthDate);
              }),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                        'Peso al nacer (Kg)', 'Peso al nacer (Kg)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [DecimalTextInputFormatter()],
                        controller: _birthWeightKgController),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: buildTextField(
                        'Peso al nacer (Lb)', 'Peso al nacer (Lb)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [DecimalTextInputFormatter()],
                        controller: _birthWeightLbController),
                  ),
                ],
              ),
              buildDropdownField(
                  'Sexo del paciente', ['Masculino', 'Femenino']),
              CheckboxListTile(
                title: Text('¿Es mayor de dos meses?'),
                value: _isOlderThanTwoMonths,
                onChanged: (newValue) {
                  setState(() {
                    _isOlderThanTwoMonths = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('¿Desea generar CUI-T?'),
                value: _generateCUIT,
                onChanged: (newValue) {
                  setState(() {
                    _generateCUIT = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              buildTextField('Primer Nombre del niño/a', 'Primer Nombre',
                  controller: _firstNameController),
              buildTextField('Segundo Nombre del niño/a', 'Segundo Nombre',
                  controller: _secondNameController),
              buildTextField('Primer Apellido del niño/a', 'Primer Apellido',
                  controller: _firstSurnameController),
              buildTextField('Segundo Apellido del niño/a', 'Segundo Apellido',
                  controller: _secondSurnameController),
              buildTextField('No. de nacimiento', 'No. de nacimiento',
                  controller: _birthNumberController),
              Row(
                children: [
                  Expanded(
                      child: buildTextField('Edad en Años', 'Años',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _ageYearsController)),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: buildTextField('Meses', 'Meses',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _ageMonthsController)),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: buildTextField('Días', 'Días',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _ageDaysController)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                        'Peso actual (Kg)', 'Peso actual (Kg)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [DecimalTextInputFormatter()],
                        controller: _currentWeightKgController),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: buildTextField(
                        'Peso actual (Lb)', 'Peso actual (Lb)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [DecimalTextInputFormatter()],
                        controller: _currentWeightLbController),
                  ),
                ],
              ),
              buildTextField('Talla (cm)', 'Talla (cm)',
                  keyboardType: TextInputType.number,
                  inputFormatters: [DecimalTextInputFormatter()],
                  controller: _heightController),
              buildTextField('¿Qué problema tiene el niño/a?', 'Problema',
                  controller: _problemController),
              Row(
                children: [
                  Expanded(
                    child: buildTextField('Perímetro Cefálico', 'P.C.',
                        controller: _cephalicPerimeterController),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: buildTextField('Presión Arterial', 'PA',
                        controller: _bloodPressureController),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField('Pulso', 'Pulso',
                        controller: _pulseController),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: buildTextField('Oximetría', 'Oximetría',
                        controller: _oximetryController),
                  ),
                ],
              ),
              buildTextField('Temperatura (°C)', 'Temperatura (°C)',
                  controller: _temperatureController,
                  inputFormatters: [DecimalTextInputFormatter()]),
              buildDropdownField(
                  'Consulta', ['Primera consulta', 'Seguimiento']),
              buildDropdownField('Región del Establecimiento',
                  ['Seleccionar región', 'Norte', 'Sur', 'Este', 'Oeste']),
              buildTextField('Establecimiento', 'Establecimiento',
                  controller: _establishmentController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _savePatient();
                    }
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint,
      {TextInputType? keyboardType,
      int? maxLength,
      TextEditingController? controller,
      List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Por favor ingrese $hint';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller,
      Function(DateTime)? onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
            onDateSelected!(pickedDate);
          }
        },
        readOnly: true,
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            if (label == 'Sexo del paciente') {
              _sex = newValue!;
            } else if (label == 'Consulta') {
              _consultationType = newValue!;
            } else if (label == 'Región del Establecimiento') {
              _region = newValue!;
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor seleccione una opción';
          }
          return null;
        },
      ),
    );
  }

  void _savePatient() async {
    final patient = {
      'identity': _identityController.text,
      'expedient': _expedientController.text,
      'date_of_attention': _dateOfAttentionController.text,
      'date_of_birth': _dateOfBirthController.text,
      'birth_weight_kg': _birthWeightKgController.text.isNotEmpty
          ? double.parse(_birthWeightKgController.text)
          : null,
      'birth_weight_lb': _birthWeightLbController.text.isNotEmpty
          ? double.parse(_birthWeightLbController.text)
          : null,
      'sex': _sex,
      'is_older_than_two_months': _isOlderThanTwoMonths ? 1 : 0,
      'generate_cuit': _generateCUIT ? 1 : 0,
      'first_name': _firstNameController.text,
      'second_name': _secondNameController.text,
      'first_surname': _firstSurnameController.text,
      'second_surname': _secondSurnameController.text,
      'birth_number': _birthNumberController.text,
      'age_years': _ageYearsController.text.isNotEmpty
          ? int.parse(_ageYearsController.text)
          : null,
      'age_months': _ageMonthsController.text.isNotEmpty
          ? int.parse(_ageMonthsController.text)
          : null,
      'age_days': _ageDaysController.text.isNotEmpty
          ? int.parse(_ageDaysController.text)
          : null,
      'current_weight_kg': _currentWeightKgController.text.isNotEmpty
          ? double.parse(_currentWeightKgController.text)
          : null,
      'current_weight_lb': _currentWeightLbController.text.isNotEmpty
          ? double.parse(_currentWeightLbController.text)
          : null,
      'height_cm': _heightController.text.isNotEmpty
          ? double.parse(_heightController.text)
          : null,
      'problem': _problemController.text,
      'cephalic_perimeter': _cephalicPerimeterController.text,
      'blood_pressure': _bloodPressureController.text,
      'pulse': _pulseController.text,
      'oximetry': _oximetryController.text,
      'temperature': _temperatureController.text.isNotEmpty
          ? double.parse(_temperatureController.text)
          : null,
      'consultation_type': _consultationType,
      'region': _region,
      'establishment': _establishmentController.text
    };

    final dbHelper = DatabaseHelper();
    await dbHelper.insertPatient(patient);

    // Show confirmation or navigate back
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Paciente guardado con éxito')));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    // Allow only digits and one decimal point
    if (RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return newValue;
    }
    return oldValue;
  }
}
