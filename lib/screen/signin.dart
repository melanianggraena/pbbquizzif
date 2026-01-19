import 'package:flutter/material.dart';
import '../main.dart'; // Untuk MainScreen
import 'signup.dart'; // Untuk navigasi ke SignUp
import 'signup_step1.dart';
import 'home.dart'; // Jika perlu, tapi di sini langsung ke MainScreen
import 'package:flutter_svg/flutter_svg.dart';




class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController(text: 'john@beyondlogic.ai');
  final _passwordController = TextEditingController();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// ROBOT ICON
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SvgPicture.asset(
                    'assets/signin.svg',
                    width: 52,
                    height: 52,
                  ),

                ),
              ),

              const SizedBox(height: 24),

              /// TITLE
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign in to ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'QUIZZIF',
                      style: TextStyle(color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// EMAIL
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'john@beyondlogic.ai',
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// PASSWORD
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••••',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF2563EB),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// REMEMBER + FORGOT
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) =>
                        setState(() => _rememberMe = v ?? true),
                    activeColor: const Color(0xFF2563EB),
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// SIGN IN BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// OR
              Center(
                child: Text(
                  'or',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),

              const SizedBox(height: 16),

              /// SOCIAL LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(Icons.g_mobiledata),
                  const SizedBox(width: 16),
                  _socialButton(Icons.apple),
                  const SizedBox(width: 16),
                  _socialButton(Icons.facebook),
                ],
              ),

              const SizedBox(height: 24),

              /// SIGN UP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
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
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 24),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);


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
            const SizedBox(height: 24),

            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SvgPicture.asset(
                  'assets/forgotpw.svg',
                  width: 52,
                  height: 52,
                ),

              ),
            ),

            const SizedBox(height: 24),

            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: 'Forgot ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Password',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Enter your email address to get an OTP code to reset your password.',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'john@beyondlogic.ai',
                border: UnderlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignInOtpScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2563EB), // BIRU
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}






// OTP


class SignInOtpScreen extends StatelessWidget {
  const SignInOtpScreen({Key? key}) : super(key: key);

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
          children: [
            const SizedBox(height: 32),

            SvgPicture.asset(
              'assets/mail.svg',
              width: 120,
            ),

            const SizedBox(height: 32),

            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(text: "You've got "),
                  TextSpan(
                    text: 'mail',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  TextSpan(text: ' 📩'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'We have sent the OTP verification code to your email address. '
              'Check your email and enter the code below.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _otpBox()),
            ),

            const SizedBox(height: 24),

            Text(
              "Didn't receive email?",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            const Text(
              "You can resend code in 55 s",
              style: TextStyle(color: Color(0xFF2563EB)),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateNewPasswordScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'CONFIRM',
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

  Widget _otpBox() {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Text(
        '•',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}



//========================
// Create new password
//===============================

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;

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
            const SizedBox(height: 32),

            SvgPicture.asset(
              'assets/newpassword.svg',
              width: 120,
            ),

            const SizedBox(height: 24),

            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(text: 'Create new '),
                  TextSpan(
                    text: 'password',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                  TextSpan(text: ' 🔐'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Save the new password in a safe place, if you forget it then you have to do a forgot password again.',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            const Text('Create a new password',
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              obscureText: _obscure1,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure1
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF2563EB),
                  ),
                  onPressed: () =>
                      setState(() => _obscure1 = !_obscure1),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text('Confirm a new password',
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(
              obscureText: _obscure2,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure2
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF2563EB),
                  ),
                  onPressed: () =>
                      setState(() => _obscure2 = !_obscure2),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignInSuccessScreen(),
                    ),
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
          ],
        ),
      ),
    );
  }
}




//==========================
//Welcome Back (Success)
//=======================



class SignInSuccessScreen extends StatelessWidget {
  const SignInSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/sukses.svg',
                width: 120,
              ),

              const SizedBox(height: 24),

              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You have successfully reset and created a new password.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'GO TO HOME',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
