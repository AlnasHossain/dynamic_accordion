library dynamic_accordion;

import 'package:flutter/material.dart';

/// A controller for [DynamicAccordionList] that allows programmatic manipulation
/// of expansion states, scroll positioning, and validation highlighting.
///
/// This controller bridges the gap between external state management (like a
/// submit button) and the internal UI state of the dynamic list.
class DynamicAccordionController<T> extends ChangeNotifier {
  final Map<Object, ExpansibleController> _tileControllers = {};
  final Map<Object, GlobalKey> _cardKeys = {};
  final Set<Object> _errorItems = {};

  List<T> _currentItems = [];
  bool _ignoreExclusiveMode = false;

  /// Synchronizes the internal tracking list with the active widget state.
  void _updateItems(List<T> items) {
    _currentItems = items;
  }

  /// Expands all accordion tiles simultaneously.
  ///
  /// Temporarily overrides [DynamicAccordionList.exclusiveMode] to ensure
  /// all tiles can open without collapsing each other.
  void expandAll() {
    _ignoreExclusiveMode = true;
    for (final controller in _tileControllers.values) {
      if (!controller.isExpanded) {
        controller.expand();
      }
    }
    // Release the override lock after the expansion microtask completes.
    Future.microtask(() => _ignoreExclusiveMode = false);
  }

  /// Collapses all currently expanded accordion tiles.
  void collapseAll() {
    for (final controller in _tileControllers.values) {
      if (controller.isExpanded) {
        controller.collapse();
      }
    }
  }

  /// Programmatically expands a specific tile by its current index.
  ///
  /// Useful for snapping open a specific section that requires user attention.
  void expandIndex(int index) {
    if (index >= 0 && index < _currentItems.length) {
      final item = _currentItems[index];
      final controller = _tileControllers[item as Object];
      if (controller != null && !controller.isExpanded) {
        controller.expand();
      }
    }
  }

  /// Smoothly scrolls the viewport to ensure the tile at the given index is visible.
  ///
  /// This utilizes [Scrollable.ensureVisible] and works safely within nested
  /// scroll views without requiring a dedicated ScrollController.
  void scrollToIndex(int index) {
    if (index >= 0 && index < _currentItems.length) {
      final item = _currentItems[index];
      final key = _cardKeys[item];
      final context = key?.currentContext;

      if (context != null && context.mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  /// Flags a specific item index with a validation error.
  ///
  /// When [hasError] is true, the corresponding card will rebuild and apply
  /// the [DynamicAccordionList.validationColor] to its border.
  void setValidationError(int index, bool hasError) {
    if (index >= 0 && index < _currentItems.length) {
      final item = _currentItems[index];
      if (hasError) {
        _errorItems.add(item as Object);
      } else {
        _errorItems.remove(item as Object);
      }
      notifyListeners();
    }
  }

  /// Clears all active validation error highlights across the entire list.
  void clearAllErrors() {
    if (_errorItems.isNotEmpty) {
      _errorItems.clear();
      notifyListeners();
    }
  }

  /// Evaluates if a specific item instance is currently flagged with an error.
  bool isItemInvalid(T item) => _errorItems.contains(item as Object);

  @override
  void dispose() {
    for (final controller in _tileControllers.values) {
      controller.dispose();
    }
    _tileControllers.clear();
    _cardKeys.clear();
    super.dispose();
  }
}

/// A highly customizable, reorderable list of accordion-style cards.
///
/// Designed for dynamic data entry forms, complex questionnaires, and modular
/// lists where users need the ability to add, remove, and reorder sections.
class DynamicAccordionList<T> extends StatefulWidget {
  /// The mutable data source driving the list.
  final List<T> items;

  /// Builds the visible header of the accordion tile.
  final Widget Function(BuildContext context, int index, T item) headerBuilder;

  /// Builds the collapsible body content of the accordion tile.
  final Widget Function(BuildContext context, int index, T item) bodyBuilder;

  /// Callback executed when the 'Add' button is pressed.
  /// Must return a new instance of [T] to be inserted into the list.
  final T Function() onAdd;

  /// Optional callback intercepting the deletion of an item.
  /// Return `true` to allow the deletion, or `false` to abort it.
  final bool Function(int index, T item)? onDelete;

  /// An optional controller to externally manage expansions, scrolling, and validation.
  final DynamicAccordionController<T>? controller;

  /// When true, expanding one tile will automatically collapse all others.
  final bool exclusiveMode;

  /// A reactive callback to determine if a specific item has a validation error.
  final bool Function(int index, T item)? hasError;

  /// The border color applied to a card when it is flagged with a validation error.
  final Color? validationColor;

  /// Whether the user can drag and drop cards to reorder them. Defaults to true.
  final bool isReorderable;

  /// The background color of the outer card.
  final Color? cardColor;

  /// The shadow depth of the card. Defaults to 2.0.
  final double? elevation;

  /// The border radius of the card. Defaults to 8.0.
  final BorderRadiusGeometry? borderRadius;

  /// The default border color of the card.
  final Color? borderColor;

  /// Icon used for the drag handle.
  final IconData? dragIcon;

  /// Color of the drag handle icon.
  final Color? dragIconColor;

  /// Widget used for the 'Add' action.
  final Widget? addIcon;

  /// Widget used for the 'Delete' action.
  final Widget? deleteIcon;

  /// Color of the 'Add' action button.
  final Color? addIconColor;

  /// Color of the 'Delete' action button.
  final Color? deleteIconColor;

  /// Whether new or existing tiles should render expanded by default.
  final bool initiallyExpanded;

  /// The scroll behavior of the underlying list.
  final ScrollPhysics? physics;

  /// Whether the list should constrain its height to its children. Defaults to true.
  final bool shrinkWrap;

  const DynamicAccordionList({
    super.key,
    required this.items,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.onAdd,
    this.controller,
    this.exclusiveMode = false,
    this.hasError,
    this.validationColor,
    this.onDelete,
    this.isReorderable = true,
    this.cardColor,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.dragIcon,
    this.dragIconColor,
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
  DynamicAccordionController<T>? _localController;
  late DynamicAccordionController<T> _effectiveController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant DynamicAccordionList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _effectiveController.removeListener(_onControllerChanged);
      _initController();
    }
    // Sync external items list changes with the controller
    _effectiveController._updateItems(widget.items);
  }

  void _initController() {
    _effectiveController = widget.controller ??
        (_localController ??= DynamicAccordionController<T>());
    _effectiveController.addListener(_onControllerChanged);
    _effectiveController._updateItems(widget.items);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onControllerChanged);
    _localController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ?? const BouncingScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: widget.items.length,
      onReorderStart: (int index) {
        // Drops keyboard focus before dragging to prevent LayerAssertion crashes
        // caused by active TextFields attempting to render selection handles during a structural shift.
        FocusManager.instance.primaryFocus?.unfocus();
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        // Removes the default white canvas background during drag operations
        return Material(
          color: Colors.transparent,
          elevation: 0,
          child: child,
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final T item = widget.items.removeAt(oldIndex);
          widget.items.insert(newIndex, item);
        });
        _effectiveController._updateItems(widget.items);
      },
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final Object itemKey = item as Object;

        final tileController =
            _effectiveController._tileControllers.putIfAbsent(
          itemKey,
          () => ExpansibleController(),
        );

        final cardKey = _effectiveController._cardKeys.putIfAbsent(
          itemKey,
          () => GlobalKey(),
        );

        final bool isInvalid = _effectiveController.isItemInvalid(item) ||
            (widget.hasError?.call(index, item) ?? false);

        final Color defaultBorderColor = widget.borderColor ??
            Theme.of(context).colorScheme.outline.withValues(alpha: 0.5);

        final Color errorColor =
            widget.validationColor ?? Theme.of(context).colorScheme.error;

        return Card(
          key: cardKey,
          color: widget.cardColor,
          elevation: widget.elevation ?? 2.0,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            side: BorderSide(
              color: isInvalid ? errorColor : defaultBorderColor,
              width: isInvalid ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            children: [
              ExpansionTile(
                controller: tileController,
                initiallyExpanded: widget.initiallyExpanded,
                shape:
                    const Border(), // Removes the default Material divider lines
                title: widget.headerBuilder(context, index, item),
                onExpansionChanged: (isExpanded) {
                  if (isExpanded &&
                      widget.exclusiveMode &&
                      !_effectiveController._ignoreExclusiveMode) {
                    _effectiveController._tileControllers
                        .forEach((key, controller) {
                      if (key != itemKey && controller.isExpanded) {
                        controller.collapse();
                      }
                    });
                  }
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.bodyBuilder(context, index, item),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    if (widget.isReorderable)
                      ReorderableDragStartListener(
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            widget.dragIcon ?? Icons.drag_handle,
                            color: widget.dragIconColor ??
                                Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      icon:
                          widget.deleteIcon ?? const Icon(Icons.delete_outline),
                      color: widget.deleteIconColor ??
                          Theme.of(context).colorScheme.error,
                      tooltip: 'Delete section',
                      onPressed: widget.items.length > 1
                          ? () {
                              bool shouldDelete =
                                  widget.onDelete?.call(index, item) ?? true;
                              if (shouldDelete) {
                                setState(() {
                                  widget.items.removeAt(index);

                                  // Cleanly dispose of controllers to prevent memory leaks
                                  _effectiveController._tileControllers[itemKey]
                                      ?.dispose();
                                  _effectiveController._tileControllers
                                      .remove(itemKey);
                                  _effectiveController._cardKeys
                                      .remove(itemKey);
                                  _effectiveController._errorItems
                                      .remove(itemKey);
                                });
                                _effectiveController._updateItems(widget.items);
                              }
                            }
                          : null,
                    ),
                    IconButton(
                      icon: widget.addIcon ??
                          const Icon(Icons.add_circle_outline),
                      color: widget.addIconColor ??
                          Theme.of(context).colorScheme.primary,
                      tooltip: 'Add new section below',
                      onPressed: () {
                        setState(() {
                          widget.items.insert(index + 1, widget.onAdd());
                        });
                        _effectiveController._updateItems(widget.items);
                      },
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
