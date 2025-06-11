import 'package:flutter/material.dart';

class DemoInfoScreen extends StatelessWidget {
  const DemoInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como Funciona'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              icon: Icons.camera_alt,
              title: 'Captura de Imagem',
              description: 'O app captura frames da câmera em tempo real para análise.',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.psychology,
              title: 'Processamento com IA',
              description: 'Cada frame é analisado usando algoritmos de visão computacional para identificar objetos.',
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.chair,
              title: 'Detecção de Cadeiras',
              description: 'O sistema identifica cadeiras e outros objetos, destacando-os com caixas coloridas.',
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.visibility,
              title: 'Visualização em Tempo Real',
              description: 'As detecções são mostradas instantaneamente sobre a imagem da câmera.',
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              'Objetos Detectáveis',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            _buildObjectsList(),
            const SizedBox(height: 24),
            _buildTipsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectsList() {
    final objects = [
      {'name': 'Cadeiras', 'icon': Icons.chair, 'highlight': true},
      {'name': 'Pessoas', 'icon': Icons.person, 'highlight': false},
      {'name': 'Mesas', 'icon': Icons.table_restaurant, 'highlight': false},
      {'name': 'Sofás', 'icon': Icons.weekend, 'highlight': false},
      {'name': 'Laptops', 'icon': Icons.laptop, 'highlight': false},
      {'name': 'Celulares', 'icon': Icons.phone_android, 'highlight': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: objects.map((obj) {
          final isHighlight = obj['highlight'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isHighlight ? Colors.green.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHighlight ? Colors.green : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  obj['icon'] as IconData,
                  color: isHighlight ? Colors.green : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  obj['name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                    color: isHighlight ? Colors.green : Colors.grey[700],
                  ),
                ),
                if (isHighlight) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'FOCO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.amber[700],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Dicas para Melhor Detecção',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Use boa iluminação no ambiente'),
          _buildTipItem('Mantenha a câmera estável'),
          _buildTipItem('Aponte diretamente para os objetos'),
          _buildTipItem('Mantenha distância adequada (1-3 metros)'),
          _buildTipItem('Evite fundos muito complexos'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.amber[600],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 