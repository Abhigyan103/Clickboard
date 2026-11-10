extension SortedByDateDesc<E> on List<E> {
  /// Retorna uma nova lista ordenada da data mais recente para a mais antiga.
  /// Elementos sem data ([dateOf] retorna `null`) vão para o fim.
  List<E> sortedByDateDesc(DateTime? Function(E element) dateOf) {
    final sorted = [...this];
    sorted.sort((a, b) =>
        (dateOf(b) ?? DateTime(0)).compareTo(dateOf(a) ?? DateTime(0)));
    return sorted;
  }
}
