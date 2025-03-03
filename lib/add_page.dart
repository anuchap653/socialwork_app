import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/social_work.dart';
import '../provider/social_work_provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _hoursController = TextEditingController();
  DateTime _date = DateTime.now();
  String _category = 'กรุณาเลือกประเภท';
  
  final List<String> _categories = [
    'การศึกษา',
    'สุขภาพ',
    'สิ่งแวดล้อม',
    'สังคม',
  ];

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;
      final enteredHours = double.tryParse(_hoursController.text);

      if (enteredHours == null || enteredHours <= 0) {
        return;
      }

      final socialWork = SocialWork(
        title: enteredTitle,
        hours: enteredHours,
        date: _date,
        category: _category,
      );

      Provider.of<SocialWorkProvider>(context, listen: false)
          .addSocialWork(socialWork);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เพิ่มงานสังคม: $enteredTitle สำเร็จ')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('เพิ่มงานสังคม'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ชื่องานสังคม',
                  border: OutlineInputBorder(),
                ),
                controller: _titleController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่องานสังคม';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'จำนวนชั่วโมง',
                  border: OutlineInputBorder(),
                ),
                controller: _hoursController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกจำนวนชั่วโมง';
                  }
                  if (double.tryParse(value) == null) {
                    return 'กรุณากรอกตัวเลขที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('วันที่: ${_date.toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category == 'กรุณาเลือกประเภท' ? null : _category,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('กรุณาเลือกหมวดหมู่'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกหมวดหมู่';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'เพิ่มงานสังคม',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}