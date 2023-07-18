int? cursorBasedPaginationNextKeyBuilder(
    List<dynamic>? lastItems, int page, int limit) {
  return (lastItems == null || lastItems.length < limit)
      ? null
      : lastItems.last.id;
}
