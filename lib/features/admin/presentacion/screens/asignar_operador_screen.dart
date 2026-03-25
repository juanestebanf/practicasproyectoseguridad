import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/alert_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/operator_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';

class AsignarOperadorScreen extends StatefulWidget {
  final AlertModel alert;

  const AsignarOperadorScreen({
    super.key,
    required this.alert,
  });

  @override
  State<AsignarOperadorScreen> createState() => _AsignarOperadorScreenState();
}

class _AsignarOperadorScreenState extends State<AsignarOperadorScreen> {
  String? selectedOperatorId;
  final AdminRepository repository = AdminRepository();
  late List<OperatorModel> activeOperators = [];

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
        activeOperators = ops.where((o) => o.activo).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF0D0D0D);
    const accentRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Asignar Operador",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.alert.tipoEmergencia,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Selecciona un operador disponible",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: accentRed))
                : ListView.builder(
                    itemCount: activeOperators.length,
                    itemBuilder: (context, index) {
                      final operator = activeOperators[index];
                      final isSelected = selectedOperatorId == operator.id;

                      return Card(
                        color: isSelected
                            ? accentRed.withOpacity(0.2)
                            : const Color(0xFF1E1414),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: Text(
                              operator.nombre[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            operator.nombre,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.white)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedOperatorId = operator.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedOperatorId == null
                    ? null
                    : () async {
                        // ✅ Llamamos al repositorio para procesar la asignación (Real API)
                        await repository.assignOperator(
                            widget.alert.id, selectedOperatorId!);
                        // ✅ Cerramos la pantalla
                        if (context.mounted) Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Confirmar Asignación",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}