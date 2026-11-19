class PlanModel {
  final String id;
  final String name;
  final double price;
  final String durationType; // 'Months' or 'Days'
  final int durationValue;

  const PlanModel({
    required this.id,
    required this.name,
    required this.price,
    this.durationType = 'Months',
    this.durationValue = 1,
  });

  String get displayName => '$name (₹${price.toStringAsFixed(0)})';

  String get durationString => '$durationValue $durationType';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'durationType': durationType,
      'durationValue': durationValue,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      durationType: map['durationType'] ?? 'Months',
      durationValue: (map['durationValue'] as num?)?.toInt() ?? 1,
    );
  }
}
