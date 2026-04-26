import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class TelaOtp extends ConsumerStatefulWidget {
  const TelaOtp({super.key});

  @override
  ConsumerState<TelaOtp> createState() => _TelaOtpState();
}

class _TelaOtpState extends ConsumerState<TelaOtp> {
  final _phoneCtrl = TextEditingController();
  final List<TextEditingController> _digitCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _codigoEnviado = false;
  bool _isLoading = false;
  String _telefone = '';

  @override
  void dispose() {
    _phoneCtrl.dispose();
    for (final c in _digitCtrl) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    if (_phoneCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post(ApiConstants.enviarCodigo, data: {
        'phone': _phoneCtrl.text.trim(),
        'channel': 'WHATSAPP',
      });
      setState(() {
        _telefone = _phoneCtrl.text.trim();
        _codigoEnviado = true;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar código. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verificarCodigo() async {
    final code = _digitCtrl.map((c) => c.text).join();
    if (code.length < 6) return;
    await ref.read(authStateProvider.notifier).loginComOtp(_telefone, code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Entrar com telefone'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: _codigoEnviado ? _buildOtpStep() : _buildPhoneStep(),
        ),
      ),
    );
  }

  Widget _buildPhoneStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seu número de telefone', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          Text(
            'Vamos enviar um código de verificação via WhatsApp',
            style: AppTextStyles.body.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),
          AppTextField(
            controller: _phoneCtrl,
            label: 'Telefone',
            hint: '+55 11 99999-9999',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Enviar código',
            onPressed: _isLoading ? null : _enviarCodigo,
            isLoading: _isLoading,
          ),
        ],
      );

  Widget _buildOtpStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Digite o código', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          Text(
            'Enviamos um código de 6 dígitos para $_telefone',
            style: AppTextStyles.body.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),

          // 6 campos OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 46,
                child: TextField(
                  controller: _digitCtrl[i],
                  focusNode: _focusNodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) {
                      _focusNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _focusNodes[i - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 32),
          AppButton(label: 'Verificar', onPressed: _verificarCodigo),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => setState(() => _codigoEnviado = false),
              child: const Text('Reenviar código'),
            ),
          ),
        ],
      );
}
