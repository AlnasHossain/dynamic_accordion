## 2.0.0

* **Feature:** Introduced `DynamicAccordionController` to support programmatic layout manipulation including expanding/collapsing all sections, opening specific indices, and clearing validation markers.
* **Feature:** Added programmatic scroll targeting (`scrollToIndex`) using safe contextual frame mapping to snap viewports directly to specific list indices.
* **Feature:** Added `exclusiveMode` parameter allowing the list to automatically collapse neighboring accordion items when a new section is opened.
* **Feature:** Added inline form validation support via the `hasError` evaluation callback and `validationColor` parameter, allowing dynamic red-border alerting for invalid data slots.
* **Fix:** Resolved a critical Flutter rendering crash (`LeaderLayer anchor must come before FollowerLayer in paint order`) by enforcing instant text field focus release (`FocusManager.unfocus`) at the moment a drag sequence starts.
* **Refactor:** Migrated internal tracking maps from legacy `ExpansionTileController` instances to standard `ExpansibleController` objects to guarantee compliance with modern Flutter engines.
* **Performance:** Implemented active lifecycle hooks to explicitly dispose of internal structural controllers upon cell deletion or widget unmounting to guarantee zero memory leaks.


## 1.2.1

* **Fix:** Resolved static analysis warning by using `onReorder` with a deprecation ignore, ensuring compatibility across all Flutter versions.


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