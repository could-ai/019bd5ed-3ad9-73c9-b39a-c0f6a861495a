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
      title: "AGENDA E OBJETIVOS",
      color: Colors.black87,
      slides: [
        SlideData(
          title: "Estrutura da Apresentação",
          objective: "Visão geral dos 4 blocos principais.",
          visuals: "Lista simples dos tópicos.",
          points: [
            "A nossa apresentação divide-se em 4 partes:",
            "",
            "1. INTRODUÇÃO",
            "   • Enquadramento e Objetivos.",
            "",
            "2. PARTE I: SÉRIES TEMPORAIS (ASTSA)",
            "   • Série 1 ('hor'): Decomposição.",
            "   • Série 2 ('co'): Previsão (SARIMA vs Holt-Winters vs DHR).",
            "",
            "3. PARTE II: ÍNDICE FTSE 100",
            "   • Volatilidade e Risco (GARCH/EGARCH).",
            "",
            "4. CONCLUSÕES",
            "   • Síntese final.",
          ],
        ),
        SlideData(
          title: "Objetivos do Projeto",
          objective: "Definir a meta principal e passos específicos.",
          visuals: "Objetivo Principal + Bullets Específicos.",
          points: [
            "OBJETIVO PRINCIPAL:",
            "• Analisar séries reais para identificar padrões, prever valores futuros e modelar risco financeiro.",
            "",
            "OBJETIVOS ESPECÍFICOS:",
            "• Explorar: Estatística descritiva e visualização.",
            "• Preparar: Transformação (Log/Diferenças) para estacionariedade.",
            "• Desenvolver: Comparar modelos preditivos (SARIMA, HW, DHR).",
            "• Implementar: Modelar volatilidade (GARCH) para gestão de risco.",
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
            "A série 'hor' tem tendência de crescimento e sazonalidade anual.",
            "ACF com picos a cada 12 meses confirma o padrão sazonal.",
            "Sem comportamento cíclico evidente.",
          ],
        ),
        SlideData(
          title: "Slide 4: Suavização e Tendência (Q4, Q5)",
          objective: "Remover ruído e modelar a tendência.",
          visuals: "Médias Móveis vs Tendência de Holt.",
          points: [
            "Médias Móveis (ordem 12): Removem sazonalidade, revelando a tendência.",
            "Holt: Modela a tendência linear (linha reta), ignorando a sazonalidade.",
          ],
        ),
        SlideData(
          title: "Slide 5: Decomposição (Q6)",
          objective: "Separar Tendência, Sazonalidade e Ruído.",
          visuals: "Painel de 4 gráficos (Original, Tendência, Sazonal, Resíduos).",
          points: [
            "Decomposição Multiplicativa (amplitude sazonal cresce com a tendência).",
            "Resíduos aleatórios indicam boa separação das componentes.",
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
            "Holt-Winters Multiplicativo captou bem os picos.",
            "Benchmark para comparação.",
            "Previsão de 12 meses segue o padrão histórico.",
          ],
        ),
        SlideData(
          title: "Slide 7: Modelação SARIMA (Box-Jenkins) (Q4)",
          objective: "Captar correlações complexas e validar estatisticamente.",
          visuals: "Bullets: Procedimento, Log, Diferenças (d=1, D=1), Seleção AIC/BIC. Imagem: Tabela AIC/BIC + Teste Ljung-Box.",
          points: [
            "Aplicámos o procedimento Box–Jenkins.",
            "Primeiro estabilizámos a variância com Log e tornámos a série estacionária com uma diferença regular (d=1, remove tendência) e uma sazonal (D=1, s=52).",
            "Com a série estacionária, analisámos ACF/PACF e testámos candidatos. Comparámos via AIC e BIC.",
            "O modelo escolhido foi o SARIMA(1,1,1)(0,1,1)[52], pois apresentou os menores valores de AIC e BIC (Modelo m2).",
            "Validámos com Ljung-Box: O teste não indica autocorrelação nos resíduos (p-value > 0.05).",
            "Conclusão simples: Retirada a tendência e sazonalidade, sobram apenas variações aleatórias (ruído branco), confirmando o bom ajuste.",
          ],
        ),
        SlideData(
          title: "Slide 8: Regressão Harmónica (DHR) (Q5)",
          objective: "Modelar sazonalidade com ondas (Fourier).",
          visuals: "Ajuste Fourier vs Original.",
          points: [
            "Usámos termos de Fourier para modelar a sazonalidade suave.",
            "Preserva a sazonalidade anual, resíduos centrados em zero.",
            "Previsões coerentes com intervalos de confiança crescentes.",
          ],
        ),
        SlideData(
          title: "Slide 9: Comparação Final (Q4e, Q5b)",
          objective: "Decidir qual o melhor modelo.",
          visuals: "Gráfico com as 3 previsões juntas.",
          points: [
            "Comparação: HW vs SARIMA vs DHR.",
            "SARIMA teve menores erros (RMSE/MAE) e melhores intervalos.",
            "Vencedor: SARIMA.",
          ],
        ),
      ],
    ),
    PresentationSection(
      title: "PARTE II: FTSE 100 (Volatilidade)",
      color: Colors.teal.shade800,
      slides: [
        SlideData(
          title: "Slide 10: Contexto (Heterocedasticidade)",
          objective: "Explicar PORQUÊ usamos GARCH.",
          visuals: "Gráfico Log-Retornos (Clusters).",
          points: [
            "Analisámos os log-retornos do FTSE 100.",
            "Média constante (zero), mas variância muda (fases calmas vs agitadas).",
            "Isto é 'Heterocedasticidade Condicional' (efeitos ARCH), exigindo modelos GARCH.",
          ],
        ),
        SlideData(
          title: "Slide 11: Seleção (AIC vs BIC)",
          objective: "Justificar a escolha do EGARCH(1,1).",
          visuals: "Tabela comparativa (EGARCH vs GJR-GARCH).",
          points: [
            "Testámos EGARCH e GJR-GARCH (várias ordens).",
            "EGARCH(2,1) teve melhor AIC (ajuste), mas EGARCH(1,1) melhor BIC (simplicidade).",
            "Escolha: EGARCH(1,1) pelo princípio da parcimónia (menos parâmetros, quase mesma qualidade).",
          ],
        ),
        SlideData(
          title: "Slide 12: Diagnóstico",
          objective: "Validar o modelo e Efeito Alavancagem.",
          visuals: "QQ-Plot + Curva de Impacto.",
          points: [
            "Confirmado 'Efeito Alavancagem': más notícias aumentam mais a volatilidade.",
            "QQ-Plot: Distribuição t-Student assimétrica captou bem as caudas pesadas.",
            "Modelo bem especificado e pronto para gestão de risco.",
          ],
        ),
      ],
    ),
  ];

  void _copyContent(BuildContext context) {
    final buffer = StringBuffer();
    
    // Title
    buffer.writeln("=== ROTEIRO DE APRESENTAÇÃO ===\n");

    for (var section in sections) {
      buffer.writeln("\n>>> ${section.title} <<<\n");
      for (var slide in section.slides) {
        buffer.writeln("[${slide.title}]");
        if (slide.objective.isNotEmpty) {
          buffer.writeln("OBJETIVO: ${slide.objective}");
        }
        if (slide.visuals.isNotEmpty) {
          buffer.writeln("VISUAL: ${slide.visuals}");
        }
        buffer.writeln("TÓPICOS:");
        for (var point in slide.points) {
          buffer.writeln(" • $point");
        }
        buffer.writeln(""); // Empty line between slides
      }
      buffer.writeln("----------------------------------------");
    }
    
    final textToCopy = buffer.toString();

    // Show dialog with selectable text
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Copiar Roteiro Completo"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selecione o texto abaixo e use Ctrl+C para copiar:",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      textToCopy,
                      style: const TextStyle(fontFamily: 'Monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text("Copiar Tudo"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: textToCopy));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiado para a área de transferência!')),
              );
            },
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
            icon: const Icon(Icons.copy_all),
            tooltip: 'Copiar Roteiro',
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
