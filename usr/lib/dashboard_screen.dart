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
    // Presentation Script - Detailed & Robust for Professor
    final String presentationScript = '''
• Slide 1: Análise Exploratória (O Problema)
"Professor, neste primeiro gráfico observamos os log-retornos do FTSE 100.
A média oscila em torno de zero, indicando ausência de tendência, mas o ponto crítico é a variância.
Vemos claramente 'clusters de volatilidade': períodos de alta instabilidade seguidos de calmaria.
Isso confirma que a série é heterocedástica. Por isso, modelos lineares simples não servem; precisamos da família GARCH para modelar essa variância condicional dinâmica."

• Slide 2: Seleção do Modelo (A Metodologia)
"Para capturar essa dinâmica e possíveis assimetrias (efeito alavancagem), estimei modelos EGARCH e GJR-GARCH.
Testei combinações de ordens (1,1), (1,2) e (2,1) usando distribuições t-Student (simétrica e assimétrica) para lidar com as caudas pesadas típicas de finanças.
A Decisão: O modelo EGARCH(2,1) teve o melhor AIC, mas a diferença para o (1,1) foi marginal.
Como o critério BIC penaliza a complexidade (número de parâmetros) mais severamente, ele apontou o EGARCH(1,1) com t-Student assimétrica como o ideal.
Seguindo o princípio da parcimónia, escolhi este modelo: explica a série tão bem quanto os outros, mas é mais simples."

• Slide 3: Diagnóstico e Validação (A Conclusão)
"Os resultados do modelo estimado confirmam duas coisas:
1. Alta persistência na volatilidade (choques demoram a dissipar).
2. Efeito de alavancagem significativo (más notícias aumentam a volatilidade mais que as boas).
No diagnóstico visual (QQ-Plot), os resíduos padronizados alinham-se quase perfeitamente à reta da distribuição t-Student assimétrica.
Isso valida a escolha da distribuição e confirma que o modelo está bem especificado, capturando adequadamente a estrutura dos dados."
''';

    // Technical Details for reference
    final String selectedModelDetails = '''Modelo Escolhido: EGARCH(1,1)
Distribuição: t-Student Assimétrica (sstd)

Justificativa Técnica:
- Heterocedasticidade: Confirmada pelos clusters.
- Caudas Pesadas: Exigem distribuição t-Student.
- Assimetria: Exige EGARCH/GJR + sstd.

Critérios:
- AIC: EGARCH(2,1) ligeiramente menor (melhor ajuste).
- BIC: EGARCH(1,1) menor (melhor trade-off).
- Decisão: Parcimónia (Menos parâmetros).''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defesa Detalhada: FTSE 100'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Script Section
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
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.record_voice_over, color: Colors.blue),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Discurso Completo (Anti-Branca)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        tooltip: 'Copiar Discurso',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: presentationScript));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Discurso copiado!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  SelectableText(
                    presentationScript,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 24),

            // Slide 1 Detail
            const Text(
              "Slide 1: Análise da Série",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _buildSlideCard(
              icon: Icons.show_chart,
              title: 'O Problema (Heterocedasticidade)',
              points: [
                'Média zero (sem tendência), mas variância instável.',
                'Clusters de Volatilidade: Períodos calmos vs agitados.',
                'Justificativa: Séries financeiras violam a premissa de variância constante, exigindo GARCH.',
              ],
              color: Colors.orange,
            ),
            
            const SizedBox(height: 20),

            // Slide 2 Detail
            const Text(
              "Slide 2: Seleção do Modelo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _buildSlideCard(
              icon: Icons.architecture,
              title: 'A Metodologia (AIC vs BIC)',
              points: [
                'Testados: EGARCH e GJR-GARCH (captam assimetria).',
                'Ordens: (1,1), (1,2), (2,1) com t-Student (caudas pesadas).',
                'Conflito: AIC preferiu (2,1) (ajuste puro), BIC preferiu (1,1) (simplicidade).',
                'Decisão: EGARCH(1,1) sstd pela parcimónia.',
              ],
              highlight: 'Porquê (1,1)? O ganho do (2,1) não compensava a complexidade extra.',
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            // Slide 3 Detail
            const Text(
              "Slide 3: Diagnóstico",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
             _buildSlideCard(
              icon: Icons.check_circle_outline,
              title: 'A Validação (QQ-Plot)',
              points: [
                'Resultados: Alta persistência e efeito alavancagem confirmado.',
                'QQ-Plot: Resíduos alinhados à reta da t-Student assimétrica.',
                'Conclusão: Modelo bem especificado, sem padrões nos resíduos.',
              ],
              color: Colors.green,
            ),

            const SizedBox(height: 24),
            
            // Technical Cheat Sheet
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cábula Técnica (Para Perguntas):',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: selectedModelDetails));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cábula copiada!')),
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
                      height: 1.4,
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
    String? highlight,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: color.withOpacity(0.8), // Darker shade
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right, size: 22, color: Colors.grey[700]),
                  Expanded(
                    child: Text(
                      point, 
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
            if (highlight != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, size: 20, color: color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        highlight,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: color, 
                          fontSize: 14,
                        ),
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
