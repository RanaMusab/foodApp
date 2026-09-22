enum OrderStatus {
  orderPlaced('order_placed', 'Order placed', 'We received your order'),
  kitchenPreparing(
    'kitchen_preparing',
    'Kitchen is preparing',
    'Your food is being cooked',
  ),
  orderPrepared('order_prepared', 'Order prepared', 'Waiting for a rider'),
  riderPickedUp(
    'rider_picked_up',
    'Rider picked up your order',
    'Your order has left the restaurant',
  ),
  riderOnTheWay('rider_on_the_way', 'Rider is on the way', 'Arriving shortly'),
  delivered('delivered', 'Delivered', 'Enjoy your meal');

  const OrderStatus(this.key, this.title, this.subtitle);

  final String key;
  final String title;
  final String subtitle;

  static OrderStatus fromKey(String? key) => OrderStatus.values.firstWhere(
    (status) => status.key == key,
    orElse: () => OrderStatus.orderPlaced,
  );

  int get step => index;

  static int get totalSteps => OrderStatus.values.length;

  double get progress => (index + 1) / OrderStatus.values.length;

  bool get isTerminal => this == OrderStatus.delivered;

  bool get hasRider => index >= OrderStatus.riderPickedUp.index;

  OrderStatus? get next =>
      isTerminal ? null : OrderStatus.values[index + 1];
}
