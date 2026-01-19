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
    final double chartTotal = 1568;
    final double tableTotal = 1576;
    
    // DAX Code: Detective Measure
    final String detectiveCode = '''Check Hidden Values = 
VAR QtdCaracteres = LEN(TRIM(SELECTEDVALUE('9K'[Quarter_unif])))
VAR Valor = [Final Airs Counting (FC a FC)]
RETURN
    IF(
        QtdCaracteres = 0 || ISBLANK(QtdCaracteres), 
        "⚠️ FANTASMA ENCONTRADO (" & Valor & ")", 
        "OK"
    )''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigação: Os 8 Perdidos'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.search, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Se não há "Blanks", o que são?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Se você converteu o gráfico em Tabela e viu 1576, mas a soma visual das barras dá 1568, temos 3 suspeitos principais:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSuspectItem(
                    '1. O "Espaço em Branco" (Space)',
                    'Existe alguma categoria cujo nome é apenas um espaço " "? O Power BI não considera isso como BLANK, mas no gráfico fica invisível.',
                  ),
                  _buildSuspectItem(
                    '2. Valores Muito Pequenos',
                    'Você tem barras com valor 1 ou 2? Elas podem estar tão finas que somem no gráfico, mas contam na tabela. A diferença é pequena (8 unidades).',
                  ),
                  _buildSuspectItem(
                    '3. Linhas sem Correspondência',
                    'Mesmo que sua coluna original não tenha blanks, o relacionamento entre tabelas pode gerar uma linha em branco na visualização se não houver match.',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Action Plan
            const Text(
              "Como achar os culpados agora:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            _buildActionCard(
              icon: Icons.sort,
              title: 'Passo 1: Ordene a Tabela',
              description: 'Na sua Tabela de 1576, clique no cabeçalho da coluna de VALOR para ordenar do menor para o maior. Veja se aparecem linhas com valores pequenos (1, 2, etc) ou linhas sem nome no topo.',
            ),
            
            const SizedBox(height: 10),

            _buildActionCard(
              icon: Icons.code,
              title: 'Passo 2: Use o "Detector"',
              description: 'Crie esta medida temporária e arraste para a sua Tabela. Ela vai gritar onde está o problema.',
            ),

            const SizedBox(height: 16),
            
            // Code Section
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
                        'Medida Detetive:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: detectiveCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Código copiado!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  Text(
                    detectiveCode,
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

  Widget _buildSuspectItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: Colors.black54),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required String description}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
