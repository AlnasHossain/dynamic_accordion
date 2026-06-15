# Dynamic Accordion

A flexible, highly customizable Flutter widget for managing dynamic lists of accordions (ExpansionTiles). Perfect for complex forms where users need to add, remove, and reorder sections on the fly.

## Features
* **Drag-and-Drop Reordering:** Users can smoothly drag handles to reorder sections, with all underlying data managed automatically.
* **Insert Between:** Adds new accordions exactly where the user clicks (index + 1), rather than blindly appending to the bottom of the list.
* **Type-Safe:** Uses Generics (`<T>`) so you can seamlessly pass your own data models, text controllers, or business logic states.
* **Fully Customizable UI:** Exposes properties for `cardColor`, `elevation`, `borderRadius`, and custom icons, allowing it to adapt to any design system.
* **Layout Control:** Supports `initiallyExpanded`, custom scroll `physics`, and `shrinkWrap` for deep integration into complex screens.

## Getting started
Add `dynamic_accordion` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  dynamic_accordion: ^1.2.0
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

Check out the `example/` folder for a fully working demonstration!