# 🪑 Detector de Cadeiras - App de Visão Computacional

Um aplicativo Flutter simples que usa visão computacional para identificar cadeiras em tempo real através da câmera do dispositivo.

## 📱 Funcionalidades

- **Detecção em Tempo Real**: Identificação de cadeiras usando a câmera do dispositivo
- **Interface Intuitiva**: Interface moderna e fácil de usar
- **Contagem Automática**: Conta automaticamente o número de cadeiras detectadas
- **Sobreposição Visual**: Desenha caixas delimitadoras ao redor dos objetos detectados
- **Controle de Flash**: Ative/desative o flash da câmera conforme necessário
- **Lista de Objetos**: Mostra todos os objetos detectados com níveis de confiança

## 🚀 Como Usar

1. **Inicializar o App**: Abra o aplicativo no seu dispositivo
2. **Conceder Permissões**: Permita o acesso à câmera quando solicitado
3. **Iniciar Detecção**: Toque em "Iniciar Detecção" na tela inicial
4. **Apontar Câmera**: Aponte a câmera para cadeiras e outros objetos
5. **Ver Resultados**: As cadeiras detectadas aparecerão destacadas em verde

## 🛠️ Instalação e Configuração

### Pré-requisitos
- Flutter SDK (versão 3.7.0 ou superior)
- Android Studio ou VS Code
- Dispositivo Android/iOS com câmera

### Passos de Instalação

1. **Clone o Repositório**
   ```bash
   git clone <seu-repositorio>
   cd optativa
   ```

2. **Instalar Dependências**
   ```bash
   flutter pub get
   ```

3. **Executar o App**
   ```bash
   flutter run
   ```

## 📦 Dependências Principais

- `camera`: Para acesso à câmera do dispositivo
- `tflite_flutter`: Para execução de modelos de machine learning
- `permission_handler`: Para gerenciar permissões do sistema
- `image`: Para processamento de imagens

## 🔧 Configuração de Permissões

### Android
As seguintes permissões são automaticamente solicitadas:
- `CAMERA`: Para acessar a câmera
- `FLASHLIGHT`: Para controlar o flash

### iOS
Adicione as seguintes permissões ao `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Este app precisa acessar a câmera para detectar cadeiras</string>
```

## 🧠 Como Funciona

O aplicativo utiliza técnicas de visão computacional para:

1. **Captura de Imagens**: Obtém frames da câmera em intervalos regulares
2. **Processamento**: Analisa cada frame em busca de objetos
3. **Detecção**: Identifica cadeiras e outros objetos usando algoritmos de IA
4. **Visualização**: Desenha caixas delimitadoras e exibe informações

## 🎯 Próximas Melhorias

- [ ] Integração com modelo TensorFlow Lite real
- [ ] Detecção de diferentes tipos de cadeiras
- [ ] Salvar capturas de tela com detecções
- [ ] Estatísticas de uso
- [ ] Modo offline
- [ ] Detecção de outros móveis

## 🔧 Desenvolvimento

### Estrutura do Projeto
```
lib/
├── main.dart                 # Tela principal e inicialização
├── chair_detector_screen.dart # Tela de detecção com câmera
└── object_detector.dart      # Lógica de detecção de objetos

assets/
├── models/                   # Modelos de IA (futuro)
└── labels/                   # Labels dos objetos detectáveis
```

### Modo de Desenvolvimento

O aplicativo atualmente usa um sistema de simulação para demonstrar a funcionalidade. Para usar um modelo real de TensorFlow Lite:

1. Adicione o arquivo `.tflite` em `assets/models/`
2. Descomente e adapte o código em `object_detector.dart`
3. Configure os parâmetros do modelo conforme necessário

## 📄 Licença

Este projeto é desenvolvido para fins educacionais e demonstrativos.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Submeter pull requests

## 📞 Suporte

Para dúvidas ou problemas, abra uma issue no repositório do projeto.

---

**Desenvolvido com ❤️ usando Flutter**
