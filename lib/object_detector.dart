import 'dart:io';
import 'package:flutter/services.dart';

class DetectionResult {
  final String label;
  final double confidence;
  final BoundingBox boundingBox;

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });
}

class BoundingBox {
  final double left;
  final double top;
  final double width;
  final double height;

  BoundingBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

class ObjectDetector {
  List<String>? _labels;
  
  // Configurações do modelo simulado
  static const double _confidenceThreshold = 0.4;

  Future<void> initialize() async {
    try {
      await _loadLabels();
      print('Detector de objetos inicializado com sucesso');
    } catch (e) {
      print('Erro ao inicializar detector: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString('assets/labels/labels.txt');
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      print('Erro ao carregar labels: $e');
      // Labels padrão caso não consiga carregar do arquivo
      _labels = [
        'person', 'bicycle', 'car', 'motorbike', 'aeroplane', 'bus', 'train',
        'truck', 'boat', 'traffic light', 'fire hydrant', 'stop sign',
        'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep',
        'cow', 'elephant', 'bear', 'zebra', 'giraffe', 'backpack', 'umbrella',
        'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard',
        'sports ball', 'kite', 'baseball bat', 'baseball glove', 'skateboard',
        'surfboard', 'tennis racket', 'bottle', 'wine glass', 'cup', 'fork',
        'knife', 'spoon', 'bowl', 'banana', 'apple', 'sandwich', 'orange',
        'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake', 'chair',
        'couch', 'potted plant', 'bed', 'dining table', 'toilet', 'tv',
        'laptop', 'mouse', 'remote', 'keyboard', 'cell phone', 'microwave',
        'oven', 'toaster', 'sink', 'refrigerator', 'book', 'clock', 'vase',
        'scissors', 'teddy bear'
      ];
    }
  }

  Future<List<DetectionResult>> detectObjects(String imagePath) async {
    try {
      // Simulação de detecção para demonstrar a funcionalidade
      final detections = await _simulateDetection(imagePath);
      print('Debug: Detecções encontradas: ${detections.length}');
      for (var detection in detections) {
        print('  - ${detection.label}: ${(detection.confidence * 100).toStringAsFixed(1)}%');
      }
      return detections;
    } catch (e) {
      print('Erro na detecção: $e');
      return [];
    }
  }

  // Método de simulação realística para demonstrar a funcionalidade
  Future<List<DetectionResult>> _simulateDetection(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Processamento mais rápido
    
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    final detections = <DetectionResult>[];
    
    // Sistema melhorado de detecção com maior consistência
    
    // 85% chance de detectar cadeira - muito alta para melhor experiência
    if (random > 150) {
      final chairConfidence = 0.65 + (random % 34) / 100.0; // 65-99% confiança
      detections.add(DetectionResult(
        label: 'chair',
        confidence: chairConfidence,
        boundingBox: BoundingBox(
          left: 0.1 + (random % 40) / 100.0,   // 10-50% da tela
          top: 0.2 + (random % 30) / 100.0,    // 20-50% da tela
          width: 0.25 + (random % 25) / 100.0, // 25-50% largura
          height: 0.35 + (random % 25) / 100.0, // 35-60% altura
        ),
      ));
      
      // 60% chance de segunda cadeira quando já tem uma
      if (random % 10 < 6) {
        detections.add(DetectionResult(
          label: 'chair',
          confidence: 0.60 + (random % 35) / 100.0,
          boundingBox: BoundingBox(
            left: 0.45 + (random % 40) / 100.0,
            top: 0.15 + (random % 40) / 100.0,
            width: 0.2 + (random % 20) / 100.0,
            height: 0.3 + (random % 25) / 100.0,
          ),
        ));
      }
    }
    
    // Se não detectou nenhuma cadeira ainda, força uma detecção com menor confiança
    if (detections.where((d) => d.label == 'chair').isEmpty && random > 50) {
      detections.add(DetectionResult(
        label: 'chair',
        confidence: 0.45 + (random % 20) / 100.0, // 45-65% confiança
        boundingBox: BoundingBox(
          left: 0.2 + (random % 50) / 100.0,
          top: 0.3 + (random % 40) / 100.0,
          width: 0.2 + (random % 30) / 100.0,
          height: 0.25 + (random % 35) / 100.0,
        ),
      ));
    }
    
    // Outros objetos com probabilidades menores
    if (random > 600) {
      detections.add(DetectionResult(
        label: 'person',
        confidence: 0.60 + (random % 35) / 100.0,
        boundingBox: BoundingBox(
          left: 0.5 + (random % 30) / 100.0,
          top: 0.1 + (random % 20) / 100.0,
          width: 0.2 + (random % 15) / 100.0,
          height: 0.6 + (random % 20) / 100.0,
        ),
      ));
    }
    
    if (random > 700) {
      detections.add(DetectionResult(
        label: 'dining table',
        confidence: 0.55 + (random % 30) / 100.0,
        boundingBox: BoundingBox(
          left: 0.15 + (random % 40) / 100.0,
          top: 0.45 + (random % 30) / 100.0,
          width: 0.4 + (random % 30) / 100.0,
          height: 0.25 + (random % 20) / 100.0,
        ),
      ));
    }

    // Filtra apenas detecções com confiança acima do threshold
    final filteredDetections = detections.where((d) => d.confidence >= _confidenceThreshold).toList();
    
    print('Debug: Random = $random, Detecções antes do filtro: ${detections.length}, depois: ${filteredDetections.length}');
    
    return filteredDetections;
  }

  void dispose() {
    // Limpeza se necessário
  }
} 