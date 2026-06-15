## 1.2.0

* **Feature:** Added true Drag-and-Drop reordering support via `ReorderableListView`.
* **Feature:** Added custom `dragIcon` and `dragIconColor` parameters.
* **Fix:** Added a custom `proxyDecorator` to remove the default white background during drag animations, preserving custom card styling.


## 1.1.0

* **Feature:** Added comprehensive styling parameters (`cardColor`, `elevation`, `borderRadius`, `borderColor`).
* **Feature:** Added ability to fully customize action bar icons and colors (`addIcon`, `deleteIcon`, `addIconColor`, `deleteIconColor`).
* **Feature:** Added layout control parameters (`initiallyExpanded`, `shrinkWrap`, and `physics`).
* **Documentation:** Added a comprehensive example application demonstrating core functionality and UI customization.

## 1.0.1

* Fixed deprecated `withOpacity` warning to ensure compatibility with recent Flutter versions.
* Improved static analysis compliance.

## 1.0.0

* Initial release of `dynamic_accordion`.
* Features: Dynamic accordion list with insertion at index + 1, deletion, and generic support for any data model.