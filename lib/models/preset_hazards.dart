import 'hazard.dart';

class HazardPreset {
  final String title;
  final String category;
  final String explanation;
  final int dangerScoreIncrease;
  final List<Product> recommendedProducts;

  const HazardPreset({
    required this.title,
    required this.category,
    required this.explanation,
    required this.dangerScoreIncrease,
    required this.recommendedProducts,
  });

  static List<HazardPreset> getPresets() {
    return const [
      // 1. Bathroom Hazards
      HazardPreset(
        title: 'Slippery floor (Bathroom)',
        category: 'floor',
        explanation:
            'Smooth tiled bathroom floors lack friction when wet. For seniors with balance recovery difficulties, slipping on hard porcelain surfaces presents high risk of head injury or hip fracture.',
        dangerScoreIncrease: 35,
        recommendedProducts: [
          Product(
            id: 'slip_spray',
            name: 'Slip-Guard Tile Treatment',
            description: 'Increases slip resistance on wet ceramic, porcelain, and stone surfaces.',
            price: 24.99,
            rating: '4.8',
            iconName: 'clean_hands',
          ),
        ],
      ),
      HazardPreset(
        title: 'Missing grab bar (Bathroom)',
        category: 'default',
        explanation:
            'Unstable transfer in and out of the tub or shower. Seniors require secure points of contact to stabilize themselves on slick wet surfaces.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'grab_bar',
            name: 'Stainless Steel Grab Bar',
            description: 'Sturdy wall-mounted safety rail providing pull support for shower entry.',
            price: 29.50,
            rating: '4.9',
            iconName: 'grid_view',
          ),
        ],
      ),
      HazardPreset(
        title: 'Wet mat (Bathroom)',
        category: 'floor',
        explanation:
            'Wet bath mats without slip backing slide underfoot. Standing up onto a sliding mat causes immediate loss of balance and falls.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'bath_mat',
            name: 'Non-Slip Microfiber Bath Mat',
            description: 'Ultra-friction latex backing holding the mat firmly to the tile floor.',
            price: 18.99,
            rating: '4.7',
            iconName: 'layers',
          ),
        ],
      ),
      HazardPreset(
        title: 'Poor lighting (Bathroom)',
        category: 'default',
        explanation:
            'Low visibility conceals water puddles and floor steps. Bright bathroom lighting is crucial for visual depth perception and safety.',
        dangerScoreIncrease: 20,
        recommendedProducts: [
          Product(
            id: 'motion_light',
            name: 'Motion-Activated Ceiling Light',
            description: 'Hands-free automatic overhead light that illuminates the bathroom instantly.',
            price: 22.00,
            rating: '4.8',
            iconName: 'wind_power',
          ),
        ],
      ),
      HazardPreset(
        title: 'High threshold (Bathroom)',
        category: 'default',
        explanation:
            'Raised door frames or marble dividers between bathroom and hallway catch senior toes, causing forward trips.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'threshold_ramp',
            name: 'Rubber Threshold Reducer',
            description: 'Creates a smooth beveled transition between differing floor heights.',
            price: 15.99,
            rating: '4.6',
            iconName: 'linear_scale',
          ),
        ],
      ),

      // 2. Bedroom Hazards
      HazardPreset(
        title: 'Poor night lighting (Bedroom)',
        category: 'default',
        explanation:
            'Low visibility during night-time bathroom visits is a major trigger for elderly falls. Insufficient lighting conceals bedside obstacles.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'night_light',
            name: 'Smart Bedside Outlet Sensor Light',
            description: 'Pulsing LED plug-in nightlight that turns on when motion is detected.',
            price: 12.99,
            rating: '4.8',
            iconName: 'wind_power',
          ),
        ],
      ),
      HazardPreset(
        title: 'Loose bedside rug (Bedroom)',
        category: 'floor',
        explanation:
            'Bedside mats without rubber backing slide easily when seniors stand up from the bed, causing them to lose footing instantly.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'rug_tape',
            name: 'Double-Sided Rug Grip Tape',
            description: 'Secures sliding bedside area rugs flat to prevent slipping.',
            price: 9.99,
            rating: '4.7',
            iconName: 'layers',
          ),
        ],
      ),
      HazardPreset(
        title: 'Clutter near bed (Bedroom)',
        category: 'fashion_good',
        explanation:
            'Trailing clothes, books, or slippers near the bed create a high-risk obstacle course for seniors getting up in the dark.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'bedside_pocket',
            name: 'Bedside Organizer Pocket',
            description: 'Attaches to bed frame to store books, glasses, and phones off the floor.',
            price: 14.50,
            rating: '4.6',
            iconName: 'checkroom',
          ),
        ],
      ),
      HazardPreset(
        title: 'Phone not reachable from floor (Bedroom)',
        category: 'default',
        explanation:
            'If a fall occurs, not having a phone within reach on the floor prevents the senior from calling for emergency assistance, increasing the danger.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'panic_pouch',
            name: 'Low-Elevation Phone Holder',
            description: 'Wall-mounted phone holster positioned near floor level for fall scenarios.',
            price: 8.99,
            rating: '4.5',
            iconName: 'attachment',
          ),
        ],
      ),
      HazardPreset(
        title: 'Sharp bed frame edge (Bedroom)',
        category: 'furniture',
        explanation:
            'Protruding wooden or metal bed corners pose severe bruising or cut hazards if a senior trips or loses balance near the bed.',
        dangerScoreIncrease: 20,
        recommendedProducts: [
          Product(
            id: 'corner_guards',
            name: 'Soft Gel Corner Bumpers',
            description: 'Clear silicone adhesive pads that cushion sharp furniture edges.',
            price: 10.99,
            rating: '4.8',
            iconName: 'grid_view',
          ),
        ],
      ),

      // 3. Kitchen Hazards
      HazardPreset(
        title: 'Slippery floor (Kitchen)',
        category: 'floor',
        explanation:
            'Spilled water, oil, or polished floor tiles in the kitchen lack traction. Slipping while holding kitchenware increases accident severity.',
        dangerScoreIncrease: 35,
        recommendedProducts: [
          Product(
            id: 'slip_spray_k',
            name: 'Kitchen Floor Anti-Slip Coating',
            description: 'Chemical treatment that increases wood and tile traction even when wet.',
            price: 24.99,
            rating: '4.8',
            iconName: 'clean_hands',
          ),
        ],
      ),
      HazardPreset(
        title: 'Items stored too high (Kitchen)',
        category: 'furniture',
        explanation:
            'Reaching for heavy kitchenware on high shelves forces seniors to stretch or use unstable stools, causing them to fall backward.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'reach_grabber',
            name: 'Ergonomic 32-inch Reach Grabber',
            description: 'Lightweight pick-up tool that grips cans, jars, and plates safely.',
            price: 19.99,
            rating: '4.9',
            iconName: 'grid_view',
          ),
        ],
      ),
      HazardPreset(
        title: 'Loose cables (Kitchen)',
        category: 'cable',
        explanation:
            'Kitchen appliance extension cords trailing across walkways catch senior toes, causing forward trip impacts.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'cord_cover_k',
            name: 'Flat Rubber Cord Ramp',
            description: 'Lies flat over walkways to route power cables safely without trip lips.',
            price: 18.50,
            rating: '4.7',
            iconName: 'linear_scale',
          ),
        ],
      ),
      HazardPreset(
        title: 'Cluttered walkway (Kitchen)',
        category: 'furniture',
        explanation:
            'Cluttered kitchen pathways block natural movement and make walking with mobility cane or walkers highly hazardous.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'wall_shelves',
            name: 'Collapsible Kitchen Organizer',
            description: 'Clears kitchen counters and floors by storing items vertically.',
            price: 29.99,
            rating: '4.6',
            iconName: 'grid_view',
          ),
        ],
      ),
      HazardPreset(
        title: 'Sharp table corner (Kitchen)',
        category: 'furniture',
        explanation:
            'Sharp dining table or counter edges multiply injury severity during a fall, posing a severe impact hazard.',
        dangerScoreIncrease: 20,
        recommendedProducts: [
          Product(
            id: 'silicone_edge',
            name: 'Silicone Table Edge Cushion Strip',
            description: 'Soft rubber edge wrapping that cushions sharp corners.',
            price: 13.99,
            rating: '4.8',
            iconName: 'grid_view',
          ),
        ],
      ),

      // 4. Living room Hazards
      HazardPreset(
        title: 'Loose rug (Living room)',
        category: 'floor',
        explanation:
            'Area rugs without rubber backing slide easily on wood or tile. Stepping on a sliding rug leads to sudden fall events.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'rug_pad',
            name: 'Eco-Grip Non-Slip Rug Pad',
            description: 'Felt-and-rubber underlay that holds carpets firmly in place.',
            price: 16.99,
            rating: '4.7',
            iconName: 'layers',
          ),
        ],
      ),
      HazardPreset(
        title: 'Low coffee table (Living room)',
        category: 'furniture',
        explanation:
            'Low-lying tables placed in center of living rooms are easy to overlook, presenting a significant tripping obstacle in normal paths.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'high_contrast_tape',
            name: 'High-Contrast Corner Markers',
            description: 'Bright adhesive pads that make low-profile edges visually stand out.',
            price: 7.99,
            rating: '4.5',
            iconName: 'attachment',
          ),
        ],
      ),
      HazardPreset(
        title: 'Cables across floor (Living room)',
        category: 'cable',
        explanation:
            'TV, speaker, and lamp extension cords trailing across walkways catch feet, a primary trigger for home hip fracture accidents.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'cable_clips',
            name: 'Adhesive Wall Cord Clips (50-pack)',
            description: 'Reroutes cables securely along baseboards to keep walk areas clear.',
            price: 9.99,
            rating: '4.8',
            iconName: 'attachment',
          ),
        ],
      ),
      HazardPreset(
        title: 'Sharp furniture edges (Living room)',
        category: 'furniture',
        explanation:
            'Protruding wooden or metal furniture corners pose severe bruising or cut hazards if a senior trips or loses balance.',
        dangerScoreIncrease: 20,
        recommendedProducts: [
          Product(
            id: 'gel_bumpers',
            name: 'Safety Edge Bumper Cushions',
            description: 'Soft gel protective corner protectors for coffee tables and TV stands.',
            price: 11.50,
            rating: '4.7',
            iconName: 'grid_view',
          ),
        ],
      ),
      HazardPreset(
        title: 'Poor lighting (Living room)',
        category: 'default',
        explanation:
            'Low lighting levels hide floor obstructions. Seniors require bright, well-lit spaces to safely navigate living area furniture.',
        dangerScoreIncrease: 20,
        recommendedProducts: [
          Product(
            id: 'smart_bulb',
            name: 'Smart Voice-Controlled LED Bulb',
            description: 'Turns on bright room lighting hands-free via voice commands.',
            price: 15.99,
            rating: '4.8',
            iconName: 'wind_power',
          ),
        ],
      ),

      // 5. Hallway Hazards
      HazardPreset(
        title: 'Poor lighting (Hallway)',
        category: 'default',
        explanation:
            'Dark hallways hide flooring level transitions and objects. High visibility lighting is critical for visual depth perception.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'outlet_light',
            name: 'Motion-Sensor Plug-in Hallway Light',
            description: 'Bright automatic nightlight designed to guide walkway navigation.',
            price: 11.99,
            rating: '4.8',
            iconName: 'wind_power',
          ),
        ],
      ),
      HazardPreset(
        title: 'Uneven floor (Hallway)',
        category: 'floor',
        explanation:
            'Sudden floor transitions, sagging floorboards, or damaged carpets catch senior toes, causing a sudden loss of forward balance.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'transition_strip',
            name: 'Beveled Floor Transition Strip',
            description: 'Creates a smooth, visual slope between two uneven rooms.',
            price: 14.50,
            rating: '4.7',
            iconName: 'linear_scale',
          ),
        ],
      ),
      HazardPreset(
        title: 'Narrow walking path (Hallway)',
        category: 'furniture',
        explanation:
            'Narrow corridors cluttered with console tables or shoe racks block walker/cane movement, causing balance conflicts.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'shoe_rack_slim',
            name: 'Ultra-Slim Vertical Shoe Cabinet',
            description: 'Replaces wide shoe racks to keep hallways completely open.',
            price: 39.99,
            rating: '4.7',
            iconName: 'grid_view',
          ),
        ],
      ),
      HazardPreset(
        title: 'High threshold (Hallway)',
        category: 'default',
        explanation:
            'Raised door thresholds or wooden separators between rooms catch toes and cause rapid loss of balance.',
        dangerScoreIncrease: 25,
        recommendedProducts: [
          Product(
            id: 'threshold_ramp_h',
            name: 'Rubber Entry Transition Ramp',
            description: 'Textured rubber wedge that eliminates raised door lips.',
            price: 16.99,
            rating: '4.6',
            iconName: 'linear_scale',
          ),
        ],
      ),
      HazardPreset(
        title: 'Loose mat (Hallway)',
        category: 'floor',
        explanation:
            'Runner mats or entryway carpets without anti-slip backing slide easily underfoot, causing high acceleration slips.',
        dangerScoreIncrease: 30,
        recommendedProducts: [
          Product(
            id: 'runner_grippers',
            name: 'L-Shaped Rug Corner Grippers',
            description: 'Double-sided adhesive hooks that anchor hallway carpets flat.',
            price: 10.99,
            rating: '4.8',
            iconName: 'layers',
          ),
        ],
      ),
    ];
  }
}
