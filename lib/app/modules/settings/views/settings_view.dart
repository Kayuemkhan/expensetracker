import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends BaseView<SettingsController> {
   SettingsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,

    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildNotificationsSection(),
            // const SizedBox(height: 32),
            _buildPrivacySection(),
            const SizedBox(height: 32),
            _buildAboutSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        Obx(() => _buildSettingItem(
          title: 'Daily budget limit',
          subtitle: 'Get notified when you reach your daily budget limit',
          isSwitch: true,
          switchValue: controller.dailyBudgetLimitNotification,
          onSwitchChanged: (value) => controller.toggleDailyBudgetNotification(value),
        )),

        const SizedBox(height: 16),

        Obx(() => _buildSettingItem(
          title: 'Monthly budget limit',
          subtitle: 'Get notified when you reach your monthly budget limit',
          isSwitch: true,
          switchValue: controller.monthlyBudgetLimitNotification,
          onSwitchChanged: (value) => controller.toggleMonthlyBudgetNotification(value),
        )),

        const SizedBox(height: 16),

        Obx(() => _buildSettingItem(
          title: 'Daily expense reminder',
          subtitle: 'Get notified when you have not added any expenses for the day',
          isSwitch: true,
          switchValue: controller.dailyExpenseReminderNotification,
          onSwitchChanged: (value) => controller.toggleDailyReminderNotification(value),
        )),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        _buildSettingItem(
          title: 'Data storage',
          subtitle: 'No account required. All data is stored locally on your device.',
          icon: Icons.security_rounded,
          onTap: () => controller.showDataStorageInfo(),
        ),

        const SizedBox(height: 16),

        _buildSettingItem(
          title: 'Export data',
          subtitle: 'Export your data to a CSV file for backup or analysis.',
          icon: Icons.download_rounded,
          onTap: () => controller.exportData(),
        ),

        const SizedBox(height: 16),

        _buildSettingItem(
          title: 'Clear all data',
          subtitle: 'Delete all expenses and impulse items from the app.',
          icon: Icons.delete_forever_rounded,
          onTap: () => controller.clearAllData(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        _buildSettingItem(
          title: 'About this app',
          subtitle: 'Version information and app details',
          icon: Icons.info_outline_rounded,
          onTap: () => controller.showAboutApp(),
        ),

        const SizedBox(height: 16),

        _buildSettingItem(
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your privacy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            Get.snackbar(
              'Privacy Policy',
              'Your data is stored locally and never shared with third parties.',
              backgroundColor: Colors.blue.shade100,
              colorText: Colors.blue.shade800,
            );
          },
        ),

        const SizedBox(height: 16),

        _buildSettingItem(
          title: 'Contact Support',
          subtitle: 'Get help or report issues',
          icon: Icons.support_agent_rounded,
          onTap: () {
            Get.snackbar(
              'Contact Support',
              'Email: support@expensetracker.app',
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade800,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    IconData? icon,
    bool isSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSwitch ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                else if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}