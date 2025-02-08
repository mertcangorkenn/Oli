import 'package:auto_route/auto_route.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        MaterialRoute(path: '/', page: SplashRoute.page),
        MaterialRoute(path: '/noconnection', page: NoConnectionRoute.page),
        MaterialRoute(path: '/landing', page: LandingRoute.page),
        MaterialRoute(path: '/languageChange', page: LanguageChangeRoute.page),
        MaterialRoute(path: '/login', page: LoginRoute.page),
        MaterialRoute(path: '/register', page: RegisterRoute.page),
        MaterialRoute(path: '/forgotPassword', page: ForgotPasswordRoute.page),
        MaterialRoute(path: '/favourites', page: FavouriteRoute.page),
        MaterialRoute(
            path: '/personalisation', page: PersonalisationRoute.page),
        MaterialRoute(path: '/holidayMode', page: HolidayModeRoute.page),
        MaterialRoute(path: '/settings', page: SettingsRoute.page),
        MaterialRoute(path: '/helpCentre', page: HelpCentreRoute.page),
        MaterialRoute(path: '/privacyPolicy', page: PrivacyPolicyRoute.page),
        MaterialRoute(path: '/terms', page: TermsRoute.page),
        MaterialRoute(path: '/legal', page: LegalInformationRoute.page),
        MaterialRoute(path: '/feedback', page: FeedbackRoute.page),
        MaterialRoute(path: '/selectUsername', page: SelectUsernameRoute.page),
        MaterialRoute(path: '/selectLocation', page: SelectLocationRoute.page),
        MaterialRoute(path: '/profileDetails', page: ProfileDetailsRoute.page),
        MaterialRoute(path: '/deleteAccount', page: DeleteAccountRoute.page),
        MaterialRoute(path: '/profile', page: ProfileDetailRoute.page),
        MaterialRoute(path: '/notification', page: NotificationRoute.page),
        MaterialRoute(path: '/faqPage', page: FaqRoute.page),
        MaterialRoute(
            path: '/subcategorySelected', page: SubcategorySelectedRoute.page),
        MaterialRoute(path: '/brandSelected', page: BrandSelectedRoute.page),
        MaterialRoute(path: '/sizeSelected', page: SizeSelectedRoute.page),
        MaterialRoute(path: '/colorSelected', page: ColorSelectedRoute.page),
        MaterialRoute(
            path: '/conditionSelected', page: ConditionSelectedRoute.page),
        MaterialRoute(
            path: '/materialSelected', page: MaterialSelectedRoute.page),
        MaterialRoute(path: '/priceSelected', page: PriceSelectedRoute.page),
        MaterialRoute(path: '/detailsView', page: DetailsViewRoute.page),
        MaterialRoute(
            path: '/notificationSettings',
            page: NotificationSettingsRoute.page),
        MaterialRoute(
            path: '/categorySelected', page: CategorySelectedRoute.page),
        MaterialRoute(
            path: '/accountSettings', page: AccountSettingsRoute.page),
        AutoRoute(
            path: '/main',
            page: MainRoute.page,
            initial: true,
            children: [
              MaterialRoute(page: HomeRoute.page),
              MaterialRoute(page: SearchRoute.page),
              MaterialRoute(page: SellRoute.page),
              MaterialRoute(page: InboxRoute.page),
              MaterialRoute(page: ProfileRoute.page),
            ]),
      ];
}
