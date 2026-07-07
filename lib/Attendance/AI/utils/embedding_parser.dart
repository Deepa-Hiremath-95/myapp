class EmbeddingParser {

  static String encode(
      List<double> embedding) {

    return embedding.join(",");

  }

  static List<double> decode(
      String embedding) {

    return embedding
        .split(",")
        .map(
          (e) => double.parse(e),
        )
        .toList();

  }

}