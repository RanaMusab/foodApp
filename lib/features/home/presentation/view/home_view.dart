import 'package:flutter/material.dart';
import 'package:food_app/base/base_screen.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/home/presentation/provider/home_provider.dart';
import 'package:food_app/features/order_tracking/presentation/view/order_tracking_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String route = '/HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseScreen<HomeView, HomeProvider> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel?.getDishes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.appName, style: R.textStyles.font18B),
        backgroundColor: R.colors.scaffoldBackground,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => gotoScreen(OrderTrackingView.route),
        backgroundColor: R.colors.primaryColor,
        foregroundColor: R.colors.white,
        icon: const Icon(Icons.delivery_dining),
        label: const Text('Track order'),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.dishes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.dishes.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.errorMessage ?? 'No dishes available',
                      textAlign: TextAlign.center,
                      style: R.textStyles.font14R,
                    ),
                    12.hBox,
                    TextButton(
                      onPressed: () => viewModel?.getDishes(),
                      child: Text('Retry', style: R.textStyles.font14B),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
            itemCount: provider.dishes.length,
            separatorBuilder: (_, _) => 12.hBox,
            itemBuilder: (context, index) {
              final dish = provider.dishes[index];
              return Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: R.colors.white,
                  borderRadius: BorderRadius.circular(14.w),
                  border: Border.all(color: R.colors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 52.w,
                      width: 52.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: R.colors.primaryColor15,
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: R.colors.primaryColor,
                      ),
                    ),
                    12.wBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dish.name ?? '', style: R.textStyles.font16M),
                          4.hBox,
                          Text(
                            dish.description ?? '',
                            style: R.textStyles.font12R.copyWith(
                              color: R.colors.lightGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.wBox,
                    Text(
                      '\$${(dish.price ?? 0).toStringAsFixed(2)}',
                      style: R.textStyles.font14B.copyWith(
                        color: R.colors.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
