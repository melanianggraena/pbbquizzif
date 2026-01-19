import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup_step2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            /// PROGRESS
            _progressBar(0.4),

            const SizedBox(height: 24),

            /// TITLE
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
              "Please complete your profile.\nDon't worry, your data will remain private.",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            /// FIRST & LAST NAME
            Row(
              children: [
                Expanded(child: _underlineInput('First Name', 'Andrew')),
                const SizedBox(width: 16),
                Expanded(child: _underlineInput('Last Name', 'Ainsley')),
              ],
            ),

            const SizedBox(height: 24),
            _underlineInput('Email', 'andrew.ainsley@yourdomain.com'),

            const SizedBox(height: 24),
            _passwordInput(),

            const SizedBox(height: 16),

            /// REMEMBER
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v ?? true),
                  activeColor: const Color(0xFF2563EB),
                ),
                const Text('Remember me'),
              ],
            ),

            const SizedBox(height: 8),
            Center(child: Text('or', style: TextStyle(color: Colors.grey.shade500))),
            const SizedBox(height: 16),

            /// SOCIAL
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _social(Icons.g_mobiledata),
                const SizedBox(width: 16),
                _social(Icons.apple),
                const SizedBox(width: 16),
                _social(Icons.facebook),
              ],
            ),

            const SizedBox(height: 32),

            /// NEXT
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpStep2Screen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SIGN IN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",
                    style: TextStyle(color: Colors.grey.shade600)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

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

  Widget _underlineInput(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••••',
            border: const UnderlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF2563EB),
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
      ],
    );
  }

  Widget _social(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon),
    );
  }
}
