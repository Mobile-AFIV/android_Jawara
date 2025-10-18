import 'package:flutter/material.dart';

class ModalBottomSheet {
  static Future<void> showCustomModalBottomSheet({
    required List<Widget> Function(StateSetter setModalState) children,
    required BuildContext context,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.directional(
          topStart: Radius.circular(12),
          topEnd: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(builder: (context, setModalState) {
          return FractionallySizedBox(
            heightFactor: 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  child: SizedBox(
                    width: 32,
                    height: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height / 2,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        top: 12,
                      ),
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children(setModalState),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
