# Dynamic Accordion

A flexible Flutter widget for managing dynamic lists of accordions (ExpansionTiles). Perfect for forms where users need to add, remove, and reorder sections on the fly.

## Features
* **Insert Between:** Adds new accordions exactly where the user clicks (index + 1), rather than just appending to the bottom.
* **Type-Safe:** Uses Generics (`<T>`) so you can pass your own data models or controllers.
* **UI Agnostic:** You control the look of the header and the body; the package just handles the state and the Add/Delete buttons.

## Getting started
Add `dynamic_accordion` to your `pubspec.yaml` dependencies.