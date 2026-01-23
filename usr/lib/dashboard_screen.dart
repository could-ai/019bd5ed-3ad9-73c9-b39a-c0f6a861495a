import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  // Data structure for the presentation
  final List<PresentationSection> sections = [
    PresentationSection(
      title: "INTRODUÇÃO E ESTRUTURA (Estilo Novo)",
      color: Colors.black87,
      slides: [
        SlideData(
          title: "Estrutura da Apresentação",
          objective: "Dar uma visão geral do fluxo da apresentação.",
          visuals: "Lista vertical simples (Estilo 'Agenda').",
          points: [
            "A nossa apresentação está organizada em 4 grandes blocos:",
            "",
            "1. INTRODUÇÃO",
            "   • Objetivos e enquadramento do estudo.",
            "",
            "2. PARTE I: ANÁLISE DE SÉRIES TEMPORAIS",
            "   • Série 1 ('hor'): Decomposição e caracterização.",
            "   • Série 2 ('co'): Previsão com Holt-Winters, SARIMA e DHR.",
            "",
            "3. PARTE II: ÍNDICE FTSE 100",
            "   • Análise de retornos e volatilidade (GARCH/EGARCH).",
            "",
            "4. CONCLUSÕES",
            "   • Síntese dos resultados e diagnósticos finais.",
          ],
        ),
        SlideData(
          title: "Objetivos do Projeto",
          objective: "Definir a meta principal e os passos específicos.",
          visuals: "Objetivo Principal em destaque + Bullets (Estilo 'Medical Cost').",
          points: [
            "OBJETIVO PRINCIPAL:",
            "• Analisar séries temporais reais para identificar padrões, realizar previsões fiáveis e modelar o risco financeiro.",
            "",
            "OBJETIVOS ESPECÍFICOS:",
            "• Explorar e compreender as séries através de estatística descritiva e visualização.",
            "• Preparar e transformar os dados (diferenciação, log-retornos) para garantir estacionariedade.",
            "• Desenvolver e avaliar modelos preditivos (SARIMA vs Holt-Winters vs DHR).",
            "• Implementar modelos de volatilidade (GARCH/EGARCH) para captar a assimetria e o risco de mercado.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE I: Série 1 ('hor')",
      color: Colors.blue.shade800,
      slides: [
        SlideData(
          title: "Slide 3: Análise Inicial (Q1, Q2, Q3)",
          objective: "Caracterizar a série e identificar padrões.",
          visuals: "Gráfico da série + ACF/PACF.",
          points: [
            "A série 'hor' apresenta uma tendência de crescimento clara e sazonalidade anual.",
            "Os correlogramas (ACF) mostram picos repetidos a cada 12 meses, confirmando o padrão sazonal.",
            "Não há comportamento cíclico evidente além da sazonalidade.",
          ],
        ),
        SlideData(
          title: "Slide 4: Suavização e Tendência (Q4, Q5)",
          objective: "Remover ruído e modelar a tendência.",
          visuals: "Médias Móveis vs Tendência de Holt.",
          points: [
            "Médias Móveis (ordem 12): Suavizam a série, eliminando a sazonalidade para revelar a tendência de longo prazo.",
            "Método de Holt: Modela a tendência linear. As previsões seguem a direção de crescimento, mas ignoram a sazonalidade (linha reta).",
          ],
        ),
        SlideData(
          title: "Slide 5: Decomposição (Q6)",
          objective: "Separar Tendência, Sazonalidade e Ruído.",
          visuals: "Painel de 4 gráficos (Original, Tendência, Sazonal, Resíduos).",
          points: [
            "Decompusemos a série em 3 componentes.",
            "O modelo Multiplicativo foi o mais adequado porque a amplitude da sazonalidade cresce com a tendência.",
            "Os resíduos resultantes são aleatórios, indicando uma boa separação.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE I: Série 2 ('co')",
      color: Colors.indigo.shade800,
      slides: [
        SlideData(
          title: "Slide 6: Holt-Winters (Q3)",
          objective: "Prever considerando Sazonalidade + Tendência.",
          visuals: "Gráfico de Ajuste HW vs Original.",
          points: [
            "O método Holt-Winters Multiplicativo captou bem os picos sazonais.",
            "É o nosso 'benchmark' (modelo base) para comparação.",
            "Previsão para 12 meses segue o padrão histórico com precisão.",
          ],
        ),
        SlideData(
          title: "Slide 7: Modelação SARIMA (Q4)",
          objective: "Captar correlações complexas (Box-Jenkins).",
          visuals: "Tabela de Modelos + Gráfico de Previsão.",
          points: [
            "Seguimos a metodologia Box-Jenkins (Identificação, Estimação, Verificação).",
            "O modelo SARIMA selecionado minimizou o AIC/BIC.",
            "Os resíduos comportam-se como ruído branco (sem autocorrelação), validando estatisticamente o modelo.",
          ],
        ),
        SlideData(
          title: "Slide 8: Regressão Harmónica (DHR) (Q5)",
          objective: "Modelar sazonalidade com ondas (Fourier).",
          visuals: "Ajuste Fourier vs Original.",
          points: [
            "Utilizámos termos de Fourier para modelar a sazonalidade de forma suave.",
            "O modelo preserva a sazonalidade anual e os resíduos estão centrados em zero.",
            "As previsões são coerentes e os intervalos de confiança aumentam com o horizonte.",
          ],
        ),
        SlideData(
          title: "Slide 9: Comparação Final (Q4e, Q5b)",
          objective: "Decidir qual o melhor modelo.",
          visuals: "Gráfico com as 3 previsões juntas.",
          points: [
            "Comparando os 3 modelos (HW, SARIMA, DHR):",
            "O SARIMA apresentou os erros mais baixos (RMSE/MAE) e intervalos de confiança mais robustos.",
            "Conclusão: O SARIMA é o modelo vencedor para esta série.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Volatilidade)",
      color: Colors.teal.shade800,
      slides: [
        SlideData(
          title: "Slide 10: Contexto e Heterocedasticidade",
          objective: "Explicar PORQUÊ usamos GARCH (Clusters de Volatilidade).",
          visuals: "Gráfico dos Log-Retornos Diários.",
          points: [
            "Observamos os log-retornos do FTSE 100.",
            "A média é constante (perto de zero), mas a variância muda: há fases calmas e fases agitadas (clusters).",
            "Isto viola a premissa de variância constante. O teste ARCH confirmou efeitos ARCH, exigindo modelos GARCH.",
          ],
        ),
        SlideData(
          title: "Slide 11: Seleção do Modelo (AIC vs BIC)",
          objective: "Justificar a escolha do EGARCH(1,1).",
          visuals: "Tabela comparativa (EGARCH vs GJR-GARCH).",
          points: [
            "Testámos modelos EGARCH e GJR-GARCH com ordens (1,1), (1,2) e (2,1).",
            "O EGARCH(2,1) teve o melhor AIC (ajuste), mas o EGARCH(1,1) teve o melhor BIC (penaliza complexidade).",
            "Escolhemos o EGARCH(1,1) pelo princípio da parcimónia: é mais simples e robusto.",
          ],
        ),
        SlideData(
          title: "Slide 12: Diagnóstico e Conclusão",
          objective: "Validar o modelo e o Efeito Alavancagem.",
          visuals: "QQ-Plot + Curva de Impacto (News Impact Curve).",
          points: [
            "O modelo confirmou o 'Efeito Alavancagem': choques negativos aumentam mais a volatilidade do que positivos.",
            "O QQ-Plot mostra que a distribuição t-Student assimétrica captou bem as caudas pesadas.",
            "Conclusão: O modelo está bem especificado e pronto para gestão de risco.",
          ],
        ),
      ],
    ),
  ];

  void _copyContent(BuildContext context) {
    final buffer = StringBuffer();
    // Copy Agenda Section
    final agendaSection = sections.first;
    buffer.writeln("=== ${agendaSection.title} ===");
    for (var slide in agendaSection.slides) {
      buffer.writeln("\n[${slide.title}]");
      if (slide.objective.isNotEmpty) {
        buffer.writeln("OBJETIVO: ${slide.objective}");
      }
      buffer.writeln(slide.points.join('\n'));
    }
    
    final textToCopy = buffer.toString();

    // Try system clipboard
    Clipboard.setData(ClipboardData(text: textToCopy));

    // Show dialog with selectable text as fallback/confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Texto da Agenda"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(textToCopy),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: textToCopy));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiado para a área de transferência!')),
              );
            },
            child: const Text("Copiar Novamente"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planeador de Apresentação'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Ver e Copiar Agenda',
            onPressed: () => _copyContent(context),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return _buildSectionCard(sections[index]);
        },
      ),
    );
  }

  Widget _buildSectionCard(PresentationSection section) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: section.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              section.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...section.slides.map((slide) => _buildSlideItem(slide, section.color)),
        ],
      ),
    );
  }

  Widget _buildSlideItem(SlideData slide, Color color) {
    return ExpansionTile(
      initiallyExpanded: true,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.slideshow, color: color),
      ),
      title: Text(
        slide.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: slide.objective.isNotEmpty 
        ? Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Text(
              "Objetivo: ${slide.objective}",
              style: TextStyle(color: Colors.brown[800], fontSize: 12, fontWeight: FontWeight.w600),
            ),
          )
        : null,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              if (slide.visuals.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    const Text(
                      "VISUAL (O que mostrar):",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 2),
                  child: Text(slide.visuals, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Icon(Icons.mic, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  const Text(
                    "TÓPICOS (O que dizer):",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...slide.points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 22),
                child: Text(point, style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500)),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class PresentationSection {
  final String title;
  final Color color;
  final List<SlideData> slides;

  PresentationSection({required this.title, required this.color, required this.slides});
}

class SlideData {
  final String title;
  final String objective;
  final String visuals;
  final List<String> points;

  SlideData({
    required this.title, 
    required this.objective, 
    required this.visuals, 
    required this.points
  });
}
