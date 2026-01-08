import 'package:flutter/material.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/models/transactions_model.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  const TransactionListItem({super.key, required this.transaction});
  //TODO Task2-3
  @override
  Widget build(BuildContext context) {
    if (transaction.type != 'credit') {
      return const SizedBox.shrink();
    }
    Color statusColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.reference,
                      style: labelSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "إيداع رصيد",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    if (transaction.description != null)
                      Text(
                        transaction.description!,
                        style: labelSmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+${transaction.amount} LYD",
                  style: labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "الرصيد: ${transaction.balanceAfter}",
                  style: labelSmall.copyWith(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
