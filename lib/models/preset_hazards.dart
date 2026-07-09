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
          Product(
            id: 'shower_chair',
            name: 'Medical Shower Chair',
            description: 'Provides a safe, stable seat during showers to prevent slips.',
            price: 45.99,
            rating: '4.7',
            iconName: 'grid_view',
          ),
          Product(
            id: 'grip_tape',
            name: 'Waterproof Anti-Slip Grip Tape',
            description: 'Provides extra traction on slick bathroom surfaces.',
            price: 12.99,
            rating: '4.5',
            iconName: 'linear_scale',
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
          Product(
            id: 'suction_grab_bar',
            name: 'Heavy-Duty Suction Grab Bar',
            description: 'Easily attachable temporary grab bar for bathroom tiles.',
            price: 19.99,
            rating: '4.4',
            iconName: 'attachment',
          ),
          Product(
            id: 'tub_rail',
            name: 'Adjustable Bathtub Safety Rail',
            description: 'Clamps onto the side of the tub to assist getting in and out.',
            price: 38.50,
            rating: '4.8',
            iconName: 'linear_scale',
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
          Product(
            id: 'bamboo_mat',
            name: 'Anti-Slip Bamboo Bath Mat',
            description: 'Sturdy and naturally water-resistant mat with rubber feet.',
            price: 26.99,
            rating: '4.6',
            iconName: 'grid_view',
          ),
          Product(
            id: 'quick_dry_stone',
            name: 'Diatomaceous Earth Bath Mat',
            description: 'Instantly absorbs water and dries quickly to prevent slipping.',
            price: 32.00,
            rating: '4.8',
            iconName: 'clean_hands',
          ),
        ],
      ),
      HazardPreset(
        title: 'Poor night lighting (Bathroom)',
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
          Product(
            id: 'toilet_light',
            name: 'LED Toilet Night Light',
            description: 'Motion-activated glow light for safe nighttime bathroom use.',
            price: 11.50,
            rating: '4.5',
            iconName: 'wind_power',
          ),
          Product(
            id: 'led_mirror',
            name: 'Illuminated Bathroom Mirror',
            description: 'Provides bright, shadow-free lighting for grooming and visibility.',
            price: 89.99,
            rating: '4.7',
            iconName: 'grid_view',
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
          Product(
            id: 'warning_tape',
            name: 'High-Visibility Hazard Tape',
            description: 'Marks uneven thresholds clearly to alert of step hazards.',
            price: 8.99,
            rating: '4.5',
            iconName: 'layers',
          ),
          Product(
            id: 'metal_ramp',
            name: 'Aluminum Transition Ramp',
            description: 'Durable, slip-resistant metal ramp for larger threshold drops.',
            price: 45.00,
            rating: '4.8',
            iconName: 'grid_view',
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
          Product(
            id: 'bed_strip_light',
            name: 'Under-Bed Motion LED Strip',
            description: 'Illuminates the floor softly when stepping out of bed.',
            price: 24.50,
            rating: '4.7',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'touch_lamp',
            name: 'Touch-Activated Table Lamp',
            description: 'Easy-to-turn-on bedside lamp with 3 brightness levels.',
            price: 28.00,
            rating: '4.9',
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
          Product(
            id: 'rug_pad_bed',
            name: 'Non-Slip Rug Underlay',
            description: 'Extra thick felt pad providing traction and cushioning.',
            price: 22.99,
            rating: '4.8',
            iconName: 'layers',
          ),
          Product(
            id: 'weighted_corners',
            name: 'Rug Corner Weights',
            description: 'Heavy duty rubber corners to stop rugs from curling and sliding.',
            price: 14.50,
            rating: '4.5',
            iconName: 'grid_view',
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
          Product(
            id: 'rolling_cart',
            name: 'Slim Rolling Storage Cart',
            description: 'Keeps bedside items organized and easily movable.',
            price: 34.00,
            rating: '4.7',
            iconName: 'grid_view',
          ),
          Product(
            id: 'cable_box',
            name: 'Cable Management Box',
            description: 'Hides and secures loose charger cables away from walking paths.',
            price: 18.99,
            rating: '4.8',
            iconName: 'attachment',
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
          Product(
            id: 'fall_detector',
            name: 'Smart Fall Detection Watch',
            description: 'Wearable device that automatically calls emergency services if a hard fall is detected.',
            price: 149.99,
            rating: '4.9',
            iconName: 'clean_hands',
          ),
          Product(
            id: 'voice_assistant',
            name: 'Smart Voice Assistant Speaker',
            description: 'Allows calling for help using voice commands from anywhere in the room.',
            price: 49.99,
            rating: '4.8',
            iconName: 'wind_power',
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
          Product(
            id: 'edge_cushion_roll',
            name: 'Foam Edge Cushion Roll',
            description: 'Cut-to-size dense foam to line sharp bed frames entirely.',
            price: 18.50,
            rating: '4.7',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'padded_headboard',
            name: 'Upholstered Bed Corner Guards',
            description: 'Fabric-covered guards that blend with bedroom decor.',
            price: 24.99,
            rating: '4.6',
            iconName: 'checkroom',
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
          Product(
            id: 'anti_fatigue_mat',
            name: 'Non-Slip Anti-Fatigue Mat',
            description: 'Provides cushion and strong grip in front of the sink or stove.',
            price: 39.99,
            rating: '4.9',
            iconName: 'layers',
          ),
          Product(
            id: 'grip_slippers',
            name: 'Non-Skid House Slippers',
            description: 'Rubber-soled indoor footwear to prevent sliding on kitchen tiles.',
            price: 22.00,
            rating: '4.7',
            iconName: 'checkroom',
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
          Product(
            id: 'step_stool',
            name: 'Folding Safety Step Stool with Handle',
            description: 'Stable stool with a tall handrail for balance support.',
            price: 59.99,
            rating: '4.8',
            iconName: 'grid_view',
          ),
          Product(
            id: 'pull_down_shelf',
            name: 'Pull-Down Cabinet Organizer',
            description: 'Brings high shelf items down to eye level safely.',
            price: 120.00,
            rating: '4.6',
            iconName: 'layers',
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
          Product(
            id: 'appliance_cord_winder',
            name: 'Stick-On Appliance Cord Organizer',
            description: 'Wraps excess cord neatly directly on the kitchen appliance.',
            price: 9.99,
            rating: '4.5',
            iconName: 'attachment',
          ),
          Product(
            id: 'short_extension',
            name: 'Short Heavy-Duty Extension Cord',
            description: 'Replaces long tripping cords with safe 1-foot spans.',
            price: 12.99,
            rating: '4.8',
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
          Product(
            id: 'corner_shelf',
            name: 'Corner Storage Rack',
            description: 'Utilizes unused corners to free up main walking space.',
            price: 45.00,
            rating: '4.7',
            iconName: 'grid_view',
          ),
          Product(
            id: 'over_door_rack',
            name: 'Over-The-Door Pantry Organizer',
            description: 'Hangs on doors to eliminate floor-standing storage bins.',
            price: 34.50,
            rating: '4.8',
            iconName: 'layers',
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
          Product(
            id: 'foam_corner',
            name: 'L-Shaped Foam Corner Protectors',
            description: 'Dense absorbing foam for sharp countertop overhangs.',
            price: 11.50,
            rating: '4.7',
            iconName: 'grid_view',
          ),
          Product(
            id: 'clear_bumpers',
            name: 'Transparent Corner Guards (12-Pack)',
            description: 'Unobtrusive silicone bumpers that blend with furniture.',
            price: 9.99,
            rating: '4.6',
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
          Product(
            id: 'corner_grips_living',
            name: 'Washable Rug Corner Grippers',
            description: 'V-shaped adhesives to stop living room rugs from curling.',
            price: 12.50,
            rating: '4.6',
            iconName: 'attachment',
          ),
          Product(
            id: 'rug_tape_heavy',
            name: 'Heavy Duty Carpet Tape',
            description: 'Industrial strength double-sided tape for large area rugs.',
            price: 14.99,
            rating: '4.8',
            iconName: 'linear_scale',
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
          Product(
            id: 'cushioned_ottoman',
            name: 'Soft Upholstered Ottoman',
            description: 'Replaces hard, low coffee tables with a soft, visible alternative.',
            price: 89.00,
            rating: '4.8',
            iconName: 'grid_view',
          ),
          Product(
            id: 'furniture_risers',
            name: 'Heavy Duty Furniture Risers',
            description: 'Elevates low tables by 3 inches to make them more visible and accessible.',
            price: 18.99,
            rating: '4.7',
            iconName: 'layers',
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
          Product(
            id: 'floor_cord_cover',
            name: 'Heavy Duty Floor Cord Cover',
            description: 'Protects walking paths by concealing cords under a smooth rubber dome.',
            price: 24.50,
            rating: '4.9',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'cable_sleeve',
            name: 'Braided Cable Management Sleeve',
            description: 'Bundles messy TV wires into a single neat tube behind furniture.',
            price: 13.99,
            rating: '4.7',
            iconName: 'layers',
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
          Product(
            id: 'foam_edge_guard',
            name: 'Extra Thick Foam Edge Guard',
            description: '15-foot roll of impact-absorbing foam for fireplace hearths and media consoles.',
            price: 22.99,
            rating: '4.8',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'corner_cushions_clear',
            name: 'Discreet Clear Corner Guards',
            description: 'Blends into wood furniture while providing safety from sharp impacts.',
            price: 9.99,
            rating: '4.5',
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
          Product(
            id: 'floor_lamp',
            name: 'High-Lumen Torchiere Floor Lamp',
            description: 'Blasts light upwards to evenly illuminate the entire living room without glare.',
            price: 55.00,
            rating: '4.7',
            iconName: 'wind_power',
          ),
          Product(
            id: 'remote_outlets',
            name: 'Remote Control Outlet Switches',
            description: 'Turn on inaccessible living room lamps safely from an armchair.',
            price: 19.99,
            rating: '4.8',
            iconName: 'attachment',
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
          Product(
            id: 'battery_sconce',
            name: 'Battery Operated Wall Sconce',
            description: 'Adds bright lighting to hallways without needing hardwired electricity.',
            price: 29.99,
            rating: '4.6',
            iconName: 'wind_power',
          ),
          Product(
            id: 'step_lights',
            name: 'Motion Sensor Step Lights',
            description: 'Low-profile lights that illuminate the floor directly to reveal hazards.',
            price: 24.50,
            rating: '4.7',
            iconName: 'grid_view',
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
          Product(
            id: 'glow_tape',
            name: 'Glow-in-the-Dark Warning Tape',
            description: 'Highlights uneven floorboards so they are visible even at night.',
            price: 8.99,
            rating: '4.5',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'carpet_tape',
            name: 'Heavy Duty Carpet Seam Tape',
            description: 'Repairs loose or frayed carpet edges that create trip hazards.',
            price: 12.99,
            rating: '4.8',
            iconName: 'attachment',
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
          Product(
            id: 'wall_hooks',
            name: 'Heavy-Duty Wall Coat Hooks',
            description: 'Gets coats and bags off hallway floors and narrow benches.',
            price: 15.50,
            rating: '4.8',
            iconName: 'attachment',
          ),
          Product(
            id: 'floating_shelf',
            name: 'Minimalist Floating Console Shelf',
            description: 'Provides key storage without taking up floor walking space.',
            price: 28.00,
            rating: '4.6',
            iconName: 'layers',
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
          Product(
            id: 'aluminum_threshold',
            name: 'Low-Profile Aluminum Threshold',
            description: 'Replaces bulky wooden transitions with a smooth metal glide.',
            price: 24.50,
            rating: '4.8',
            iconName: 'linear_scale',
          ),
          Product(
            id: 'step_stool_half',
            name: 'Half-Step Walking Platform',
            description: 'Reduces step height for very high transitions or patio doors.',
            price: 35.00,
            rating: '4.7',
            iconName: 'grid_view',
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
          Product(
            id: 'non_slip_runner',
            name: 'Heavy-Rubber Backed Hallway Runner',
            description: 'A dedicated high-traction carpet designed not to slide.',
            price: 49.99,
            rating: '4.9',
            iconName: 'layers',
          ),
          Product(
            id: 'carpet_tacks',
            name: 'Non-Damaging Rug Tacks',
            description: 'Pins runner rugs safely into wood floors to prevent any movement.',
            price: 8.50,
            rating: '4.4',
            iconName: 'attachment',
          ),
        ],
      ),
    ];
  }
}
