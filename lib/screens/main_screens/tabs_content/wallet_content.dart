import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/models/wallet_model.dart';
import 'package:saees_cards/providers/auth_provider.dart';
import 'package:saees_cards/providers/transactions_provider.dart';
import 'package:saees_cards/widgets/statics/shimmer_widget.dart';
import 'package:saees_cards/widgets/dialogs/transaction_list_item.dart';

class WalletContent extends StatefulWidget {
  const WalletContent({super.key});

  @override
  State<WalletContent> createState() => _WalletContentState();
}

//TODO Task2-4
class _WalletContentState extends State<WalletContent> {
  @override
  void initState() {
    super.initState();
    //Future.microtask(() {
    if (!mounted) return;
    Provider.of<AuthProvider>(context, listen: false).getWallet();
    Provider.of<TransactionsProvider>(context, listen: false).getTransactions();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AuthProvider>(
            builder: (context, authConsumer, _) {
              return AnimatedSwitcher(
                duration: 300.ms,
                child: authConsumer.busy || authConsumer.walletModel == null
                    ? SizedBox(
                        height: getSize(context).height * 0.24,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ShimmerWidget(),
                        ),
                      )
                    : DigitalCard(walletModel: authConsumer.walletModel!),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              "آخر العمليات",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ).animate().fadeIn(delay: 200.ms),

          Expanded(
            child: Consumer<TransactionsProvider>(
              builder: (context, transConsumer, _) {
                if (transConsumer.busy) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: SizedBox(height: 70, child: ShimmerWidget()),
                    ),
                  );
                }

                if (transConsumer.transactions.isEmpty) {
                  return const Center(child: Text("لا توجد عمليات حالياً"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: transConsumer.transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionListItem(
                      transaction: transConsumer.transactions[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DigitalCard extends StatelessWidget {
  const DigitalCard({super.key, required this.walletModel});
  final WalletModel walletModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/chip.png",
                    width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  Text(
                    walletModel.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("01/27", style: TextStyle(color: Colors.white)),
                  Text(
                    "${walletModel.balance} LYD",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
