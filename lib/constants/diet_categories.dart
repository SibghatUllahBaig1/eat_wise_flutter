/// Diet categories for recipe filtering
class DietCategories {
  static const List<Map<String, String>> categories = [
    {'emoji': '🌱', 'name': 'Vegan Diet', 'key': 'vegan'},
    {'emoji': '🥗', 'name': 'Vegetarian Diet', 'key': 'vegetarian'},
    {'emoji': '🌿', 'name': 'Plant-Based Diet', 'key': 'plant_based'},
    {'emoji': '🤏', 'name': 'Flexitarian Diet', 'key': 'flexitarian'},
    {'emoji': '🐟', 'name': 'Pescatarian Diet', 'key': 'pescatarian'},
    {'emoji': '🥩', 'name': 'Low-Carb Diet', 'key': 'low_carb'},
    {'emoji': '🥑', 'name': 'Keto Ketogenic Diet', 'key': 'keto'},
    {'emoji': '🍖', 'name': 'Carnivore Diet', 'key': 'carnivore'},
    {'emoji': '🌾🚫', 'name': 'Gluten-Free Diet', 'key': 'gluten_free'},
    {'emoji': '🥛🚫', 'name': 'Dairy-Free Diet', 'key': 'dairy_free'},
    {'emoji': '🧼', 'name': 'Clean Eating', 'key': 'clean_eating'},
    {'emoji': '🍎', 'name': 'Whole Foods Diet', 'key': 'whole_foods'},
    {'emoji': '🫒', 'name': 'Mediterranean Diet', 'key': 'mediterranean'},
    {'emoji': '❤️‍🔥', 'name': 'Anti-Inflammatory Diet', 'key': 'anti_inflammatory'},
  ];

  static String getEmojiByKey(String key) {
    final category = categories.firstWhere(
      (cat) => cat['key'] == key,
      orElse: () => {'emoji': '🍽️', 'name': '', 'key': ''},
    );
    return category['emoji'] ?? '🍽️';
  }

  static String getNameByKey(String key) {
    final category = categories.firstWhere(
      (cat) => cat['key'] == key,
      orElse: () => {'emoji': '', 'name': 'Other', 'key': ''},
    );
    return category['name'] ?? 'Other';
  }
}

