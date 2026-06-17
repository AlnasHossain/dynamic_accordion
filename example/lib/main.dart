import 'package:dynamic_accordion/dynamic_accordion.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DynamicFormExample(),
    ));

/// A simple data controller representing a section in a dynamic questionnaire or sales form.
class SalesSectionController {
  final TextEditingController responseController = TextEditingController();
}

class DynamicFormExample extends StatefulWidget {
  const DynamicFormExample({super.key});

  @override
  State<DynamicFormExample> createState() => _DynamicFormExampleState();
}

class _DynamicFormExampleState extends State<DynamicFormExample> {
  // Initialize our form with one default section
  final List<SalesSectionController> _formSections = [SalesSectionController()];

  // Instantiating the controller gives us external power over the list layout
  final DynamicAccordionController<SalesSectionController>
      _accordionController =
      DynamicAccordionController<SalesSectionController>();

  /// Simulates a form submission, validating all dynamic fields.
  void _validateAndSubmit() {
    // Clear previous errors before running a new check
    _accordionController.clearAllErrors();

    bool hasAnyErrors = false;
    int? firstErrorIndex;

    // Evaluate each item in our underlying data list
    for (int i = 0; i < _formSections.length; i++) {
      if (_formSections[i].responseController.text.trim().isEmpty) {
        _accordionController.setValidationError(i, true);
        hasAnyErrors = true;
        firstErrorIndex ??= i; // Track the first failure to scroll to it
      }
    }

    if (hasAnyErrors && firstErrorIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Missing data in Section ${firstErrorIndex + 1}. Heading there now..."),
          backgroundColor: Colors.redAccent,
        ),
      );

      // Force the UI to focus on the exact card the user needs to fix
      _accordionController.scrollToIndex(firstErrorIndex);
      _accordionController.expandIndex(firstErrorIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "All sections validated perfectly! Form ready for submission."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Dynamic Form Builder"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // ---------------------------------------------------------
          // Controller Dashboard: External triggers for the accordion
          // ---------------------------------------------------------
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: _accordionController.expandAll,
                      icon: const Icon(Icons.unfold_more),
                      label: const Text("Expand All"),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _accordionController.collapseAll,
                      icon: const Icon(Icons.unfold_less),
                      label: const Text("Collapse All"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _validateAndSubmit,
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text("Submit Responses"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // ---------------------------------------------------------
          // The Core Component: Dynamic Accordion List
          // ---------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DynamicAccordionList<SalesSectionController>(
                items: _formSections,
                controller: _accordionController,

                // Layout behaviors
                exclusiveMode: true, // Opens one section at a time
                initiallyExpanded: true,

                // Styling parameters
                elevation: 1.5,
                cardColor: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                borderColor: Colors.blueAccent.withValues(alpha: 0.2),
                validationColor: Colors.red.shade600, // Color applied on error

                // Action icon overrides
                addIcon: const Icon(Icons.add_box_rounded),
                addIconColor: Colors.green.shade600,
                deleteIcon: const Icon(Icons.delete_sweep_rounded),
                deleteIconColor: Colors.red.shade400,
                dragIcon: Icons.drag_indicator,
                dragIconColor: Colors.grey.shade400,

                // Builders
                headerBuilder: (ctx, index, item) => Text(
                  "Questionnaire Section ${index + 1}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                bodyBuilder: (ctx, index, item) => TextFormField(
                  controller: item.responseController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Client Response *",
                    hintText: "Enter the required details here...",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                // Core Actions
                onAdd: () => SalesSectionController(),
                onDelete: (index, item) {
                  // Example: Prevent deletion if there is text inside
                  if (item.responseController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Cannot delete a section with existing data.")),
                    );
                    return false;
                  }
                  return true;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
