class Nota {
  int? id;
  String titulo;
  String contenido;
  String fecha;

  Nota({
    this.id,
    required this.titulo,
    required this.contenido,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'titulo': titulo, 'contenido': contenido, 'fecha': fecha};
  }
}
