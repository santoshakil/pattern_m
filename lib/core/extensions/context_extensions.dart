import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  // Colors shortcuts
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  
  // MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get screenPadding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
  Orientation get orientation => mediaQuery.orientation;
  
  // Safe area
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  double get safeAreaTop => safeAreaPadding.top;
  double get safeAreaBottom => safeAreaPadding.bottom;
  
  // Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
  
  // Localization
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  // Navigation
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  void showErrorSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: errorColor,
      textColor: colorScheme.onError,
      duration: duration ?? const Duration(seconds: 4),
    );
  }
  
  void showSuccessSnackBar(String message, {Duration? duration}) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
    );
  }
  
  // Dialogs
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: (_) => child,
    );
  }
  
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle ?? true,
      useSafeArea: useSafeArea,
      builder: (_) => child,
    );
  }
  
  // Loading dialog
  void showLoadingDialog({String? message}) {
    showAppDialog(
      barrierDismissible: false,
      child: PopScope(
        canPop: false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(message ?? 'Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void hideLoadingDialog() {
    if (canPop()) {
      pop();
    }
  }
  
  // Focus
  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}