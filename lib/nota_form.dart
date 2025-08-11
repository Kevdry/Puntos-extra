import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'nota_model.dart';

class NotaForm extends StatefulWidget {
  final Nota? nota;
  final Function refresh;

  const NotaForm({super.key, this.nota, required this.refresh});

  @override
  State<NotaForm> createState() => _NotaFormState();
}

class _NotaFormState extends State<NotaForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.nota != null) {
      _tituloController.text = widget.nota!.titulo;
      _contenidoController.text = widget.nota!.contenido;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _guardarNota() async {
    if (_formKey.currentState!.validate()) {
      final nota = Nota(
        id: widget.nota?.id,
        titulo: _tituloController.text,
        contenido: _contenidoController.text,
        fecha: DateTime.now().toString().substring(0, 16),
      );

      if (widget.nota == null) {
        await DBHelper().insertNota(nota.toMap());
      } else {
        await DBHelper().updateNota(nota.toMap());
      }

      widget.refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nota == null ? 'Nueva Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un título' : null,
              ),
              TextFormField(
                controller: _contenidoController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese contenido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarNota,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
