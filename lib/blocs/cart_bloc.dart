import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/data/cart_product.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends BlocBase {
  
  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();
  List<CartProduct> products =[];
  bool isLoading = false;

  late String? couponCode;
  int discountPercentage = 0;

  getCurrentUser() {
    User? user;
    _loginBLoc.outCurrentUser.listen((state) async {

      user = currentuser;
    });
    return  user;
  }
  
  //AUMENTA A QUANTIDADE DO PRODUCTO EM QUESTÃO
  void aumProduct(CartProduct cartProduct){
    int? c = cartProduct.quantity;

    if (c != null) c++;

    cartProduct.quantity = c;
    FirebaseFirestore.instance.collection("users").doc(getCurrentUser().uid).collection("cart")
        .doc(cartProduct.cart_id).update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupom(String? coupomCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  //SERÁ CHAMDO PARA ACTULIZAR OS VALORES SEMPRE QUE A TELA ABRE
  void updatPrices(){
    notifyListeners();
  }

  double getProductsPrice(){

    double price = 0.0;

    //1- Para cada item em "products" multiplica quantidade X Preço
    // e o resultado acrescenta no valor do "price"
    for(CartProduct c in products){
      if (c.productData != null)
        price = c.productData!.price;

        if(price != null && c.quantity != null) {

          price  += (c.quantity! * c.productData!.price);
        }
    } return price;

  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage /100;
  }

  double getShipPrice(){
    return 500.0;

  }

  //Obtendo os dados do carrinho do User Logado no Firebase
  Future<void> _loadCartItems() async {
    QuerySnapshot <Map <String, dynamic>> query = await FirebaseFirestore.instance.collection("users")
        .doc(getCurrentUser().uid).collection("cart")
        .get();

    //Convertendo cada documento obtido em um CartProduct
    //Transformando todos esses CartProducts em uma Lista
    //Colocando essa Lista na nossa Lista "products" que é
    // do tipo CartProduct
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();


  }

  //GUARDANDO O PEDIDO (ORDER)
  Future<String?> finishOrder() async {
    if(products.isEmpty) return null;
    isLoading = true;
    double  productsPrice = getProductsPrice();
    double shiPrice = getShipPrice();
    double discount = getDiscount();


//GUARDANDO o ID do Ped
// ido na variavel reOrder
    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
        {"clientId": getCurrentUser().uid,
          "products": products.map((cartProduct)=>
              cartProduct.toMap()).toList(),
          "shipPrice": shiPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": productsPrice - discount + shiPrice,
          "status": 1
        }
    );

    //GUARDANDO O ID DO PRODUTO NA COLLETION ORDERS DENTRO DO USUÁRIO
    FirebaseFirestore.instance.collection("users").doc(getCurrentUser().uid)
        .collection("orders").doc(refOrder.id).set({
      //Todo: Alterar o ID da Order , para um código mais comprensivel
      "orderId": refOrder.id
    });

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users")
        .doc(getCurrentUser().uid).collection("cart").get();

    //DELETE CADA DOCUMENTO NO QUERY OBTIDO
    for (DocumentSnapshot doc in query.docs){
      doc.reference.delete();

      //Limpando a lista local de productos selecionados
      products.clear();

      //LIMPANDO VARIAVEIS
      couponCode = null;
      discountPercentage = 0;
     isLoading  = false;
      notifyListeners();

      return refOrder.id;
    }


  }

  ///=======================================================///

  void addCartItem(cartProduct){

    //0 - Adicionar o Producto selecionado na lista de productos
    //1 - Criando uma colletion "cart" dentro da colletion
    //do "user" activo;

    //2 - Adicionando o carrinho criado como document da
    // colletion "cart" criada;

    //3 - colocar o id do firebase do  "carrinho" criado
    // como uma propriedade da proprieddade cart_id do
    // proprio carrinho.

    products.add(cartProduct);

    FirebaseFirestore.instance.collection("users").
    doc(getCurrentUser().uid).collection("cart").
    add(cartProduct.toMap()).then((doc){
      cartProduct.cart_id = doc.id;
    });
  }

  void removeCartItem(CartProduct){
    FirebaseFirestore.instance.collection("users").
    doc(getCurrentUser().uid).collection("cart").
    doc(CartProduct.cart_product_id).delete();

    products.remove(CartProduct);
    notifyListeners();

  }

  //DIMINUI A QUANTIDADE DO PRODUCTO EM QUESTÃO
  void dimProduct(CartProduct cartProduct){

    var q = cartProduct.quantity;

    if(q != null) {
      q--;
    }

    q=cartProduct.quantity;

    FirebaseFirestore.instance.collection("users").doc(getCurrentUser().uid).collection("cart")
        .doc(cartProduct.cart_id).update(cartProduct.toMap());

    notifyListeners();
  }

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  late User firebaseUser;

  Stream<Map> get outData => _dataController.stream;

  Stream<bool> get outLoading => _loadingController.stream;

  Stream<bool> get outCreated => _createdController.stream;

  late String StoreId;
  late DocumentSnapshot store;

  //Mapa para guardar temporáriamente os dados do producto
  // que está a ser editado/adicionado no momento.
  late Map<String, dynamic> unsavedData;



  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveNIF(String nif) {
    unsavedData["nif"] = nif;
  }

  void saveDescription(String description) {
    unsavedData["description"] = description;
  }

  void saveAddress(String address) {
    unsavedData["address"] = address;
  }

  void saveEmail(String email) {
    unsavedData["email"] = email;
  }

  void savePhone_number(String phone_number) {
    unsavedData["phone_number"] = int.parse(phone_number);
  }

  void saveStoreType(String? StoreType) {
    unsavedData["type"] = StoreType;
  }

  void saveImages(List images) {
    unsavedData["images"] = images;
  }

  void saveManagers(List StoreManagers) {
    unsavedData["managers"] = StoreManagers;
  }

  //Todo: Implementar gerentes
  /*void saveManagers(List managers) {
    unsavedData["managers"] = managers;
  }*/

  Future<bool> saveStore() async {
    _loadingController.add(true);

    try {
      if (store != null) {
        //Se o producto for diferente de nulo, significa que já tem um
        // producto, apenas vamos actualiaza-lo
        await _uploadImages(store.id);
        //Função _uploadImages carrega para o firebase tdas imagens q
        // ainda não estão lá.
        await store.reference.update(unsavedData);
        //Actualizando os dados do producto com os dados temporarios;
      } else {
        DocumentReference dr = await FirebaseFirestore.instance
            .collection("lojas")
            .add(Map.from(unsavedData)..remove("images")..remove("managers"));
        //Caso o producto não exista, criamos acima o producto,
        // a partir do "UnsavedData", mas sem as Imagens do "UnsavedData"
        // que n se encontram gravadas em formato de URL.

        await _uploadImages(dr.id);
        //Aqui adicionamos os urls das imagens no producto criado, considerando
        // que acima removemos as imagens.

        await dr.update(unsavedData);
        //
      }

      //Informando que o produto em causa já foi criado.
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      print(e);
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadManagers(String StoreId) async {
    for (int i = 0; i < unsavedData["managers"].length; i++) {
      if (unsavedData["managers"][i] == _auth.currentUser) continue;
      //Se unsavedData for uma string é porq já está guardada
      //já é uma URL, e o "continue" ignora todo o resto para este "i"

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(StoreId)
          .child("images")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["images"][i]);
      //Criamos pegamos a referência do nosso BD e criamos nele uma pasta
      // com o nome da "CategoryID" em questão, e uma subpasta com o nome
      // do "productID", e o nome do producto será a data actual em milesegungos.

      uploadTask.then((res) async {
        unsavedData["images"][i] = await res.ref.getDownloadURL();
        //Passando o Link da imagem adicionada como referência da mesma.
      });

    }
  }

  Future _uploadImages(String StoreId) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData["images"][i] is String) continue;
      //Se unsavedData for uma string é porq já está guardada
      //já é uma URL, e o "continue" ignora todo o resto para este "i"

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(StoreId)
          .child("images")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["images"][i]);
      //Criamos pegamos a referência do nosso BD e criamos nele uma pasta
      // com o nome da "CategoryID" em questão, e uma subpasta com o nome
      // do "productID", e o nome do producto será a data actual em milesegungos.

      uploadTask.then((res) async {
        unsavedData["images"][i] = await res.ref.getDownloadURL();
        //Passando o Link da imagem adicionada como referência da mesma.
      });
    }
  }


  void deleteProduct() {
    store.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
