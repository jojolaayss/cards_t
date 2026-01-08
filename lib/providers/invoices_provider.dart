import 'dart:convert';
import 'package:saees_cards/models/invoice_model.dart';
import 'package:saees_cards/providers/base_provider.dart';

//TODO Task 5-1-1
class InvoicesProvider extends BaseProvider {
  List<InvoiceModel> invoices = [];
  int currentPage = 1;
  bool hasNextPage = true;
  bool isFetchingMore = false;

  bool get isFetchingMores => isFetchingMore;
  bool get hasNextPages => hasNextPage;

  Future<void> getInvoices({bool isRefresh = false}) async {
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

    final response = await api.get("/vendor/invoices?page=$currentPage");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];

      List<InvoiceModel> newInvoices = List<InvoiceModel>.from(
        data.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>)),
      );

      if (isRefresh) {
        invoices = newInvoices;
      } else {
        invoices.addAll(newInvoices);
      }

      if (newInvoices.isEmpty) {
        hasNextPage = false;
      } else {
        currentPage++;
      }
    } else {
      if (isRefresh) invoices = [];
      hasNextPage = false;
    }

    setBusy(false);
    isFetchingMore = false;
    notifyListeners();
  }

  Future<List<dynamic>> validateCard(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/wallets/validate", body);

    if (response.statusCode == 200) {
      setBusy(false);
      return [true, json.decode(response.body)['data']['balance']];
    } else {
      setBusy(false);
      return [false, "This card is invalid"];
    }
  }

  Future<List> placeInvoice(Map body) async {
    setBusy(true);
    final response = await api.post("/vendor/invoices", body);
    if (response.statusCode == 201) {
      await getInvoices(isRefresh: true);
      return [true, "Invoice Added Successfully"];
    } else {
      setBusy(false);
      return [false, json.decode(response.body)["message"]];
    }
  }
}
