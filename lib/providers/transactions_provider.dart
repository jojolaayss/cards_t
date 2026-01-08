import 'dart:convert';
import 'package:saees_cards/models/transactions_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

//TODO Task2-2
class TransactionsProvider extends BaseProvider {
  List<Transaction> transactions = [];

  Future<void> getTransactions() async {
    setBusy(true);
    try {
      final response = await api.get('/vendor/transactions');
      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);
        List data = decodedData['data'];
        transactions = data.map((e) => Transaction.fromJson(e)).toList();
      }
    } catch (e) {
      setFailed(true);
    } finally {
      setBusy(false);
    }
  }
}
