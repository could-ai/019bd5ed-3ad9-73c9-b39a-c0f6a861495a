import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State to toggle the "Align Card" simulation
  bool _alignCardToChart = false;

  @override
  Widget build(BuildContext context) {
    // Scenario: The Chart is stubborn at 1568.
    // The User wants to lower the Card (1576) to match the Chart (1568).
    
    // Chart is fixed at 1568 (The "Reality")
    final double chartTotal = 1568;
    
    // Card Value:
    // Without fix: 1576 (Iterating K_Type, counting duplicates)
    // With fix: 1568 (Removing K_Type iteration, matching Chart)
    final double cardValue = _alignCardToChart ? 1568 : 1576;

    // Data for the chart (Visual representation of 1568)
    final List<List<double>> chartData = [
      [395, 390, 385],  // Q1
      [395, 390, 385],  // Q2
      [394, 389, 384],  // Q3
      [384, 399, 394], // Q4
      // Total = 1568
    ];

    // DAX Code: Simplified Card Logic (Removing K_Type iteration)
    final String daxCode = '''Total Bars Airs (Match Chart) = 
SUMX(
    VALUES('9K'[Quarter_unif]),
    SUMX(
        VALUES('9K'[release_instance]),
        SUMX(
            VALUES('9K'[FC Res]),
            [Final Airs Counting (FC a FC)]
        )
    )
)
-- REMOVIDO: SUMX(VALUES('9K'[K_Type Patches])...)
-- Motivo: O gráfico não separa por K_Type, então o Card também não deve separar.''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solução: Ajustar Card ao Gráfico'),
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
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estratégia Inversa: Ajustar Card',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                        ),
                        Text(
                          'Remover iteração extra do Card para bater com o Gráfico',
                          style: TextStyle(fontSize: 12, color: Colors.brown),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _alignCardToChart,
                    activeColor: Colors.deepOrange,
                    onChanged: (value) {
                      setState(() {
                        _alignCardToChart = value;
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
                    subtitle: _alignCardToChart ? 'Alinhado (1568)' : 'Excesso (1576)',
                    value: cardValue.toStringAsFixed(0),
                    color: _alignCardToChart ? Colors.green.shade50 : Colors.red.shade50,
                    textColor: _alignCardToChart ? Colors.green.shade900 : Colors.red.shade900,
                    icon: Icons.functions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Soma do Gráfico',
                    subtitle: 'Fixo (1568)',
                    value: chartTotal.toStringAsFixed(0),
                    color: Colors.blue.shade50,
                    textColor: Colors.blue.shade900,
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Visualização Stacked Column (1568)',
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
                    _makeGroupData(0, chartData[0]),
                    _makeGroupData(1, chartData[1]),
                    _makeGroupData(2, chartData[2]),
                    _makeGroupData(3, chartData[3]),
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
                      const Expanded(
                        child: Text(
                          'Nova Medida para o CARD (Simplificada):',
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
                        Icon(Icons.info_outline, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ao remover o SUMX de "K_Type Patches", o Card deixa de contar duplicatas entre 5K e 9K, alinhando-se com o comportamento natural do gráfico (1568).',
                            style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
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
