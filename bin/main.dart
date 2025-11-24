import 'package:assicronismo/exceptions/transaction_exceptions.dart';
import 'package:assicronismo/screens/account_screen.dart';
import 'package:assicronismo/services/transaction_service.dart';

void main() {
  TransactionService()
      .makeTransaction(idSender: "ID001", idReceiver: "ID002", amount: 5000)
      .catchError((e) {
        print(e.message);
        print(
          "${e.cause.name} possui saldo ${e.cause.balance} que é menor que ${e.amount + e.taxes}.",
        );
      }, test: (error) => error is InsufficientBalanceException);

  AccountScreen accountScreen = AccountScreen();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
}

// void main() async {
//   try {
//   await TransactionService().makeTransaction(
//     idSender: "ID001",
//     idReceiver: "ID002",
//     amount: 5000,
//   ); 
// } on InsufficientBalanceException catch (e) {
//   print(e.message);
//   print("${e.cause.name} possui saldo ${e.cause.balance} que é menor que ${e.amount + e.taxes}." );
// }


//   // AccountScreen accountScreen = AccountScreen();
//   // accountScreen.initializeStream();
//   // accountScreen.runChatBot();
// }