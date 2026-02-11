import '../domain/servico.dart';

class ServicoRepository {
  final List<Servico> _servicos = [];

  List<Servico> getAll() {
    return List.unmodifiable(_servicos);
  }

  

  void add(Servico servico) {
    _servicos.add(servico);
  }

  void removeById(int id) {
    _servicos.removeWhere((s) => s.id == id);
  }



}