import 'package:flutter/material.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class CustomDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    bool fullscreenDialog = false,
    bool? requestFocus,
    AnimationStyle? animationStyle,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      //   builder: (context) {
      //     return AlertDialog(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       child: builder(context),
      //     );
      //   },
      builder: builder,
    );
  }

  static AlertDialog alertDialog({
    Key? key,
    Widget? icon,
    EdgeInsetsGeometry? iconPadding,
    Color? iconColor,
    Widget? title,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? contentTextStyle,
    List<Widget>? actions,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    String? semanticLabel,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
    bool scrollable = false,
  }) {
    return AlertDialog(
      key: key,
      icon: icon,
      iconPadding: iconPadding ?? const EdgeInsets.only(bottom: 8),
      iconColor: iconColor ?? AppStyles.primaryColor,
      title: title,
      titlePadding: titlePadding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
      titleTextStyle: titleTextStyle ??
          const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      content: content,
      contentPadding:
          contentPadding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
      contentTextStyle: contentTextStyle ??
          const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
      actions: actions,
      actionsPadding:
          actionsPadding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
          ),
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 6,
      shadowColor: shadowColor ?? Colors.black54,
      surfaceTintColor: surfaceTintColor,
      semanticLabel: semanticLabel,
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
      clipBehavior: clipBehavior ?? Clip.none,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      alignment: alignment,
      constraints: constraints,
      scrollable: scrollable,
    );
  }

  static TextButton actionTextButton({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    WidgetStatesController? statesController,
    bool? isSemanticButton = true,
    Widget? child,
    required String textButton,
  }) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style ??
          TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: Colors.grey[700],
          ),
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      child: child ?? Text(textButton),
      isSemanticButton: isSemanticButton,
    );
  }

  static FilledButton actionFilledButton({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    WidgetStatesController? statesController,
    Widget? child,
    required String textButton,
    Color? customButtonColor,
  }) {
    return FilledButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style ??
          FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            backgroundColor: customButtonColor ?? AppStyles.primaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      child: child ?? Text(textButton),
    );
  }
}
