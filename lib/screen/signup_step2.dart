import 'package:flutter/material.dart';
import 'signin.dart';


class SignUpStep2Screen extends StatefulWidget {
  const SignUpStep2Screen({Key? key}) : super(key: key);

  @override
  State<SignUpStep2Screen> createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  final TextEditingController _dobController = TextEditingController();

  String _selectedCountry = 'United States';
  String _selectedGender = 'Male';

  final List<String> _countries = ['United States', 'Indonesia'];
  final List<String> _genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _progressBar(0.8),

            const SizedBox(height: 24),

            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(text: 'Create an ', style: TextStyle(color: Colors.black)),
                  TextSpan(text: 'account', style: TextStyle(color: Color(0xFF2563EB))),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Please enter your username, date of birth and country.',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            _underlineInput(
              label: 'Username',
              hint: 'andrew_ainsley',
              suffix: const Icon(Icons.check, color: Color(0xFF2563EB)),
            ),

            const SizedBox(height: 24),

            /// DATE OF BIRTH (CALENDAR)
            _datePickerInput(),

            const SizedBox(height: 24),

            /// COUNTRY DROPDOWN
            _dropdownInput(
              label: 'Country',
              value: _selectedCountry,
              items: _countries,
              onChanged: (val) {
                setState(() => _selectedCountry = val!);
              },
            ),

            const SizedBox(height: 24),

            /// GENDER DROPDOWN
            _dropdownInput(
              label: 'Gender',
              value: _selectedGender,
              items: _genders,
              onChanged: (val) {
                setState(() => _selectedGender = val!);
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  _showSuccess(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _progressBar(double value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: Colors.grey.shade200,
        valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
      ),
    );
  }

  Widget _underlineInput({
    required String label,
    required String hint,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  /// DATE PICKER FIELD
  Widget _datePickerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          controller: _dobController,
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(1995),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if (picked != null) {
              _dobController.text =
                '${picked.month.toString().padLeft(2, '0')}/'
                '${picked.day.toString().padLeft(2, '0')}/'
                '${picked.year}';

            }
          },
          decoration: const InputDecoration(
            hintText: '12/27/1995',
            border: UnderlineInputBorder(),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Color(0xFF2563EB),
            ),
          ),
        ),
      ],
    );
  }

  /// DROPDOWN FIELD (COUNTRY & GENDER)
  Widget _dropdownInput({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF2563EB)),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ================= SUCCESS DIALOG =================

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF4FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy,
                    size: 48, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait a moment, we are preparing for you...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Color(0xFF2563EB)),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    });
  }
}
