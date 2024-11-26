# texasgym_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

 # Aviso de problema caso tentar emular com um emulador sem aceleração de hardware
Na tela ExerciciosView.dart pode causar exception devido a um problema com a criação de uma Platform View, que é uma integração entre o Flutter e componentes nativos (como o WebView). No caso, a exceção ocorre porque o tipo de Platform View (com.pichillilorenzo/flutter_inappwebview) não está registrado corretamente ou está sendo utilizado em um contexto que não suporta isso, como em dispositivos emuladores sem suporte ao Hardware Acceleration ou configurações específicas.