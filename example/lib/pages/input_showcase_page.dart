import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class InputShowcasePage extends StatefulWidget {
  const InputShowcasePage({super.key});

  @override
  State<InputShowcasePage> createState() => _InputShowcasePageState();
}

class _InputShowcasePageState extends State<InputShowcasePage> {
  final _textController = TextEditingController(text: 'Hero UI');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'segreta123');
  final _telController = TextEditingController(text: '3331234567');
  final _otpController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telController.dispose();
    _otpController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Input'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Text · full width · icon default · clear'),
          HUFInput(
            label: 'Nome',
            hintText: 'Il tuo nome',
            controller: _textController,
            type: HUFInputType.text,
            icon: true,
            clear: true,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Text · larghezza contenuto'),
          const HUFInput(
            label: 'Codice',
            hintText: 'ABC',
            type: HUFInputType.text,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Email · solo caratteri email'),
          HUFInput(
            label: 'Email',
            hintText: 'nome@esempio.it',
            controller: _emailController,
            type: HUFInputType.email,
            icon: true,
            clear: true,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Password · nascosta · toggle visibilità'),
          HUFInput(
            label: 'Password',
            hintText: 'Inserisci la password',
            controller: _passwordController,
            type: HUFInputType.password,
            icon: true,
            clear: true,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Tel · prefisso + sole cifre'),
          HUFInput(
            label: 'Telefono',
            hintText: '333 1234567',
            controller: _telController,
            type: HUFInputType.tel,
            telPrefix: '+39',
            icon: true,
            clear: true,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('OTP / PIN · 4 celle · auto-focus'),
          HUFInput(
            label: 'Enter PIN',
            controller: _otpController,
            type: HUFInputType.otp,
            otpLength: 4,
            icon: true,
            clear: true,
            onChanged: (_) => setState(() {}),
          ),
          if (_otpController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Valore OTP: ${_otpController.text}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('OTP · 6 celle · icona custom'),
          const HUFInput(
            label: 'Codice verifica',
            type: HUFInputType.otp,
            otpLength: 6,
            icon: Icon(Icons.sms_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Search · icona leading custom'),
          HUFInput(
            hintText: 'Cerca…',
            controller: _searchController,
            type: HUFInputType.text,
            icon: const Icon(Icons.search_rounded),
            clear: true,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Senza label · disabilitato'),
          const HUFInput(
            label: 'Campo disabilitato',
            hintText: 'Non modificabile',
            enabled: false,
            isFullWidth: true,
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle(
            'Tap fuori dal campo per togliere il focus (bordo primary)',
          ),
          const HUFInput(
            label: 'Prova il focus',
            hintText: 'Tocca qui, poi fuori',
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
