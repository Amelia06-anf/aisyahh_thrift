import 'package:flutter/material.dart';

class AddAddressForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const AddAddressForm({required this.onSave, required this.onCancel});

  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Negara'),
                validator: (value) =>
                    value!.isEmpty ? 'Harap isi negara' : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nama Awal'),
                validator: (value) =>
                    value!.isEmpty ? 'Harap isi nama awal' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nama Akhir'),
              ),
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) =>
                    value!.isEmpty ? 'Harap isi alamat' : null,
              ),
              TextFormField(
                controller: _addressLine2Controller,
                decoration:
                    const InputDecoration(labelText: 'Alamat 2 (Optional)'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Kota'),
                validator: (value) => value!.isEmpty ? 'Harap isi kota' : null,
              ),
              TextFormField(
                controller: _provinceController,
                decoration: const InputDecoration(labelText: 'Provinsi'),
                validator: (value) =>
                    value!.isEmpty ? 'Harap isi provinsi' : null,
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Kode Pos'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'No Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final addressData = {
                            'country': _countryController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                            'addressLine1': _addressLine1Controller.text,
                            'addressLine2': _addressLine2Controller.text,
                            'city': _cityController.text,
                            'province': _provinceController.text,
                            'postalCode': _postalCodeController.text,
                            'phone': _phoneController.text,
                          };
                          widget.onSave(addressData);
                        }
                      },
                      child: const Text('Tambah Alamat'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onCancel,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text('Batal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
