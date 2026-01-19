import '../../../menu/domain/entities/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final List<String> selectedExtras;
  final String? notes;

  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedExtras = const [],
    this.notes,
  });

  double get pricePerUnit => product.price + (selectedExtras.length * 1.0);

  double get totalPrice => pricePerUnit * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    List<String>? selectedExtras,
    String? notes,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity &&
        _listEquals(other.selectedExtras, selectedExtras) &&
        other.notes == notes;
  }

  @override
  int get hashCode => 
      product.hashCode ^ 
      quantity.hashCode ^ 
      Object.hashAll(selectedExtras) ^ 
      notes.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
