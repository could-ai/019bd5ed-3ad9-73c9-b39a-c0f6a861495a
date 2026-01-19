import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State to toggle the "Filter Blanks" simulation
  bool _filterBlanks = false;

  @override
  Widget build(BuildContext context) {
    // Scenario: 
    // Chart (Visual Sum) = 1568.
    // Table (Converted Chart) = 1576.
    // Card (DAX Sum) = 1576.
    
    final double chartTotal = 1568;
    final double tableTotal = 1576;
    
    // Card Value:
    // Without filter: 1576 (Includes Blank/Empty Strings)
    // With filter: 1568 (Excludes Empty Strings to match Chart)
    final double cardValue = _filterBlanks ? 1568 : 1576;

    // Data for the chart (Visual representation of 1568)
    final List<List<double>> chartData = [
      [395, 390, 385],  // Q1
      [395, 390, 385],  // Q2
      [394, 389, 384],  // Q3
      [384, 399, 394], // Q4
      // Total = 1568
    ];

    // DAX Code: Handling Empty Strings ("") which ISBLANK misses
    final String daxCode = '''Card Match Chart (String Fix) = 
CALCULATE(
    [Final Airs Counting (FC a FC)],
    '9K'[Quarter_unif] <> "",
    '9K'[release_instance] <> "",
    NOT ISBLANK('9K'[Quarter_unif]),
    NOT ISBLANK('9K'[release_instance])
)
-- Se ISBLANK não funcionou, é quase certo que são "Textos Vazios" ("").
-- O Power BI trata "" diferente de BLANK().
-- O Gráfico esconde os dois. A Tabela mostra.
-- Este código remove ambos para bater 1568.''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico: Texto Vazio vs Blank'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diagnosis Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'ISBLANK falhou? Então são "Strings Vazias"!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se o filtro "NOT ISBLANK" não mudou o valor de 1576, significa que os campos NÃO são nulos (null).',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Eles provavelmente contêm um texto vazio ("") que parece branco, mas conta como valor válido para o DAX.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• O Gráfico esconde "" automaticamente.\n• A Tabela mostra "" (pode parecer uma linha fina vazia).\n• O Card soma tudo.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Control Panel
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filtrar Strings Vazias ("")',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        Text(
                          'Remover itens com texto vazio',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _filterBlanks,
                    activeColor: Colors.blueAccent,
                    onChanged: (value) {
                      setState(() {
                        _filterBlanks = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // KPI Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Tabela',
                    subtitle: 'Mostra Vazios (1576)',
                    value: tableTotal.toStringAsFixed(0),
                    color: Colors.grey.shade100,
                    textColor: Colors.black87,
                    icon: Icons.table_chart,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Gráfico',
                    subtitle: 'Esconde Vazios (1568)',
                    value: chartTotal.toStringAsFixed(0),
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade900,
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildKpiCard(
              title: 'Seu Card (Meta)',
              subtitle: _filterBlanks ? 'Corrigido (Sem "")' : 'Original (Com "")',
              value: cardValue.toStringAsFixed(0),
              color: _filterBlanks ? Colors.green.shade50 : Colors.red.shade50,
              textColor: _filterBlanks ? Colors.green.shade900 : Colors.red.shade900,
              icon: Icons.functions,
            ),
            
            const SizedBox(height: 30),
            
            // DAX Solution Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Nova Tentativa (Remove ""):',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70),
                        tooltip: 'Copiar Código',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: daxCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Código DAX copiado!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 8),
                  Text(
                    daxCode,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amberAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Adicionei a verificação <> "" (diferente de vazio). Isso pega casos que o ISBLANK deixa passar.',
                            style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
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

  Widget _buildKpiCard({
    required String title,
    required String subtitle,
    required String value,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor, size: 20),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
