import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Presentation Script for FTSE 100 GARCH Analysis - Simplified for Professor
    final String presentationScript = '''
• Slide 1: Análise da Série (O Porquê)
"Professor, comecei por calcular os log-retornos do FTSE 100.
Como vemos no gráfico, a média é zero, mas a volatilidade varia muito (clusters).
Isso justifica o uso de modelos GARCH para captar essa dinâmica."

• Slide 2: Seleção do Modelo (O Que Fiz)
"Estimei modelos EGARCH e GJR-GARCH com várias ordens e distribuições t-Student.
A escolha recaiu sobre o EGARCH(1,1) com t-Student assimétrica.
Porquê? O AIC do modelo (2,1) era ligeiramente melhor, mas o BIC (que penaliza a complexidade) indicou o (1,1) como a escolha mais eficiente e parcimoniosa."

• Slide 3: Diagnóstico (O Resultado)
"O modelo confirmou persistência na volatilidade e efeito de alavancagem (más notícias pesam mais).
O QQ-Plot mostra os resíduos alinhados à reta, validando a distribuição escolhida.
Conclusão: O modelo está bem especificado."
''';

    // Model Details for the "Code" section
    final String selectedModelDetails = '''Modelo Final: EGARCH(1,1)
Distribuição: t-Student Assimétrica (sstd)

Critérios de Decisão:
1. AIC: -6.58747 (Muito próximo do 2,1)
2. BIC: -6.582467 (Decisivo pela parcimónia)

Conclusões Económicas:
- Persistência: Alta
- Alavancagem: Confirmada (choques negativos > positivos)''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defesa: FTSE 100 GARCH'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Presentation Helper Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.mic, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Roteiro para o Professor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        tooltip: 'Copiar Texto',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: presentationScript));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Roteiro copiado!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  SelectableText(
                    presentationScript,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 24),

            // Slide 1 Section
            const Text(
              "Slide 1: Análise dos Log-Retornos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _buildSlideCard(
              icon: Icons.show_chart,
              title: 'Contexto',
              points: [
                'Log-retornos oscilam em torno de zero (sem tendência).',
                'Volatilidade aglomerada (clusters de instabilidade).',
                'Justificativa: Séries financeiras exigem GARCH.',
              ],
            ),
            
            const SizedBox(height: 20),

            // Slide 2 Section
            const Text(
              "Slide 2: Seleção do Modelo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _buildSlideCard(
              icon: Icons.filter_alt,
              title: 'Metodologia & Decisão',
              points: [
                'Testados: EGARCH e GJR-GARCH (1,1), (1,2), (2,1).',
                'Distribuições: t-Student (simétrica e assimétrica).',
                'Critério: BIC preferiu EGARCH(1,1) (mais simples) vs (2,1).',
              ],
              highlight: 'Escolhido: EGARCH(1,1) com t-Student assimétrica',
            ),

            const SizedBox(height: 20),

            // Slide 3 Section
            const Text(
              "Slide 3: Diagnóstico Final",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
             _buildSlideCard(
              icon: Icons.check_circle,
              title: 'Validação',
              points: [
                'Volatilidade persistente e efeito de alavancagem confirmado.',
                'QQ-Plot: Resíduos alinhados com a reta teórica.',
                'Conclusão: Modelo bem especificado e robusto.',
              ],
            ),

            const SizedBox(height: 16),
            
            // Technical Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Resumo Técnico:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: selectedModelDetails));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Detalhes copiados!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  Text(
                    selectedModelDetails,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCard({
    required IconData icon, 
    required String title, 
    required List<String> points, 
    String? highlight
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  child: Icon(icon, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_right, size: 20, color: Colors.black54),
                  Expanded(child: Text(point, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
            if (highlight != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        highlight,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
