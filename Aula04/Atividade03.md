

# Atividade 03 - Mapeamento de APIs Públicas

**Disciplina:** Programação para Dispositivos Móveis (PDM)
**Instituição:** Fatec Matão
**Nome:** Victor Hugo M. Testi

---

## 1. ViaCEP

* **Nome e Link Oficial:** ViaCEP — <https://viacep.com.br/>
* **Recursos Expostos:** Consulta completa de endereços do Brasil a partir de um código postal (CEP), retornando dados como logradouro, complemento, bairro, localidade, UF, DDD e código IBGE. Também permite a busca inversa de CEP por endereço.
* **URL de Endpoint Funcional:** `https://viacep.com.br/ws/01001000/json/`
* **Utilidade Prática em um App Mobile:** Autopreenchimento de formulários em telas de cadastro, checkout de e-commerce e aplicativos de delivery (ex: iFood). O usuário digita o CEP de entrega e o aplicativo preenche automaticamente rua, bairro e cidade, reduzindo erros de digitação e melhorando drasticamente a experiência do usuário (UX).

## 2. Open-Meteo Weather API

* **Nome e Link Oficial:** Open-Meteo — <https://open-meteo.com/>
* **Recursos Expostos:** Dados meteorológicos em tempo real (temperatura atual, velocidade e direção do vento, umidade relativa) e previsões numéricas do tempo (horárias e diárias) baseadas em coordenadas de latitude e longitude.
* **URL de Endpoint Funcional:** `https://api.open-meteo.com/v1/forecast?latitude=-21.6033&longitude=-48.3653&current_weather=true` *(Coordenadas geográficas de Matão - SP)*
* **Utilidade Prática em um App Mobile:** Criação de widgets de clima na tela inicial do app, integrados diretamente com a localização do GPS do smartphone (pacotes como `geolocator` no Flutter). Muito útil em aplicativos de viagens, esportes ao ar livre, corridas e agricultura.

## 3. Nominatim (OpenStreetMap)

* **Nome e Link Oficial:** Nominatim (OSM) — <https://nominatim.org/>
* **Recursos Expostos:** Geocodificação direta (converte nomes de ruas, locais ou cidades em coordenadas de latitude/longitude), Geocodificação reversa (converte uma coordenada GPS exata em um endereço legível completo) e busca de Pontos de Interesse (POIs).
* **URL de Endpoint Funcional (Geocodificação direta):** `https://nominatim.openstreetmap.org/search?q=Fatec+Matao&format=json`
* **Utilidade Prática em um App Mobile:** É fundamental em aplicativos de mobilidade (como Uber), logística ou delivery. Pode ser usada para autocompletar endereços na barra de busca, converter a posição atual do GPS do celular (obtida via pacotes como `geolocator`) em um endereço em texto na tela do usuário, ou centralizar a câmera de um mapa usando o pacote `flutter_map` no Flutter.