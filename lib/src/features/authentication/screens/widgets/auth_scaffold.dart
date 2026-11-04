import 'package:flutter/material.dart';

import '../../../../core/common_widgets/college_logo.dart';
import '../../../../core/common_widgets/fx/aurora_background.dart';
import '../../../../core/common_widgets/fx/glass_card.dart';
import '../../../../core/common_widgets/fx/gradient_text.dart';
import '../../../../core/common_widgets/fx/reveal_in.dart';
import '../../../../core/design/app_tokens.dart';

/// A partir desta largura a tela se divide: vitrine à esquerda, formulário
/// à direita.
const double authSplitBreakpoint = 900;

/// Estrutura comum de login, cadastro, recuperar senha e verificar e-mail:
/// fundo animado, marca, título em destaque e o formulário num card.
class AuthScaffold extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBack;

  const AuthScaffold({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.background,
      body: AuroraBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= authSplitBreakpoint;
              final form = _FormColumn(
                eyebrow: eyebrow,
                title: title,
                subtitle: subtitle,
                footer: footer,
                showBack: showBack,
                showBrand: !wide,
                child: child,
              );
              if (!wide) return form;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Expanded(flex: 108, child: AuthShowcasePanel()),
                    Expanded(flex: 100, child: form),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FormColumn extends StatelessWidget {
  final String eyebrow, title, subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBack, showBrand;

  const _FormColumn({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.footer,
    required this.showBack,
    required this.showBrand,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: RevealIn(
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Voltar'),
                      style: TextButton.styleFrom(
                          foregroundColor: AppTokens.textMuted),
                    ),
                  ),
                ),
              if (showBrand)
                const RevealIn(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Center(child: BrandMark()),
                  ),
                ),
              RevealIn(
                delay: const Duration(milliseconds: 120),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              eyebrow.toUpperCase(),
                              style: const TextStyle(
                                color: AppTokens.primarySoft,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ),
                          // Logo da Católica SC: leva ao site da faculdade.
                          const CollegeLogo(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppTokens.text,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.6,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppTokens.textMuted,
                          fontSize: 13.5,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ),
              if (footer != null)
                RevealIn(
                  delay: const Duration(milliseconds: 260),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: footer,
                  ),
                ),
              const RevealIn(
                delay: Duration(milliseconds: 340),
                child: Padding(
                  padding: EdgeInsets.only(top: 22),
                  child: Text(
                    'ClickBoard · Católica SC',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTokens.textFaint, fontSize: 11),
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

/// Logo + nome do app.
class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 1.7,
          height: size * 1.7,
          decoration: BoxDecoration(
            gradient: AppTokens.brandButton,
            borderRadius: BorderRadius.circular(size * .5),
            boxShadow: [
              BoxShadow(
                color: AppTokens.primary.withValues(alpha: .45),
                blurRadius: 18,
              ),
            ],
          ),
          child: Icon(Icons.dashboard_rounded,
              color: Colors.white, size: size * 1.05),
        ),
        SizedBox(width: size * .55),
        Text(
          'ClickBoard',
          style: TextStyle(
            color: AppTokens.text,
            fontSize: size,
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
        ),
      ],
    );
  }
}

/// Painel da esquerda no layout largo: o que o aluno encontra no app.
class AuthShowcasePanel extends StatelessWidget {
  const AuthShowcasePanel({super.key});

  static const _features = [
    (
      Icons.campaign_rounded,
      'Avisos oficiais',
      'Comunicados da coordenação num só lugar, sem se perder no grupo.'
    ),
    (
      Icons.folder_copy_rounded,
      'Documentos à mão',
      'Abra e baixe calendários, editais e regulamentos quando precisar.'
    ),
    (
      Icons.verified_user_rounded,
      'Seguro de verdade',
      'Só a coordenação publica e altera o conteúdo oficial.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('auth-showcase'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTokens.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15132B), Color(0xFF0C0B16)],
          stops: [0, .65],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -140,
            right: -80,
            child: _Glow(size: 420, color: Color(0x662A2366)),
          ),
          const Positioned(
            bottom: -160,
            left: -100,
            child: _Glow(size: 420, color: Color(0x553B1D5C)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 40, 44, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RevealIn(child: BrandMark()),
                const Spacer(),
                const RevealIn(
                  delay: Duration(milliseconds: 100),
                  child: Text(
                    'PORTAL DO ALUNO',
                    style: TextStyle(
                      color: AppTokens.primarySoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const RevealIn(
                  delay: Duration(milliseconds: 180),
                  child: Text(
                    'Tudo o que a coordenação publica,',
                    style: TextStyle(
                      color: AppTokens.text,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                      height: 1.08,
                    ),
                  ),
                ),
                const RevealIn(
                  delay: Duration(milliseconds: 260),
                  child: GradientText(
                    'na palma da mão.',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                      height: 1.08,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                for (var i = 0; i < _features.length; i++)
                  RevealIn(
                    delay: Duration(milliseconds: 360 + 90 * i),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FeatureTile(
                        icon: _features[i].$1,
                        title: _features[i].$2,
                        description: _features[i].$3,
                        number: i + 1,
                      ),
                    ),
                  ),
                const Spacer(),
                const Text(
                  'Feito pelo Grupo 4 · Análise, Projeto e Desenvolvimento Ágil',
                  style: TextStyle(color: AppTokens.textFaint, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _FeatureTile extends StatefulWidget {
  final IconData icon;
  final String title, description;
  final int number;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.number,
  });

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: AppTokens.easeOut,
        transform: Matrix4.translationValues(_hover ? 6 : 0, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Color(_hover ? 0xD9221E45 : 0xB31B1838),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: _hover ? AppTokens.borderStrong : AppTokens.border),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0x406366F1), Color(0x26A454ED)],
                    ),
                  ),
                  child: Icon(widget.icon,
                      color: const Color(0xFFC7C4FF), size: 22),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTokens.primary,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF15132B), width: 2),
                    ),
                    child: Text(
                      '${widget.number}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          color: AppTokens.text,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(widget.description,
                      style: const TextStyle(
                          color: Color(0xFFA9A7BD),
                          fontSize: 12.5,
                          height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
