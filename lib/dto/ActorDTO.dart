class ActorDTO {
  final int actor_id;
  final String name;
  final String email;
  final String description;
  final String image;
  final List<String> persona;
  final String phone;
  final String role;
  final String password;

  ActorDTO(
      {this.actor_id,
      this.name,
      this.description,
      this.email,
      this.phone,
      this.role,
      this.image,
      this.password,
      this.persona});

  factory ActorDTO.fromJson(Map<String, dynamic> json) {
    return ActorDTO(
      actor_id: json['actor_id'],
      name: json['name'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'] != null ? json['phone'] : '',
      role: json['role'],
      image: json['image'],
      // persona: json['persona'],
    );
  }

  serialize() {
    return <String, String>{
      "tool_id": this.actor_id.toString(),
      "name": this.name,
      "description": this.description,
      "email": this.email,
      "phone": this.phone,
      "role": this.role,
      "image": this.image,
      // "persona": this.persona
    };
  }
}
