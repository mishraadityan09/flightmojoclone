import 'package:flightmojo/features/search/presentation/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.setup(); // Initialize GetIt registrations (DioClient, RemoteDataSource, Provider factories)

  runApp(const FlightsMojoApp());
}

class FlightsMojoApp extends StatelessWidget {
  const FlightsMojoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => di.sl<SearchProvider>(),
        ),
        // Add other providers here...
      ],
      child: MaterialApp.router(
        title: 'FlightsMojo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
