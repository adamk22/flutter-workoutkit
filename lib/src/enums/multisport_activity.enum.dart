// ignore_for_file: public_member_api_docs
enum MultisportActivityType {
  cycling(label: 'Cycling'),
  running(label: 'Running'),
  swimming(label: 'Swimming');

  final String label;
  const MultisportActivityType({required this.label});
}
