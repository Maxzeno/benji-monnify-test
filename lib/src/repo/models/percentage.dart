class Percentage {
  final String id;
  final double riderPercentage;
  final double agentPercentage;
  final double stateCoordinatorPercentage;

  Percentage({
    required this.id,
    required this.riderPercentage,
    required this.agentPercentage,
    required this.stateCoordinatorPercentage,
  });

  factory Percentage.fromJson(Map<String, dynamic> json) {
    return Percentage(
      id: json['id'],
      riderPercentage: json['rider_percentage'].toDouble(),
      agentPercentage: json['agent_percentage'].toDouble(),
      stateCoordinatorPercentage:
          json['stateCoordinator_percentage'].toDouble(),
    );
  }
}
