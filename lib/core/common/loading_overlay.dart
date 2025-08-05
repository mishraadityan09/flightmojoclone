import 'package:flightmojo/core/common/generic_loading_screen.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _current;

  static void show<T>({
    required BuildContext context,
    required Future<T> Function() operation,
    Map<String, dynamic>? infoToShow,
    required void Function(BuildContext, T) onSuccess,
    void Function(BuildContext, Object)? onError,
  }) {
    if (_current != null) return; // Prevent multiple overlays

    _current = OverlayEntry(
      builder: (_) => GenericLoadingScreen<T>(
        operation: () => operation(),
        infoToShow: infoToShow,
        onSuccess: (ctx, result) {
          // Navigate first, then hide with delay
          onSuccess(ctx, result);
          Future.delayed(const Duration(milliseconds: 100), () {
            hide();
          });
        },
        onError: (ctx, error) {
          hide();
          if (onError != null) onError(ctx, error);
        },
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_current!);
  }

  static void hide() {
    _current?.remove();
    _current = null;
  }
}
