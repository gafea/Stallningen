class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String rating;
  final String iconName;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.iconName,
  });
}

class Hazard {
  final String id;
  final String title;
  final String explanation;
  final int dangerScoreIncrease;

  // Coordinate boxes relative to viewfinder size (0.0 to 1.0)
  final double relativeX;
  final double relativeY;
  final double relativeWidth;
  final double relativeHeight;
  final String category;
  final List<Product> recommendedProducts;

  const Hazard({
    required this.id,
    required this.title,
    required this.explanation,
    required this.dangerScoreIncrease,
    required this.relativeX,
    required this.relativeY,
    required this.relativeWidth,
    required this.relativeHeight,
    required this.recommendedProducts,
    this.category = 'default',
  });

  static List<Hazard> getMockHazards() {
    return [
      const Hazard(
        id: 'slippery_floor',
        title: 'Slippery Tiled Floor',
        category: 'floor',
        explanation:
            'Polished tiles have very low friction when wet or dry. For seniors with balance impairment or gait changes, slippery surfaces increase the risk of a devastating hip fracture or head injury by over 60%.',
        dangerScoreIncrease: 35,
        relativeX: 0.1,
        relativeY: 0.65,
        relativeWidth: 0.8,
        relativeHeight: 0.22,
        recommendedProducts: [
          Product(
            id: 'slip_spray',
            name: 'Slip-Guard Anti-Slip Spray',
            description:
                'Invisible floor treatment that increases slip resistance on ceramic, stone, and tile surfaces.',
            price: 24.99,
            rating: '4.8',
            iconName: 'clean_hands',
          ),
          Product(
            id: 'grip_slippers',
            name: 'Orthopedic Grip Slippers',
            description:
                'Ultra-friction rubber outsoles combined with memory foam support, optimized for senior indoor walking.',
            price: 34.50,
            rating: '4.9',
            iconName: 'checkroom',
          ),
          Product(
            id: 'dry_fan',
            name: 'Motion-Activated Floor Fan',
            description: 'Quickly dries wet kitchen and bathroom floors automatically when motion is detected.',
            price: 49.99,
            rating: '4.6',
            iconName: 'wind_power',
          ),
        ],
      ),
      const Hazard(
        id: 'loose_cable',
        title: 'Trailing Extension Cable',
        category: 'cable',
        explanation:
            'Cords trailing across high-traffic walking paths are high-risk tripping obstacles. Older adults tend to lift their feet less when walking, making low-lying wires highly susceptible to catching feet.',
        dangerScoreIncrease: 25,
        relativeX: 0.55,
        relativeY: 0.45,
        relativeWidth: 0.35,
        relativeHeight: 0.15,
        recommendedProducts: [
          Product(
            id: 'cable_ramp',
            name: 'Rubber Cable Protector Ramp',
            description: 'Low-profile floor cord cover that lies flat and prevents tripping while organizing cords.',
            price: 18.99,
            rating: '4.7',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'cord_clips',
            name: 'Adhesive Cable Wall Clips',
            description: 'Reroute cables along baseboards and walls instead of floor surfaces. Pack of 50.',
            price: 9.99,
            rating: '4.5',
            iconName: 'attachment',
          ),
        ],
      ),
      const Hazard(
        id: 'curled_rug',
        title: 'Curled Rug Corners',
        category: 'rug',
        explanation:
            'Loose rugs and runner mats with folded edges or lack of backing are major fall triggers. Tapping a toe against an unsecured edge leads to sudden forward momentum loss, causing a fall.',
        dangerScoreIncrease: 30,
        relativeX: 0.05,
        relativeY: 0.40,
        relativeWidth: 0.38,
        relativeHeight: 0.18,
        recommendedProducts: [
          Product(
            id: 'rug_grippers',
            name: 'L-Shaped Non-Slip Rug Grippers',
            description: 'Double-sided adhesive pads that anchor rug corners flat to the floor without residue.',
            price: 12.99,
            rating: '4.8',
            iconName: 'grid_view',
          ),
          Product(
            id: 'rug_underlay',
            name: 'Eco-Grip Rug Pad Underlay',
            description: 'Non-slip mesh pad placed beneath carpets to prevent sliding on wood or tile surfaces.',
            price: 15.99,
            rating: '4.7',
            iconName: 'layers',
          ),
        ],
      ),
    ];
  }
}
