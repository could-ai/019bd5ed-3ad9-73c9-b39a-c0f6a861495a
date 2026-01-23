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
      title: "AGENDA E OBJETIVOS (Slide Único)",
      color: Colors.black87,
      slides: [
        SlideData(
          title: "Roteiro da Apresentação",
          objective: "Apresentar a estrutura e o propósito do trabalho.",
          visuals: "Lista de Tópicos (Agenda) + Objetivos em destaque.",
          points: [
            "OBJETIVOS DO PROJETO:",
            "1. Identificar padrões (tendência/sazonalidade) em séries temporais.",
            "2. Comparar métodos de previsão (Holt-Winters vs SARIMA vs DHR).",
            "3. Modelar a volatilidade e o risco financeiro (Modelos GARCH).",
            "",
            "ESTRUTURA DA APRESENTAÇÃO:",
            "• Parte I - Série 1 ('hor'): Caracterização e Decomposição.",
            "• Parte I - Série 2 ('co'): Modelação Avançada e Previsão.",
            "• Parte II - FTSE 100: Análise de Retornos e Volatilidade Assimétrica.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE I: Série 1 ('hor')",
      color: Colors.blue.shade800,
      slides: [
        SlideData(
          title: "Slide 1: Análise Inicial",
          objective: "Caracterizar a série e identificar padrões (Q1, Q2, Q3).",
          visuals: "Gráfico da série + ACF/PACF.",
          points: [
            "A série 'hor' tem tendência e sazonalidade claras.",
            "Os picos no ACF confirmam que o padrão se repete.",
          ],
        ),
        SlideData(
          title: "Slide 2: Suavização e Tendência",
          objective: "Remover ruído e modelar a tendência (Q4, Q5).",
          visuals: "Médias Móveis vs Tendência de Holt.",
          points: [
            "Médias Móveis: Suavizam a linha, mostrando melhor a direção.",
            "Holt: Capta a tendência linear para prever o futuro.",
          ],
        ),
        SlideData(
          title: "Slide 3: Decomposição",
          objective: "Separar o que é Tendência, Sazonalidade e Ruído (Q6).",
          visuals: "Painel de 4 gráficos (Original, Tendência, Sazonal, Resíduos).",
          points: [
            "Separamos a série nas suas 3 partes.",
            "O modelo Multiplicativo funcionou melhor (resíduos menores).",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE I: Série 2 ('co')",
      color: Colors.indigo.shade800,
      slides: [
        SlideData(
          title: "Slide 4: Holt-Winters",
          objective: "Prever considerando Sazonalidade + Tendência (Q3).",
          visuals: "Gráfico de Ajuste HW vs Original.",
          points: [
            "O método HW adapta-se bem aos picos sazonais.",
            "Previsão para 12 meses segue o padrão histórico.",
          ],
        ),
        SlideData(
          title: "Slide 5: Modelação SARIMA",
          objective: "Captar correlações complexas (Box-Jenkins) (Q4).",
          visuals: "Tabela de Modelos + Gráfico de Previsão.",
          points: [
            "Seguimos os 7 passos de Box-Jenkins.",
            "O modelo escolhido tem os menores erros (AIC/BIC).",
            "Os resíduos são 'ruído branco' (aleatórios), o que valida o modelo.",
          ],
        ),
        SlideData(
          title: "Slide 6: Regressão Harmónica (DHR)",
          objective: "Modelar sazonalidade com ondas (Fourier) (Q5).",
          visuals: "Ajuste Fourier vs Original.",
          points: [
            "Usamos ondas senoidais para desenhar a sazonalidade.",
            "Resultado muito suave e estável.",
          ],
        ),
        SlideData(
          title: "Slide 7: Comparação Final",
          objective: "Decidir qual o melhor modelo (Q4e, Q5b).",
          visuals: "Gráfico com as 3 previsões juntas.",
          points: [
            "Comparando os 3 modelos: SARIMA vence.",
            "Teve os menores erros e intervalos de confiança mais seguros.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Adjusted)",
      color: Colors.teal.shade800,
      slides: [
        SlideData(
          title: "Slide 8: Volatilidade (ARCH)",
          objective: "Provar que a volatilidade varia (Q1, Q2, Q3).",
          visuals: "Gráfico dos Retornos + Teste ARCH.",
          points: [
            "Os retornos variam muito: há fases calmas e fases agitadas.",
            "O teste ARCH confirma: precisamos de modelos GARCH.",
          ],
        ),
        SlideData(
          title: "Slide 9: Modelos GARCH",
          objective: "Prever o risco (volatilidade) (Q4, Q5).",
          visuals: "Previsão da Volatilidade (h=20).",
          points: [
            "Testamos vários modelos (1,1), (1,2)...",
            "O melhor modelo prevê como o risco vai evoluir nos próximos 20 dias.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Close)",
      color: Colors.orange.shade900,
      slides: [
        SlideData(
          title: "Slide 10: Assimetria (EGARCH)",
          objective: "Captar o 'medo' do mercado (Choques Negativos) (Q6).",
          visuals: "Tabela Comparativa (AIC/BIC).",
          points: [
            "Mercados caem mais rápido do que sobem (Efeito Alavancagem).",
            "Escolhemos o EGARCH(1,1) porque é simples e capta isso bem.",
          ],
        ),
        SlideData(
          title: "Slide 11: Diagnóstico Final",
          objective: "Garantir que o modelo é robusto (Q6).",
          visuals: "QQ-Plot + Curva de Impacto.",
          points: [
            "O modelo passou nos testes (resíduos normais).",
            "Conclusão: É seguro usar este modelo para gestão de risco.",
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda e Objetivos'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar Agenda',
            onPressed: () {
              final buffer = StringBuffer();
              // Only copy the Agenda section (first section)
              final agendaSection = sections.first;
              buffer.writeln("=== ${agendaSection.title} ===");
              for (var slide in agendaSection.slides) {
                buffer.writeln("\n${slide.points.join('\n')}");
              }
              
              Clipboard.setData(ClipboardData(text: buffer.toString()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agenda copiada para a área de transferência!')),
              );
            },
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
      initiallyExpanded: true, // Keep expanded for visibility
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.slideshow, color: color),
      ),
      title: Text(
        slide.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        slide.objective,
        style: TextStyle(color: Colors.grey[700], fontSize: 13, fontStyle: FontStyle.italic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              if (slide.visuals.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  "VISUAL (O que mostrar):",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                ),
                Text(slide.visuals, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
              ],
              const Text(
                "CONTEÚDO (O que dizer):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              ...slide.points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
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
