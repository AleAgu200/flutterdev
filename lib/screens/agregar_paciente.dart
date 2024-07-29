import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/build_date_field.dart';
import '../widgets/build_dropdown_field.dart';
import '../widgets/build_text_field.dart';
import '../widgets/decimal_text_input_formatter.dart';
import '../services/database_helper.dart';
import '../models/patient.dart';

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
  final _formKey = GlobalKey<FormState>();

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
  final TextEditingController _ageYearsController = TextEditingController();
  final TextEditingController _ageMonthsController = TextEditingController();
  final TextEditingController _ageDaysController = TextEditingController();
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

  void _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
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

    setState(() {
      _isOlderThanTwoMonths = months >= 2;
    });
  }

  void _savePatient() async {
    final patient = Patient(
      identity: _identityController.text,
      expedient: _expedientController.text,
      dateOfAttention: _dateOfAttentionController.text,
      dateOfBirth: _dateOfBirthController.text,
      birthWeightKg: _birthWeightKgController.text.isNotEmpty
          ? double.parse(_birthWeightKgController.text)
          : null,
      birthWeightLb: _birthWeightLbController.text.isNotEmpty
          ? double.parse(_birthWeightLbController.text)
          : null,
      sex: _sex,
      isOlderThanTwoMonths: _isOlderThanTwoMonths ? 1 : 0,
      generateCuit: _generateCUIT ? 1 : 0,
      firstName: _firstNameController.text,
      secondName: _secondNameController.text,
      firstSurname: _firstSurnameController.text,
      secondSurname: _secondSurnameController.text,
      birthNumber: _birthNumberController.text,
      ageYears: _ageYearsController.text.isNotEmpty
          ? int.parse(_ageYearsController.text)
          : null,
      ageMonths: _ageMonthsController.text.isNotEmpty
          ? int.parse(_ageMonthsController.text)
          : null,
      ageDays: _ageDaysController.text.isNotEmpty
          ? int.parse(_ageDaysController.text)
          : null,
      currentWeightKg: _currentWeightKgController.text.isNotEmpty
          ? double.parse(_currentWeightKgController.text)
          : null,
      currentWeightLb: _currentWeightLbController.text.isNotEmpty
          ? double.parse(_currentWeightLbController.text)
          : null,
      heightCm: _heightController.text.isNotEmpty
          ? double.parse(_heightController.text)
          : null,
      problem: _problemController.text,
      cephalicPerimeter: _cephalicPerimeterController.text,
      bloodPressure: _bloodPressureController.text,
      pulse: _pulseController.text,
      oximetry: _oximetryController.text,
      temperature: _temperatureController.text.isNotEmpty
          ? double.parse(_temperatureController.text)
          : null,
      consultationType: _consultationType,
      region: _region,
      establishment: _establishmentController.text,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.insertPatient(patient);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Paciente guardado con éxito')));
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
              BuildDateField(
                label: 'Fecha de la atención',
                controller: _dateOfAttentionController,
              ),
              BuildTextField(
                label: 'Identidad del paciente',
                hint: 'Identidad del paciente',
                maxLength: 13,
                controller: _identityController,
              ),
              BuildTextField(
                label: 'No. Expediente',
                hint: 'No. Expediente',
                controller: _expedientController,
              ),
              BuildDateField(
                label: 'Fecha de nacimiento',
                controller: _dateOfBirthController,
                onDateSelected: (DateTime birthDate) {
                  _calculateAge(birthDate);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Peso al nacer (Kg)',
                      hint: 'Peso al nacer (Kg)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [DecimalTextInputFormatter()],
                      controller: _birthWeightKgController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Peso al nacer (Lb)',
                      hint: 'Peso al nacer (Lb)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [DecimalTextInputFormatter()],
                      controller: _birthWeightLbController,
                    ),
                  ),
                ],
              ),
              BuildDropdownField(
                label: 'Sexo del paciente',
                items: ['Masculino', 'Femenino'],
                onChanged: (newValue) {
                  setState(() {
                    _sex = newValue!;
                  });
                },
              ),
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
              BuildTextField(
                label: 'Primer Nombre del niño/a',
                hint: 'Primer Nombre',
                controller: _firstNameController,
              ),
              BuildTextField(
                label: 'Segundo Nombre del niño/a',
                hint: 'Segundo Nombre',
                controller: _secondNameController,
              ),
              BuildTextField(
                label: 'Primer Apellido del niño/a',
                hint: 'Primer Apellido',
                controller: _firstSurnameController,
              ),
              BuildTextField(
                label: 'Segundo Apellido del niño/a',
                hint: 'Segundo Apellido',
                controller: _secondSurnameController,
              ),
              BuildTextField(
                label: 'No. de nacimiento',
                hint: 'No. de nacimiento',
                controller: _birthNumberController,
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Edad en Años',
                      hint: 'Años',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _ageYearsController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Meses',
                      hint: 'Meses',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _ageMonthsController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Días',
                      hint: 'Días',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _ageDaysController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Peso actual (Kg)',
                      hint: 'Peso actual (Kg)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [DecimalTextInputFormatter()],
                      controller: _currentWeightKgController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Peso actual (Lb)',
                      hint: 'Peso actual (Lb)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [DecimalTextInputFormatter()],
                      controller: _currentWeightLbController,
                    ),
                  ),
                ],
              ),
              BuildTextField(
                label: 'Talla (cm)',
                hint: 'Talla (cm)',
                keyboardType: TextInputType.number,
                inputFormatters: [DecimalTextInputFormatter()],
                controller: _heightController,
              ),
              BuildTextField(
                label: '¿Qué problema tiene el niño/a?',
                hint: 'Problema',
                controller: _problemController,
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Perímetro Cefálico',
                      hint: 'P.C.',
                      controller: _cephalicPerimeterController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Presión Arterial',
                      hint: 'PA',
                      controller: _bloodPressureController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Pulso',
                      hint: 'Pulso',
                      controller: _pulseController,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: BuildTextField(
                      label: 'Oximetría',
                      hint: 'Oximetría',
                      controller: _oximetryController,
                    ),
                  ),
                ],
              ),
              BuildTextField(
                label: 'Temperatura (°C)',
                hint: 'Temperatura (°C)',
                controller: _temperatureController,
                inputFormatters: [DecimalTextInputFormatter()],
              ),
              BuildDropdownField(
                label: 'Consulta',
                items: ['Primera consulta', 'Seguimiento'],
                onChanged: (newValue) {
                  setState(() {
                    _consultationType = newValue!;
                  });
                },
              ),
              BuildDropdownField(
                label: 'Región del Establecimiento',
                items: ['Seleccionar región', 'Norte', 'Sur', 'Este', 'Oeste'],
                onChanged: (newValue) {
                  setState(() {
                    _region = newValue!;
                  });
                },
              ),
              BuildTextField(
                label: 'Establecimiento',
                hint: 'Establecimiento',
                controller: _establishmentController,
              ),
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
}
