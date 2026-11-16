import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/location_service.dart';

class GeolocalizacaoScreen extends StatefulWidget {
  const GeolocalizacaoScreen({super.key});

  @override
  State<GeolocalizacaoScreen> createState() => _GeolocalizacaoScreenState();
}

class _GeolocalizacaoScreenState extends State<GeolocalizacaoScreen> {
  final _locationService = LocationService();

  // Coordenadas de referência: Fatec Matão (Campus Luiz Marchesan)
  static const double _fatecMataoLat = -21.6033;
  static const double _fatecMataoLng = -48.3658;

  Position? _posicaoAtual;
  bool _carregando = false;
  String? _mensagemErro;
  StreamSubscription<Position>? _positionStreamSub;
  bool _rastreando = false;

  Future<void> _buscarLocalizacao() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final posicao = await _locationService.obterPosicaoAtual();
      setState(() => _posicaoAtual = posicao);
    } catch (e) {
      setState(() {
        _mensagemErro = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _alternarRastreamento() {
    if (_rastreando) {
      _positionStreamSub?.cancel();
      setState(() => _rastreando = false);
    } else {
      setState(() {
        _rastreando = true;
        _mensagemErro = null;
      });

      _positionStreamSub = _locationService.monitorarPosicao().listen(
        (pos) => setState(() => _posicaoAtual = pos),
        onError: (err) => setState(() {
          _mensagemErro = err.toString().replaceAll('Exception: ', '');
          _rastreando = false;
        }),
      );
    }
  }

  /// DESAFIO BÁSICO: Indicador visual (Chip) da qualidade da precisão
  Widget _buildChipPrecisao(double accuracy) {
    Color corFundo;
    Color corTexto;
    String status;

    if (accuracy < 15) {
      corFundo = Colors.green.shade100;
      corTexto = Colors.green.shade900;
      status = 'Alta (${accuracy.toStringAsFixed(1)}m)';
    } else if (accuracy <= 50) {
      corFundo = Colors.amber.shade100;
      corTexto = Colors.amber.shade900;
      status = 'Média (${accuracy.toStringAsFixed(1)}m)';
    } else {
      corFundo = Colors.red.shade100;
      corTexto = Colors.red.shade900;
      status = 'Baixa (${accuracy.toStringAsFixed(1)}m)';
    }

    return Chip(
      backgroundColor: corFundo,
      side: BorderSide.none,
      avatar: Icon(Icons.radar, size: 18, color: corTexto),
      label: Text(
        status,
        style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// DESAFIO INTERMEDIÁRIO: Calcula distância em metros até a Fatec Matão
  String _calcularDistanciaFatec() {
    if (_posicaoAtual == null) return '-';

    final distanciaMetros = Geolocator.distanceBetween(
      _posicaoAtual!.latitude,
      _posicaoAtual!.longitude,
      _fatecMataoLat,
      _fatecMataoLng,
    );

    if (distanciaMetros >= 1000) {
      final km = distanciaMetros / 1000;
      return '${distanciaMetros.toStringAsFixed(0)} m (${km.toStringAsFixed(2)} km)';
    }
    return '${distanciaMetros.toStringAsFixed(1)} m';
  }

  /// DESAFIO AVANÇADO: Abre coordenadas atuais no Google Maps
  Future<void> _abrirNoGoogleMaps() async {
    if (_posicaoAtual == null) return;

    final lat = _posicaoAtual!.latitude;
    final lng = _posicaoAtual!.longitude;
    final url = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o Google Maps.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in & GPS'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_carregando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            if (_mensagemErro != null)
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _mensagemErro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            if (_posicaoAtual != null) ...[
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                        title: const Text('Latitude'),
                        subtitle: Text('${_posicaoAtual!.latitude}'),
                        trailing: _buildChipPrecisao(_posicaoAtual!.accuracy),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        title: const Text('Longitude'),
                        subtitle: Text('${_posicaoAtual!.longitude}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.speed, color: Colors.orange),
                        title: const Text('Precisão / Altitude'),
                        subtitle: Text(
                          'Precisão: ${_posicaoAtual!.accuracy.toStringAsFixed(1)}m | '
                          'Alt: ${_posicaoAtual!.altitude.toStringAsFixed(1)}m',
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.school, color: Colors.indigo),
                        title: const Text('Distância até a Fatec Matão'),
                        subtitle: Text(_calcularDistanciaFatec()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: _abrirNoGoogleMaps,
                icon: const Icon(Icons.map),
                label: const Text('Abrir no Mapa'),
              ),
            ],

            const Spacer(),

            ElevatedButton.icon(
              onPressed: _carregando ? null : _buscarLocalizacao,
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Capturar Localização Atual'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _alternarRastreamento,
              icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
              label: Text(
                _rastreando
                    ? 'Parar Rastreamento'
                    : 'Iniciar Rastreamento Contínuo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
