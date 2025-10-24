import 'package:flutter/material.dart';

void main() {
  runApp(const PharmaIAApp());
}

class PharmaIAApp extends StatelessWidget {
  const PharmaIAApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmaIA - Gerenciar Clientes',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDEEEF), // soft pink page bg
        // Make TextButtons/OutlinedButtons use darker text (remove default blue) and bolder font
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black87, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
      home: const ClientesPage(),
    );
  }
}

class Cliente {
  String nome;
  String email;
  String telefone;
  String cidade;
  bool ativo;
  DateTime? dataCadastro;

  Cliente({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cidade,
    required this.ativo,
    this.dataCadastro,
  });

  Cliente copy() => Cliente(
        nome: nome,
        email: email,
        telefone: telefone,
        cidade: cidade,
        ativo: ativo,
        dataCadastro: dataCadastro,
      );
}

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final List<Cliente> _clientes = [
    Cliente(
      nome: 'Maria Silva Santos',
      email: 'maria.silva@email.com',
      telefone: '(11) 98765-4321',
      cidade: 'São Paulo - SP',
      ativo: true,
      dataCadastro: DateTime(2025, 1, 14),
    ),
    Cliente(
      nome: 'João Pedro Oliveira',
      email: 'joao.pedro@email.com',
      telefone: '(21) 99876-5432',
      cidade: 'Rio de Janeiro - RJ',
      ativo: true,
      dataCadastro: DateTime(2025, 2, 3),
    ),
    Cliente(
      nome: 'Ana Carolina Costa',
      email: 'ana.costa@email.com',
      telefone: '(31) 97654-3210',
      cidade: 'Belo Horizonte - MG',
      ativo: true,
      dataCadastro: DateTime(2025, 3, 8),
    ),
    Cliente(
      nome: 'Carlos Eduardo Mendes',
      email: 'carlos.mendes@email.com',
      telefone: '(41) 96543-2109',
      cidade: 'Curitiba - PR',
      ativo: false,
      dataCadastro: DateTime(2025, 4, 1),
    ),
    Cliente(
      nome: 'Juliana Almeida',
      email: 'juliana.almeida@email.com',
      telefone: '(51) 95432-1098',
      cidade: 'Porto Alegre - RS',
      ativo: true,
      dataCadastro: DateTime(2025, 5, 10),
    ),
  ];

  String _filtro = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Cliente> get _filteredClientes {
    if (_filtro.trim().isEmpty) return _clientes;
    final q = _filtro.toLowerCase();
    return _clientes.where((c) {
      return c.nome.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.cidade.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openNewClient() async {
    final novo = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => const NewClientPage()),
    );

    if (novo != null) {
      setState(() {
        _clientes.add(novo);
      });
    }
  }

  void _removerCliente(int index) {
    setState(() {
      _clientes.removeAt(index);
    });
  }

  Future<void> _openDetails(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final result = await Navigator.of(context).push<DetailsResult>(
      MaterialPageRoute(
        builder: (_) => ClientDetailsPage(cliente: cliente.copy(), originalIndex: originalIndex),
      ),
    );

    if (result != null) {
      if (result.deleted) {
        _removerCliente(originalIndex);
      } else if (result.updated != null) {
        setState(() {
          _clientes[originalIndex] = result.updated!;
        });
      }
    }
  }

  Future<void> _openEdit(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(
        builder: (_) => EditClientPage(cliente: cliente.copy()),
      ),
    );

    if (updated != null) {
      // If the returned cliente has empty name, treat as deletion
      if (updated.nome.isEmpty) {
        _removerCliente(originalIndex);
      } else {
        setState(() {
          _clientes[originalIndex] = updated;
        });
      }
    }
  }

  Future<void> _confirmDelete(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => DeleteConfirmationPage(cliente: cliente)),
    );

    if (confirmed == true) {
      _removerCliente(originalIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredClientes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        title: Row(
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services_outlined, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Pharma',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  'IA',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Início')),
            TextButton(onPressed: () {}, child: const Text('Dashboard')),
            TextButton(onPressed: () {}, child: const Text('Clientes')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Acessar plataforma')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Fale com a gente')),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 6),
                      Text(
                        'Gerenciar Clientes',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Visualize, edite e gerencie seus clientes cadastrados',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _filtro = v),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Buscar por nome, email ou cidade...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF6F6F6),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        ElevatedButton.icon(
                          onPressed: _openNewClient,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Cliente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('${filtered.length} clientes encontrados', style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFFCECEC)),
                        columns: const [
                          DataColumn(label: Padding(padding: EdgeInsets.only(left: 16), child: Text('Nome'))),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Telefone')),
                          DataColumn(label: Text('Cidade')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows: List<DataRow>.generate(
                          filtered.length,
                          (index) {
                            final cliente = filtered[index];
                            final originalIndex = _clientes.indexWhere((c) => c.email == cliente.email && c.nome == cliente.nome);
                            return DataRow(cells: [
                              DataCell(Padding(padding: const EdgeInsets.only(left: 16), child: Text(cliente.nome))),
                              DataCell(Text(cliente.email)),
                              DataCell(Text(cliente.telefone)),
                              DataCell(Text(cliente.cidade)),
                              DataCell(_StatusBadge(ativo: cliente.ativo)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Visualizar',
                                    onPressed: originalIndex != -1 ? () => _openDetails(originalIndex) : null,
                                    icon: const Icon(Icons.remove_red_eye_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Editar',
                                    onPressed: originalIndex != -1 ? () => _openEdit(originalIndex) : null,
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Excluir',
                                    onPressed: originalIndex != -1 ? () => _confirmDelete(originalIndex) : null,
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              )),
                            ]);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool ativo;
  const _StatusBadge({Key? key, required this.ativo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = ativo ? const Color(0xFFDFF6E9) : const Color(0xFFF1F2F5);
    final textColor = ativo ? const Color(0xFF19964F) : const Color(0xFF8D94A1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        ativo ? 'Ativo' : 'Inativo',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class DetailsResult {
  final bool deleted;
  final Cliente? updated;

  DetailsResult({this.deleted = false, this.updated});
}

class ClientDetailsPage extends StatefulWidget {
  final Cliente cliente;
  final int originalIndex;
  const ClientDetailsPage({Key? key, required this.cliente, required this.originalIndex}) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  late Cliente _editable;

  @override
  void initState() {
    super.initState();
    _editable = widget.cliente.copy();
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => EditClientPage(cliente: _editable.copy())),
    );

    if (updated != null) {
      setState(() {
        _editable = updated;
      });
    }
  }

  Future<void> _confirmDeleteFromDetails() async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => DeleteConfirmationPage(cliente: _editable)),
    );

    if (confirmed == true) Navigator.of(context).pop(DetailsResult(deleted: true));
  }

  void _saveAndReturn() {
    Navigator.of(context).pop(DetailsResult(updated: _editable));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: const [
          Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54),
          SizedBox(width: 6),
          Text('Voltar para Clientes', style: TextStyle(color: Colors.black87)),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Detalhes do Cliente', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Visualize as informações do cliente', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LabeledField(label: 'Nome Completo *', child: TextFormField(initialValue: _editable.nome, readOnly: true, decoration: _inputDecoration())),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Email *', child: TextFormField(initialValue: _editable.email, readOnly: true, decoration: _inputDecoration())),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Telefone *', child: TextFormField(initialValue: _editable.telefone, readOnly: true, decoration: _inputDecoration())),
                        const SizedBox(height: 12),
                        _LabeledField(label: 'Cidade *', child: TextFormField(initialValue: _editable.cidade, readOnly: true, decoration: _inputDecoration())),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: const Color(0xFFFBECEC), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                Text('Status do Cliente', style: TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text('Cliente ativo no sistema', style: TextStyle(color: Colors.black54)),
                              ]),
                              // Switch with gray colors (thumb and track) similar to icon color
                              Switch(
                                value: _editable.ativo,
                                onChanged: (v) => setState(() => _editable.ativo = v),
                                activeColor: const Color(0xFF2E2E2E),
                                activeTrackColor: const Color(0xFFEFEFEF),
                                inactiveThumbColor: const Color(0xFF2E2E2E),
                                inactiveTrackColor: const Color(0xFFF1F1F1),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: const Color(0xFFFBECEC), borderRadius: BorderRadius.circular(8)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Data de Cadastro', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(_editable.dataCadastro != null ? _formatDate(_editable.dataCadastro!) : '—'),
                          ]),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(children: [
                          OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close), label: const Text('Cancelar')),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(onPressed: _saveAndReturn, icon: const Icon(Icons.edit), label: const Text('Editar Cliente'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                        ])
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade100)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Zona de Perigo', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700, fontSize: 18)),
                      const SizedBox(height: 6),
                      const Text('Esta ação não pode ser desfeita. O cliente será permanentemente excluído.'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final confirmed = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(builder: (_) => DeleteConfirmationPage(cliente: _editable)),
                          );

                          if (confirmed == true) Navigator.of(context).pop(DetailsResult(deleted: true));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Excluir Cliente'),
                      )
                    ]),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    final months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];
    return '${d.day} de ${months[d.month - 1]} de ${d.year}';
  }

  InputDecoration _inputDecoration() => const InputDecoration(
        filled: true,
        fillColor: Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      );
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({Key? key, required this.label, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      child
    ]);
  }
}

class EditClientPage extends StatefulWidget {
  final Cliente cliente;
  const EditClientPage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  late TextEditingController _nome;
  late TextEditingController _email;
  late TextEditingController _telefone;
  late TextEditingController _cidade;
  late bool _ativo;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: widget.cliente.nome);
    _email = TextEditingController(text: widget.cliente.email);
    _telefone = TextEditingController(text: widget.cliente.telefone);
    _cidade = TextEditingController(text: widget.cliente.cidade);
    _ativo = widget.cliente.ativo;
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _cidade.dispose();
    super.dispose();
  }

  void _save() {
    final updated = Cliente(
      nome: _nome.text.trim(),
      email: _email.text.trim(),
      telefone: _telefone.text.trim(),
      cidade: _cidade.text.trim(),
      ativo: _ativo,
      dataCadastro: widget.cliente.dataCadastro ?? DateTime.now(),
    );

    Navigator.of(context).pop(updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => DeleteConfirmationPage(cliente: widget.cliente)),
    );

    if (confirmed == true) {
      // signal deletion by returning a Cliente with empty name
      Navigator.of(context).pop(Cliente(nome: '', email: '', telefone: '', cidade: '', ativo: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: Row(children: const [Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54), SizedBox(width: 6), Text('Voltar para Clientes', style: TextStyle(color: Colors.black87)),])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              const Text('Editar Cliente', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Atualize as informações do cliente', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _LabeledField(label: 'Nome Completo *', child: TextFormField(controller: _nome, decoration: _inputDecoration())),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Email *', child: TextFormField(controller: _email, decoration: _inputDecoration())),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Telefone *', child: TextFormField(controller: _telefone, decoration: _inputDecoration())),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Cidade *', child: TextFormField(controller: _cidade, decoration: _inputDecoration())),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFFBECEC), borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Status do Cliente', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height: 4), Text('Cliente ativo no sistema', style: TextStyle(color: Colors.black54))]),
                        Switch(
                          value: _ativo,
                          onChanged: (v) => setState(() => _ativo = v),
                          activeColor: const Color(0xFF2E2E2E),
                          activeTrackColor: const Color(0xFFEFEFEF),
                          inactiveThumbColor: const Color(0xFF2E2E2E),
                          inactiveTrackColor: const Color(0xFFF1F1F1),
                        )
                      ]),
                    ),
                    const SizedBox(height: 18),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(children: [
                      OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close), label: const Text('Cancelar')),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Salvar Alterações'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                    ])
                  ]),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade100)),
                child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Zona de Perigo', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700, fontSize: 18)), const SizedBox(height: 6), const Text('Esta ação não pode ser desfeita. O cliente será permanentemente excluído.'), const SizedBox(height: 12), ElevatedButton(onPressed: _confirmDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Excluir Cliente'))])),
              ),
              const SizedBox(height: 36),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() => const InputDecoration(filled: true, fillColor: Color(0xFFF6F6F6), border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))), contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12));
}

class NewClientPage extends StatefulWidget {
  const NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _cidade = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _cidade.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final novo = Cliente(
      nome: _nome.text.trim(),
      email: _email.text.trim(),
      telefone: _telefone.text.trim(),
      cidade: _cidade.text.trim(),
      ativo: _ativo,
      dataCadastro: DateTime.now(),
    );
    Navigator.of(context).pop(novo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: Row(children: const [Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54), SizedBox(width: 6), Text('Voltar para Clientes', style: TextStyle(color: Colors.black87)),])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              const Text('Novo Cliente', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Preencha as informações para cadastrar um novo cliente', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _LabeledField(label: 'Nome Completo *', child: TextFormField(controller: _nome, decoration: _inputDecoration(hint: 'Digite o nome completo'))),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Email *', child: TextFormField(controller: _email, decoration: _inputDecoration(hint: 'exemplo@email.com'))),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Telefone *', child: TextFormField(controller: _telefone, decoration: _inputDecoration(hint: '(00) 00000-0000'))),
                    const SizedBox(height: 12),
                    _LabeledField(label: 'Cidade *', child: TextFormField(controller: _cidade, decoration: _inputDecoration(hint: 'Cidade - UF'))),
                    const SizedBox(height: 18),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(children: [
                      OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close), label: const Text('Cancelar')),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(onPressed: _cadastrar, icon: const Icon(Icons.save), label: const Text('Cadastrar Cliente'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                    ])
                  ]),
                ),
              ),
              const SizedBox(height: 36),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(filled: true, fillColor: const Color(0xFFF6F6F6), hintText: hint, border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8))), contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12));
}

class DeleteConfirmationPage extends StatelessWidget {
  final Cliente cliente;
  const DeleteConfirmationPage({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep top bar and use pink/red background behind the modal (like the attached image)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        title: Row(
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services_outlined, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Pharma',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  'IA',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Início')),
            TextButton(onPressed: () {}, child: const Text('Dashboard')),
            TextButton(onPressed: () {}, child: const Text('Clientes')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Acessar plataforma')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Fale com a gente')),
          ],
        ),
      ),
      // Use soft red/pink background to match design
      backgroundColor: const Color(0xFFFBECEC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFEBEB)),
                  child: const Icon(Icons.error_outline, size: 34, color: Colors.red),
                ),
                const SizedBox(height: 12),
                const Text('Confirmar Exclusão', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text('Tem certeza que deseja excluir o cliente ${cliente.nome}?', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const Text('Esta ação não pode ser desfeita. Todos os dados do cliente serão permanentemente removidos do sistema.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFBECEC), borderRadius: BorderRadius.circular(8)), child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Nome:'), Text(cliente.nome)]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Email:'), Text(cliente.email)]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Cidade:'), Text(cliente.cidade)]),
                ])),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Sim, Excluir Cliente'))
                ]),
                const SizedBox(height: 8),
                const Text('Pressione ESC ou clique em Cancelar para voltar sem excluir', style: TextStyle(fontSize: 12, color: Colors.black45))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
