import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Captura única da posição atual com validações defensivas
  Future<Position> obterPosicaoAtual() async {
    // 1. Verifica se o GPS do dispositivo está ligado
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('O serviço de GPS está desativado no dispositivo.');
    }

    // 2. Verifica e solicita permissão de acesso
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada pelo usuário.');
      }
    }

    // 3. Trata bloqueio permanente nas configurações do SO
    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissões negadas permanentemente. Altere nas configurações.',
      );
    }

    // 4. Retorna as coordenadas com alta precisão
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Rastreamento contínuo em fluxo (Stream) a cada 10 metros de deslocamento
  Stream<Position> monitorarPosicao() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}