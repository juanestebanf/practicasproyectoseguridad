import 'package:flutter/material.dart';
import 'package:app_seguridadmx/features/admin/presentacion/data/admin_repository.dart';
import 'package:app_seguridadmx/features/admin/presentacion/domain/models/operator_model.dart';
import 'package:app_seguridadmx/features/admin/presentacion/screens/crear_operador_screen.dart';
import 'package:app_seguridadmx/core/services/auth_service.dart';

class OperadoresScreen extends StatefulWidget {
  const OperadoresScreen({super.key});

  @override
  State<OperadoresScreen> createState() => _OperadoresScreenState();
}

class _OperadoresScreenState extends State<OperadoresScreen> {
  final AdminRepository repository = AdminRepository();
  List<OperatorModel> users = [];
  String _selectedRoleFilter = 'todos';
  bool _isLoading = true;
  String? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _currentUserRole = await AuthService.getUserRol();
    await _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final results = await repository.getAnyUsers(_selectedRoleFilter);
    if (mounted) {
      setState(() {
        users = results;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1414),
        title: const Text("Confirmar Eliminación", style: TextStyle(color: Colors.white)),
        content: const Text("¿Estás seguro de que deseas eliminar este usuario permanentemente?", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCELAR")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("ELIMINAR", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await repository.deleteUser(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario eliminado"), backgroundColor: Colors.green)
        );
        _loadUsers();
      }
    }
  }

  Future<void> _changeRole(OperatorModel user) async {
    if (_currentUserRole != 'superadmin') return;

    final List<String> roles = ['user', 'operador', 'admin', 'superadmin'];
    String tempRole = user.rol ?? 'user';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFF1E1414),
          title: Text("Cambiar Rol de ${user.nombre}", style: const TextStyle(color: Colors.white, fontSize: 16)),
          content: DropdownButton<String>(
            value: tempRole,
            dropdownColor: const Color(0xFF1E1414),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
            onChanged: (val) {
              if (val != null) setStateDialog(() => tempRole = val);
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCELAR")),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final success = await repository.updateUser(user.id, {'rol': tempRole});
                if (success && mounted) _loadUsers();
              }, 
              child: const Text("GUARDAR", style: TextStyle(color: Colors.red))
            ),
          ],
        ),
      ),
    );
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
          _loadUsers();
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
                  Text(
                    _currentUserRole == 'superadmin' ? "Gestión Usuarios" : "Operadores",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
                      "${users.length} Total",
                      style: const TextStyle(color: accentRed, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // Filtro de Roles
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['todos', 'operador', 'user', 'admin', 'superadmin'].map((role) {
                    final isSelected = _selectedRoleFilter == role;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(role.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 11)),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            setState(() => _selectedRoleFilter = role);
                            _loadUsers();
                          }
                        },
                        selectedColor: accentRed,
                        backgroundColor: cardColor,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: accentRed))
                  : ListView.builder(
                      itemCount: users.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = users[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: user.activo ? accentRed.withOpacity(0.3) : Colors.white10,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        onTap: () => _changeRole(user),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black26,
                          child: Text(
                            user.nombre.isEmpty ? '?' : user.nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: accentRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.nombre,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (user.rol != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.rol!.toUpperCase(),
                                  style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          user.telefono,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: user.activo,
                              activeColor: accentRed,
                              activeTrackColor: accentRed.withOpacity(0.3),
                              onChanged: (_) async {
                                final currentStatus = user.activo;
                                setState(() {
                                  user.activo = !user.activo;
                                });
                                await repository.toggleOperatorStatus(user.id, currentStatus);
                                _loadUsers();
                              },
                            ),
                            if (_currentUserRole == 'superadmin')
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                onPressed: () => _deleteUser(user.id),
                              ),
                          ],
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