import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }


  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 4) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final String userEmail = ModalRoute.of(context)?.settings.arguments as String? ?? "your email";

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      body: SafeArea(
        child: SingleChildScrollView( // لحماية التصميم من الـ Keyboard Overflow
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildBackButton(context),
              const SizedBox(height: 40),
              const Text("Check your email", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3B5BB5))),
              const SizedBox(height: 16),


              Text(
                "We sent a reset link to $userEmail\nEnter 5 digit code that mentioned in the email",
                style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 40),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) => _buildOtpSlot(index)),
              ),

              const SizedBox(height: 40),


              _buildVerifyButton(userEmail),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSlot(int index) {
    return SizedBox(
      width: 55,
      height: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF6C8CE3), width: 2)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF3B5BB5), width: 2)),
        ),
        onChanged: (value) => _onCodeChanged(value, index),
      ),
    );
  }

  Widget _buildVerifyButton(String email) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF719EFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: _isLoading ? null : () => _handleVerify(email),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Verify Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF))),
      ),
    );
  }


  Future<void> _handleVerify(String email) async {
    String code = _controllers.map((c) => c.text).join();

    if (code.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the complete 5-digit code")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // هنا سيتم الربط:
      // bool isSuccess = await ApiService.verifyOtp(email, code);

      await Future.delayed(const Duration(seconds: 2)); // محاكاة الـ API

      if (!mounted) return;


      Navigator.pushNamed(context, '/reset-password');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Code, try again.")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildBackButton(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: const Icon(Icons.arrow_back,color: Colors.black ,),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}