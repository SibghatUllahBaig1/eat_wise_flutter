import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

/// Script to upload hardcoded recipes from app_state.dart to Firebase Firestore
///
/// This script transforms RecipesStruct data to match the Firestore recipes collection schema
///
/// Run with: dart scripts/upload_recipes.dart

void main() async {
  print('🚀 Starting recipe upload to Firebase...\n');

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized\n');
  } catch (e) {
    print('❌ Error initializing Firebase: $e');
    exit(1);
  }

  final firestore = FirebaseFirestore.instance;
  final recipesCollection = firestore.collection('recipes');

  // Hardcoded recipes data from app_state.dart
  final recipes = [
    {
      'title': 'Neapolitan-Style Margherita Pizza',
      'description':
          'The Neapolitan Margherita Pizza is a classic Italian dish originating from Naples. It features a thin, soft, and slightly chewy crust, topped with simple, high-quality ingredients: crushed San Marzano tomatoes, fresh mozzarella, fragrant basil, and a drizzle of extra virgin olive oil. It\'s the essence of Italian cuisine simple, fresh, and flavorful.',
      'content':
          'Ingredients:\n\n •  250 g (about 2 cups) all-purpose flour\n •  160 ml (2/3 cup) warm water\n •  1/2 tsp salt\n •  1/4 tsp dry yeast\n •  2 tbsp olive oil\n •  100 g fresh mozzarella\n •  4 tbsp crushed tomatoes or pizza sauce\n •  Fresh basil leaves\n •  Olive oil (for drizzling)\n\nInstructions:\n\n •  Make the dough: Mix flour, salt, yeast, and water. Knead for 8–10 min until smooth. Cover and let it rise for 1–2 hours.\n •  Preheat oven: Heat to the highest setting (250–300°C / 480–570°F) with a pizza stone or baking tray inside.\n •  Shape the dough: Stretch the dough into a thin circle (about 10–12 inches).\n •  Add toppings: Spread tomato sauce, tear mozzarella on top, and add fresh basil.\n •  Bake: Place pizza on hot stone/tray. Bake for 7–9 minutes until crust is golden and cheese is bubbling.\n •  Finish: Drizzle with olive oil and serve hot.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/articles%2FMargherita%20Pizza.jpg?alt=media&token=554d8b4e-f983-433e-8162-966b2ef326ce',
      'tags': ['Dinner', 'High Fiber', '500-600 kcal', 'Lunch', 'Vegetarian'],
      'cook_time': 85,
      'kcal': 567,
    },
    {
      'title': 'Marinated zucchini with hazelnuts and ricotta',
      'description':
          'This light and flavorful dish is perfect as an appetizer or a refreshing side. Thinly sliced zucchini is marinated in a lemony dressing, paired with creamy ricotta, and topped with crunchy toasted hazelnuts. It\'s elegant, simple, and full of contrast — a real summer favorite.',
      'content':
          'Ingredients:\n\n •  2 medium zucchinis\n •  3 tbsp olive oil\n •  1 tbsp lemon juice\n •  Salt & black pepper (to taste)\n •  1/3 cup ricotta cheese\n •  1/4 cup toasted hazelnuts (chopped)\n •  Fresh basil or mint leaves (optional)\n\nInstructions:\n\n •  Slice zucchini into thin ribbons using a peeler or mandoline.\n •  Mix olive oil, lemon juice, salt, and pepper in a bowl.\n •  Toss zucchini in the marinade and let sit for 15–20 minutes.\n •  Arrange zucchini on a plate, dollop ricotta over the top.\n •  Sprinkle with chopped hazelnuts and fresh herbs if using.\n •  Serve chilled or at room temperature.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe.png?alt=media&token=c91690dd-35ad-435b-8f45-d90fa7837690',
      'tags': ['Dinner', '700+ kcal', 'Lunch', 'Vegetarian'],
      'cook_time': 45,
      'kcal': 752,
    },
    {
      'title': 'Watermelon Smoothie with Basil & Mint',
      'description':
          'This refreshing watermelon smoothie is the perfect summer drink — light, hydrating, and packed with flavor. The combination of sweet watermelon, cool mint, and aromatic basil creates a unique taste that is both soothing and revitalizing. It\'s naturally sweet, easy to make, and ideal for hot days or a post-workout refreshment.',
      'content':
          'Ingredients:\n\n •  3 cups fresh watermelon (seedless, cubed)\n •  1 tablespoon fresh basil leaves (roughly chopped)\n •  1 tablespoon fresh mint leaves (roughly chopped)\n •  1/2 cup cold water or coconut water (optional, for thinner consistency)\n •  1 teaspoon lime juice (optional, for extra zing)\n •  Ice cubes (as needed)\n •  Honey or agave syrup (optional, if extra sweetness is desired)\n\nInstructions:\n\n1. Prepare the ingredients:\nCut the watermelon into cubes and remove any seeds if necessary. Roughly chop the basil and mint leaves.\n\n2. Blend:\nIn a blender, combine the watermelon, basil, mint, lime juice (if using), and a few ice cubes. Blend until smooth.\n\n3. Adjust consistency:\nIf the smoothie is too thick, add cold water or coconut water and blend again until you reach the desired consistency.\n\n4. Taste and sweeten:\nTaste the smoothie. If you\'d like it sweeter, add a little honey or agave syrup and blend briefly.\n\n5. Serve:\nPour into a glass and garnish with a mint or basil leaf for a fresh look. Serve immediately while cold.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe2.png?alt=media&token=7e87f236-7000-49d7-bf50-d4b30ac15d6c',
      'tags': [
        'Dessert',
        '300-400 kcal',
        'Low Calorie',
        'Low Fat',
        'Smoothie',
        'Snack',
        'Sugar Free',
        'Vegan',
        'Vegetarian'
      ],
      'cook_time': 7,
      'kcal': 345,
    },
    {
      'title': 'Vegetarian Butternut Squash Soup',
      'description':
          'This cozy and comforting soup is made with roasted butternut squash, aromatic vegetables, and warm spices. It\'s creamy, naturally sweet, and completely vegetarian (and can easily be made vegan). Perfect for chilly days and pairs wonderfully with crusty bread.',
      'content':
          'Ingredients:\n\n •  1 medium butternut squash (peeled, cubed)\n •  1 onion (chopped)\n •  2 garlic cloves (minced)\n •  1 carrot (chopped)\n •  3 cups vegetable broth\n •  1 tbsp olive oil\n •  1/2 cup coconut milk or cream (optional)\n •  Salt & pepper to taste\n\nInstructions:\n\n1. Heat olive oil in a pot. Sauté onion, garlic, and carrot for 5–6 minutes.\n2. Add squash cubes and cook 5 more minutes.\n3. Pour in vegetable broth. Bring to a boil, then simmer for 20 minutes.\n4. Blend the soup until smooth using a blender.\n5. Stir in coconut milk (optional), season with salt and pepper.\n6. Serve warm. You can top with pumpkin seeds or fresh herbs.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe3.png?alt=media&token=e27bdcf7-7cde-4f28-80eb-3b7b84d7ab68',
      'tags': [
        'Dinner',
        '400-500 kcal',
        'Low Calorie',
        'Lunch',
        'Soup',
        'Vegetarian'
      ],
      'cook_time': 55,
      'kcal': 434,
    },
    {
      'title': 'Buttermilk Mango Shake',
      'description':
          'A refreshing and tangy Indian summer drink made with ripe mangoes and buttermilk. It\'s light, healthy, and perfect for cooling down on hot days.',
      'content':
          'Ingredients:\n\n •  1 ripe mango (peeled and chopped)\n •  1 cup buttermilk (chilled)\n •  1–2 tsp sugar (optional)\n •  A pinch of salt\n •  Ice cubes (optional)\n •  Mint leaves (for garnish, optional)\n\nInstructions:\n\n •  Add mango, buttermilk, sugar, and salt to a blender.\n •  Blend until smooth and creamy.\n •  Pour into a glass, add ice cubes if desired.\n •  Garnish with mint and serve chilled.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe4.png?alt=media&token=2c0498fe-dc71-4cda-9164-ac611eb0fc57',
      'tags': [
        'Breakfast',
        '100-200 kcal',
        'Low Calorie',
        'Low Fat',
        'Shake',
        'Vegetarian'
      ],
      'cook_time': 3,
      'kcal': 99,
    },
    {
      'title': 'Surimi Salad',
      'description':
          'A light, refreshing salad made with imitation crab sticks (surimi), perfect as an appetizer or quick meal. It\'s creamy, crunchy, and super easy to prepare.',
      'content':
          'Ingredients:\n\n •  200 g surimi (imitation crab sticks)\n •  2 boiled eggs\n •  1 small cucumber (or pickles)\n •  1 small can of sweet corn (optional)\n •  2 tbsp mayonnaise\n •  Salt and pepper to taste\n\nInstructions:\n\n •  Cut surimi, eggs, and cucumber into small cubes.\n •  Drain the corn and add it in (if using).\n •  Mix everything in a bowl.\n •  Add mayonnaise, salt, and pepper. Stir well.\n •  Chill for 15–20 minutes before serving (optional).',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe5.png?alt=media&token=80d7b3b5-f8cb-433c-b379-dd374076988b',
      'tags': ['Dinner', '300-400 kcal Lunch', 'Salad', 'Vegetables'],
      'cook_time': 15,
      'kcal': 310,
    },
    {
      'title': 'Classic Caesar Salad',
      'description':
          'A timeless salad made with crisp romaine lettuce, creamy dressing, crunchy croutons, and parmesan cheese. Perfect as a starter or light meal.',
      'content':
          'Ingredients:\n\n •  1 large romaine lettuce (chopped)\n •  1/2 cup Caesar dressing\n •  1 cup croutons\n •  1/4 cup grated parmesan cheese\n •  Salt and black pepper to taste\n •  (Optional: grilled chicken, anchovies)\n\nInstructions:\n\n •  Wash and dry the romaine lettuce.\n •  In a large bowl, toss the lettuce with Caesar dressing.\n •  Add croutons and parmesan cheese.\n •  Season with salt and pepper.\n •  Serve immediately. Optional: top with grilled chicken or anchovies.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe6.png?alt=media&token=609745f9-d294-409a-888a-fdb4474f85b8',
      'tags': ['Dinner', '300-400 kcal', 'Low Carb', 'Lunch', 'Salad'],
      'cook_time': 15,
      'kcal': 308,
    },
    {
      'title': 'Semolina Casserole',
      'description':
          'A simple and delicious dessert made with semolina, milk, and a touch of sweetness. It\'s soft, creamy, and perfect for breakfast or tea time.',
      'content':
          'Ingredients:\n\n •  1 cup semolina\n •  3 cups milk\n •  1/2 cup sugar\n •  2 tbsp butter\n •  1 tsp vanilla extract (optional)\n •  A pinch of salt\n •  Cinnamon or nuts for topping (optional)\n\nInstructions:\n\n •  In a pot, heat the milk with sugar, salt, and butter.\n •  Once warm, slowly add semolina while stirring constantly.\n •  Cook on low heat, stirring until it thickens (about 5–7 minutes).\n •  Add vanilla, mix well.\n •  Pour the mixture into a greased baking dish.\n •  Bake at 180°C (350°F) for 20–25 minutes until golden on top.\n •  Let it cool, then cut and serve with cinnamon or nuts if desired.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe7.png?alt=media&token=0eedb004-1b6b-48cb-98c8-d6f45e964028',
      'tags': ['Breakfast', 'Dessert', '300-400 kcal', 'Low Fat', 'Vegetarian'],
      'cook_time': 49,
      'kcal': 352,
    },
    {
      'title': 'Sweet Potato Chips',
      'description':
          'Crunchy, slightly sweet, and healthier than regular chips — these sweet potato chips make a perfect snack or side dish.',
      'content':
          'Ingredients:\n\n •  2 medium sweet potatoes\n •  2 tbsp olive oil\n •  Salt to taste\n •  Optional: paprika, garlic powder, or rosemary\n\nInstructions:\n\n •  Preheat oven to 200°C (400°F).\n •  Wash and thinly slice sweet potatoes (use a mandoline if possible).\n •  Toss slices with olive oil and seasonings.\n •  Spread in a single layer on a baking sheet.\n •  Bake for 15–20 minutes, flipping halfway, until crisp and golden.\n •  Cool slightly and enjoy!',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe8.png?alt=media&token=3f230e57-8103-4ab2-9248-7556a50c8d4b',
      'tags': ['Snack', 'Sugar Free', 'Vegan', 'Vegetarian'],
      'cook_time': 32,
      'kcal': 301,
    },
    {
      'title': 'Lasagne Soup',
      'description':
          'Lasagne Soup is a cozy, one-pot version of classic lasagna. It has all the flavors of the traditional dish—meaty tomato sauce, pasta, and cheese but in a warm, comforting soup form.',
      'content':
          'Ingredients:\n\n •  1 tbsp olive oil\n •  1 onion, chopped\n •  2 garlic cloves, minced\n •  300g ground beef (or sausage)\n •  1 can (400g) crushed tomatoes\n •  1 tbsp tomato paste\n •  4 cups beef or vegetable broth\n •  1 tsp Italian seasoning\n •  Salt and pepper to taste\n •  6 lasagna noodles, broken into pieces\n •  100g mozzarella, shredded\n •  100g ricotta (optional)\n •  Fresh basil (for garnish)\n\nInstructions:\n\n •  Heat olive oil in a pot, sauté onion and garlic.\n •  Add ground beef, cook until browned.\n •  Stir in tomato paste, crushed tomatoes, broth, and seasoning.\n •  Bring to a boil, add broken noodles.\n •  Simmer 10–15 minutes, until noodles are tender.\n •  Serve hot with mozzarella, a spoon of ricotta, and fresh basil on top.',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe9%20(1).png?alt=media&token=7fc442fa-80c1-4cfb-a7df-f319bfaa16bb',
      'tags': [
        'Dinner',
        '200-300 kcal',
        'Low Calorie',
        'Low Fat',
        'Lunch',
        'Soup',
        'Vegan',
        'Vegetarian'
      ],
      'cook_time': 35,
      'kcal': 272,
    },
  ];

  print('📦 Preparing to upload ${recipes.length} recipes...\n');

  int successCount = 0;
  int errorCount = 0;

  for (var i = 0; i < recipes.length; i++) {
    final recipe = recipes[i];
    try {
      print(
          '⏳ Uploading recipe ${i + 1}/${recipes.length}: ${recipe['title']}');

      // Parse content to extract ingredients and instructions
      final content = recipe['content'] as String;
      final parts = content.split('Instructions:');
      final ingredientsPart = parts[0].replaceAll('Ingredients:', '').trim();
      final instructionsPart = parts.length > 1 ? parts[1].trim() : '';

      // Convert to arrays
      final ingredients = ingredientsPart
          .split('\n')
          .where((line) => line.trim().isNotEmpty && line.trim() != '•')
          .map((line) => line.trim().replaceFirst(RegExp(r'^•\s*'), ''))
          .toList();

      final instructions = instructionsPart
          .split('\n')
          .where((line) => line.trim().isNotEmpty && line.trim() != '•')
          .map((line) => line
              .trim()
              .replaceFirst(RegExp(r'^•\s*'), '')
              .replaceFirst(RegExp(r'^\d+\.\s*'), ''))
          .toList();

      // Prepare Firestore document
      final recipeData = {
        'name': recipe['title'],
        'description': recipe['description'],
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': recipe['image'],
        'calories': recipe['kcal'],
        'protein': 0.0, // Not available in hardcoded data
        'carbs': 0.0, // Not available in hardcoded data
        'fat': 0.0, // Not available in hardcoded data
        'dietCategories': recipe['tags'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Upload to Firestore
      await recipesCollection.add(recipeData);

      successCount++;
      print('   ✅ Successfully uploaded: ${recipe['title']}\n');
    } catch (e) {
      errorCount++;
      print('   ❌ Error uploading ${recipe['title']}: $e\n');
    }
  }

  print('\n' + '=' * 50);
  print('📊 Upload Summary:');
  print('   ✅ Successful: $successCount');
  print('   ❌ Failed: $errorCount');
  print('   📦 Total: ${recipes.length}');
  print('=' * 50);

  exit(0);
}
