import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _dateOfBirth = prefs.containsKey('ff_dateOfBirth')
          ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt('ff_dateOfBirth')!)
          : _dateOfBirth;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_onboardingAnswers')) {
        try {
          final serializedData =
              prefs.getString('ff_onboardingAnswers') ?? '{}';
          _onboardingAnswers =
              AnswersStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _height = prefs.getString('ff_height') ?? _height;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_weight')) {
        try {
          final serializedData = prefs.getString('ff_weight') ?? '{}';
          _weight =
              WeightStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_newWeight')) {
        try {
          final serializedData = prefs.getString('ff_newWeight') ?? '{}';
          _newWeight =
              WeightStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _eventDay = prefs.containsKey('ff_eventDay')
          ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt('ff_eventDay')!)
          : _eventDay;
    });
    _safeInit(() {
      _authenticated = prefs.getBool('ff_authenticated') ?? _authenticated;
    });
    _safeInit(() {
      _NavBar = prefs.getInt('ff_NavBar') ?? _NavBar;
    });
    _safeInit(() {
      _gender = prefs.getString('ff_gender') ?? _gender;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_notification')) {
        try {
          final serializedData = prefs.getString('ff_notification') ?? '{}';
          _notification = NotificationsStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_accountSecurity')) {
        try {
          final serializedData = prefs.getString('ff_accountSecurity') ?? '{}';
          _accountSecurity = AccountSecurityStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _paymentMethods = prefs
              .getStringList('ff_paymentMethods')
              ?.map((x) {
                try {
                  return PaymentMethodStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _paymentMethods;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_defaultPayment')) {
        try {
          final serializedData = prefs.getString('ff_defaultPayment') ?? '{}';
          _defaultPayment = PaymentMethodStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _darkMode = prefs.getString('ff_darkMode') ?? _darkMode;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_selectedLang')) {
        try {
          final serializedData = prefs.getString('ff_selectedLang') ?? '{}';
          _selectedLang =
              LanguageStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _appFoods = prefs
              .getStringList('ff_appFoods')
              ?.map((x) {
                try {
                  return FoodStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _appFoods;
    });
    _safeInit(() {
      _foodType = prefs.getString('ff_foodType') ?? _foodType;
    });
    _safeInit(() {
      _favoritesRecipes = prefs
              .getStringList('ff_favoritesRecipes')
              ?.map((x) {
                try {
                  return RecipesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _favoritesRecipes;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_tracker')) {
        try {
          final serializedData = prefs.getString('ff_tracker') ?? '{}';
          _tracker =
              TrackerStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_trackerSettings')) {
        try {
          final serializedData = prefs.getString('ff_trackerSettings') ?? '{}';
          _trackerSettings = TrackerSettingsStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<GoalsStruct> _goals = [
    GoalsStruct.fromSerializableMap(jsonDecode(
        '{\"goal\":\"🥗 Lose Weight\",\"question1\":\"What is the most important thing for you to keep track of?\",\"answers1\":\"[\\\"🥑 Fats\\\",\\\"🍎 Vitamins\\\",\\\"🪨 Minerals\\\",\\\"💧 Water\\\",\\\"🍗 Squirrels\\\",\\\"🌾 Fiber\\\",\\\"🍞 Carbohydrates\\\",\\\"🍽 Calories\\\"]\",\"question2\":\"How did you find out about Calorio?\",\"answers2\":\"[\\\"📷 Instagram\\\",\\\"📱 Facebook\\\",\\\"🎥 TikTok\\\",\\\"🧑‍🤝‍🧑 Friend or Family\\\",\\\"🔍 Search Engine\\\",\\\"🌐 Website or Blog\\\",\\\"🛒 App Store\\\"]\",\"question3\":\"What’s your gender?\",\"question4\":\"Why do you want to lose weight?\",\"answers4\":\"[\\\"😎 Feel more confident\\\",\\\"❤️ To improve my health\\\",\\\"🏋️‍♀️ Improve overall health\\\",\\\"🎊 Prepare for a special event\\\",\\\"💬 Other\\\"]\",\"question5\":\"Do you have any experience in losing weight?\",\"answers5\":\"[\\\"🍲 Improve your relationship with food\\\",\\\"👨‍🍳 Learn how to cook healthy food\\\",\\\"🍋 Strengthen your immune system\\\",\\\"💤 Sleep better and be more energetic\\\",\\\"🫶 To make me like my body\\\",\\\"💬 Other\\\"]\",\"question6\":\"Do you have any experience in losing weight?\",\"answers6\":\"[\\\"↘️ I\'ve already lost weight, but I want to lose more.\\\",\\\"➡️ My attempts to lose weight were unsuccessful.\\\",\\\"↔️ I lost weight, but the excess weight returned.\\\",\\\"💡 I\'ve never tried to lose weight before.\\\"]\",\"question7\":\"What difficulties have you encountered?\",\"answers7\":\"[\\\"🍟 Strong craving to eat something\\\",\\\"✨ Keeping motivated\\\",\\\"🥙 Reducing portion size\\\",\\\"⏰ Lack of free time\\\",\\\"💬 Other\\\"]\",\"title7\":\"We will help you lose weight.\",\"description7\":\"Losing weight can be difficult, but you are not alone! WE will be with you every step of the way, doing everything to ensure that you achieve your goals.\",\"question8\":\"Why have you gained weight in the past?\",\"answers8\":\"[\\\"🩹 Injury or deterioration of physical health\\\",\\\"💼 Work or personal life\\\",\\\"🔁 Slowing down the metabolism\\\",\\\"🤯 Stress or deterioration of mental health\\\",\\\"💊 Medicines\\\",\\\"💬 Other\\\"]\",\"question9\":\"Remember your previous attempt to lose weight. Has anything changed since then?\",\"question10\":\"What\'s different this time?\",\"answers10\":\"[\\\"🧠 My mindset has changed\\\",\\\"📝 I have a good plan\\\",\\\"🧹 My personal life has changed\\\",\\\"🧘‍♀️ My health has changed\\\",\\\"🚀 I have more motivation\\\",\\\"💬 Other\\\"]\",\"title10\":\"Don\'t stop getting stronger!\",\"description10\":\"There are always ups and downs in life, but you have the strength to see it through. It\'s great that you continue on your way!\",\"question11\":\"Imagine someone who has achieved their goal. What was the key to success?\",\"answers11\":\"[\\\"✊ The inner weakness of the will\\\",\\\"📐 Structure and planning\\\",\\\"🍎 Healthy habits\\\",\\\"🤝 Good support\\\",\\\"❓ I do not know\\\"]\",\"title11\":\"You can too!\",\"description11\":\"Success depends on several factors. Of course, willpower and fortitude are important, but a strong plan and reliable support are absolutely necessary. That\'s exactly what Kalorik gives you.\",\"question12\":\"Have you counted calories before?\",\"title12\":\"Super! It\'s a great start.\",\"description12\":\"Studies have proven a direct link between regular calorie counting and motivation for successful weight loss!\",\"question13\":\"How did you count calories before?\",\"answers13\":\"[\\\"📱 Using the app\\\",\\\"🖥 On the website\\\",\\\"✏️ By hand on paper\\\",\\\"🔢 In the spreadsheet\\\",\\\"📟 Using a calculator\\\",\\\"🧠 Counting in the mind\\\",\\\"💬 Other\\\"]\",\"question14\":\"Which app did you use?\",\"answers14\":\"[\\\"🔶 Kalorik\\\",\\\"🔷 Lifesum\\\",\\\"🔷 MyFitnessPal\\\",\\\"🔷 Yazio\\\",\\\"🔷 Loselt!\\\",\\\"🔷 WW (Weight Watchers)\\\",\\\"🔷 Noom\\\",\\\"🔷 FatSecret\\\",\\\"💬 Other\\\"]\",\"question15\":\"When you were keeping track of calories, was it difficult to stick to a daily calorie goal?\",\"question16\":\"Would you like to learn a little more about how calorie counting works?\",\"title16\":\"It\'s really simple.\",\"description16\":\"The whole point is to consume fewer calories than you expend. In order to lose weight without harm to health and so that the weight does not return, the calorie deficit should be small - this way the body will receive enough nutrients. Don\'t be afraid, we will guide you every step of the way!\",\"question17\":\"Have you tried intermittent fasting?\",\"answers17\":\"[\\\"🤩 Yes, I liked it\\\",\\\"🤔 Yes, but it\'s not for me\\\",\\\"🙋‍♂️ No, but I\'d like to try\\\",\\\"🙅‍♀️ No, I\'m not interested in that\\\",\\\"❓ What is intermittent fasting?\\\"]\",\"title17\":\"The structure of meals matters\",\"description17\":\"Intermittent fasting is a dietary pattern where periods of fasting alternate with periods of habitual eating. It has been proven to control weight, promote weight loss, and help in the fight against certain diseases.\",\"question18\":\"Do you want to try intermittent fasting?\",\"title18\":\"Meet the dream team\",\"description18\":\"Calorie counting and intermittent fasting together have a great effect. Calorio has a fasting tracker and a multifunctional calorie counter, so it will be much easier to form healthy habits.\",\"question19\":\"How do you plan to stay on track?\",\"answers19\":\"[\\\"🍎 I will add all the dishes to my diary before eating.\\\",\\\"👫 I\'m going to find a reliable like-minded person.\\\",\\\"🍱 I will use the recipes and plan ahead.\\\",\\\"🔥 I plan to use the activity counter as much as possible.\\\",\\\"👀 I\'m going to monitor my calorie intake.\\\",\\\"🤷 Don\'t know yet\\\"]\",\"question20\":\"What emotions do you feel at the beginning of the journey?\",\"answers20\":\"[\\\"🤩 Motivation\\\",\\\"😎 Confidence\\\",\\\"😰 Nervousness\\\",\\\"😔 Disappointment\\\",\\\"😴 Without motivation\\\",\\\"😶 I don\'t know\\\"]\",\"question21\":\"Imagine that you have reached your goal. What inspires you most about yourself?\",\"answers21\":\"[\\\"🚀 Live a healthier and more energetic life\\\",\\\"🌟 To feel self-confidence and pride\\\",\\\"👖 Be able to wear clothes that you like\\\",\\\"📏 See the difference in your body size\\\",\\\"💪 Be in the best physical shape\\\",\\\"💬 Other\\\"]\",\"title21\":\"Remember when you achieved some difficult goal.\",\"description21\":\"How did you overcome difficulties and how did you feel about it? Remember your achievements whenever you need motivation. You know you can!\",\"question22\":\"How active are you?\",\"answers22\":\"[\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"👨‍💻 Slightly active\\\\\\\",\\\\\\\"description\\\\\\\":\\\\\\\"Sedentary work, for example, office worker\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"🧑‍🏫 Moderately active\\\\\\\",\\\\\\\"description\\\\\\\":\\\\\\\"Stand-up work, for example, as a teacher\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"🤵 Active\\\\\\\",\\\\\\\"description\\\\\\\":\\\\\\\"A walking job, for example, a salesman\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"👷‍♂️ Very active\\\\\\\",\\\\\\\"description\\\\\\\":\\\\\\\"Physical work, for example, construction\\\\\\\"}\\\"]\",\"description22\":\"The level of your daily activity will help you calculate your calorie requirement more accurately.\",\"question23\":\"Are you expecting an event that will motivate you to lose weight?\",\"answers23\":\"[\\\"⛱ Vacation\\\",\\\"💍 Wedding\\\",\\\"🏆 Sports competitions\\\",\\\"☀️ Summer\\\",\\\"👨‍👩‍👦‍👦 Meeting with family or friends\\\",\\\"💬 Other\\\",\\\"🗓 There is no special event\\\"]\",\"question25\":\"How many minutes a day do you plan to use Kalorik?\",\"answers25\":\"[\\\"🦦 5 minutes / day (rare)\\\",\\\"🐇 10 minutes / day (regularly)\\\",\\\"🦘 15 minutes / day (seriously)\\\",\\\"🐆 30 minutes / day (intensive)\\\"]\",\"question26\":\"The test of time. How many consecutive days can you monitor your meals?\",\"answers26\":\"[\\\"🚀 50 days in a row (perfectly)\\\",\\\"🚄 30 days in a row (incredible)\\\",\\\"🚲 14 days in a row (excellent)\\\",\\\"👟 7 days in a row (good)\\\"]\",\"question27\":\"Do you want to stick to a certain type of diet?\",\"description27\":\"Recommendations will be selected according to your preferences.\",\"answers27\":\"[\\\"🍗 Classic\\\",\\\"🐟 Pescetarianism\\\",\\\"🧀 Vegetarianism\\\",\\\"🌱 Veganism\\\"]\",\"question28\":\"What can you do to improve your eating and health?\",\"question29\":\"What usually makes you eat even when you\'re not hungry?\",\"answers29\":\"[\\\"🍕 Being near food\\\",\\\"💤 Boredom\\\",\\\"👀 Watching other people eat\\\",\\\"💬 Other\\\"]\",\"question30\":\"What can you do to improve your eating and health?\",\"answers30\":\"[\\\"🧘 Be more aware of your food choices\\\",\\\"🥒 Eat more fruits and vegetables\\\",\\\"💧 Drink more water\\\",\\\"📚 Learn more about nutrition and health\\\",\\\"🍱 Pay attention to hunger and portion size\\\"]\",\"question31\":\"How do you plan to achieve regularity in keeping a food diary?\",\"answers31\":\"[\\\"🥘 Add dishes to your diary before meals\\\",\\\"🍽 Add what you eat immediately after eating\\\",\\\"☀️ First thing in the morning, add all the dishes for the day\\\",\\\"🌙 Add all the dishes at the end of the day\\\",\\\"❓ I don\'t know yet\\\"]\",\"question32\":\"What will you do to increase your activity level?\",\"answers32\":\"[\\\"🏄 Try new types of physical activity\\\",\\\"🏁 I will fulfill the daily goal of the number of steps\\\",\\\"🚶‍♀️ I\'d rather walk instead of driving\\\",\\\"🏋️‍♀️ I will add a new type of training\\\",\\\"⏰ I\'ll set aside some time for training\\\"]\",\"question33\":\"How do you plan to define your achievements?\",\"answers33\":\"[\\\"📝 Check your weight regularly\\\",\\\"📏 Track body volume\\\",\\\"📱 Track your health indicators using a fitness app\\\",\\\"⚡️ Monitor changes in energy levels\\\",\\\"👕 Compare how clothes fit now and before\\\",\\\"💬 Other\\\"]\",\"question34\":\"There are many achievements waiting for you. How will you celebrate them?\",\"answers34\":\"[\\\"🛍 I\'ll buy new clothes\\\",\\\"🎒 Going on a trip\\\",\\\"💆‍♀️ I\'ll spend the day at the spa\\\",\\\"🥂 I\'ll celebrate with my friends\\\",\\\"💬 Other\\\"]\",\"question35\":\"Do you have children?\",\"answers35\":\"[\\\"👍 Yes, we live together.\\\",\\\"👆 Yes, but we live separately.\\\",\\\"👎 No, I don\'t have any children.\\\"]\",\"question36\":\"What is your work schedule?\",\"answers36\":\"[\\\"🧘 I have a free schedule\\\",\\\"⏰ I work from nine to six\\\",\\\"🗓 I work in shifts\\\",\\\"🌴 I have a seasonal job\\\",\\\"💬 Other\\\"]\",\"question37\":\"How would you describe the eating habits of the people you spend most of your time with?\",\"answers37\":\"[\\\"🥇 They eat healthy food regularly.\\\",\\\"🥈 They eat healthy food from time to time.\\\",\\\"🥉 They mostly eat unhealthy food.\\\",\\\"❓ I don\'t know.\\\"]\",\"answers38\":\"[]\"}')),
    GoalsStruct.fromSerializableMap(
        jsonDecode('{\"goal\":\"💪 Gain Muscle\"}')),
    GoalsStruct.fromSerializableMap(
        jsonDecode('{\"goal\":\"⚖️ Maintain Weight\"}')),
    GoalsStruct.fromSerializableMap(
        jsonDecode('{\"goal\":\"🥦 Eat Healthier\"}')),
    GoalsStruct.fromSerializableMap(
        jsonDecode('{\"goal\":\"🔋 Boost Energy\"}')),
    GoalsStruct.fromSerializableMap(
        jsonDecode('{\"goal\":\"🧘 Improve Wellness\"}'))
  ];
  List<GoalsStruct> get goals => _goals;
  set goals(List<GoalsStruct> value) {
    _goals = value;
  }

  void addToGoals(GoalsStruct value) {
    goals.add(value);
  }

  void removeFromGoals(GoalsStruct value) {
    goals.remove(value);
  }

  void removeAtIndexFromGoals(int index) {
    goals.removeAt(index);
  }

  void updateGoalsAtIndex(
    int index,
    GoalsStruct Function(GoalsStruct) updateFn,
  ) {
    goals[index] = updateFn(_goals[index]);
  }

  void insertAtIndexInGoals(int index, GoalsStruct value) {
    goals.insert(index, value);
  }

  DateTime? _dateOfBirth = DateTime.fromMillisecondsSinceEpoch(1240385100000);
  DateTime? get dateOfBirth => _dateOfBirth;
  set dateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    value != null
        ? prefs.setInt('ff_dateOfBirth', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dateOfBirth');
  }

  List<OnboardingReviewsStruct> _onboardingReview = [
    OnboardingReviewsStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Adam, 24 years old\",\"content\":\"\\\"The best calorie counting app! Clear and easy to use!\\\"\"}')),
    OnboardingReviewsStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Chris, 53 years old\",\"content\":\"\\\"The Kalorik app helped me stop being lazy and lose 16 kg of weight!\\\"\"}')),
    OnboardingReviewsStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Louis, 37 years old\",\"content\":\"\\\"I recommend this app! It helps you lose weight quickly and without harm to your health.!\\\"\"}'))
  ];
  List<OnboardingReviewsStruct> get onboardingReview => _onboardingReview;
  set onboardingReview(List<OnboardingReviewsStruct> value) {
    _onboardingReview = value;
  }

  void addToOnboardingReview(OnboardingReviewsStruct value) {
    onboardingReview.add(value);
  }

  void removeFromOnboardingReview(OnboardingReviewsStruct value) {
    onboardingReview.remove(value);
  }

  void removeAtIndexFromOnboardingReview(int index) {
    onboardingReview.removeAt(index);
  }

  void updateOnboardingReviewAtIndex(
    int index,
    OnboardingReviewsStruct Function(OnboardingReviewsStruct) updateFn,
  ) {
    onboardingReview[index] = updateFn(_onboardingReview[index]);
  }

  void insertAtIndexInOnboardingReview(
      int index, OnboardingReviewsStruct value) {
    onboardingReview.insert(index, value);
  }

  AnswersStruct _onboardingAnswers = AnswersStruct.fromSerializableMap(jsonDecode(
      '{\"answers1\":\"[]\",\"answer5\":\"[]\",\"answers7\":\"[]\",\"answers19\":\"[]\",\"date_of_birth\":\"1240385100000\",\"answers30\":\"[]\",\"answers32\":\"[]\",\"answers34\":\"[]\"}'));
  AnswersStruct get onboardingAnswers => _onboardingAnswers;
  set onboardingAnswers(AnswersStruct value) {
    _onboardingAnswers = value;
    prefs.setString('ff_onboardingAnswers', value.serialize());
  }

  void updateOnboardingAnswersStruct(Function(AnswersStruct) updateFn) {
    updateFn(_onboardingAnswers);
    prefs.setString('ff_onboardingAnswers', _onboardingAnswers.serialize());
  }

  String _height = '';
  String get height => _height;
  set height(String value) {
    _height = value;
    prefs.setString('ff_height', value);
  }

  WeightStruct _weight = WeightStruct.fromSerializableMap(
      jsonDecode('{\"unit\":\"kg\",\"value\":\"70.0\"}'));
  WeightStruct get weight => _weight;
  set weight(WeightStruct value) {
    _weight = value;
    prefs.setString('ff_weight', value.serialize());
  }

  void updateWeightStruct(Function(WeightStruct) updateFn) {
    updateFn(_weight);
    prefs.setString('ff_weight', _weight.serialize());
  }

  WeightStruct _newWeight = WeightStruct.fromSerializableMap(
      jsonDecode('{\"unit\":\"kg\",\"value\":\"60.0\"}'));
  WeightStruct get newWeight => _newWeight;
  set newWeight(WeightStruct value) {
    _newWeight = value;
    prefs.setString('ff_newWeight', value.serialize());
  }

  void updateNewWeightStruct(Function(WeightStruct) updateFn) {
    updateFn(_newWeight);
    prefs.setString('ff_newWeight', _newWeight.serialize());
  }

  DateTime? _eventDay = DateTime.fromMillisecondsSinceEpoch(1271919600000);
  DateTime? get eventDay => _eventDay;
  set eventDay(DateTime? value) {
    _eventDay = value;
    value != null
        ? prefs.setInt('ff_eventDay', value.millisecondsSinceEpoch)
        : prefs.remove('ff_eventDay');
  }

  bool _authenticated = false;
  bool get authenticated => _authenticated;
  set authenticated(bool value) {
    _authenticated = value;
    prefs.setBool('ff_authenticated', value);
  }

  int _NavBar = 0;
  int get NavBar => _NavBar;
  set NavBar(int value) {
    _NavBar = value;
    prefs.setInt('ff_NavBar', value);
  }

  String _gender = 'Male';
  String get gender => _gender;
  set gender(String value) {
    _gender = value;
    prefs.setString('ff_gender', value);
  }

  NotificationsStruct _notification = NotificationsStruct.fromSerializableMap(
      jsonDecode(
          '{\"mealtime\":\"true\",\"breakfast\":\"1745467200000\",\"lunch\":\"1745481600000\",\"supper\":\"1745503200000\",\"snack\":\"1745488800000\",\"water\":\"true\",\"checkYourProgress\":\"true\",\"dayOfTheWeek\":\"[\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Monday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Mo\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Tuesday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Tu\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Wednesday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"We\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Thursday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Th\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Friday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Fr\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Saturday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Sa\\\\\\\"}\\\",\\\"{\\\\\\\"day\\\\\\\":\\\\\\\"Sunday\\\\\\\",\\\\\\\"abbreviated\\\\\\\":\\\\\\\"Su\\\\\\\"}\\\"]\",\"time\":\"1745460000000\",\"fastingTime\":\"true\",\"stagesOfFasting\":\"true\",\"coachsAdvice\":\"true\"}'));
  NotificationsStruct get notification => _notification;
  set notification(NotificationsStruct value) {
    _notification = value;
    prefs.setString('ff_notification', value.serialize());
  }

  void updateNotificationStruct(Function(NotificationsStruct) updateFn) {
    updateFn(_notification);
    prefs.setString('ff_notification', _notification.serialize());
  }

  List<DayOfTheWeekStruct> _Dayoftheweek = [
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Monday\",\"abbreviated\":\"Mo\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Tuesday\",\"abbreviated\":\"Tu\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Wednesday\",\"abbreviated\":\"We\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Thursday\",\"abbreviated\":\"Th\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Friday\",\"abbreviated\":\"Fr\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Saturday\",\"abbreviated\":\"Sa\"}')),
    DayOfTheWeekStruct.fromSerializableMap(
        jsonDecode('{\"day\":\"Sunday\",\"abbreviated\":\"Su\"}'))
  ];
  List<DayOfTheWeekStruct> get Dayoftheweek => _Dayoftheweek;
  set Dayoftheweek(List<DayOfTheWeekStruct> value) {
    _Dayoftheweek = value;
  }

  void addToDayoftheweek(DayOfTheWeekStruct value) {
    Dayoftheweek.add(value);
  }

  void removeFromDayoftheweek(DayOfTheWeekStruct value) {
    Dayoftheweek.remove(value);
  }

  void removeAtIndexFromDayoftheweek(int index) {
    Dayoftheweek.removeAt(index);
  }

  void updateDayoftheweekAtIndex(
    int index,
    DayOfTheWeekStruct Function(DayOfTheWeekStruct) updateFn,
  ) {
    Dayoftheweek[index] = updateFn(_Dayoftheweek[index]);
  }

  void insertAtIndexInDayoftheweek(int index, DayOfTheWeekStruct value) {
    Dayoftheweek.insert(index, value);
  }

  AccountSecurityStruct _accountSecurity =
      AccountSecurityStruct.fromSerializableMap(jsonDecode(
          '{\"biometric_id\":\"true\",\"face_id\":\"true\",\"sms_authenticator\":\"true\",\"google_authenticator\":\"true\"}'));
  AccountSecurityStruct get accountSecurity => _accountSecurity;
  set accountSecurity(AccountSecurityStruct value) {
    _accountSecurity = value;
    prefs.setString('ff_accountSecurity', value.serialize());
  }

  void updateAccountSecurityStruct(Function(AccountSecurityStruct) updateFn) {
    updateFn(_accountSecurity);
    prefs.setString('ff_accountSecurity', _accountSecurity.serialize());
  }

  List<PaymentMethodStruct> _paymentMethods = [
    PaymentMethodStruct.fromSerializableMap(jsonDecode(
        '{\"card_number\":\"5466 1234 1234 1234\",\"card_holder\":\"Alex Johnson\",\"expire_date\":\"05/30\",\"cvc\":\"321\",\"card_nickname\":\"\",\"type\":\"Mastercard\"}')),
    PaymentMethodStruct.fromSerializableMap(jsonDecode(
        '{\"card_number\":\"4293 0000 0000 0000\",\"card_holder\":\"Alex Johnson\",\"expire_date\":\"03/21\",\"cvc\":\"123\",\"card_nickname\":\"\",\"type\":\"Visa\"}')),
    PaymentMethodStruct.fromSerializableMap(jsonDecode(
        '{\"card_number\":\"6011 5465 4646 4984\",\"card_holder\":\"Alex Johnson\",\"expire_date\":\"05/11\",\"cvc\":\"464\",\"card_nickname\":\"\",\"type\":\"Discover\"}'))
  ];
  List<PaymentMethodStruct> get paymentMethods => _paymentMethods;
  set paymentMethods(List<PaymentMethodStruct> value) {
    _paymentMethods = value;
    prefs.setStringList(
        'ff_paymentMethods', value.map((x) => x.serialize()).toList());
  }

  void addToPaymentMethods(PaymentMethodStruct value) {
    paymentMethods.add(value);
    prefs.setStringList('ff_paymentMethods',
        _paymentMethods.map((x) => x.serialize()).toList());
  }

  void removeFromPaymentMethods(PaymentMethodStruct value) {
    paymentMethods.remove(value);
    prefs.setStringList('ff_paymentMethods',
        _paymentMethods.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromPaymentMethods(int index) {
    paymentMethods.removeAt(index);
    prefs.setStringList('ff_paymentMethods',
        _paymentMethods.map((x) => x.serialize()).toList());
  }

  void updatePaymentMethodsAtIndex(
    int index,
    PaymentMethodStruct Function(PaymentMethodStruct) updateFn,
  ) {
    paymentMethods[index] = updateFn(_paymentMethods[index]);
    prefs.setStringList('ff_paymentMethods',
        _paymentMethods.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInPaymentMethods(int index, PaymentMethodStruct value) {
    paymentMethods.insert(index, value);
    prefs.setStringList('ff_paymentMethods',
        _paymentMethods.map((x) => x.serialize()).toList());
  }

  PaymentMethodStruct _defaultPayment = PaymentMethodStruct.fromSerializableMap(
      jsonDecode(
          '{\"card_number\":\"5466 1234 1234 1234\",\"card_holder\":\"Alex Johnson\",\"expire_date\":\"05/30\",\"cvc\":\"321\",\"type\":\"Mastercard\"}'));
  PaymentMethodStruct get defaultPayment => _defaultPayment;
  set defaultPayment(PaymentMethodStruct value) {
    _defaultPayment = value;
    prefs.setString('ff_defaultPayment', value.serialize());
  }

  void updateDefaultPaymentStruct(Function(PaymentMethodStruct) updateFn) {
    updateFn(_defaultPayment);
    prefs.setString('ff_defaultPayment', _defaultPayment.serialize());
  }

  String _darkMode = 'Light';
  String get darkMode => _darkMode;
  set darkMode(String value) {
    _darkMode = value;
    prefs.setString('ff_darkMode', value);
  }

  List<LanguageStruct> _langList = [
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"English\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1\",\"lang_code\":\"en\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Français\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Ffrance.png?alt=media&token=bd059836-7859-43a7-9600-0a0b7855ae80\",\"lang_code\":\"fr\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Deutsch\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgermany.png?alt=media&token=4708d606-97dd-4146-8f99-e73fa6c73ed9\",\"lang_code\":\"de\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Italiano\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fitaly.png?alt=media&token=684ff3e6-b796-40ba-9e42-0fd5f9cc35b6\",\"lang_code\":\"it\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Español\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fspain.png?alt=media&token=18099b94-886f-4fc3-9694-52ad67ecd515\",\"lang_code\":\"es\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Português\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fportugal.png?alt=media&token=b0334855-d95f-4b79-943f-d2e27ae3edba\",\"lang_code\":\"pt\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Русский\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Frussia.png?alt=media&token=b8b096d3-6560-4f5e-ba19-ec49edf9a911\",\"lang_code\":\"ru\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"Türkçe\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fturkey.png?alt=media&token=aa5df5a6-7056-46ce-a74d-7bc4d6558b02\",\"lang_code\":\"tr\"}')),
    LanguageStruct.fromSerializableMap(jsonDecode(
        '{\"language\":\"عربي\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fsaudi_arabia.png?alt=media&token=9ba1c3d7-2c59-490f-8991-99eb6d84f477\",\"lang_code\":\"ar\"}'))
  ];
  List<LanguageStruct> get langList => _langList;
  set langList(List<LanguageStruct> value) {
    _langList = value;
  }

  void addToLangList(LanguageStruct value) {
    langList.add(value);
  }

  void removeFromLangList(LanguageStruct value) {
    langList.remove(value);
  }

  void removeAtIndexFromLangList(int index) {
    langList.removeAt(index);
  }

  void updateLangListAtIndex(
    int index,
    LanguageStruct Function(LanguageStruct) updateFn,
  ) {
    langList[index] = updateFn(_langList[index]);
  }

  void insertAtIndexInLangList(int index, LanguageStruct value) {
    langList.insert(index, value);
  }

  LanguageStruct _selectedLang = LanguageStruct.fromSerializableMap(jsonDecode(
      '{\"language\":\"English\",\"flag\":\"https://firebasestorage.googleapis.com/v0/b/infocus-1903c.firebasestorage.app/o/flags%2Fgreat_britain.png?alt=media&token=4065decd-2928-4f87-ba81-6dabdd17dde1\",\"lang_code\":\"en\"}'));
  LanguageStruct get selectedLang => _selectedLang;
  set selectedLang(LanguageStruct value) {
    _selectedLang = value;
    prefs.setString('ff_selectedLang', value.serialize());
  }

  void updateSelectedLangStruct(Function(LanguageStruct) updateFn) {
    updateFn(_selectedLang);
    prefs.setString('ff_selectedLang', _selectedLang.serialize());
  }

  List<MessageStruct> _support = [
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"Hi! I was wondering — how can I change my main goal in the app?\",\"time_stamp\":\"1745500439467\",\"seen\":\"true\",\"image\":\"\",\"user_message\":\"true\"}')),
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"Hey there! 😊 Sure — you can change your goal anytime. Just go to Profile > Goals > Edit Goal. From there, you can choose a new goal like gaining muscle or maintaining your weight.\",\"time_stamp\":\"1745500560000\",\"seen\":\"true\",\"image\":\"\",\"user_message\":\"false\"}')),
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"Oh perfect, found it! Will the calorie recommendations update automatically?\",\"time_stamp\":\"1745501040000\",\"seen\":\"true\",\"image\":\"\",\"user_message\":\"true\"}')),
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"Yes! Once you save your new goal, we’ll instantly adjust your daily calorie target and nutrient breakdown. 💪\",\"time_stamp\":\"1745501280000\",\"seen\":\"false\",\"image\":\"\",\"user_message\":\"false\"}')),
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"That’s awesome. Thanks so much for the help!\",\"time_stamp\":\"1745501940000\",\"seen\":\"true\",\"image\":\"\",\"user_message\":\"true\"}')),
    MessageStruct.fromSerializableMap(jsonDecode(
        '{\"message\":\"You\'re very welcome! 😊 Let us know if you need anything else. Have a great day on your health journey! 🌱\",\"time_stamp\":\"1745502480000\",\"seen\":\"false\",\"image\":\"\",\"user_message\":\"false\"}'))
  ];
  List<MessageStruct> get support => _support;
  set support(List<MessageStruct> value) {
    _support = value;
  }

  void addToSupport(MessageStruct value) {
    support.add(value);
  }

  void removeFromSupport(MessageStruct value) {
    support.remove(value);
  }

  void removeAtIndexFromSupport(int index) {
    support.removeAt(index);
  }

  void updateSupportAtIndex(
    int index,
    MessageStruct Function(MessageStruct) updateFn,
  ) {
    support[index] = updateFn(_support[index]);
  }

  void insertAtIndexInSupport(int index, MessageStruct value) {
    support.insert(index, value);
  }

  List<RecipesStruct> _recipes = [
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Neapolitan-Style Margherita Pizza\",\"content\":\"Ingredients:\\n\\n •  250 g (about 2 cups) all-purpose flour\\n •  160 ml (2/3 cup) warm water\\n •  1/2 tsp salt\\n •  1/4 tsp dry yeast\\n •  2 tbsp olive oil\\n •  100 g fresh mozzarella\\n •  4 tbsp crushed tomatoes or pizza sauce\\n •  Fresh basil leaves\\n •  Olive oil (for drizzling)\\n\\nInstructions:\\n\\n •  Make the dough: Mix flour, salt, yeast, and water. Knead for 8–10 min until smooth. Cover and let it rise for 1–2 hours.\\n •  Preheat oven: Heat to the highest setting (250–300°C / 480–570°F) with a pizza stone or baking tray inside.\\n •  Shape the dough: Stretch the dough into a thin circle (about 10–12 inches).\\n •  Add toppings: Spread tomato sauce, tear mozzarella on top, and add fresh basil.\\n •  Bake: Place pizza on hot stone/tray. Bake for 7–9 minutes until crust is golden and cheese is bubbling.\\n •  Finish: Drizzle with olive oil and serve hot.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/articles%2FMargherita%20Pizza.jpg?alt=media&token=554d8b4e-f983-433e-8162-966b2ef326ce\",\"tags\":\"[\\\"Dinner\\\",\\\"High Fiber\\\",\\\"500-600 kcal\\\",\\\"Lunch\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"85\",\"created_at\":\"1745833680000\",\"kcal\":\"567\",\"description\":\"The Neapolitan Margherita Pizza is a classic Italian dish originating from Naples. It features a thin, soft, and slightly chewy crust, topped with simple, high-quality ingredients: crushed San Marzano tomatoes, fresh mozzarella, fragrant basil, and a drizzle of extra virgin olive oil. It’s the essence of Italian cuisine simple, fresh, and flavorful.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Marinated zucchini with hazelnuts and ricotta\",\"content\":\"Ingredients:\\n\\n •  2 medium zucchinis\\n •  3 tbsp olive oil\\n •  1 tbsp lemon juice\\n •  Salt & black pepper (to taste)\\n •  1/3 cup ricotta cheese\\n •  1/4 cup toasted hazelnuts (chopped)\\n •  Fresh basil or mint leaves (optional)\\n\\nInstructions:\\n\\n •  Slice zucchini into thin ribbons using a peeler or mandoline.\\n •  Mix olive oil, lemon juice, salt, and pepper in a bowl.\\n •  Toss zucchini in the marinade and let sit for 15–20 minutes.\\n •  Arrange zucchini on a plate, dollop ricotta over the top.\\n •  Sprinkle with chopped hazelnuts and fresh herbs if using.\\n •  Serve chilled or at room temperature.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe.png?alt=media&token=c91690dd-35ad-435b-8f45-d90fa7837690\",\"tags\":\"[\\\"Dinner\\\",\\\"700+ kcal\\\",\\\"Lunch\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"45\",\"created_at\":\"1745833680000\",\"kcal\":\"752\",\"description\":\"This light and flavorful dish is perfect as an appetizer or a refreshing side. Thinly sliced zucchini is marinated in a lemony dressing, paired with creamy ricotta, and topped with crunchy toasted hazelnuts. It’s elegant, simple, and full of contrast — a real summer favorite.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Watermelon Smoothie with Basil & Mint\",\"content\":\"Ingredients:\\n\\n •  3 cups fresh watermelon (seedless, cubed)\\n •  1 tablespoon fresh basil leaves (roughly chopped)\\n •  1 tablespoon fresh mint leaves (roughly chopped)\\n •  1/2 cup cold water or coconut water (optional, for thinner consistency)\\n •  1 teaspoon lime juice (optional, for extra zing)\\n •  Ice cubes (as needed)\\n •  Honey or agave syrup (optional, if extra sweetness is desired)\\n\\nInstructions:\\n\\n1. Prepare the ingredients:\\nCut the watermelon into cubes and remove any seeds if necessary. Roughly chop the basil and mint leaves.\\n\\n2. Blend:\\nIn a blender, combine the watermelon, basil, mint, lime juice (if using), and a few ice cubes. Blend until smooth.\\n\\n3. Adjust consistency:\\nIf the smoothie is too thick, add cold water or coconut water and blend again until you reach the desired consistency.\\n\\n4. Taste and sweeten:\\nTaste the smoothie. If you’d like it sweeter, add a little honey or agave syrup and blend briefly.\\n\\n5. Serve:\\nPour into a glass and garnish with a mint or basil leaf for a fresh look. Serve immediately while cold.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe2.png?alt=media&token=7e87f236-7000-49d7-bf50-d4b30ac15d6c\",\"tags\":\"[\\\"Dessert\\\",\\\"300-400 kcal\\\",\\\"Low Calorie\\\",\\\"Low Fat\\\",\\\"Smoothie\\\",\\\"Snack\\\",\\\"Sugar Free\\\",\\\"Vegan\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"7\",\"created_at\":\"1745833680000\",\"kcal\":\"345\",\"description\":\"This refreshing watermelon smoothie is the perfect summer drink — light, hydrating, and packed with flavor. The combination of sweet watermelon, cool mint, and aromatic basil creates a unique taste that is both soothing and revitalizing. It’s naturally sweet, easy to make, and ideal for hot days or a post-workout refreshment.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Vegetarian Butternut Squash Soup\",\"content\":\"Ingredients:\\n\\n •  1 medium butternut squash (peeled, cubed)\\n •  1 onion (chopped)\\n •  2 garlic cloves (minced)\\n •  1 carrot (chopped)\\n •  3 cups vegetable broth\\n •  1 tbsp olive oil\\n •  1/2 cup coconut milk or cream (optional)\\n •  Salt & pepper to taste\\n\\nInstructions:\\n\\n1. Heat olive oil in a pot. Sauté onion, garlic, and carrot for 5–6 minutes.\\n2. Add squash cubes and cook 5 more minutes.\\n3. Pour in vegetable broth. Bring to a boil, then simmer for 20 minutes.\\n4. Blend the soup until smooth using a blender.\\n5. Stir in coconut milk (optional), season with salt and pepper.\\n6. Serve warm. You can top with pumpkin seeds or fresh herbs.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe3.png?alt=media&token=e27bdcf7-7cde-4f28-80eb-3b7b84d7ab68\",\"tags\":\"[\\\"Dinner\\\",\\\"400-500 kcal\\\",\\\"Low Calorie\\\",\\\"Lunch\\\",\\\"Soup\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"55\",\"created_at\":\"1745780400000\",\"kcal\":\"434\",\"description\":\"This cozy and comforting soup is made with roasted butternut squash, aromatic vegetables, and warm spices. It\'s creamy, naturally sweet, and completely vegetarian (and can easily be made vegan). Perfect for chilly days and pairs wonderfully with crusty bread.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Buttermilk Mango Shake\",\"content\":\"Ingredients:\\n\\n •  1 ripe mango (peeled and chopped)\\n •  1 cup buttermilk (chilled)\\n •  1–2 tsp sugar (optional)\\n •  A pinch of salt\\n •  Ice cubes (optional)\\n •  Mint leaves (for garnish, optional)\\n\\nInstructions:\\n\\n •  Add mango, buttermilk, sugar, and salt to a blender.\\n •  Blend until smooth and creamy.\\n •  Pour into a glass, add ice cubes if desired.\\n •  Garnish with mint and serve chilled.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe4.png?alt=media&token=2c0498fe-dc71-4cda-9164-ac611eb0fc57\",\"tags\":\"[\\\"Breakfast\\\",\\\"100-200 kcal\\\",\\\"Low Calorie\\\",\\\"Low Fat\\\",\\\"Shake\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"3\",\"created_at\":\"1745833740000\",\"kcal\":\"99\",\"description\":\"A refreshing and tangy Indian summer drink made with ripe mangoes and buttermilk. It’s light, healthy, and perfect for cooling down on hot days.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Surimi Salad\",\"content\":\"Ingredients:\\n\\n •  200 g surimi (imitation crab sticks)\\n •  2 boiled eggs\\n •  1 small cucumber (or pickles)\\n •  1 small can of sweet corn (optional)\\n •  2 tbsp mayonnaise\\n •  Salt and pepper to taste\\n\\nInstructions:\\n\\n •  Cut surimi, eggs, and cucumber into small cubes.\\n •  Drain the corn and add it in (if using).\\n •  Mix everything in a bowl.\\n •  Add mayonnaise, salt, and pepper. Stir well.\\n •  Chill for 15–20 minutes before serving (optional).\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe5.png?alt=media&token=80d7b3b5-f8cb-433c-b379-dd374076988b\",\"tags\":\"[\\\"Dinner\\\",\\\"300-400 kcal Lunch\\\",\\\"Salad\\\",\\\"Vegetables\\\"]\",\"cook_time\":\"15\",\"created_at\":\"1745833740000\",\"kcal\":\"310\",\"description\":\"A light, refreshing salad made with imitation crab sticks (surimi), perfect as an appetizer or quick meal. It\'s creamy, crunchy, and super easy to prepare.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Classic Caesar Salad\",\"content\":\"Ingredients:\\n\\n •  1 large romaine lettuce (chopped)\\n •  1/2 cup Caesar dressing\\n •  1 cup croutons\\n •  1/4 cup grated parmesan cheese\\n •  Salt and black pepper to taste\\n •  (Optional: grilled chicken, anchovies)\\n\\nInstructions:\\n\\n •  Wash and dry the romaine lettuce.\\n •  In a large bowl, toss the lettuce with Caesar dressing.\\n •  Add croutons and parmesan cheese.\\n •  Season with salt and pepper.\\n •  Serve immediately. Optional: top with grilled chicken or anchovies.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe6.png?alt=media&token=609745f9-d294-409a-888a-fdb4474f85b8\",\"tags\":\"[\\\"Dinner\\\",\\\"300-400 kcal\\\",\\\"Low Carb\\\",\\\"Lunch\\\",\\\"Salad\\\"]\",\"cook_time\":\"15\",\"created_at\":\"1745833740000\",\"kcal\":\"308\",\"description\":\"A timeless salad made with crisp romaine lettuce, creamy dressing, crunchy croutons, and parmesan cheese. Perfect as a starter or light meal.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Semolina Casserole\",\"content\":\"Ingredients:\\n\\n •  1 cup semolina\\n •  3 cups milk\\n •  1/2 cup sugar\\n •  2 tbsp butter\\n •  1 tsp vanilla extract (optional)\\n •  A pinch of salt\\n •  Cinnamon or nuts for topping (optional)\\n\\nInstructions:\\n\\n •  In a pot, heat the milk with sugar, salt, and butter.\\n •  Once warm, slowly add semolina while stirring constantly.\\n •  Cook on low heat, stirring until it thickens (about 5–7 minutes).\\n •  Add vanilla, mix well.\\n •  Pour the mixture into a greased baking dish.\\n •  Bake at 180°C (350°F) for 20–25 minutes until golden on top.\\n •  Let it cool, then cut and serve with cinnamon or nuts if desired.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe7.png?alt=media&token=0eedb004-1b6b-48cb-98c8-d6f45e964028\",\"tags\":\"[\\\"Breakfast\\\",\\\"Dessert\\\",\\\"300-400 kcal\\\",\\\"Low Fat\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"49\",\"created_at\":\"1745833740000\",\"kcal\":\"352\",\"description\":\"A simple and delicious dessert made with semolina, milk, and a touch of sweetness. It’s soft, creamy, and perfect for breakfast or tea time.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Sweet Potato Chips\",\"content\":\"Ingredients:\\n\\n •  2 medium sweet potatoes\\n •  2 tbsp olive oil\\n •  Salt to taste\\n •  Optional: paprika, garlic powder, or rosemary\\n\\nInstructions:\\n\\n •  Preheat oven to 200°C (400°F).\\n •  Wash and thinly slice sweet potatoes (use a mandoline if possible).\\n •  Toss slices with olive oil and seasonings.\\n •  Spread in a single layer on a baking sheet.\\n •  Bake for 15–20 minutes, flipping halfway, until crisp and golden.\\n •  Cool slightly and enjoy!\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe8.png?alt=media&token=3f230e57-8103-4ab2-9248-7556a50c8d4b\",\"tags\":\"[\\\"Snack\\\",\\\"Sugar Free\\\",\\\"Vegan\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"32\",\"created_at\":\"1745833740000\",\"kcal\":\"301\",\"description\":\"Crunchy, slightly sweet, and healthier than regular chips — these sweet potato chips make a perfect snack or side dish.\"}')),
    RecipesStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Lasagne Soup\",\"content\":\"Ingredients:\\n\\n •  1 tbsp olive oil\\n •  1 onion, chopped\\n •  2 garlic cloves, minced\\n •  300g ground beef (or sausage)\\n •  1 can (400g) crushed tomatoes\\n •  1 tbsp tomato paste\\n •  4 cups beef or vegetable broth\\n •  1 tsp Italian seasoning\\n •  Salt and pepper to taste\\n •  6 lasagna noodles, broken into pieces\\n •  100g mozzarella, shredded\\n •  100g ricotta (optional)\\n •  Fresh basil (for garnish)\\n\\nInstructions:\\n\\n •  Heat olive oil in a pot, sauté onion and garlic.\\n •  Add ground beef, cook until browned.\\n •  Stir in tomato paste, crushed tomatoes, broth, and seasoning.\\n •  Bring to a boil, add broken noodles.\\n •  Simmer 10–15 minutes, until noodles are tender.\\n •  Serve hot with mozzarella, a spoon of ricotta, and fresh basil on top.\",\"image\":\"https://firebasestorage.googleapis.com/v0/b/cookio-7cfc3.firebasestorage.app/o/recipes%2Frecipe9%20(1).png?alt=media&token=7fc442fa-80c1-4cfb-a7df-f319bfaa16bb\",\"tags\":\"[\\\"Dinner\\\",\\\"200-300 kcal\\\",\\\"Low Calorie\\\",\\\"Low Fat\\\",\\\"Lunch\\\",\\\"Soup\\\",\\\"Vegan\\\",\\\"Vegetarian\\\"]\",\"cook_time\":\"35\",\"created_at\":\"1745833740000\",\"kcal\":\"272\",\"description\":\"Lasagne Soup is a cozy, one-pot version of classic lasagna. It has all the flavors of the traditional dish—meaty tomato sauce, pasta, and cheese but in a warm, comforting soup form.\"}'))
  ];
  List<RecipesStruct> get recipes => _recipes;
  set recipes(List<RecipesStruct> value) {
    _recipes = value;
  }

  void addToRecipes(RecipesStruct value) {
    recipes.add(value);
  }

  void removeFromRecipes(RecipesStruct value) {
    recipes.remove(value);
  }

  void removeAtIndexFromRecipes(int index) {
    recipes.removeAt(index);
  }

  void updateRecipesAtIndex(
    int index,
    RecipesStruct Function(RecipesStruct) updateFn,
  ) {
    recipes[index] = updateFn(_recipes[index]);
  }

  void insertAtIndexInRecipes(int index, RecipesStruct value) {
    recipes.insert(index, value);
  }

  List<NutritionStruct> _nutritionChart = [
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"24\",\"carbs\":\"30\",\"protein\":\"15\",\"fat\":\"55\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"25\",\"carbs\":\"20\",\"protein\":\"30\",\"fat\":\"50\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"26\",\"carbs\":\"30\",\"protein\":\"40\",\"fat\":\"30\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"27\",\"carbs\":\"45\",\"protein\":\"20\",\"fat\":\"35\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"28\",\"carbs\":\"30\",\"protein\":\"30\",\"fat\":\"40\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"29\",\"carbs\":\"45\",\"protein\":\"35\",\"fat\":\"20\"}')),
    NutritionStruct.fromSerializableMap(jsonDecode(
        '{\"day\":\"30\",\"carbs\":\"45\",\"protein\":\"20\",\"fat\":\"35\"}'))
  ];
  List<NutritionStruct> get nutritionChart => _nutritionChart;
  set nutritionChart(List<NutritionStruct> value) {
    _nutritionChart = value;
  }

  void addToNutritionChart(NutritionStruct value) {
    nutritionChart.add(value);
  }

  void removeFromNutritionChart(NutritionStruct value) {
    nutritionChart.remove(value);
  }

  void removeAtIndexFromNutritionChart(int index) {
    nutritionChart.removeAt(index);
  }

  void updateNutritionChartAtIndex(
    int index,
    NutritionStruct Function(NutritionStruct) updateFn,
  ) {
    nutritionChart[index] = updateFn(_nutritionChart[index]);
  }

  void insertAtIndexInNutritionChart(int index, NutritionStruct value) {
    nutritionChart.insert(index, value);
  }

  List<FoodStruct> _foods = [
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Cheesburger\",\"kcal\":\"303\",\"gram\":\"150\"}')),
    FoodStruct.fromSerializableMap(
        jsonDecode('{\"title\":\"Oatmeal\",\"kcal\":\"150\",\"gram\":\"40\"}')),
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Grilled Chicken Salad\",\"kcal\":\"350\",\"gram\":\"300\"}')),
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Scrambled Eggs\",\"kcal\":\"160\",\"gram\":\"100\"}')),
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Sushi Roll\",\"kcal\":\"250\",\"gram\":\"180\"}')),
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Mashed Potatoes\",\"kcal\":\"240\",\"gram\":\"200\"}')),
    FoodStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Shrimp Scampi\",\"kcal\":\"150\",\"gram\":\"120\"}'))
  ];
  List<FoodStruct> get foods => _foods;
  set foods(List<FoodStruct> value) {
    _foods = value;
  }

  void addToFoods(FoodStruct value) {
    foods.add(value);
  }

  void removeFromFoods(FoodStruct value) {
    foods.remove(value);
  }

  void removeAtIndexFromFoods(int index) {
    foods.removeAt(index);
  }

  void updateFoodsAtIndex(
    int index,
    FoodStruct Function(FoodStruct) updateFn,
  ) {
    foods[index] = updateFn(_foods[index]);
  }

  void insertAtIndexInFoods(int index, FoodStruct value) {
    foods.insert(index, value);
  }

  List<FoodStruct> _selectedFoods = [];
  List<FoodStruct> get selectedFoods => _selectedFoods;
  set selectedFoods(List<FoodStruct> value) {
    _selectedFoods = value;
  }

  void addToSelectedFoods(FoodStruct value) {
    selectedFoods.add(value);
  }

  void removeFromSelectedFoods(FoodStruct value) {
    selectedFoods.remove(value);
  }

  void removeAtIndexFromSelectedFoods(int index) {
    selectedFoods.removeAt(index);
  }

  void updateSelectedFoodsAtIndex(
    int index,
    FoodStruct Function(FoodStruct) updateFn,
  ) {
    selectedFoods[index] = updateFn(_selectedFoods[index]);
  }

  void insertAtIndexInSelectedFoods(int index, FoodStruct value) {
    selectedFoods.insert(index, value);
  }

  List<FoodStruct> _appFoods = [];
  List<FoodStruct> get appFoods => _appFoods;
  set appFoods(List<FoodStruct> value) {
    _appFoods = value;
    prefs.setStringList(
        'ff_appFoods', value.map((x) => x.serialize()).toList());
  }

  void addToAppFoods(FoodStruct value) {
    appFoods.add(value);
    prefs.setStringList(
        'ff_appFoods', _appFoods.map((x) => x.serialize()).toList());
  }

  void removeFromAppFoods(FoodStruct value) {
    appFoods.remove(value);
    prefs.setStringList(
        'ff_appFoods', _appFoods.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAppFoods(int index) {
    appFoods.removeAt(index);
    prefs.setStringList(
        'ff_appFoods', _appFoods.map((x) => x.serialize()).toList());
  }

  void updateAppFoodsAtIndex(
    int index,
    FoodStruct Function(FoodStruct) updateFn,
  ) {
    appFoods[index] = updateFn(_appFoods[index]);
    prefs.setStringList(
        'ff_appFoods', _appFoods.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAppFoods(int index, FoodStruct value) {
    appFoods.insert(index, value);
    prefs.setStringList(
        'ff_appFoods', _appFoods.map((x) => x.serialize()).toList());
  }

  int _foodKcal = 0;
  int get foodKcal => _foodKcal;
  set foodKcal(int value) {
    _foodKcal = value;
  }

  String _foodType = 'Dinner';
  String get foodType => _foodType;
  set foodType(String value) {
    _foodType = value;
    prefs.setString('ff_foodType', value);
  }

  String _activityMinuts = '30 mins';
  String get activityMinuts => _activityMinuts;
  set activityMinuts(String value) {
    _activityMinuts = value;
  }

  List<RecipesStruct> _favoritesRecipes = [];
  List<RecipesStruct> get favoritesRecipes => _favoritesRecipes;
  set favoritesRecipes(List<RecipesStruct> value) {
    _favoritesRecipes = value;
    prefs.setStringList(
        'ff_favoritesRecipes', value.map((x) => x.serialize()).toList());
  }

  void addToFavoritesRecipes(RecipesStruct value) {
    favoritesRecipes.add(value);
    prefs.setStringList('ff_favoritesRecipes',
        _favoritesRecipes.map((x) => x.serialize()).toList());
  }

  void removeFromFavoritesRecipes(RecipesStruct value) {
    favoritesRecipes.remove(value);
    prefs.setStringList('ff_favoritesRecipes',
        _favoritesRecipes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromFavoritesRecipes(int index) {
    favoritesRecipes.removeAt(index);
    prefs.setStringList('ff_favoritesRecipes',
        _favoritesRecipes.map((x) => x.serialize()).toList());
  }

  void updateFavoritesRecipesAtIndex(
    int index,
    RecipesStruct Function(RecipesStruct) updateFn,
  ) {
    favoritesRecipes[index] = updateFn(_favoritesRecipes[index]);
    prefs.setStringList('ff_favoritesRecipes',
        _favoritesRecipes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInFavoritesRecipes(int index, RecipesStruct value) {
    favoritesRecipes.insert(index, value);
    prefs.setStringList('ff_favoritesRecipes',
        _favoritesRecipes.map((x) => x.serialize()).toList());
  }

  CategoriesStruct _categories = CategoriesStruct.fromSerializableMap(jsonDecode(
      '{\"meals\":\"[\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Breakfast\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Lunch\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"438\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Dinner\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"546\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Soup\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/ywvo4bnuvvwv/soup.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Salad\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/clzo92jmw0yn/salad.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"357\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Dessert\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/1le196eau99c/dessert.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"578\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Shake\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/udznjjtgj5zg/shake.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"224\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Snack\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/v07c29d8eg7x/snacks.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"645\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Smoothie\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/sell7e5a7qj6/smoothie.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"246\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\"]\",\"diets\":\"[\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Vegetarian\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/2xazb2pktaas/diet1.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"134\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Vegan\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"97\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Carb\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"355\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Fat\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/fu0kfqexmorm/diet2.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"462\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Calorie\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/y5u6ppeen5ob/diet3.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"224\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"High Protein\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"97\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"High Fiber\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/75neip0s8ajj/diet7.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Clean Eating\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/4a8d6rq5g0y7/diet9.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"214\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Sugar Free\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/uth2eexc2pvz/diet8.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"334\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Ketogenic\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/y0vpe1tvshrc/diet10.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\"]\",\"energy\":\"[\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"50-100 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/plc4905l1e8q/energy1.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"545\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"100-200 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/dqp10yjcloyl/energy4.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"245\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"200-300 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/f89co5s8t6yg/energy2.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"300-400 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/snnmd2p6lq9y/energy7.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"400-500 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/97qa06dqxnlp/energy3.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"654\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"500-600 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/7ri9qx2xexda/energy5.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"245\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"600-700 kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/4fpzx1q86zbn/energy8.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"98\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"700+ kcal\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/dzzndgldpzz9/energy6.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"324\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"energy\\\\\\\"}\\\"]\",\"popular_categories\":\"[\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Breakfast\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Lunch\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"245\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Dinner\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"234\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"meal\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Vegan\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"342\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"High Protein\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"435\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Carb\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"423\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Fat\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/fu0kfqexmorm/diet2.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"235\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Sugar Free\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/uth2eexc2pvz/diet8.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"324\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Low Calorie\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/y5u6ppeen5ob/diet3.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"423\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\",\\\"{\\\\\\\"title\\\\\\\":\\\\\\\"Vegetarian\\\\\\\",\\\\\\\"image\\\\\\\":\\\\\\\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/2xazb2pktaas/diet1.png\\\\\\\",\\\\\\\"quantity\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"diet\\\\\\\"}\\\"]\"}'));
  CategoriesStruct get categories => _categories;
  set categories(CategoriesStruct value) {
    _categories = value;
  }

  void updateCategoriesStruct(Function(CategoriesStruct) updateFn) {
    updateFn(_categories);
  }

  FilterStruct _filter = FilterStruct.fromSerializableMap(jsonDecode(
      '{\"categories\":\"[]\",\"energy_value_start\":\"0.0\",\"energy_value_end\":\"700.0\"}'));
  FilterStruct get filter => _filter;
  set filter(FilterStruct value) {
    _filter = value;
  }

  void updateFilterStruct(Function(FilterStruct) updateFn) {
    updateFn(_filter);
  }

  ChartStruct _chart = ChartStruct.fromSerializableMap(jsonDecode(
      '{\"calorie\":\"{\\\"xValues\\\":\\\"[\\\\\\\"5\\\\\\\",\\\\\\\"6\\\\\\\",\\\\\\\"7\\\\\\\",\\\\\\\"8\\\\\\\",\\\\\\\"9\\\\\\\",\\\\\\\"10\\\\\\\",\\\\\\\"11\\\\\\\"]\\\",\\\"yValues\\\":\\\"[\\\\\\\"1600\\\\\\\",\\\\\\\"1800\\\\\\\",\\\\\\\"2000\\\\\\\",\\\\\\\"1800\\\\\\\",\\\\\\\"1500\\\\\\\",\\\\\\\"1700\\\\\\\",\\\\\\\"1600\\\\\\\"]\\\"}\",\"water\":\"{\\\"xValues\\\":\\\"[\\\\\\\"5\\\\\\\",\\\\\\\"6\\\\\\\",\\\\\\\"7\\\\\\\",\\\\\\\"8\\\\\\\",\\\\\\\"9\\\\\\\",\\\\\\\"10\\\\\\\",\\\\\\\"11\\\\\\\"]\\\",\\\"yValues\\\":\\\"[\\\\\\\"1500\\\\\\\",\\\\\\\"2800\\\\\\\",\\\\\\\"2500\\\\\\\",\\\\\\\"2000\\\\\\\",\\\\\\\"3000\\\\\\\",\\\\\\\"1800\\\\\\\",\\\\\\\"1800\\\\\\\"]\\\"}\",\"step\":\"{\\\"xValues\\\":\\\"[\\\\\\\"5\\\\\\\",\\\\\\\"6\\\\\\\",\\\\\\\"8\\\\\\\",\\\\\\\"9\\\\\\\",\\\\\\\"10\\\\\\\",\\\\\\\"11\\\\\\\",\\\\\\\"7\\\\\\\"]\\\",\\\"yValues\\\":\\\"[\\\\\\\"5500\\\\\\\",\\\\\\\"6000\\\\\\\",\\\\\\\"3500\\\\\\\",\\\\\\\"4500\\\\\\\",\\\\\\\"6000\\\\\\\",\\\\\\\"7000\\\\\\\",\\\\\\\"5000\\\\\\\"]\\\"}\",\"weight\":\"{\\\"xValues\\\":\\\"[\\\\\\\"5\\\\\\\",\\\\\\\"6\\\\\\\",\\\\\\\"7\\\\\\\",\\\\\\\"8\\\\\\\",\\\\\\\"9\\\\\\\",\\\\\\\"10\\\\\\\",\\\\\\\"11\\\\\\\"]\\\",\\\"yValues\\\":\\\"[\\\\\\\"72\\\\\\\",\\\\\\\"70\\\\\\\",\\\\\\\"70\\\\\\\",\\\\\\\"70\\\\\\\",\\\\\\\"72\\\\\\\",\\\\\\\"75\\\\\\\",\\\\\\\"80\\\\\\\"]\\\"}\"}'));
  ChartStruct get chart => _chart;
  set chart(ChartStruct value) {
    _chart = value;
  }

  void updateChartStruct(Function(ChartStruct) updateFn) {
    updateFn(_chart);
  }

  TrackerStruct _tracker = TrackerStruct.fromSerializableMap(jsonDecode(
      '{\"step\":\"[\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.6\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"3600\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748804400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.4\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"2400\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748890800000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.95\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"5700\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748977200000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.8\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"4800\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749063600000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.72\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"4320\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749150000000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.54\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"3240\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749236400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.0\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"0\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"steps\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749322800000\\\\\\\"}\\\"]\",\"water\":\"[\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.5\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"1500\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748804400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.85\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"2975\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748890800000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.7\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"2450\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748977200000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.6\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"2100\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749063600000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.45\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"1575\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749150000000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.8\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"2800\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749236400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.0\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"0\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"mL\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749322800000\\\\\\\"}\\\"]\",\"weight\":\"[\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.0\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"0\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748804400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.2\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"76\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748890800000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.3\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"77\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1748977200000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.3\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"77\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749063600000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.4\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"78\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749150000000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.5\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"79\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749236400000\\\\\\\"}\\\",\\\"{\\\\\\\"progress\\\\\\\":\\\\\\\"0.6\\\\\\\",\\\\\\\"value\\\\\\\":\\\\\\\"80\\\\\\\",\\\\\\\"unit\\\\\\\":\\\\\\\"kg\\\\\\\",\\\\\\\"date\\\\\\\":\\\\\\\"1749322800000\\\\\\\"}\\\"]\",\"current_date\":\"1749236400000\",\"selected_date\":\"1749236400000\"}'));
  TrackerStruct get tracker => _tracker;
  set tracker(TrackerStruct value) {
    _tracker = value;
    prefs.setString('ff_tracker', value.serialize());
  }

  void updateTrackerStruct(Function(TrackerStruct) updateFn) {
    updateFn(_tracker);
    prefs.setString('ff_tracker', _tracker.serialize());
  }

  TrackerSettingsStruct _trackerSettings =
      TrackerSettingsStruct.fromSerializableMap(jsonDecode(
          '{\"calorie\":\"{\\\"goal\\\":\\\"3500\\\",\\\"unit\\\":\\\"kcal\\\",\\\"repeat\\\":\\\"[\\\\\\\"Monday\\\\\\\",\\\\\\\"Tuesday\\\\\\\",\\\\\\\"Wednesday\\\\\\\",\\\\\\\"Thursday\\\\\\\",\\\\\\\"Friday\\\\\\\",\\\\\\\"Saturday\\\\\\\",\\\\\\\"Sunday\\\\\\\"]\\\",\\\"reminder_time\\\":\\\"{\\\\\\\"hour\\\\\\\":\\\\\\\"08\\\\\\\",\\\\\\\"min\\\\\\\":\\\\\\\"50\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"AM\\\\\\\"}\\\",\\\"ringtone\\\":\\\"Asteroid\\\",\\\"sound_volume\\\":\\\"4.0\\\",\\\"vibration\\\":\\\"true\\\"}\",\"water\":\"{\\\"goal\\\":\\\"3500\\\",\\\"unit\\\":\\\"mL\\\",\\\"reminder\\\":\\\"true\\\",\\\"repeat\\\":\\\"[\\\\\\\"Monday\\\\\\\",\\\\\\\"Tuesday\\\\\\\",\\\\\\\"Wednesday\\\\\\\",\\\\\\\"Thursday\\\\\\\",\\\\\\\"Friday\\\\\\\",\\\\\\\"Saturday\\\\\\\",\\\\\\\"Sunday\\\\\\\"]\\\",\\\"reminder_time\\\":\\\"{\\\\\\\"hour\\\\\\\":\\\\\\\"06\\\\\\\",\\\\\\\"min\\\\\\\":\\\\\\\"30\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"PM\\\\\\\"}\\\",\\\"ringtone\\\":\\\"Asteroid\\\",\\\"sound_volume\\\":\\\"6.0\\\",\\\"vibration\\\":\\\"true\\\",\\\"stop_when_100p\\\":\\\"true\\\"}\",\"step\":\"{\\\"goal\\\":\\\"5000\\\",\\\"unit\\\":\\\"m\\\",\\\"repeat\\\":\\\"[\\\\\\\"Monday\\\\\\\",\\\\\\\"Wednesday\\\\\\\",\\\\\\\"Friday\\\\\\\"]\\\",\\\"reminder_time\\\":\\\"{\\\\\\\"hour\\\\\\\":\\\\\\\"07\\\\\\\",\\\\\\\"min\\\\\\\":\\\\\\\"25\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"AM\\\\\\\"}\\\",\\\"ringtone\\\":\\\"Asteroid\\\",\\\"sound_volume\\\":\\\"3.0\\\",\\\"vibration\\\":\\\"true\\\",\\\"stop_when_100p\\\":\\\"true\\\"}\",\"weight\":\"{\\\"current_weight\\\":\\\"79\\\",\\\"goal_weight\\\":\\\"85\\\",\\\"weight_unit\\\":\\\"kg\\\",\\\"height_unit\\\":\\\"cm\\\",\\\"bmi\\\":\\\"true\\\",\\\"reminder\\\":\\\"true\\\",\\\"repeat\\\":\\\"[\\\\\\\"Monday\\\\\\\",\\\\\\\"Tuesday\\\\\\\",\\\\\\\"Wednesday\\\\\\\",\\\\\\\"Thursday\\\\\\\",\\\\\\\"Friday\\\\\\\",\\\\\\\"Saturday\\\\\\\",\\\\\\\"Sunday\\\\\\\"]\\\",\\\"reminder_time\\\":\\\"{\\\\\\\"hour\\\\\\\":\\\\\\\"06\\\\\\\",\\\\\\\"min\\\\\\\":\\\\\\\"30\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"PM\\\\\\\"}\\\",\\\"ringtone\\\":\\\"Asteroid\\\",\\\"sound_volume\\\":\\\"6.0\\\",\\\"vibration\\\":\\\"true\\\",\\\"stop_when_100p\\\":\\\"true\\\",\\\"height\\\":\\\"175\\\"}\"}'));
  TrackerSettingsStruct get trackerSettings => _trackerSettings;
  set trackerSettings(TrackerSettingsStruct value) {
    _trackerSettings = value;
    prefs.setString('ff_trackerSettings', value.serialize());
  }

  void updateTrackerSettingsStruct(Function(TrackerSettingsStruct) updateFn) {
    updateFn(_trackerSettings);
    prefs.setString('ff_trackerSettings', _trackerSettings.serialize());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
