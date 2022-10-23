class Crypto {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.fromJsonMap(Map<String, dynamic> jsonObject) {
    return Crypto(
      jsonObject['id'],
      jsonObject['name'],
      jsonObject['symbol'],
      double.parse(jsonObject['changePercent24Hr']),
      double.parse(jsonObject['priceUsd']),
      double.parse(jsonObject['marketCapUsd']),
      int.parse(jsonObject['rank']),
    );
  }
}
