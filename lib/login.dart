import 'package:flutter/material.dart';

void main() => runApp(const PresensiApp());

class PresensiApp extends StatelessWidget {
  const PresensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presensi Siswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: LoginPage.primary,
        scaffoldBackgroundColor: LoginPage.background,
      ),
      home: LoginPage(
        // Ganti dengan pemanggilan API/backend Anda.
        // Kembalikan true jika kredensial valid.
        onLogin: (username, password) async {
          await Future.delayed(const Duration(seconds: 1));
          return username == 'admin' && password == 'admin123';
        },
        onSuccess: () => debugPrint('Login berhasil'),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin, this.onSuccess});

  static const Color primary = Color(0xFF1F5FD1);
  static const Color background = Color(0xFFF3F5FA);
  static const Color ink = Color(0xFF0F1B33);
  static const Color muted = Color(0xFF43506B);
  static const Color danger = Color(0xFFB42318);

  /// Memeriksa kredensial. Mengembalikan true jika valid.
  final Future<bool> Function(String username, String password) onLogin;

  /// Dipanggil setelah login berhasil (mis. navigasi ke beranda).
  final VoidCallback? onSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    bool ok = false;
    try {
      ok = await widget.onLogin(_usernameCtrl.text.trim(), _passwordCtrl.text);
    } catch (_) {
      ok = false;
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (ok) widget.onSuccess?.call();
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  InputDecoration _decoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: _border(const Color(0xFFB9C3D8)),
      enabledBorder: _border(const Color(0xFFB9C3D8)),
      focusedBorder: _border(LoginPage.primary, width: 2),
      errorBorder: _border(LoginPage.danger, width: 2),
      focusedErrorBorder: _border(LoginPage.danger, width: 2),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: LoginPage.ink,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: LoginPage.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Presensi Siswa',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        color: LoginPage.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Masuk dengan akun dari sekolah. Halaman akan '
                      'menyesuaikan jenis akun Anda.',
                      style: TextStyle(fontSize: 15, color: LoginPage.muted),
                    ),
                    const SizedBox(height: 20),

                    // Username
                    _label('Username'),
                    TextFormField(
                      controller: _usernameCtrl,
                      enabled: !_loading,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      decoration: _decoration('Masukkan username'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Username wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Kata sandi
                    _label('Kata sandi'),
                    TextFormField(
                      controller: _passwordCtrl,
                      enabled: !_loading,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      decoration: _decoration(
                        'Masukkan kata sandi',
                        suffix: IconButton(
                          tooltip: _obscure
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Kata sandi wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Tombol masuk
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: LoginPage.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Masuk'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
