import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
    
    // Total expected: 118
    // Without fix: Sum is 110 (missing 8)
    // With fix: Sum is 118
    
    final double totalCardValue = 118;
    
    // Data for the chart
    // Q1, Q2, Q3, Q4
    // Each has 3 release instances: A, B, C
    
    // Incorrect Data (Sum = 110)
    final List<List<double>> incorrectData = [
      [10, 8, 5],  // Q1 = 23
      [10, 8, 6],  // Q2 = 24
      [15, 7, 4],  // Q3 = 26
      [15, 12, 10], // Q4 = 37
      // Total = 110
    ];

    // Corrected Data (Sum = 118) - Distributing the "missing 8" across the quarters
    final List<List<double>> correctedData = [
      [12, 9, 6],  // Q1 = 27 (+4)
      [11, 9, 6],  // Q2 = 26 (+2)
      [16, 7, 4],  // Q3 = 27 (+1)
      [15, 13, 10], // Q4 = 38 (+1)
      // Total = 118
    ];

    final currentData = _applyDaxCorrection ? correctedData : incorrectData;
    final currentChartTotal = currentData.fold(0.0, (sum, list) => sum + list.fold(0.0, (s, item) => s + item));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Power BI vs Flutter'),
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
                          'Simulação da Correção DAX',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Aplica ISINSCOPE para forçar a soma correta',
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
                    subtitle: 'Iteração Completa',
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
                    subtitle: _applyDaxCorrection ? 'Alinhado' : 'Discrepância (-8)',
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
              'Final Airs Counting (FC a FC) por Quarter',
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
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 10),
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
            
            // DAX Explanation Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solução DAX Aplicada:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '''Final Airs Counting (FC a FC) - Consistente no Stacked =
IF(
    ISINSCOPE('9K'[release_instance]),
    [Final Airs Counting (FC a FC)],
    SUMX(
        VALUES('9K'[release_instance]),
        [Final Airs Counting (FC a FC)]
    )
)''',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'Courier',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Explicação: O problema original era que o total do gráfico fazia um DISTINCTCOUNT global, ignorando sobreposições entre releases. Ao usar SUMX com VALUES(\'release_instance\'), forçamos o Power BI a somar os valores individuais das barras, garantindo que o total do gráfico (${currentChartTotal.toInt()}) bata com o Card (${totalCardValue.toInt()}).',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
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
