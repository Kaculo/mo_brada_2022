import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
/*
/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }

}*/


class UserBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  FirebaseFirestore _FirebaseFirestore = FirebaseFirestore.instance;



  UserBloc() {
    _addUsersListener();
  }

  void onChangedSearch(String? search) {
    //trim remove os espaços do conteudo de uma String.
    if (search!.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      //se o usuário não pesquisou nada...passamos a list de users normal
      _usersController.add(_filter(search.trim()));
    }
  }

  ///Função que filtra os Users ao pesquisar
  List<Map<String, dynamic>> _filter(String search) {
    //Lista para armazenar Users Filtrados
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());

    ///Filtra os users que Têm o conteudo do "seacrh" no nome.
    filteredUsers.retainWhere((user) {
      return user["name"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }

  //Sempre que tiver uma alteração na colecção "users", esta função
  // será chamada
  void _addUsersListener() {
    _FirebaseFirestore.collection("users").snapshots().listen(

        ///Monitorando a base de dados
        (snapshot) {
      ///Recebendo lista de mudanças
      snapshot.docChanges

          ///Aplicando uma acção para cada mudança
          .forEach((change) {
        ///Pegando o ID do user que sofre mudança/alteração
        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            //Caso seja adicionado um novo user
            //então adicione esse user ao nosso Map _users
            _users[uid] = change.doc.data() as Map<String, dynamic>;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid]?.addAll(change.doc.data() as Map<String, dynamic>) ;
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }




  //para o App não ficar pesado convém usar "getDocuments" em vez de
  // "snapshots" que busca dados em tempo real.

  void _subscribeToOrders(String uid) {
    //Armazenamos a subscrição toda em cada usuário, para que possamos cancelar
    // a subscrição de cada um user é deletado, assim não teremos nenhum listen
    // para um user deletado

    _users[uid]!["subscription"] = _FirebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .listen((orders) async {
      int numOrdesrs = orders.docs.length;
      double money = 0.0;
      for (DocumentSnapshot<Map<String, dynamic>> d in orders.docs) {
        DocumentSnapshot <Map<String, dynamic>> order =
            await _FirebaseFirestore.collection("orders").doc(d.id).get();

        //caso não exista uma order com aquela uid
        if (order.data == null) continue;
        money += order.data()!["totalPrice"];
      }
      //salvando o total de orders e valor de gastos total na collection users
      _users[uid]?.addAll({"money": money, "orders": numOrdesrs});

      //passando os dados dos users actualizados para o controladors
      //mas estamos apenas a passar os valor do Mapa _users, sem as chaves
      _usersController.add(_users.values.toList());
    });
  }

  //Função para pegar dados do user por fora
  Map<String, dynamic>? getUser(String uid){
    return _users[uid];

  }

  //Função que cancela a subscrição dos usuários
  void _unsubscribeToOrders(String uid) {
    _users[uid]!["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
