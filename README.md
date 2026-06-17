# Dynamic Accordion

A flexible, highly customizable Flutter widget for managing dynamic lists of accordions. Perfect for complex forms where users need to add, remove, and reorder sections on the fly. Now fully equipped with programmatic controllers, exclusive modes, and form validation for production-grade applications.

## Features
* **Programmatic Controller:** Programmatically expand/collapse all, open specific indices, or smoothly scroll to targeted cards from anywhere in your app.
* **Exclusive Mode (Auto-Collapse):** Enable auto-collapse so opening one section automatically closes the others, keeping your UI clean during heavy data entry.
* **Validation Highlighting:** Instantly flag missing data by applying custom error borders to specific cards and auto-scrolling users directly to the sections they need to fix.
* **Drag-and-Drop Reordering:** Users can smoothly drag handles to reorder sections, with all underlying data managed automatically.
* **Insert Between:** Adds new accordions exactly where the user clicks (index + 1), rather than blindly appending to the bottom of the list.
* **Type-Safe & Memory Safe:** Uses Generics (`<T>`) so you can seamlessly pass your own data models. Built for modern Flutter (3.32+) with automated memory management to prevent controller leaks.
* **Fully Customizable UI:** Exposes properties for `cardColor`, `elevation`, `borderRadius`, and custom icons, allowing it to adapt to any design system.
* **Layout Control:** Supports `initiallyExpanded`, custom scroll `physics`, and `shrinkWrap` for deep integration into complex screens.

## Getting started
Add `dynamic_accordion` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  dynamic_accordion: ^2.0.0
```

## Basic Usage

The package handles the state and the action buttons; you just tell it what the header and body should look like!

```dart
DynamicAccordionList<MyController>(
  items: myControllersList,
  
  // 1. Build your Header
  headerBuilder: (context, index, item) => Text("Section ${index + 1}"),
  
  // 2. Build your Body
  bodyBuilder: (context, index, item) => TextFormField(
    controller: item.textController,
  ),
  
  // 3. Define what happens when 'Add' is pressed
  onAdd: () => MyController(),
  
  // Optional: Customize the look and feel!
  isReorderable: true, // Enabled by default!
  dragIcon: Icons.drag_indicator, // Customize the drag handle
  initiallyExpanded: true,
  elevation: 4.0,
  cardColor: Colors.white,
  addIconColor: Colors.green,
  deleteIconColor: Colors.red,
)
```

## Advanced Usage (Controllers & Validation)

Unlock the full power of the package by attaching a `DynamicAccordionController`. This allows you to orchestrate the list from external buttons, like a "Submit Form" action.

```dart
// 1. Instantiate the Controller
final DynamicAccordionController<MyController> _accordionController = 
    DynamicAccordionController<MyController>();

// 2. Pass it to the widget alongside your advanced features
DynamicAccordionList<MyController>(
  items: myControllersList,
  controller: _accordionController,
  
  exclusiveMode: true, // Auto-collapses neighboring open tabs
  validationColor: Colors.red.shade700, // Color applied when errors are flagged
  
  headerBuilder: (context, index, item) => Text("Section ${index + 1}"),
  bodyBuilder: (context, index, item) => TextFormField(controller: item.textController),
  onAdd: () => MyController(),
)

// 3. Control the UI Programmatically from anywhere!
void _submitForm() {
  // Expand or Collapse everything
  _accordionController.expandAll();
  
  // Highlight an item with a red border if it fails validation
  _accordionController.setValidationError(0, true); 
  
  // Smoothly scroll the user to the exact card that needs fixing and pop it open
  _accordionController.scrollToIndex(0);
  _accordionController.expandIndex(0);
}
```

Check out the `example/` folder for a fully working demonstration!