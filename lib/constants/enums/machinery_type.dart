enum MachineryType {
  CHAIN('Chain'),
  TYRE('Tyre');

  final String description;

  const MachineryType(this.description);

  @override
  String toString() => description;

}