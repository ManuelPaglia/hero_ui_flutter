/// Stato ordinamento colonna per [HUFTable].
class HUFTableSortDescriptor {
  const HUFTableSortDescriptor({
    required this.columnKey,
    this.ascending = true,
  });

  final String columnKey;
  final bool ascending;

  HUFTableSortDescriptor toggle() {
    return HUFTableSortDescriptor(
      columnKey: columnKey,
      ascending: !ascending,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HUFTableSortDescriptor &&
        other.columnKey == columnKey &&
        other.ascending == ascending;
  }

  @override
  int get hashCode => Object.hash(columnKey, ascending);
}
