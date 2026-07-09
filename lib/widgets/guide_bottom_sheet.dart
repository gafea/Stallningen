import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/preset_hazards.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideBottomSheet extends StatefulWidget {
  const GuideBottomSheet({super.key});

  @override
  State<GuideBottomSheet> createState() => _GuideBottomSheetState();
}

class _GuideBottomSheetState extends State<GuideBottomSheet> {
  final Map<String, List<HazardPreset>> groupedHazards = {};

  @override
  void initState() {
    super.initState();
    _groupHazards();
  }

  void _groupHazards() {
    var presets = HazardPreset.getPresets();
    for (var preset in presets) {
      var roomMatch = RegExp(r'\((.*?)\)').firstMatch(preset.title);
      var room = roomMatch != null ? roomMatch.group(1) ?? 'Other' : 'Other';

      if (!groupedHazards.containsKey(room)) {
        groupedHazards[room] = [];
      }
      groupedHazards[room]!.add(preset);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Home Environment Safety',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),

          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: groupedHazards.keys.length,
              itemBuilder: (context, index) {
                var room = groupedHazards.keys.elementAt(index);
                var hazards = groupedHazards[room]!;

                return ExpansionTile(
                  title: Text(
                    room,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: hazards.map((hazard) {
                    return ExpansionTile(
                      title: Text(
                        hazard.title.replaceAll(RegExp(r'\s*\(.*?\)'), ''),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: hazard.recommendedProducts.map((product) {
                        return ListTile(
                          leading: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.primary),
                          title: Text(
                            product.name,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          trailing: FilledButton.tonal(
                            onPressed: () async {
                              var url = Uri.parse('https://www.amazon.com/s?k=${Uri.encodeComponent(product.name)}');
                              try {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } catch (_) {}
                            },
                            child: const Text('Find'),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
