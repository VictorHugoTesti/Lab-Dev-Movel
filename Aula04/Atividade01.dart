void main() {
  Map<String, dynamic> payloadJson = {
    "faculdade": "Fatec Matão",
    "ano_letivo": 2026,
    "esta_ativo": true,
    "nota_de_corte": 68.5
  };

  String faculdade = payloadJson["faculdade"];
  int anoLetivo = payloadJson["ano_letivo"];
  bool estaAtivo = payloadJson["esta_ativo"];
  double notaDeCorte = payloadJson["nota_de_corte"];

  print("Faculdade: $faculdade");
  print("Ano Letivo: $anoLetivo");
  print("Ativo: $estaAtivo");
  print("Nota de Corte: $notaDeCorte");
}