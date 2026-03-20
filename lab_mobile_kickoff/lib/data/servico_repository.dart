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

void update(Servico servico) {
  //Atributo index procura na lista se existe o usuário
  final index = _servicos.indexWhere((s) => s.id == servico.id);
  if(index != -1) _servicos[index] = servico;
}

}