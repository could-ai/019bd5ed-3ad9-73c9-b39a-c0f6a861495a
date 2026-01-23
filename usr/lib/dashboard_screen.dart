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
    // Presentation Script for FTSE 100 GARCH Analysis
    final String presentationScript = '''
• Slide 1: Contexto (Log-retornos)
"Analisando os log-retornos do FTSE 100, vemos oscilação em torno de zero (sem tendência), mas com 'clusters' de volatilidade. Períodos calmos alternam com instáveis, justificando o uso de modelos GARCH para captar essa dinâmica."

• Slide 2: Seleção do Modelo
"Estimamos modelos EGARCH e GJR-GARCH com distribuições t-Student (simétrica e assimétrica). Comparando AIC e BIC, o EGARCH(1,1) com t-Student assimétrica foi o escolhido. Embora o (2,1) tivesse um AIC ligeiramente melhor, o BIC (que penaliza complexidade) favoreceu o (1,1) por ser mais parcimonioso."

• Slide 3: Diagnóstico e Conclusão
"O modelo confirma que a volatilidade é persistente e existe efeito de alavancagem (más notícias afetam mais o mercado). O QQ-Plot mostra os resíduos alinhados à reta, validando a distribuição t-Student assimétrica e o bom ajuste do modelo."
''';

    // Model Details for the "Code" section
    final String selectedModelDetails = '''Modelo: EGARCH(1,1)
Distribuição: t-Student Assimétrica (sstd)
Critério de Escolha: BIC (Melhor trade-off ajuste/simplicidade)

AIC: -6.58747 (Muito próximo do modelo 2,1)
BIC: -6.582467 (Menor valor = Melhor escolha)

Características Capturadas:
- Persistência da volatilidade
- Efeito de Alavancagem (Leverage Effect)
- Caudas pesadas (Fat tails)''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise GARCH: FTSE 100'),
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
                            'Roteiro de Apresentação',
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
                            const SnackBar(content: Text('Roteiro copiado para a área de transferência!')),
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

            // Context Section (Slide 1)
            const Text(
              "1. Análise da Série (Slide 1)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.show_chart, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Comportamento dos Log-retornos',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('Média zero: Ausência de tendência.'),
                  _buildBulletPoint('Volatilidade variável: Períodos de calmaria vs. instabilidade.'),
                  _buildBulletPoint('Conclusão: Necessidade de modelos GARCH para modelar a variância condicional.'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Selection Section (Slide 2)
            const Text(
              "2. Seleção do Modelo (Slide 2)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.compare_arrows,
              title: 'EGARCH(1,1) vs EGARCH(2,1)',
              description: 'O modelo (2,1) teve AIC ligeiramente menor (-6.588 vs -6.587), mas a diferença é ínfima. O BIC penalizou a complexidade extra do (2,1).',
              highlight: 'Vencedor: EGARCH(1,1) sstd (Mais parcimonioso)',
            ),

            const SizedBox(height: 20),

            // Diagnostics Section (Slide 3)
            const Text(
              "3. Diagnóstico Final (Slide 3)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
             _buildInfoCard(
              icon: Icons.check_circle_outline,
              title: 'Validação do Modelo',
              description: 'QQ-Plot mostra resíduos alinhados com a distribuição teórica. Captura bem caudas pesadas e assimetria.',
              highlight: 'Conclusão: Modelo bem especificado.',
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
                        'Ficha Técnica do Modelo:',
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: Colors.black54),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String description, required String highlight}) {
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
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: const TextStyle(fontSize: 14)),
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
          ],
        ),
      ),
    );
  }
}
