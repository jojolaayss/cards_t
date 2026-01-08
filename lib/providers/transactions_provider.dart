import 'dart:convert';
import 'package:saees_cards/models/transactions_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

//TODO Task2-2
class TransactionsProvider extends BaseProvider {
  List<Transaction> transactions = [];
  int currentPage = 1;
  bool hasNextPage = true;
  bool isFetchingMore = false;

  bool get isFetchingMores => isFetchingMore;
  bool get hasNextPages => hasNextPage;

  Future<void> getTransactions({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasNextPage = true;
    }

    if (!hasNextPage || isFetchingMore) return;

    if (currentPage == 1) {
      setBusy(true);
    } else {
      isFetchingMore = true;
      notifyListeners();
    }

    try {
      final response = await api.get('/vendor/transactions?page=$currentPage');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];

        List<Transaction> newTransactions = List<Transaction>.from(
          data.map((e) => Transaction.fromJson(e as Map<String, dynamic>)),
        );

        if (isRefresh) {
          transactions = newTransactions;
        } else {
          transactions.addAll(newTransactions);
        }

        if (newTransactions.isEmpty) {
          hasNextPage = false;
        } else {
          currentPage++;
        }
      } else {
        if (isRefresh) transactions = [];
        hasNextPage = false;
      }
    } catch (e) {
      setFailed(true);
    } finally {
      setBusy(false);
      isFetchingMore = false;
      notifyListeners();
    }
  }
}
