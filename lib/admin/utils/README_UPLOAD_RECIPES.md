# Upload Hardcoded Recipes to Firebase

This utility uploads the 10 hardcoded recipes from `lib/app_state.dart` to the Firebase `recipes` collection.

## How to Use

### Option 1: Add a Button to Admin Panel (Recommended)

1. Open `lib/admin/pages/recipe_management_page.dart`
2. Add an import at the top:
   ```dart
   import '../utils/upload_hardcoded_recipes.dart';
   ```
3. Add a button in the header section (around line 56, next to "Add Recipe" button):
   ```dart
   ElevatedButton(
     onPressed: () async {
       final result = await uploadHardcodedRecipes();
       if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(
               'Upload complete! Success: ${result['success']}, Errors: ${result['errors']}',
             ),
           ),
         );
       }
     },
     style: ElevatedButton.styleFrom(
       backgroundColor: Colors.green,
     ),
     child: const Row(
       mainAxisSize: MainAxisSize.min,
       children: [
         Icon(Icons.upload_rounded, size: 20),
         SizedBox(width: 8),
         Text('Upload Hardcoded Recipes'),
       ],
     ),
   ),
   ```

### Option 2: Run from Flutter DevTools Console

1. Run your app in debug mode
2. Open Flutter DevTools
3. Go to the Console tab
4. Import and run:
   ```dart
   import 'package:eat_wise/admin/utils/upload_hardcoded_recipes.dart';
   uploadHardcodedRecipes().then((result) => print(result));
   ```

## What It Does

The script:
1. Takes all 10 hardcoded recipes from `lib/app_state.dart` (lines 634-655)
2. Parses the `content` field to extract:
   - **Ingredients**: Converted to an array of strings
   - **Instructions**: Converted to an array of strings
3. Maps the data to match the Firestore `recipes` collection schema:
   - `title` → `name`
   - `description` → `description`
   - `content` → parsed into `ingredients` and `instructions` arrays
   - `image` → `imageUrl`
   - `tags` → `dietCategories`
   - `kcal` → `calories`
   - Adds `protein`, `carbs`, `fat` as 0.0 (not available in hardcoded data)
   - Adds `createdAt` and `updatedAt` timestamps
4. Uploads each recipe to Firestore
5. Returns a summary with success/error counts

## Recipes Included

1. Neapolitan-Style Margherita Pizza (567 kcal)
2. Marinated zucchini with hazelnuts and ricotta (752 kcal)
3. Watermelon Smoothie with Basil & Mint (345 kcal)
4. Vegetarian Butternut Squash Soup (434 kcal)
5. Buttermilk Mango Shake (99 kcal)
6. Surimi Salad (310 kcal)
7. Classic Caesar Salad (308 kcal)
8. Semolina Casserole (352 kcal)
9. Sweet Potato Chips (301 kcal)
10. Lasagne Soup (272 kcal)

## Important Notes

- **Run this only once** to avoid duplicate recipes
- Firebase must be initialized before calling this function
- The function returns a Map with:
  - `success`: Number of successfully uploaded recipes
  - `errors`: Number of failed uploads
  - `total`: Total number of recipes
  - `errorDetails`: List of error messages (if any)
- After uploading, you can edit/delete recipes from the admin panel
- The hardcoded recipes in `lib/app_state.dart` can be removed after successful upload

## Troubleshooting

If you encounter errors:
1. Check Firebase connection
2. Verify Firestore security rules allow writes to `recipes` collection
3. Check the `errorDetails` in the returned result for specific error messages

