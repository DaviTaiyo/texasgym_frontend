import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final int age;
  final double height;
  final double weight;
  final File? profileImage;

  ProfileScreen({
    required this.name,
    required this.phone,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.profileImage,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String phone;
  late String email;
  late int age;
  late double height;
  late double weight;
  late File? profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phone = widget.phone;
    email = widget.email;
    age = widget.age;
    height = widget.height;
    weight = widget.weight;
    profileImage = widget.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nome'),
              subtitle: Text(name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Nome', name, (value) {
                  setState(() {
                    name = value;
                  });
                }),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone'),
              subtitle: Text(phone),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Telefone', phone, (value) {
                  setState(() {
                    phone = value;
                  });
                }),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Email', email, (value) {
                  setState(() {
                    email = value;
                  });
                }),
              ),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Idade'),
              subtitle: Text('$age anos'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Idade', '$age', (value) {
                  setState(() {
                    age = int.parse(value);
                  });
                }),
              ),
            ),
            ListTile(
              leading: Icon(Icons.height),
              title: Text('Altura'),
              subtitle: Text('${height.toStringAsFixed(2)} m'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Altura', height.toString(), (value) {
                  setState(() {
                    height = double.parse(value);
                  });
                }),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Peso'),
              subtitle: Text('${weight.toStringAsFixed(1)} kg'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editField(context, 'Peso', weight.toString(), (value) {
                  setState(() {
                    weight = double.parse(value);
                  });
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          Navigator.pop(context, {
            'name': name,
            'phone': phone,
            'email': email,
            'age': age,
            'height': height,
            'weight': weight,
            'profileImage': profileImage,
          });
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  void _editField(BuildContext context, String fieldName, String currentValue, Function(String) onValueChanged) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $fieldName'),
          content: TextField(
            controller: controller,
            keyboardType: fieldName == 'Idade' ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              labelText: fieldName,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                onValueChanged(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
