import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'object_detector.dart';

class ChairDetectorScreen extends StatefulWidget {
  final CameraDescription camera;

  const ChairDetectorScreen({super.key, required this.camera});

  @override
  State<ChairDetectorScreen> createState() => _ChairDetectorScreenState();
}

class _ChairDetectorScreenState extends State<ChairDetectorScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  ObjectDetector? _detector;
  bool _isDetecting = false;
  List<DetectionResult> _detections = [];
  int _chairCount = 0;
  bool _flashEnabled = false;
  String _detectionStatus = 'Iniciando detecção...';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeDetector();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize();
    
    await _initializeControllerFuture;
    if (mounted) {
      setState(() {});
      _startDetection();
    }
  }

  Future<void> _initializeDetector() async {
    _detector = ObjectDetector();
    await _detector!.initialize();
  }

  void _startDetection() {
    if (_controller == null || !_controller!.value.isInitialized || _isDetecting) {
      return;
    }

    _isDetecting = true;
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (!mounted || _controller == null || !_controller!.value.isInitialized) {
        timer.cancel();
        return;
      }

      try {
        final XFile image = await _controller!.takePicture();
        final detections = await _detector?.detectObjects(image.path) ?? [];
        
        if (mounted) {
          setState(() {
            _detections = detections;
            _chairCount = detections.where((d) => d.label == 'chair').length;
            _detectionStatus = _chairCount > 0 
              ? 'Cadeiras encontradas!' 
              : 'Procurando cadeiras...';
          });
        }
      } catch (e) {
        print('Erro na detecção: $e');
        if (mounted) {
          setState(() {
            _detectionStatus = 'Erro na detecção - tentando novamente...';
          });
        }
      }
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    
    try {
      await _controller!.setFlashMode(
        _flashEnabled ? FlashMode.off : FlashMode.torch,
      );
      setState(() {
        _flashEnabled = !_flashEnabled;
      });
    } catch (e) {
      print('Erro ao alternar flash: $e');
    }
  }

  @override
  void dispose() {
    _isDetecting = false;
    _controller?.dispose();
    _detector?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detectando Cadeiras'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_flashEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Preview da câmera
                Positioned.fill(
                  child: CameraPreview(_controller!),
                ),
                
                // Overlay das detecções
                Positioned.fill(
                  child: CustomPaint(
                    painter: DetectionOverlayPainter(_detections),
                  ),
                ),
                
                // Informações da detecção
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.chair, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Cadeiras detectadas: $_chairCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _detectionStatus,
                          style: TextStyle(
                            color: _chairCount > 0 ? Colors.green : Colors.orange,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (_chairCount > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              '✓ Cadeira(s) encontrada(s)!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Lista de objetos detectados
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Objetos detectados:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _detections.length,
                            itemBuilder: (context, index) {
                              final detection = _detections[index];
                              final isChair = detection.label == 'chair';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isChair 
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    if (isChair)
                                      const Icon(Icons.chair, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${detection.label} (${(detection.confidence * 100).toStringAsFixed(1)}%)',
                                      style: TextStyle(
                                        color: isChair ? Colors.green : Colors.white,
                                        fontSize: 12,
                                        fontWeight: isChair ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetectionOverlayPainter extends CustomPainter {
  final List<DetectionResult> detections;

  DetectionOverlayPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final detection in detections) {
      final isChair = detection.label == 'chair';
      paint.color = isChair ? Colors.green : Colors.blue;
      
      final rect = Rect.fromLTWH(
        detection.boundingBox.left * size.width,
        detection.boundingBox.top * size.height,
        detection.boundingBox.width * size.width,
        detection.boundingBox.height * size.height,
      );

      // Desenhar bounding box
      canvas.drawRect(rect, paint);

      // Desenhar label
      final labelText = '${detection.label} ${(detection.confidence * 100).toStringAsFixed(1)}%';
      textPainter.text = TextSpan(
        text: labelText,
        style: TextStyle(
          color: isChair ? Colors.green : Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withOpacity(0.7),
        ),
      );
      textPainter.layout();
      
      final labelRect = Rect.fromLTWH(
        rect.left,
        rect.top - textPainter.height - 4,
        textPainter.width + 8,
        textPainter.height + 4,
      );
      
      canvas.drawRect(labelRect, Paint()..color = Colors.black.withOpacity(0.7));
      textPainter.paint(canvas, Offset(rect.left + 4, rect.top - textPainter.height - 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 