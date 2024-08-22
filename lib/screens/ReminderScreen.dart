import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.plus),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddReminderScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('reminders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay recordatorios'));
                }

                final reminders = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder =
                        reminders[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          reminder['title'] ?? 'Sin título',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${reminder['description'] ?? ''}\n'
                          '${reminder['date'] ?? ''} ${reminder['time'] ?? ''}',
                          style: const TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: const Icon(FontAwesomeIcons.chevronRight),
                        onTap: () {
                          // Aquí puedes agregar lógica para ver detalles del recordatorio
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({Key? key}) : super(key: key);

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveReminder() async {
    if (_titleController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      try {
        await _firestore.collection('reminders').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'date': _selectedDate!.toIso8601String(),
          'time': _selectedTime!.format(context),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recordatorio guardado con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el recordatorio')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Recordatorio'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(FontAwesomeIcons.tag),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(FontAwesomeIcons.clipboard),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(FontAwesomeIcons.calendar),
              title: Text(
                _selectedDate == null
                    ? 'Seleccionar Fecha'
                    : _selectedDate!.toLocal().toString().split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(FontAwesomeIcons.clock),
              title: Text(
                _selectedTime == null
                    ? 'Seleccionar Hora'
                    : _selectedTime!.format(context),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: _pickTime,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveReminder,
              icon: const Icon(FontAwesomeIcons.save),
              label: const Text('Guardar Recordatorio'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
