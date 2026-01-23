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
      title: "PARTE I: Série 1 ('hor')",
      color: Colors.blue.shade800,
      slides: [
        SlideData(
          title: "Slide 1: Análise Exploratória (hor)",
          visuals: "Gráfico da série temporal original + ACF/PACF.",
          points: [
            "Descrição: Série 'hor' (ex: dados mensais/trimestrais).",
            "Visual: Tendência clara? Sazonalidade visível?",
            "ACF/PACF: Confirmam a sazonalidade (picos repetidos)?",
          ],
        ),
        SlideData(
          title: "Slide 2: Métodos Determinísticos",
          visuals: "Gráfico Médias Móveis vs Tendência Linear de Holt.",
          points: [
            "Médias Móveis: Ordem 2 vs Ordem ideal. A suavização removeu o ruído?",
            "Holt: Equações de previsão e suavização.",
            "Conclusão: O método captou a tendência?",
          ],
        ),
        SlideData(
          title: "Slide 3: Decomposição",
          visuals: "Painel de 4 gráficos (Obs, Trend, Seas, Random) para Aditivo vs Multiplicativo.",
          points: [
            "Comparação: Aditivo vs Multiplicativo.",
            "Decisão: Qual teve resíduos menores ou padrão mais estável?",
            "Mostrar: Gráfico das componentes separadas.",
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
          visuals: "Gráfico Ajuste HW Aditivo vs Multiplicativo.",
          points: [
            "Objetivo: Captar Sazonalidade + Tendência.",
            "Melhor Modelo: Aditivo ou Multiplicativo? (Baseado no erro/visual).",
            "Horizonte: Previsão para 12 períodos.",
          ],
        ),
        SlideData(
          title: "Slide 5: Modelação SARIMA",
          visuals: "Tabela de Modelos Candidatos + Diagnóstico (Resíduos).",
          points: [
            "Metodologia: Box-Jenkins (7 passos).",
            "Seleção: Modelo com menor AIC/BIC e resíduos 'ruído branco'.",
            "Previsão: Intervalos de confiança a 95%.",
          ],
        ),
        SlideData(
          title: "Slide 6: Regressão Harmónica (DHR)",
          visuals: "Gráfico Ajuste Fourier + Resíduos.",
          points: [
            "Abordagem: Séries de Fourier para sazonalidade complexa.",
            "Resultado: Preserva bem a sazonalidade anual.",
            "Resíduos: Centrados em zero, validando o modelo.",
          ],
        ),
        SlideData(
          title: "Slide 7: Comparação Final (Série 2)",
          visuals: "Gráfico único com: Original + Prev HW + Prev SARIMA + Prev DHR.",
          points: [
            "Visual: Sobreposição das previsões (intervalos de confiança).",
            "Veredito: SARIMA teve erros menores (melhor qualidade).",
            "DHR vs HW: Desempenho semelhante.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Adjusted)",
      color: Colors.teal.shade800,
      slides: [
        SlideData(
          title: "Slide 8: Análise de Retornos & ARCH",
          visuals: "Gráfico Retornos Simples + Teste ARCH.",
          points: [
            "Dados: FTSE.Adjusted. Retornos oscilam em torno de zero.",
            "Volatilidade: Clusters visíveis (períodos calmos vs agitados).",
            "Teste ARCH: Rejeita H0 -> Existem efeitos ARCH (precisamos de GARCH).",
          ],
        ),
        SlideData(
          title: "Slide 9: Modelos GARCH (sGARCH)",
          visuals: "Tabela AIC/BIC dos modelos (1,1), (1,2)... + Gráfico Previsão.",
          points: [
            "Melhor Modelo: Qual ordem? Qual distribuição (Normal/Student)?",
            "Diagnóstico: QQ-Plot e Histograma dos resíduos.",
            "Previsão: Volatilidade para h=20.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Close) - O Grande Final",
      color: Colors.orange.shade900,
      slides: [
        SlideData(
          title: "Slide 10: Log-Retornos & Seleção",
          visuals: "Gráfico Log-Retornos + Tabela Comparativa (AIC vs BIC).",
          points: [
            "Problema: Heterocedasticidade confirmada.",
            "Modelos: EGARCH vs GJR-GARCH (Assimetria).",
            "Conflito: AIC preferiu (2,1), BIC preferiu (1,1).",
            "Decisão: EGARCH(1,1) t-Student Assimétrica (Parcimónia).",
          ],
        ),
        SlideData(
          title: "Slide 11: Diagnóstico Final",
          visuals: "QQ-Plot + Curva de Impacto de Notícias (se houver).",
          points: [
            "Validação: Resíduos alinhados à t-Student.",
            "Alavancagem: Choques negativos aumentam mais a volatilidade.",
            "Conclusão: Modelo bem especificado.",
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estrutura da Apresentação'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar Estrutura Completa',
            onPressed: () {
              final buffer = StringBuffer();
              for (var section in sections) {
                buffer.writeln("\n=== ${section.title} ===");
                for (var slide in section.slides) {
                  buffer.writeln("\n${slide.title}");
                  buffer.writeln("Visual: ${slide.visuals}");
                  buffer.writeln("Falar: ${slide.points.join(' ')}");
                }
              }
              Clipboard.setData(ClipboardData(text: buffer.toString()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Estrutura copiada!')),
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
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.slideshow, color: color),
      ),
      title: Text(
        slide.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        slide.visuals,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              const Text(
                "O QUE MOSTRAR (Gráficos/Tabelas):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(slide.visuals, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              const Text(
                "O QUE DIZER (Pontos Chave):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              ...slide.points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, size: 18, color: color),
                    Expanded(
                      child: Text(point, style: const TextStyle(fontSize: 14, height: 1.4)),
                    ),
                  ],
                ),
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
  final String visuals;
  final List<String> points;

  SlideData({required this.title, required this.visuals, required this.points});
}
