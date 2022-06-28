import 'package:firestart/main.dart';
import 'package:firestart/models/cart_item.dart';
import 'package:firestart/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';





final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.read(boxCart)));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);

   String addToCart(Product product){
         if(state.isEmpty){
           final newCart = CartItem(
               imageUrl: product.image,
               id: product.id,
               title: product.product_name,
               quantity: 1,
               price: product.price,
               total: product.price
           );
           Hive.box<CartItem>('carts').add(newCart);
           state = [newCart];
           return 'success';
         }else{
           final cart = state.firstWhere((element) => product.id == element.id, orElse: (){
             return CartItem(imageUrl: '', id: '', title: 'not added', quantity: 0, price: 0, total: 0);
           });
           if(cart.title == 'not added'){
             final newCart = CartItem(
                 imageUrl: product.image,
                 id: product.id,
                 title: product.product_name,
                 quantity: 1,
                 price: product.price,
                 total: product.price
             );
             Hive.box<CartItem>('carts').add(newCart);
             state = [newCart];
             return 'success';
           }else{
             return 'already added to cart';
           }
         }
      }


      void addSingle(CartItem cartItem){
        cartItem.quantity = cartItem.quantity+ 1;
        cartItem.total = cartItem.price * cartItem.quantity ;
        cartItem.save();
        state = [
          for(final element in state)
            if(element == cartItem) cartItem else element
        ];
      }


  void removeSingle(CartItem cartItem){
     if(cartItem.quantity > 1){
       cartItem.quantity = cartItem.quantity- 1;
       cartItem.total = cartItem.price * cartItem.quantity ;
       cartItem.save();
       state = [
         for(final element in state)
           if(element == cartItem) cartItem else element
       ];
     }

  }

  int get total{
   int total = 0;
     state.forEach((element) {
       total += element.quantity * element.price;
     });

     return total;
  }

  void removeAll(){
    Hive.box<CartItem>('carts').clear();
   state = [];
  }


}



