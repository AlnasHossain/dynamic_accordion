import 'package:flutter/material.dart';

/// A dynamic list of accordion-style expansion tiles that allows users
/// to insert new items exactly where they click, and remove specific items.
class DynamicAccordionList<T> extends StatefulWidget {
  /// The mutable list of data objects or controllers.
  final List<T> items;

  /// Builds the header of the accordion (always visible).
  final Widget Function(BuildContext context, int index, T item) headerBuilder;

  /// Builds the body of the accordion (visible when expanded).
  final Widget Function(BuildContext context, int index, T item) bodyBuilder;

  /// A callback that must return a new instance of your data object/controller.
  final T Function() onAdd;

  /// Optional: Called before an item is removed.
  /// Return true to proceed with deletion, false to cancel (useful for showing confirmation dialogs).
  final bool Function(int index, T item)? onDelete;

  const DynamicAccordionList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.onAdd,
    this.onDelete,
  });

  @override
  State<DynamicAccordionList<T>> createState() =>
      _DynamicAccordionListState<T>();
}

class _DynamicAccordionListState<T> extends State<DynamicAccordionList<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Column(
            children: [
              // 1. The Accordion
              ExpansionTile(
                shape:
                    const Border(), // Removes default flutter borders on expansion
                title: widget.headerBuilder(context, index, item),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.bodyBuilder(context, index, item),
                  ),
                ],
              ),

              // 2. The Dynamic Action Bar (Inside the Card, below the accordion)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Theme.of(context).colorScheme.error,
                      // Disable delete if it's the last remaining item
                      onPressed: widget.items.length > 1
                          ? () {
                              bool shouldDelete = true;
                              if (widget.onDelete != null) {
                                shouldDelete = widget.onDelete!(index, item);
                              }
                              if (shouldDelete) {
                                setState(() {
                                  widget.items.removeAt(index);
                                });
                              }
                            }
                          : null,
                      tooltip: 'Delete this section',
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        // Core Logic: Insert at index + 1
                        setState(() {
                          widget.items.insert(index + 1, widget.onAdd());
                        });
                      },
                      tooltip: 'Add new section below',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
