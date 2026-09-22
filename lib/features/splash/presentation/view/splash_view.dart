import 'package:flutter/material.dart';
import 'package:food_app/base/base_screen.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/features/home/presentation/view/home_view.dart';
import 'package:food_app/features/splash/presentation/provider/splash_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const String route = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends BaseScreen<SplashView, SplashProvider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    await viewModel?.restoreSession();
    if (!mounted) return;
    // Branch to your auth flow here when the session could not be restored.
    gotoScreen(HomeView.route, clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.scaffoldBackground,
      body: Center(
        child: Text(R.strings.appName, style: R.textStyles.font24B),
      ),
    );
  }
}
