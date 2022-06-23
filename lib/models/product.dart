



class Product{

  final String id;
  final String product_name;
  final String image;
  final int price;
  final String product_detail;

  Product({
    required this.id,
    required this.price,
    required this.image,
    required this.product_name,
   required this.product_detail
});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
        id: json['_id'],
        price: json['price'],
        image: json['image'],
        product_name: json['product_name'],
      product_detail: json['product_detail']
    );
  }


}