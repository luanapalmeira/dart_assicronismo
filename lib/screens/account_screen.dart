import 'dart:io';

import 'package:assicronismo/models/account.dart';
import 'package:assicronismo/services/account_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class AccountScreen {
  AccountService _accountService = AccountService();

  void initializeStream() {
    _accountService.streamInfos.listen((event) {
      print(event);
    });
  }

  void runChatBot() async {
    print("Bom dia! Eu sou o Lewis, assistente do Banco d'Ouro!");
    print("Que bom te ter aqui com a gente.\n");

    bool isRunning = true;
    while (isRunning) {
      print("Como posso te ajudar? (digite o número desejado)");
      print("1 - 👀 Ver todas as contas");
      print("2 - ➕ Adicionar nova conta.");
      print("3 - Sair\n");

      String? input = stdin.readLineSync();

      if (input != null) {
        switch (input) {
          case "1": {
            await _getAllAccounts();
            break;
          }
          case "2": {
            await _addNewAccount();
            // await _addExampleAccount();
            break;
          }
          case "3": {
            isRunning = false;
            print("Te vejo na próxima! 👋");
            break;
          }
          default: {
            print("Não entendi. Tente novamente.");
          } 
        }
      }
    }
  }

  _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print(listAccounts);
    } on ClientException catch (clientException) {  // é comum usar apenas um 'e' tipo o 'i' no for"
      print("Não foi possível alcançar o servidor.");
      print("Tente novamente mais tarde.");
      print(clientException.message);
      print(clientException.uri);
    } on Exception {
      print("Não consegui recuperar os dados da conta.");
      print("Tente novamente mais tarde.");
    } finally {
      print("${DateTime.now()} | Ocorreu uma tentativa de consulta.");
    }
  }

  // _addExampleAccount() async {
  //   Account example = Account(
  //     id: "ID555",
  //     name: "Haley",
  //     lastName: "Chirívia",
  //     balance: 8001,
  //   );
  //   await _accountService.addAccount(example);
  // }

  _addNewAccount() async {
    print("Qual o nome completo da pessoa?");
    String? name = stdin.readLineSync();

    if (name != null) {
      print("Qual é o saldo inicial da conta?");
      String? balanceString = stdin.readLineSync();
      if (balanceString != null && double.tryParse(balanceString) != null) {
        await _addAccount(name, double.parse(balanceString));

        print("Conta criada com sucesso! 👏");
      }
    }
  }

  _addAccount(String name, double balance) async {
    Account newAccount = Account(
      id: Uuid().v1(),
      name: name.split(" ").first,
      lastName: name.split(" ").length > 1 ? name.split(" ").last : "",
      balance: balance,
    );

    await _accountService.addAccount(newAccount);
  }
}