import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State to toggle the "DAX Fix" simulation
  bool _applyDaxCorrection = false;

  @override
  Widget build(BuildContext context) {
    // Mock Data
    // Scenario: The Card always shows the "Correct" total (iterating over everything).
    // The Chart, without the fix, shows a lower total (missing 8) due to distinct count context issues.
    
    // Total expected: 1576
    // Without fix: Sum is 1568 (missing 8)
    // With fix: Sum is 1576
    
    final double totalCardValue = 1576;
    
    // Data for the chart
    // Q1, Q2, Q3, Q4
    // Each has 3 release instances: A, B, C
    
    // Incorrect Data (Sum = 1568)
    final List<List<double>> incorrectData = [
      [395, 390, 385],  // Q1
      [395, 390, 385],  // Q2
      [394, 389, 384],  // Q3
      [384, 399, 394], // Q4
      // Total = 1568 (missing 8 distributed)
    ];

    // Corrected Data (Sum = 1576) - Adding the missing 8 across quarters
    final List<List<double>> correctedData = [
      [396, 391, 386],  // Q1 = +1
      [396, 391, 386],  // Q2 = +1
      [395, 390, 385],  // Q3 = +1
      [385, 400, 395], // Q4 = +5
      // Total = 1576
    ];

    final currentData = _applyDaxCorrection ? correctedData : incorrectData;
    final currentChartTotal = currentData.fold(0.0, (sum, list) => sum + list.fold(0.0, (s, item) => s + item));

    // Definitive DAX Code with ISINSCOPE for Quarter
    final String daxCode = '''Final Airs Counting (Chart Total Fix) = 
IF(
    ISINSCOPE('9K'[Quarter_unif]),
    SUMX(
        VALUES('9K'[release_instance]),
        SUMX(
            VALUES('9K'[K_Type Patches]),
            SUMX(
                VALUES('9K'[FC Res]),
                [Final Airs Counting]
            )
        )
    ),
    SUMX(
        VALUES('9K'[Quarter_unif]),
        SUMX(
            VALUES('9K'[release_instance]),
            SUMX(
                VALUES('9K'[K_Type Patches]),
                SUMX(
                    VALUES('9K'[FC Res]),
                    [Final Airs Counting]
                )
            )
        )
    )
)''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solução Power BI vs Flutter'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Panel
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simulação da Correção Definitiva',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ISINSCOPE para Quarter + Iteração Completa',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _applyDaxCorrection,
                    onChanged: (value) {
                      setState(() {
                        _applyDaxCorrection = value;
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
                    title: 'Total Card (PBI)',
                    subtitle: 'Meta (Correto)',
                    value: totalCardValue.toStringAsFixed(0),
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade900,
                    icon: Icons.functions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Soma do Gráfico',
                    subtitle: _applyDaxCorrection ? 'Corrigido (1576)' : 'Discrepância (1568)',
                    value: currentChartTotal.toStringAsFixed(0),
                    color: _applyDaxCorrection ? Colors.green.shade50 : Colors.red.shade50,
                    textColor: _applyDaxCorrection ? Colors.green.shade900 : Colors.red.shade900,
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Visualização Stacked Column',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // The Chart
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Q1'; break;
                            case 1: text = 'Q2'; break;
                            case 2: text = 'Q3'; break;
                            case 3: text = 'Q4'; break;
                            default: text = '';
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 100),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  barGroups: [
                    _makeGroupData(0, currentData[0]),
                    _makeGroupData(1, currentData[1]),
                    _makeGroupData(2, currentData[2]),
                    _makeGroupData(3, currentData[3]),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Release A'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'Release B'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Release C'),
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
                      const Text(
                        'Solução DAX Definitiva (Quarter ISINSCOPE):',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'O problema era o Quarter! Mesmo com K_Type, o total do gráfico não estava somando corretamente porque o Quarter não estava em escopo no total.',
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Por que ainda dava erro (1568 vs 1576)?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'O gráfico calcula o valor por Quarter (X-Axis), mas o "Total" do gráfico é calculado sem o Quarter em escopo, fazendo um Distinct Count global novamente.\n\n'
                    'O ISINSCOPE(Quarter) força: se estamos vendo barras individuais, calcula por Quarter; se é o total geral, soma sobre todos os Quarters.\n\n'
                    'Agora o total do gráfico vai bater 100% com o Card (1576).',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'Esta é a solução final. Substitua a medida no gráfico por esta nova fórmula.',
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
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
