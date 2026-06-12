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
  /// Return true to proceed with deletion, false to cancel.
  final bool Function(int index, T item)? onDelete;

  // ==========================================
  // NEW: Stylistic & Layout Parameters
  // ==========================================

  /// The background color of the card.
  final Color? cardColor;

  /// The shadow elevation of the card. Defaults to 2.0.
  final double? elevation;

  /// The border radius of the card. Defaults to 8.0.
  final BorderRadiusGeometry? borderRadius;

  /// The color of the card's border.
  final Color? borderColor;

  /// Custom icon for the 'Add' button. Defaults to Icons.add_circle_outline.
  final Widget? addIcon;

  /// Custom icon for the 'Delete' button. Defaults to Icons.delete_outline.
  final Widget? deleteIcon;

  /// Custom color for the 'Add' button. Defaults to Theme primary color.
  final Color? addIconColor;

  /// Custom color for the 'Delete' button. Defaults to Theme error color.
  final Color? deleteIconColor;

  /// Whether the tiles should be expanded by default. Defaults to false.
  final bool initiallyExpanded;

  /// Scroll physics for the list. Defaults to NeverScrollableScrollPhysics().
  final ScrollPhysics? physics;

  /// Whether the list should shrink-wrap its contents. Defaults to true.
  final bool shrinkWrap;

  const DynamicAccordionList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.onAdd,
    this.onDelete,
    this.cardColor,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.addIcon,
    this.deleteIcon,
    this.addIconColor,
    this.deleteIconColor,
    this.initiallyExpanded = false,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  State<DynamicAccordionList<T>> createState() =>
      _DynamicAccordionListState<T>();
}

class _DynamicAccordionListState<T> extends State<DynamicAccordionList<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ?? const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];

        return Card(
          color: widget.cardColor,
          elevation: widget.elevation ?? 2.0,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            side: BorderSide(
              color: widget.borderColor ??
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              // 1. The Accordion
              ExpansionTile(
                initiallyExpanded: widget.initiallyExpanded,
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

              // 2. The Dynamic Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon:
                          widget.deleteIcon ?? const Icon(Icons.delete_outline),
                      color: widget.deleteIconColor ??
                          Theme.of(context).colorScheme.error,
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
                      icon: widget.addIcon ??
                          const Icon(Icons.add_circle_outline),
                      color: widget.addIconColor ??
                          Theme.of(context).colorScheme.primary,
                      onPressed: () {
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
