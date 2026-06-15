import 'package:dynamic_accordion/dynamic_accordion.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner:
          false, // Hides the debug banner for a cleaner look
      home: ExamplePage(),
    ));

/// A simple model to represent our form data
class PropertyController {
  TextEditingController nameController = TextEditingController();
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List<PropertyController> myControllers = [PropertyController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100, // Light background to make cards pop
      appBar: AppBar(
        title: const Text("Dynamic Accordion Example"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DynamicAccordionList<PropertyController>(
          items: myControllers,

          // ==========================================
          // 1. CORE FUNCTIONALITY
          // ==========================================
          headerBuilder: (ctx, index, item) => Text(
            "Property Details ${index + 1}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          bodyBuilder: (ctx, index, item) => TextFormField(
            controller: item.nameController,
            decoration: const InputDecoration(
              labelText: "Property Name",
              border:
                  OutlineInputBorder(), // Adds a clean border to the text field
            ),
          ),
          onAdd: () => PropertyController(),
          onDelete: (index, item) {
            // Optional: return false to prevent deletion
            return true;
          },

          // ==========================================
          // 2. NEW: STYLING & LAYOUT DEMONSTRATION
          // ==========================================
          initiallyExpanded: true, // Opens the first item automatically
          elevation: 4.0, // Thicker shadow
          cardColor: Colors.white,
          borderRadius: BorderRadius.circular(12.0), // Rounder edges
          borderColor:
              Colors.blueAccent.withValues(alpha: 0.3), // Tinted border

          // Customizing the action buttons
          addIcon: const Icon(Icons.add_box), // Swapped to a box icon
          addIconColor: Colors.green.shade600,
          deleteIcon:
              const Icon(Icons.delete_forever), // Swapped to forever icon
          deleteIconColor: Colors.red.shade400,

          // Change the icon itself
          dragIcon: Icons.drag_indicator, // Instead of the default 3 lines

          // Change the color
          dragIconColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
