import 'package:flutter/material.dart';
import 'database_create.dart'; // Make sure this path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patients List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientsListPage(),
    );
  }
}

class PatientsListPage extends StatefulWidget {
  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  late Future<List<Map<String, dynamic>>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = DatabaseHelper().getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final patient = snapshot.data![index];
                return ListTile(
                  title: Text(
                      '${patient['first_name']} ${patient['first_surname']}'),
                  subtitle: Text('ID: ${patient['identity']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => _showPatientDetails(context, patient),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showPatientDetails(BuildContext context, Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${patient['first_name']} ${patient['first_surname']}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ID: ${patient['identity']}'),
                Text('Expedient: ${patient['expedient']}'),
                Text('Date of Attention: ${patient['date_of_attention']}'),
                Text('Date of Birth: ${patient['date_of_birth']}'),
                Text('Birth Weight (kg): ${patient['birth_weight_kg']}'),
                Text('Birth Weight (lb): ${patient['birth_weight_lb']}'),
                Text('Sex: ${patient['sex']}'),
                Text(
                    'Is Older Than Two Months: ${patient['is_older_than_two_months']}'),
                Text('Generate CUIT: ${patient['generate_cuit']}'),
                Text('First Name: ${patient['first_name']}'),
                Text('Second Name: ${patient['second_name']}'),
                Text('First Surname: ${patient['first_surname']}'),
                Text('Second Surname: ${patient['second_surname']}'),
                Text('Birth Number: ${patient['birth_number']}'),
                Text('Age (Years): ${patient['age_years']}'),
                Text('Age (Months): ${patient['age_months']}'),
                Text('Age (Days): ${patient['age_days']}'),
                Text('Current Weight (kg): ${patient['current_weight_kg']}'),
                Text('Current Weight (lb): ${patient['current_weight_lb']}'),
                Text('Height (cm): ${patient['height_cm']}'),
                Text('Problem: ${patient['problem']}'),
                Text('Cephalic Perimeter: ${patient['cephalic_perimeter']}'),
                Text('Blood Pressure: ${patient['blood_pressure']}'),
                Text('Pulse: ${patient['pulse']}'),
                Text('Oximetry: ${patient['oximetry']}'),
                Text('Temperature: ${patient['temperature']}'),
                Text('Consultation Type: ${patient['consultation_type']}'),
                Text('Region: ${patient['region']}'),
                Text('Establishment: ${patient['establishment']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
