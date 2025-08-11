import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'nota_model.dart';
import 'nota_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Notas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaNotas(),
    );
  }
}

class ListaNotas extends StatefulWidget {
  const ListaNotas({super.key});

  @override
  State<ListaNotas> createState() => _ListaNotasState();
}

class _ListaNotasState extends State<ListaNotas> {
  List<Nota> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  void _cargarNotas() async {
    final datos = await DBHelper().getNotas();
    setState(() {
      _notas = datos
          .map(
            (e) => Nota(
              id: e['id'],
              titulo: e['titulo'],
              contenido: e['contenido'],
              fecha: e['fecha'],
            ),
          )
          .toList();
    });
  }

  void _eliminarNota(int id) async {
    await DBHelper().deleteNota(id);
    _cargarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),
      body: _notas.isEmpty
          ? const Center(child: Text('No hay notas'))
          : ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];
                return Card(
                  child: ListTile(
                    title: Text(nota.titulo),
                    subtitle: Text(
                      '${nota.fecha}\n${nota.contenido}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NotaForm(nota: nota, refresh: _cargarNotas),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarNota(nota.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NotaForm(refresh: _cargarNotas)),
          );
        },
      ),
    );
  }
}
