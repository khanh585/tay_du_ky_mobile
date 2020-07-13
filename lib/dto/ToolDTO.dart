class ToolDTO {
  final int tool_id;
  final int quantity;
  final String name;
  final String description;
  final String image;
  final String status;

  ToolDTO(
      {this.tool_id,
      this.quantity,
      this.name,
      this.description,
      this.image,
      this.status});

  factory ToolDTO.fromJson(Map<String, dynamic> json) {
    return ToolDTO(
      tool_id: json['tool_id'],
      quantity: json['quantity'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
    );
  }

  serialize() {
    return <String, String>{
      "tool_id": this.tool_id.toString(),
      "quantity": this.quantity.toString(),
      "name": this.name,
      "description": this.description,
      "image": this.image,
      "status": this.status,
    };
  }
}
