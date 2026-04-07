import 'package:expense/features/about/presentation/screens/about_screen.dart';
import 'package:expense/features/auth/presentation/screens/login_screen.dart';
import 'package:expense/features/auth/presentation/screens/otp_screen.dart';
import 'package:expense/features/auth/presentation/screens/register_screen.dart';
import 'package:expense/features/category/presentation/screens/category_detail_screen.dart';
import 'package:expense/features/category/presentation/screens/category_list_screen.dart';
import 'package:expense/features/dash/presentation/screens/dash_screen.dart';
import 'package:expense/features/profile/presentation/screens/profile_detail_screen.dart';
import 'package:expense/features/profile/presentation/screens/profile_list_screen.dart';
import 'package:expense/features/start/presentation/screens/start_screen.dart';
import 'package:expense/features/transaction/presentation/screens/transaction_detail_screen.dart';
import 'package:expense/features/transaction/presentation/screens/transaction_list_screen.dart';
import 'package:expense/features/wallet/presentation/screens/wallet_detail_screen.dart';
import 'package:expense/features/wallet/presentation/screens/wallet_list_screen.dart';
import 'package:expense/shared/widgets/app_anonymous_scaffold.dart';
import 'package:expense/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Create a global key for the scaffold
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

final appRouter = GoRouter(
  routes: [
    // Start
    GoRoute(
      name: 'start',
      path: '/',
      builder: (context, state) => const StartScreen(),
    ),
    // Anonymous
    ShellRoute(
      builder: (context, state, child) => AppAnonymousScaffold(child: child),
      routes: [
        // Login
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        // Register
        GoRoute(
          name: 'register',
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        // OTP
        GoRoute(
          name: 'otp',
          path: '/otp',
          builder: (context, state) => OtpScreen(email: state.extra as String),
        ),
      ],
    ),
    // Authenticated
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        drawer: const AppDrawer(),
        body: child,
        key: rootScaffoldKey,
      ),
      routes: [
        // Dashboard
        GoRoute(
          name: 'dash',
          path: '/dash',
          builder: (context, state) => const DashScreen(),
        ),
        // About
        GoRoute(
          name: 'about',
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        // Profile
        GoRoute(
          name: 'profile-list',
          path: '/profile',
          builder: (context, state) => const ProfileListScreen(),
          routes: [
            // Profile detail
            GoRoute(
              name: 'profile-detail',
              path: ':id',
              builder: (context, state) => ProfileDetailScreen(
                id: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        // Wallet
        GoRoute(
          name: 'wallet-list',
          path: '/wallet',
          builder: (context, state) => const WalletListScreen(),
          routes: [
            // Wallet detail
            GoRoute(
              name: 'wallet-detail',
              path: ':id',
              builder: (context, state) => WalletDetailScreen(
                id: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        // Category
        GoRoute(
          name: 'category-list',
          path: '/category',
          builder: (context, state) => const CategoryListScreen(),
          routes: [
            // Category detail
            GoRoute(
              name: 'category-detail',
              path: ':id',
              builder: (context, state) => CategoryDetailScreen(
                id: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
        // Transaction
        GoRoute(
          name: 'transaction-list',
          path: '/transaction',
          builder: (context, state) => const TransactionListScreen(),
          routes: [
            // Transaction detail
            GoRoute(
              name: 'transaction-detail',
              path: ':id',
              builder: (context, state) => TransactionDetailScreen(
                id: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
