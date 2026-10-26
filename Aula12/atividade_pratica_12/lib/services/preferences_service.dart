import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyNomeUsuario = 'key_nome_usuario';
  static const String _keyModoEscuro = 'key_modo_escuro';
  static const String _keyUltimoAcesso = 'key_ultimo_acesso';
  static const String _keyHistorico = 'key_historico';

  Future<void> salvarNomeUsuario(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNomeUsuario, nome);
  }

  Future<String> obterNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNomeUsuario) ?? 'Usuário Convidado';
  }

  Future<void> salvarModoEscuro(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyModoEscuro, valor);
  }

  Future<bool> obterModoEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyModoEscuro) ?? false;
  }

  Future<void> salvarUltimoAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUltimoAcesso, DateTime.now().toString());
  }

  Future<String> obterUltimoAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUltimoAcesso) ?? 'Primeiro acesso';
  }

  Future<void> salvarHistorico(List<Map<String, dynamic>> historico) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(historico);
    await prefs.setString(_keyHistorico, jsonString);
  }

  Future<List<Map<String, dynamic>>> obterHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyHistorico);
    if (jsonString != null) {
      List<dynamic> decodificado = jsonDecode(jsonString);
      return decodificado.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}