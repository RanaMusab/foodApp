import 'package:flutter/material.dart';
import 'package:food_app/base/base_screen.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_entities.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:food_app/features/order_tracking/presentation/provider/order_tracking_provider.dart';
import 'package:food_app/features/order_tracking/presentation/widgets/status_timeline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderTrackingView extends StatefulWidget {
  const OrderTrackingView({super.key, this.orderId = 'ORD-4417'});

  static const String route = '/OrderTrackingView';

  final String orderId;

  @override
  State<OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState
    extends BaseScreen<OrderTrackingView, OrderTrackingProvider> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => viewModel?.startTracking(widget.orderId),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  LatLng _latLng(GeoPoint point) => LatLng(point.latitude, point.longitude);

  /// Keeps the rider and the destination both in frame as the rider moves.
  void _followRider(GeoPoint rider) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_latLng(rider), 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderTrackingProvider>(
        builder: (context, provider, child) {
          final order = provider.order;
          final restaurant = order?.restaurant;
          final destination = order?.destination;
          final rider = order?.riderLocation;

          if (rider != null) _followRider(rider);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: restaurant != null
                      ? _latLng(restaurant)
                      : const LatLng(37.78825, -122.4324),
                  zoom: 13,
                ),
                onMapCreated: (controller) => _mapController = controller,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: {
                  if (restaurant != null)
                    Marker(
                      markerId: const MarkerId('restaurant'),
                      position: _latLng(restaurant),
                      infoWindow: InfoWindow(
                        title: order?.restaurantName ?? 'Restaurant',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange,
                      ),
                    ),
                  if (destination != null)
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: _latLng(destination),
                      infoWindow: const InfoWindow(title: 'Delivery address'),
                    ),
                  if (rider != null)
                    Marker(
                      markerId: const MarkerId('rider'),
                      position: _latLng(rider),
                      infoWindow: InfoWindow(
                        title: order?.riderName ?? 'Rider',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                    ),
                },
                polylines: {
                  if (provider.routePoints.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: R.colors.primaryColor,
                      width: 4,
                      points: provider.routePoints.map(_latLng).toList(),
                    ),
                },
                padding: EdgeInsets.only(bottom: 0.42.sh),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8.h,
                left: 16.w,
                child: _RoundIconButton(
                  icon: Icons.arrow_back,
                  onTap: () async {
                    await provider.stopTracking();
                    if (mounted) goBack();
                  },
                ),
              ),
              _TrackingSheet(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: R.colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(10.w), child: Icon(icon)),
      ),
    );
  }
}

/// The draggable panel over the map: headline status, progress, ETA and the
/// six-step timeline.
class _TrackingSheet extends StatelessWidget {
  const _TrackingSheet({required this.provider});

  final OrderTrackingProvider provider;

  @override
  Widget build(BuildContext context) {
    final status = provider.status;
    final order = provider.order;

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.22,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: R.colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
            boxShadow: [
              BoxShadow(
                color: R.colors.blackTextColor10,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            children: [
              Center(
                child: Container(
                  height: 4.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: R.colors.disableIcon,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              16.hBox,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(status.title, style: R.textStyles.font18B),
                        4.hBox,
                        Text(
                          status.subtitle,
                          style: R.textStyles.font12R.copyWith(
                            color: R.colors.lightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!status.isTerminal && (order?.etaMinutes ?? 0) > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${order?.etaMinutes}',
                          style: R.textStyles.font24B.copyWith(
                            color: R.colors.primaryColor,
                          ),
                        ),
                        Text('min', style: R.textStyles.font10R),
                      ],
                    ),
                ],
              ),
              16.hBox,
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween(begin: 0, end: status.progress),
                  builder: (context, value, child) => LinearProgressIndicator(
                    value: value,
                    minHeight: 6.h,
                    backgroundColor: R.colors.disableIcon,
                    valueColor: AlwaysStoppedAnimation(R.colors.primaryColor),
                  ),
                ),
              ),
              8.hBox,
              Text(
                'Step ${status.step + 1} of ${OrderStatus.totalSteps}',
                style: R.textStyles.font10R.copyWith(
                  color: R.colors.lightGreyColor,
                ),
              ),
              20.hBox,
              StatusTimeline(current: status),
              20.hBox,
              if (!provider.liveActivityEnabled)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: R.colors.orangeLight,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Text(
                    'Lock-screen updates are off. Enable Live Activities for '
                    'this app in Settings to follow your order without '
                    'unlocking your phone.',
                    style: R.textStyles.font12R,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
