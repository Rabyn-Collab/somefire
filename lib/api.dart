


class Api{

//static const String baseUrl = 'https://nodeprosonline.herokuapp.com';
static const String baseUrl = 'http://192.168.50.110:3000';
static const register = '$baseUrl/userSignUp';
static const login = '$baseUrl/userLogin';
static const postAdd = '$baseUrl/create_products';
static const postUpdate = '$baseUrl/product/update';
static const postRemove = '$baseUrl/products/remove';
static const orderHistory = '$baseUrl/order/history';
static const orderCreate = '$baseUrl/order/order_create';


}