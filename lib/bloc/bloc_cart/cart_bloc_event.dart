import '../../model/cart.dart';
import '../../model/cart_items.dart';

abstract class CartEvent {}

class OnPressedAddToCart extends CartEvent {
  int cartId;
  int userId;
  CartItem cartItem;
  OnPressedAddToCart(this.cartId,this.userId,this.cartItem);
}

class OnPressedRemoveCart extends CartEvent {
  int cartId;
  int quizId;
  OnPressedRemoveCart(this.cartId, this.quizId);
}

class OnPressedClearCart extends CartEvent {
  int userId;
  OnPressedClearCart(this.userId);
}

class LoadingCart extends CartEvent {
  int userId;
  LoadingCart(this.userId);
}

class OnPressedApplyVoucher extends CartEvent {
  int rankId;
  int userId;
  OnPressedApplyVoucher(this.rankId, this.userId);
}


