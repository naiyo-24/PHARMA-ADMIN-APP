import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/asm_management/asm_details_screen.dart';
import '../screens/asm_management/asm_management_screen.dart';
import '../screens/asm_management/onboard_edit_asm_screen.dart';
import '../screens/mr_management/mr_details_screen.dart';
import '../screens/mr_management/mr_management_screen.dart';
import '../screens/mr_management/onboard_edit_mr_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/attendance/attendance_management_screen.dart';
import '../screens/announcement/announcement_management_screen.dart';
import '../screens/announcement/create_edit_announcement_screen.dart';
import '../screens/team_management/create_edit_team_screen.dart';
import '../screens/team_management/team_chat_room_screen.dart';
import '../screens/team_management/team_details_screen.dart';
import '../screens/team_management/team_management_screen.dart';
import '../screens/terms_conditions/terms_conditions_screen.dart';
import '../screens/visual_ads/create_edit_visual_ads_screen.dart';
import '../screens/visual_ads/visual_ad_preview_screen.dart';
import '../screens/visual_ads/visual_ads_management_screen.dart';
import '../screens/salary_slip/salary_slip_screen.dart';
import '../screens/chemist_shop/chemist_shop_detail_screen.dart';
import '../screens/chemist_shop/chemist_shop_screen.dart';

sealed class AppRoutes {
  static const splash = 'splash';
  static const login = 'login';
  static const signup = 'signup';
  static const dashboard = 'dashboard';
  static const termsConditions = 'termsConditions';
  static const aboutUs = 'aboutUs';
  static const profile = 'profile';
  static const mrManagement = 'mrManagement';
  static const mrDetails = 'mrDetails';
  static const onboardMr = 'onboardMr';
  static const editMr = 'editMr';

  static const asmManagement = 'asmManagement';
  static const asmDetails = 'asmDetails';
  static const onboardAsm = 'onboardAsm';
  static const editAsm = 'editAsm';

  static const visualAdsManagement = 'visualAdsManagement';
  static const createVisualAd = 'createVisualAd';
  static const editVisualAd = 'editVisualAd';
  static const visualAdPreview = 'visualAdPreview';

  static const teamManagement = 'teamManagement';
  static const createTeam = 'createTeam';
  static const editTeam = 'editTeam';
  static const teamDetails = 'teamDetails';
  static const teamChatRoom = 'teamChatRoom';

  static const attendanceManagement = 'attendanceManagement';

  static const announcementManagement = 'announcementManagement';
  static const createAnnouncement = 'createAnnouncement';
  static const editAnnouncement = 'editAnnouncement';

  static const salarySlipManagement = 'salarySlipManagement';

  static const chemistShopManagement = 'chemistShopManagement';
  static const chemistShopDetails = 'chemistShopDetails';

  static const splashPath = '/';
  static const loginPath = '/login';
  static const signupPath = '/signup';
  static const dashboardPath = '/dashboard';
  static const termsConditionsPath = '/terms-conditions';
  static const aboutUsPath = '/about-us';
  static const profilePath = '/profile';
  static const mrManagementPath = '/mr-management';
  static const mrDetailsPath = ':mrId';
  static const onboardMrPath = 'onboard';
  static const editMrPath = ':mrId/edit';

  static const asmManagementPath = '/asm-management';
  static const asmDetailsPath = ':asmId';
  static const onboardAsmPath = 'onboard';
  static const editAsmPath = ':asmId/edit';

  static const visualAdsManagementPath = '/visual-ads';
  static const createVisualAdPath = 'create';
  static const editVisualAdPath = ':adId/edit';
  static const visualAdPreviewPath = ':adId/preview';

  static const teamManagementPath = '/team-management';
  static const createTeamPath = 'create';
  static const teamDetailsPath = ':teamId';
  static const editTeamPath = 'edit';
  static const teamChatRoomPath = 'chat';

  static const attendanceManagementPath = '/attendance-records';

  static const announcementManagementPath = '/announcements';
  static const createAnnouncementPath = 'create';
  static const editAnnouncementPath = ':announcementId/edit';

  static const salarySlipManagementPath = '/salary-slips';

  static const chemistShopManagementPath = '/chemist-shops';
  static const chemistShopDetailsPath = ':shopId';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.asmManagementPath,
        name: AppRoutes.asmManagement,
        builder: (context, state) => const AsmManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.onboardAsmPath,
            name: AppRoutes.onboardAsm,
            builder: (context, state) => const OnboardEditAsmScreen(),
          ),
          GoRoute(
            path: AppRoutes.editAsmPath,
            name: AppRoutes.editAsm,
            builder: (context, state) {
              final asmId = state.pathParameters['asmId'] ?? '';
              return OnboardEditAsmScreen(asmId: asmId);
            },
          ),
          GoRoute(
            path: AppRoutes.asmDetailsPath,
            name: AppRoutes.asmDetails,
            builder: (context, state) {
              final asmId = state.pathParameters['asmId'] ?? '';
              return AsmDetailsScreen(asmId: asmId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.mrManagementPath,
        name: AppRoutes.mrManagement,
        builder: (context, state) => const MrManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.onboardMrPath,
            name: AppRoutes.onboardMr,
            builder: (context, state) => const OnboardEditMrScreen(),
          ),
          GoRoute(
            path: AppRoutes.editMrPath,
            name: AppRoutes.editMr,
            builder: (context, state) {
              final mrId = state.pathParameters['mrId'] ?? '';
              return OnboardEditMrScreen(mrId: mrId);
            },
          ),
          GoRoute(
            path: AppRoutes.mrDetailsPath,
            name: AppRoutes.mrDetails,
            builder: (context, state) {
              final mrId = state.pathParameters['mrId'] ?? '';
              return MrDetailsScreen(mrId: mrId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.visualAdsManagementPath,
        name: AppRoutes.visualAdsManagement,
        builder: (context, state) => const VisualAdsManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createVisualAdPath,
            name: AppRoutes.createVisualAd,
            builder: (context, state) => const CreateEditVisualAdsScreen(),
          ),
          GoRoute(
            path: AppRoutes.editVisualAdPath,
            name: AppRoutes.editVisualAd,
            builder: (context, state) {
              final adId = state.pathParameters['adId'] ?? '';
              return CreateEditVisualAdsScreen(adId: adId);
            },
          ),
          GoRoute(
            path: AppRoutes.visualAdPreviewPath,
            name: AppRoutes.visualAdPreview,
            builder: (context, state) {
              final adId = state.pathParameters['adId'] ?? '';
              return VisualAdPreviewScreen(adId: adId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.teamManagementPath,
        name: AppRoutes.teamManagement,
        builder: (context, state) => const TeamManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createTeamPath,
            name: AppRoutes.createTeam,
            builder: (context, state) => const CreateEditTeamScreen(),
          ),
          GoRoute(
            path: AppRoutes.teamDetailsPath,
            name: AppRoutes.teamDetails,
            builder: (context, state) {
              final teamId = state.pathParameters['teamId'] ?? '';
              return TeamDetailsScreen(teamId: teamId);
            },
            routes: [
              GoRoute(
                path: AppRoutes.teamChatRoomPath,
                name: AppRoutes.teamChatRoom,
                builder: (context, state) {
                  final teamId = state.pathParameters['teamId'] ?? '';
                  return TeamChatRoomScreen(teamId: teamId);
                },
              ),
              GoRoute(
                path: AppRoutes.editTeamPath,
                name: AppRoutes.editTeam,
                builder: (context, state) {
                  final teamId = state.pathParameters['teamId'] ?? '';
                  return CreateEditTeamScreen(teamId: teamId);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.attendanceManagementPath,
        name: AppRoutes.attendanceManagement,
        builder: (context, state) => const AttendanceManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.announcementManagementPath,
        name: AppRoutes.announcementManagement,
        builder: (context, state) => const AnnouncementManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createAnnouncementPath,
            name: AppRoutes.createAnnouncement,
            builder: (context, state) => const CreateEditAnnouncementScreen(),
          ),
          GoRoute(
            path: AppRoutes.editAnnouncementPath,
            name: AppRoutes.editAnnouncement,
            builder: (context, state) {
              final announcementId =
                  state.pathParameters['announcementId'] ?? '';
              return CreateEditAnnouncementScreen(
                announcementId: announcementId,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.salarySlipManagementPath,
        name: AppRoutes.salarySlipManagement,
        builder: (context, state) => const SalarySlipScreen(),
      ),
      GoRoute(
        path: AppRoutes.chemistShopManagementPath,
        name: AppRoutes.chemistShopManagement,
        builder: (context, state) => const ChemistShopScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.chemistShopDetailsPath,
            name: AppRoutes.chemistShopDetails,
            builder: (context, state) {
              final shopId = state.pathParameters['shopId'] ?? '';
              return ChemistShopDetailScreen(shopId: shopId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.termsConditionsPath,
        name: AppRoutes.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.aboutUsPath,
        name: AppRoutes.aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profilePath,
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupPath,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Route not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    },
  );
});
