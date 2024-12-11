import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e, isHovered) {
              final scale = isHovered ? 1.3 : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 48),
                  height: 48,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.primaries[e.hashCode % Colors.primaries.length],
                  ),
                  child: Center(child: Icon(e, color: Colors.white)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T, bool) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late List<T> _items = widget.items.toList();

  /// Current index of dragged item, if any.
  T? _draggedItem;

  /// Currently hovered index.
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final currentItems = _draggedItem == null
        ? _items
        : _items.where((item) => item != _draggedItem).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(currentItems.length, (index) {
          final item = currentItems[index];

          return MouseRegion(
            onEnter: (_) => setState(() {
              _hoveredIndex = index;
            }),
            onExit: (_) => setState(() {
              _hoveredIndex = null;
            }),
            child: DragTarget<T>(
              onWillAcceptWithDetails: (details) {
                return details.data != null && details.data != item;
              },
              onAccept: (data) {
                setState(() {
                  final fromIndex = _items.indexOf(data);
                  _items.removeAt(fromIndex);
                  _items.insert(index, data);
                  _draggedItem = null;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Draggable<T>(
                  data: item,
                  feedback: Material(
                    color: Colors.transparent,
                    child: widget.builder(item, index == _hoveredIndex),
                  ),
                  onDragStarted: () {
                    setState(() {
                      _draggedItem = item;
                    });
                  },
                  onDragCompleted: () {
                    setState(() {
                      _draggedItem = null;
                    });
                  },
                  onDraggableCanceled: (_, __) {
                    setState(() {
                      _draggedItem = null;
                    });
                  },
                  child: widget.builder(item, index == _hoveredIndex),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// /// Entrypoint of the application.
// void main() {
//   runApp(const MyApp());
// }

// /// [Widget] building the [MaterialApp].
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Dock(
//             items: const [
//               Icons.person,
//               Icons.message,
//               Icons.call,
//               Icons.camera,
//               Icons.photo,
//             ],
//             builder: (e) {
//               return Container(
//                 constraints: const BoxConstraints(minWidth: 48),
//                 height: 48,
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.primaries[e.hashCode % Colors.primaries.length],
//                 ),
//                 child: Center(child: Icon(e, color: Colors.white)),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Dock of the reorderable [items].
// class Dock<T extends Object> extends StatefulWidget {
//   const Dock({
//     super.key,
//     this.items = const [],
//     required this.builder,
//   });

//   /// Initial [T] items to put in this [Dock].
//   final List<T> items;

//   /// Builder building the provided [T] item.
//   final Widget Function(T) builder;

//   @override
//   State<Dock<T>> createState() => _DockState<T>();
// }

// /// State of the [Dock] used to manipulate the [_items].
// class _DockState<T extends Object> extends State<Dock<T>> {
//   /// [T] items being manipulated.
//   late List<T> _items = widget.items.toList();

//   /// Current index of dragged item, if any.
//   T? _draggedItem;

//   @override
//   Widget build(BuildContext context) {
//     final currentItems = _draggedItem == null
//         ? _items
//         : _items.where((item) => item != _draggedItem).toList();

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.black12,
//       ),
//       padding: const EdgeInsets.all(4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: List.generate(currentItems.length, (index) {
//           final item = currentItems[index];

//           return DragTarget<T>(
//             onWillAccept: (data) => data != null && data != item,
//             onAccept: (data) {
//               setState(() {
//                 final fromIndex = _items.indexOf(data);
//                 _items.removeAt(fromIndex);
//                 _items.insert(index, data);
//                 _draggedItem = null;
//               });
//             },
//             builder: (context, candidateData, rejectedData) {
//               return Draggable<T>(
//                 data: item,
//                 feedback: Material(
//                   color: Colors.transparent,
//                   child: widget.builder(item),
//                 ),
//                 onDragStarted: () {
//                   setState(() {
//                     _draggedItem = item;
//                   });
//                 },
//                 onDragCompleted: () {
//                   setState(() {
//                     _draggedItem = null;
//                   });
//                 },
//                 onDraggableCanceled: (_, __) {
//                   setState(() {
//                     _draggedItem = null;
//                   });
//                 },
//                 child: widget.builder(item),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
