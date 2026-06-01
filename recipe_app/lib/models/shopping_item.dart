class ShoppingItem {
  final String id;
  final String name;
  final String measure;
  bool isChecked;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.measure,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'measure': measure,
      'isChecked': isChecked,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      measure: json['measure'] ?? '',
      isChecked: json['isChecked'] ?? false,
    );
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? measure,
    bool? isChecked,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      measure: measure ?? this.measure,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
