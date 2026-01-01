import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? HomePageWidget() : EntryPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? HomePageWidget() : EntryPageWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: EntryPageWidget.routeName,
          path: EntryPageWidget.routePath,
          builder: (context, params) => EntryPageWidget(),
        ),
        FFRoute(
          name: GetStartedWidget.routeName,
          path: GetStartedWidget.routePath,
          builder: (context, params) => GetStartedWidget(),
        ),
        FFRoute(
          name: LogInWidget.routeName,
          path: LogInWidget.routePath,
          builder: (context, params) => LogInWidget(),
        ),
        FFRoute(
          name: SignUpWidget.routeName,
          path: SignUpWidget.routePath,
          builder: (context, params) => SignUpWidget(),
        ),
        FFRoute(
          name: TermsOfServiceWidget.routeName,
          path: TermsOfServiceWidget.routePath,
          builder: (context, params) => TermsOfServiceWidget(),
        ),
        FFRoute(
          name: ResetPasswordWidget.routeName,
          path: ResetPasswordWidget.routePath,
          builder: (context, params) => ResetPasswordWidget(),
        ),
        FFRoute(
          name: VerifyCodeWidget.routeName,
          path: VerifyCodeWidget.routePath,
          builder: (context, params) => VerifyCodeWidget(
            email: params.getParam(
              'email',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: NewPasswordWidget.routeName,
          path: NewPasswordWidget.routePath,
          builder: (context, params) => NewPasswordWidget(),
        ),
        FFRoute(
          name: CreatPlanWidget.routeName,
          path: CreatPlanWidget.routePath,
          builder: (context, params) => CreatPlanWidget(),
        ),
        FFRoute(
          name: OnboardingWidget.routeName,
          path: OnboardingWidget.routePath,
          builder: (context, params) => OnboardingWidget(),
        ),
        FFRoute(
          name: PlanWidget.routeName,
          path: PlanWidget.routePath,
          builder: (context, params) => PlanWidget(),
        ),
        FFRoute(
          name: ProfileWidget.routeName,
          path: ProfileWidget.routePath,
          builder: (context, params) => ProfileWidget(),
        ),
        FFRoute(
          name: CalorieCounterWidget.routeName,
          path: CalorieCounterWidget.routePath,
          builder: (context, params) => CalorieCounterWidget(),
        ),
        FFRoute(
          name: WaterTrackerWidget.routeName,
          path: WaterTrackerWidget.routePath,
          builder: (context, params) => WaterTrackerWidget(),
        ),
        FFRoute(
          name: StepCounterWidget.routeName,
          path: StepCounterWidget.routePath,
          builder: (context, params) => StepCounterWidget(),
        ),
        FFRoute(
          name: WeightTrackerWidget.routeName,
          path: WeightTrackerWidget.routePath,
          builder: (context, params) => WeightTrackerWidget(),
        ),
        FFRoute(
          name: PreferencesWidget.routeName,
          path: PreferencesWidget.routePath,
          builder: (context, params) => PreferencesWidget(),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(),
        ),
        FFRoute(
          name: NotificationsSettingsWidget.routeName,
          path: NotificationsSettingsWidget.routePath,
          builder: (context, params) => NotificationsSettingsWidget(),
        ),
        FFRoute(
          name: AccountSecurityWidget.routeName,
          path: AccountSecurityWidget.routePath,
          builder: (context, params) => AccountSecurityWidget(),
        ),
        FFRoute(
          name: LinkedAccountsWidget.routeName,
          path: LinkedAccountsWidget.routePath,
          builder: (context, params) => LinkedAccountsWidget(),
        ),
        FFRoute(
          name: DataAnalyticsWidget.routeName,
          path: DataAnalyticsWidget.routePath,
          builder: (context, params) => DataAnalyticsWidget(),
        ),
        FFRoute(
          name: BillingSubscriptionsWidget.routeName,
          path: BillingSubscriptionsWidget.routePath,
          builder: (context, params) => BillingSubscriptionsWidget(),
        ),
        FFRoute(
          name: PaymentMethodsWidget.routeName,
          path: PaymentMethodsWidget.routePath,
          builder: (context, params) => PaymentMethodsWidget(),
        ),
        FFRoute(
          name: CreditCardPageWidget.routeName,
          path: CreditCardPageWidget.routePath,
          builder: (context, params) => CreditCardPageWidget(
            paymentData: params.getParam(
              'paymentData',
              ParamType.DataStruct,
              isList: false,
              structBuilder: PaymentMethodStruct.fromSerializableMap,
            ),
            index: params.getParam(
              'index',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddNewCardWidget.routeName,
          path: AddNewCardWidget.routePath,
          builder: (context, params) => AddNewCardWidget(),
        ),
        FFRoute(
          name: AppAppearanceWidget.routeName,
          path: AppAppearanceWidget.routePath,
          builder: (context, params) => AppAppearanceWidget(),
        ),
        FFRoute(
          name: AppThemeWidget.routeName,
          path: AppThemeWidget.routePath,
          builder: (context, params) => AppThemeWidget(),
        ),
        FFRoute(
          name: AppLanguageWidget.routeName,
          path: AppLanguageWidget.routePath,
          builder: (context, params) => AppLanguageWidget(),
        ),
        FFRoute(
          name: HelpSupportWidget.routeName,
          path: HelpSupportWidget.routePath,
          builder: (context, params) => HelpSupportWidget(),
        ),
        FFRoute(
          name: FaqWidget.routeName,
          path: FaqWidget.routePath,
          builder: (context, params) => FaqWidget(),
        ),
        FFRoute(
          name: SupportWidget.routeName,
          path: SupportWidget.routePath,
          builder: (context, params) => SupportWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyWidget.routeName,
          path: PrivacyPolicyWidget.routePath,
          builder: (context, params) => PrivacyPolicyWidget(),
        ),
        FFRoute(
          name: SocilaMediaWidget.routeName,
          path: SocilaMediaWidget.routePath,
          builder: (context, params) => SocilaMediaWidget(),
        ),
        FFRoute(
          name: RecipesWidget.routeName,
          path: RecipesWidget.routePath,
          builder: (context, params) => RecipesWidget(),
        ),
        FFRoute(
          name: RecipesPageWidget.routeName,
          path: RecipesPageWidget.routePath,
          builder: (context, params) => RecipesPageWidget(
            recipeData: params.getParam(
              'recipeData',
              ParamType.DataStruct,
              isList: false,
              structBuilder: RecipesStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: RecipesByCategoryWidget.routeName,
          path: RecipesByCategoryWidget.routePath,
          builder: (context, params) => RecipesByCategoryWidget(
            category: params.getParam(
              'category',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: ProgressWidget.routeName,
          path: ProgressWidget.routePath,
          builder: (context, params) => ProgressWidget(),
        ),
        FFRoute(
          name: TrackerWidget.routeName,
          path: TrackerWidget.routePath,
          builder: (context, params) => TrackerWidget(),
        ),
        FFRoute(
          name: TrackerWaterWidget.routeName,
          path: TrackerWaterWidget.routePath,
          builder: (context, params) => TrackerWaterWidget(),
        ),
        FFRoute(
          name: WaterIntakeHistoryWidget.routeName,
          path: WaterIntakeHistoryWidget.routePath,
          builder: (context, params) => WaterIntakeHistoryWidget(),
        ),
        FFRoute(
          name: TrackerStepWidget.routeName,
          path: TrackerStepWidget.routePath,
          builder: (context, params) => TrackerStepWidget(),
        ),
        FFRoute(
          name: StepIntakeHistoryWidget.routeName,
          path: StepIntakeHistoryWidget.routePath,
          builder: (context, params) => StepIntakeHistoryWidget(),
        ),
        FFRoute(
          name: TrackerWeightWidget.routeName,
          path: TrackerWeightWidget.routePath,
          builder: (context, params) => TrackerWeightWidget(),
        ),
        FFRoute(
          name: WeightIntakeHistoryWidget.routeName,
          path: WeightIntakeHistoryWidget.routePath,
          builder: (context, params) => WeightIntakeHistoryWidget(),
        ),
        FFRoute(
          name: FoodHistoryWidget.routeName,
          path: FoodHistoryWidget.routePath,
          builder: (context, params) => FoodHistoryWidget(),
        ),
        FFRoute(
          name: FoodDetailsWidget.routeName,
          path: FoodDetailsWidget.routePath,
          builder: (context, params) => FoodDetailsWidget(
            fromHistory: params.getParam(
              'fromHistory',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: PersonalFoodDetailsWidget.routeName,
          path: PersonalFoodDetailsWidget.routePath,
          builder: (context, params) => PersonalFoodDetailsWidget(
            fromHistory: params.getParam(
              'fromHistory',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: ActivityDetailsWidget.routeName,
          path: ActivityDetailsWidget.routePath,
          builder: (context, params) => ActivityDetailsWidget(),
        ),
        FFRoute(
          name: NotificationWidget.routeName,
          path: NotificationWidget.routePath,
          builder: (context, params) => NotificationWidget(),
        ),
        FFRoute(
          name: ActivityHistoryWidget.routeName,
          path: ActivityHistoryWidget.routePath,
          builder: (context, params) => ActivityHistoryWidget(),
        ),
        FFRoute(
          name: DietsWidget.routeName,
          path: DietsWidget.routePath,
          builder: (context, params) => DietsWidget(
            diets: params.getParam(
              'diets',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: MealsWidget.routeName,
          path: MealsWidget.routePath,
          builder: (context, params) => MealsWidget(
            meals: params.getParam(
              'meals',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: EnergyValueWidget.routeName,
          path: EnergyValueWidget.routePath,
          builder: (context, params) => EnergyValueWidget(
            energy: params.getParam(
              'energy',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AllCategoriesWidget.routeName,
          path: AllCategoriesWidget.routePath,
          builder: (context, params) => AllCategoriesWidget(),
        ),
        FFRoute(
          name: HomePageCopyWidget.routeName,
          path: HomePageCopyWidget.routePath,
          builder: (context, params) => HomePageCopyWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/entryPage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 35.0,
                    height: 35.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
