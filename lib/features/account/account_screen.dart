import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/account/controller/account_controller.dart';
import 'package:tajwal_rider/features/account/widgets/account_field.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Account details — view only, every field disabled.
///
/// The data is fetched fresh over HTTP when the page opens (see
/// [AccountController]), not read from the init-time app config, so it always
/// reflects the server. Composition only.
class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      appBar: AppBar(
        title: Text('account_details'.tr),
        backgroundColor: OrderTokens.page,
        surfaceTintColor: OrderTokens.page,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.account.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final account = controller.account.value;
          if (account == null) {
            return _Error(
              message: controller.error.value ?? 'could_not_load_account'.tr,
              onRetry: controller.fetchAccount,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchAccount,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                // A quiet notice so it's clear the screen is intentionally read-only.
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: OrderTokens.accentSoft,
                    borderRadius: OrderTokens.rField,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: OrderTokens.accent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'details_view_only'.tr,
                          style: TextStyle(fontSize: 12.5, color: OrderTokens.ink),
                        ),
                      ),
                    ],
                  ),
                ),

                AccountField(label: 'full_name'.tr, value: account.fullName, icon: Icons.person_outline),
                AccountField(label: 'username_label'.tr, value: account.userName, icon: Icons.alternate_email),
                AccountField(label: 'email_label'.tr, value: account.email, icon: Icons.email_outlined),
                AccountField(label: 'phone_number_label'.tr, value: account.phoneNumber, icon: Icons.phone_outlined),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Load-failure state with a retry.
class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: OrderTokens.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OrderTokens.ink),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: OrderTokens.primary,
                side: const BorderSide(color: OrderTokens.primary),
                shape: RoundedRectangleBorder(borderRadius: OrderTokens.rField),
              ),
              child: Text('try_again'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
