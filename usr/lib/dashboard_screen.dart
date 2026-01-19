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

    // DAX Code: KEEPFILTERS Strategy
    final String daxCode = '''Card Match Chart (KEEPFILTERS) = 
VAR CombinacoesValidas = 
    FILTER(
        SUMMARIZE(
            '9K', 
            '9K'[Quarter_unif], 
            '9K'[release_instance]
        ),
        -- Garante que só pegamos combinações com texto real
        LEN(TRIM('9K'[Quarter_unif])) > 0 && 
        LEN(TRIM('9K'[release_instance])) > 0
    )
RETURN
    CALCULATE(
        [Final Airs Counting (FC a FC)],
        -- KEEPFILTERS aplica a tabela filtrada como um filtro rígido
        -- Isso intersecta com o contexto atual e remove os "fantasmas"
        KEEPFILTERS(CombinacoesValidas)
    )''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meta: 1568 (Igual ao Gráfico)'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'O Objetivo é 1568!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se SUMX não funcionou, vamos tentar KEEPFILTERS.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'SUMMARIZECOLUMNS geralmente dá erro em medidas com filtros de página. O melhor é usar SUMMARIZE com KEEPFILTERS para "cortar" os dados vazios.',
                    style: TextStyle(fontSize: 14),
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
                          'Simular Solução "KEEPFILTERS"',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        Text(
                          'Forçar intersecção apenas com dados válidos',
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
                    title: 'Tabela / Código Antigo',
                    subtitle: 'Mostra Tudo',
                    value: tableTotal.toStringAsFixed(0),
                    color: Colors.red.shade50,
                    textColor: Colors.red.shade900,
                    icon: Icons.close,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Gráfico (Meta)',
                    subtitle: 'Soma Barras',
                    value: chartTotal.toStringAsFixed(0),
                    color: Colors.green.shade50,
                    textColor: Colors.green.shade900,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildKpiCard(
              title: 'Seu Card (Novo Código)',
              subtitle: _filterBlanks ? 'Sucesso (1568)' : 'Ainda Falhando (1576)',
              value: cardValue.toStringAsFixed(0),
              color: _filterBlanks ? Colors.blue.shade50 : Colors.orange.shade50,
              textColor: _filterBlanks ? Colors.blue.shade900 : Colors.orange.shade900,
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
                          'Solução KEEPFILTERS (Mais Robusta):',
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
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.purple.withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.purpleAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'DICA IMPORTANTE: Verifique se o seu Gráfico tem algum "Filtro Visual" (Visual Level Filter) na aba de filtros lateral. Se tiver, o Card precisa ter esse mesmo filtro aplicado manualmente no CALCULATE.',
                            style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 13),
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
