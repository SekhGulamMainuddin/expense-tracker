import 'package:flutter/material.dart';

/// Rebuilds a subtree on demand. Used after DB restore so every BlocBuilder
/// rebinds to freshly registered singletons instead of stale ones.
class Phoenix extends StatefulWidget {
  Phoenix({required this.child}) : super(key: _rootKey);

  final Widget child;

  static final GlobalKey<_PhoenixState> _rootKey = GlobalKey<_PhoenixState>();

  /// Call after clearing and re-registering the service locator to force the
  /// widget tree to rebind to the fresh singletons.
  static void rebirth() {
    _rootKey.currentState?._rebirth();
  }

  @override
  State<Phoenix> createState() => _PhoenixState();
}

class _PhoenixState extends State<Phoenix> {
  Key _subtreeKey = UniqueKey();

  void _rebirth() {
    setState(() {
      _subtreeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _subtreeKey, child: widget.child);
  }
}
