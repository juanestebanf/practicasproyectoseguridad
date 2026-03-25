import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/operator_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/screens/crear_operador_screen.dart';

class OperadoresScreen extends StatefulWidget {
  const OperadoresScreen({super.key});

  @override
  State<OperadoresScreen> createState() => _OperadoresScreenState();
}

class _OperadoresScreenState extends State<OperadoresScreen> {
  final AdminRepository repository = AdminRepository();
  List<OperatorModel> operators = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOperators();
  }

  Future<void> _loadOperators() async {
    final ops = await repository.getOperators();
    if (mounted) {
      setState(() {
        operators = ops;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const cardColor = Color(0xFF1E1414);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentRed,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearOperadorScreen()),
          );
          _loadOperators();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Operadores",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${operators.length} Total",
                      style: const TextStyle(color: accentRed, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: accentRed))
                  : ListView.builder(
                      itemCount: operators.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final operator = operators[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: operator.activo ? accentRed.withOpacity(0.3) : Colors.white10,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black26,
                          child: Text(
                            operator.nombre.isEmpty ? '?' : operator.nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: accentRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          operator.nombre,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          operator.telefono,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        trailing: Switch(
                          value: operator.activo,
                          activeColor: accentRed,
                          activeTrackColor: accentRed.withOpacity(0.3),
                          onChanged: (_) async {
                            final currentStatus = operator.activo;
                            setState(() {
                              operator.activo = !operator.activo;
                            });
                            await repository.toggleOperatorStatus(operator.id, currentStatus);
                            _loadOperators();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}