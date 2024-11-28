import 'package:flutter/material.dart';

void main() {
  runApp(ContactsApp());
}

class ContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactsScreen(),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, String>> records = [];

  void addRecord(Map<String, String> newRecord) {
    setState(() => records.add(newRecord));
  }

  void deleteRecord(int index) {
    setState(() => records.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.yellow),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Organizer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_box_rounded, color: Colors.green),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRecordScreen(onAddRecord: addRecord),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final initials = record['firstName']![0] + record['lastName']![0];
                  return Card(
                    color: Colors.lightBlue[50],
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(initials, style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
                      title: Text("${record['firstName']} ${record['lastName']}", style: TextStyle(color: Colors.blue)),
                      subtitle: Text(record['phoneNumber']!, style: TextStyle(color: Colors.black54)),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordDetailsScreen(record: record),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirm Delete", style: TextStyle(color: Colors.red)),
                            content: Text("Are you sure you want to delete this record?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  deleteRecord(index);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRecordScreen extends StatelessWidget {
  final Function(Map<String, String>) onAddRecord;

  AddRecordScreen({required this.onAddRecord});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Add Record',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildTextField("First Name", firstNameController),
              buildTextField("Last Name", lastNameController),
              buildTextField("Phone Number", phoneNumberController),
              buildTextField("Address", addressController),
              buildTextField("Email", emailController),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text("Add Record"),
                onPressed: () {
                  onAddRecord({
                    'firstName': firstNameController.text,
                    'lastName': lastNameController.text,
                    'phoneNumber': phoneNumberController.text,
                    'address': addressController.text,
                    'email': emailController.text,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class RecordDetailsScreen extends StatelessWidget {
  final Map<String, String> record;

  RecordDetailsScreen({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Record Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildReadOnlyField("First Name", record['firstName']!),
              buildReadOnlyField("Last Name", record['lastName']!),
              buildReadOnlyField("Phone Number", record['phoneNumber']!),
              buildReadOnlyField("Address", record['address']!),
              buildReadOnlyField("Email", record['email']!),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
