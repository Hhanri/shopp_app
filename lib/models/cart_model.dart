class CartItemModel {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemModel({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price
  });

  static Map<String, dynamic> toMap(CartItemModel cartItem) {
    return {
      'id': cartItem.id,
      'title': cartItem.title,
      'quantity': cartItem.quantity,
      'price': cartItem.price
    };
  }
  factory CartItemModel.fromMap(Map<String, dynamic> json) {
    return CartItemModel(id: json['id'], title: json['title'], quantity: json['quantity'], price: json['price']);
  }
}