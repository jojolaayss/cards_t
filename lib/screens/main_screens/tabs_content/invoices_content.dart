import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/models/invoice_model.dart';
import 'package:saees_cards/providers/invoices_provider.dart';
import 'package:saees_cards/widgets/statics/shimmer_widget.dart';
//TODO Task 5-1-2

class InvoicesContent extends StatefulWidget {
  const InvoicesContent({super.key});

  @override
  State<InvoicesContent> createState() => _InvoicesContentState();
}

class _InvoicesContentState extends State<InvoicesContent> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(
        context,
        listen: false,
      ).getInvoices(isRefresh: true);
    });

    scrollController.addListener(() {
      final provider = Provider.of<InvoicesProvider>(context, listen: false);
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!provider.busy && provider.hasNextPage) {
          provider.getInvoices();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesConsumer, _) {
        if (invoicesConsumer.busy && invoicesConsumer.invoices.isEmpty) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: getSize(context).height * 0.1,
                child: const ShimmerWidget(),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async =>
              await invoicesConsumer.getInvoices(isRefresh: true),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                invoicesConsumer.invoices.length +
                (invoicesConsumer.hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == invoicesConsumer.invoices.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final invoice = invoicesConsumer.invoices[index];
              return AnimatedSwitcher(
                duration: 300.milliseconds,
                key: ValueKey(invoice.invoiceNumber),
                child: InvoiceCard(invoiceModel: invoice),
              );
            },
          ),
        );
      },
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.invoiceModel});
  final InvoiceModel invoiceModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(1, 2),
              blurRadius: 7,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoiceModel.createdAt
                        .toIso8601String()
                        .substring(0, 10)
                        .replaceAll("-", "/"),
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),
                  Text(invoiceModel.family.name, style: labelSmall),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoiceModel.invoiceNumber,
                    style: labelSmall.copyWith(color: Colors.grey),
                  ),
                  Text(
                    "${invoiceModel.amount} LYD",
                    style: labelMedium.copyWith(color: greenColor),
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
