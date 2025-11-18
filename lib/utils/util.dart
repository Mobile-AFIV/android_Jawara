import 'package:flutter/cupertino.dart';

class Util {
  static RelativeRect getRectPositionFromAccountButton({
    required BuildContext context,
    required GlobalKey parentKey,
  }) {
    final RenderBox renderBox =
        parentKey.currentContext!.findRenderObject() as RenderBox;

    final Offset parentOffset = renderBox.localToGlobal(Offset.zero);

    final Size parentSize = renderBox.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      parentOffset.dx,
      parentOffset.dy + parentSize.height,
      MediaQuery.sizeOf(context).width - (parentOffset.dx + parentSize.width),
      0,
    );

    return position;
  }
}
