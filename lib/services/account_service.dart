import 'dart:async';
import 'package:assicronismo/api_key.dart';
import 'package:assicronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  // Criando uma stream
  StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = "https://api.github.com/gists/6d1081c8bf38a3a58e2d663649efcdf4";

  // Obtém uma lista com todas as contas
  Future<List<Account>> getAll() async {
    //Já aqui, usando o await, roda tudo de forma linear. Um seguido do outro, como de modo comum
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura (usando async e await).",);

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic = json.decode(mapResponse["files"]["accounts.json"]["content"]);  //Assim faz chegar uma lista de dinâmicos

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;  //as = como
      // Pega o map e transforma em account
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }
    return listAccounts;
  }

  // Cria um novo map, uma lista alterada com um item a mais (adiciona uma nova conta ao final da lista e salva no Gist)
  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      // Pega o account e tranforma em map
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    // Cria a requisição para enviar e atualizar a api gist
    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $githubApiKey"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição de adição bem sucedida (${account.name}).",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição falhou! (${account.name}).",
      );
    }
  }
}
