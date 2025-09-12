import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: _getBackgroundColor(type),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 600),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getIcon(type),
          color: Colors.white,
          size: 24,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          height: 1.3,
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: _getBackgroundColor(type).withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static void success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
      duration: duration,
    );
  }

  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF10B981); // Green
      case SnackbarType.error:
        return const Color(0xFFEF4444); // Red
      case SnackbarType.warning:
        return const Color(0xFFF59E0B); // Orange
      case SnackbarType.info:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;
      case SnackbarType.error:
        return Icons.error_rounded;
      case SnackbarType.warning:
        return Icons.warning_rounded;
      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }
}

class EnhancedSnackbar {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.transparent,
        // elevation: 0,
        duration: duration,
        animationDuration: const Duration(milliseconds: 800),
        forwardAnimationCurve: Curves.elasticOut,
        reverseAnimationCurve: Curves.easeInBack,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        messageText: _buildSnackbarContent(title, message, type),
      ),
    );
  }

  static Widget _buildSnackbarContent(String title, String message, SnackbarType type) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getBackgroundColor(type),
            _getBackgroundColor(type).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getBackgroundColor(type).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              _getIcon(type),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
      duration: duration,
    );
  }

  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF059669); // Darker green
      case SnackbarType.error:
        return const Color(0xFFDC2626); // Darker red
      case SnackbarType.warning:
        return const Color(0xFFD97706); // Darker orange
      case SnackbarType.info:
        return const Color(0xFF2563EB); // Darker blue
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;
      case SnackbarType.error:
        return Icons.error_rounded;
      case SnackbarType.warning:
        return Icons.warning_amber_rounded;
      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }
}