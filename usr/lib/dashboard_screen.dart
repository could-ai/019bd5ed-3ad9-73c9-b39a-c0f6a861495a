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
    // Card (DAX Sum) = 1576.
    // Page Filter: "FC is not blank" is ACTIVE.
    
    // Logic:
    // The 8 extra items HAVE a valid FC (so they pass the page filter).
    // However, they likely have a BLANK Quarter or Release.
    // Chart: Hides Blank Quarters automatically.
    // Card: Counts Blank Quarters unless explicitly filtered.
    
    final double chartTotal = 1568;
    
    // Card Value:
    // Without filter: 1576 (Counts items with Valid FC but Blank Quarter)
    // With filter: 1568 (Matches Chart by excluding Blank Quarter)
    final double cardValue = _filterBlanks ? 1568 : 1576;

    // Data for the chart (Visual representation of 1568)
    final List<List<double>> chartData = [
      [395, 390, 385],  // Q1
      [395, 390, 385],  // Q2
      [394, 389, 384],  // Q3
      [384, 399, 394], // Q4
      // Total = 1568
    ];

    // DAX Code: Removing Blanks from Iteration
    final String daxCode = '''Total Card (Match Chart) = 
SUMX(
    FILTER(
        VALUES('9K'[Quarter_unif]), 
        NOT ISBLANK('9K'[Quarter_unif])
    ),
    SUMX(
        FILTER(
            VALUES('9K'[release_instance]), 
            NOT ISBLANK('9K'[release_instance])
        ),
        [Final Airs Counting (FC a FC)]
    )
)
-- O filtro de página "FC não é blank" deixa passar linhas com FC válido.
-- Mas essas linhas podem ter Quarter ou Release VAZIOS.
-- O Gráfico esconde Quarter vazio. O Card conta.
-- Este código remove explicitamente os vazios para igualar.''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise: Filtro de Página vs. Blanks'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation of Page Filter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'O Filtro de Página "FC não é Blank" ajuda?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SIM, ele remove linhas sem valor. MAS...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'As 8 unidades extras (1576 - 1568) provavelmente têm um FC válido (passam no filtro), mas têm "Quarter" ou "Release" em BRANCO.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• O Gráfico esconde colunas/legendas em branco automaticamente.\n• O Card (DAX) conta tudo, inclusive categorias em branco.',
                    style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Control Panel
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simular Correção no Card',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                        ),
                        Text(
                          'Adicionar NOT ISBLANK(Quarter) na medida',
                          style: TextStyle(fontSize: 12, color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _filterBlanks,
                    activeColor: Colors.deepOrange,
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
                    title: 'Seu Card Atual',
                    subtitle: _filterBlanks ? 'Corrigido (1568)' : 'Com "Ghosts" (1576)',
                    value: cardValue.toStringAsFixed(0),
                    color: _filterBlanks ? Colors.green.shade50 : Colors.red.shade50,
                    textColor: _filterBlanks ? Colors.green.shade900 : Colors.red.shade900,
                    icon: Icons.functions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Soma do Gráfico',
                    subtitle: 'Visual (1568)',
                    value: chartTotal.toStringAsFixed(0),
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade900,
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
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
                          'Solução para o Card (Ignorar Blanks):',
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
                      color: Colors.orangeAccent,
                      fontFamily: 'Courier',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.lightBlueAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Use esta medida no CARD. Ela força a exclusão de Quarters vazios, mesmo que o FC seja válido, alinhando com o comportamento visual do gráfico.',
                            style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 13),
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

  BarChartGroupData _makeGroupData(int x, List<double> values) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: values.reduce((a, b) => a + b),
          rodStackItems: [
            BarChartRodStackItem(0, values[0], Colors.blue),
            BarChartRodStackItem(values[0], values[0] + values[1], Colors.orange),
            BarChartRodStackItem(values[0] + values[1], values[0] + values[1] + values[2], Colors.green),
          ],
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
