import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';
import 'table_all_employees_demo.dart';

class _Employee {
  const _Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.email,
  });

  final String id;
  final String name;
  final String role;
  final String status;
  final String email;
}

class _TreeNode {
  const _TreeNode({
    required this.id,
    required this.name,
    required this.type,
    required this.modified,
    this.children = const [],
  });

  final String id;
  final String name;
  final String type;
  final String modified;
  final List<_TreeNode> children;
}

class TableShowcasePage extends StatefulWidget {
  const TableShowcasePage({super.key});

  @override
  State<TableShowcasePage> createState() => _TableShowcasePageState();
}

class _TableShowcasePageState extends State<TableShowcasePage> {
  static const _employees = [
    _Employee(
      id: '1',
      name: 'Kate Moore',
      role: 'CEO',
      status: 'Active',
      email: 'kate@acme.com',
    ),
    _Employee(
      id: '2',
      name: 'John Smith',
      role: 'CTO',
      status: 'Active',
      email: 'john@acme.com',
    ),
    _Employee(
      id: '3',
      name: 'Sara Johnson',
      role: 'CMO',
      status: 'On Leave',
      email: 'sara@acme.com',
    ),
    _Employee(
      id: '4',
      name: 'Michael Brown',
      role: 'CFO',
      status: 'Active',
      email: 'michael@acme.com',
    ),
  ];

  static const _sortEmployees = [
    _Employee(
      id: 'e1',
      name: 'Emily Davis',
      role: 'Product Manager',
      status: 'Inactive',
      email: 'emily@acme.com',
    ),
    _Employee(
      id: 'e2',
      name: 'John Smith',
      role: 'CTO',
      status: 'Active',
      email: 'john@acme.com',
    ),
    _Employee(
      id: 'e3',
      name: 'Kate Moore',
      role: 'CEO',
      status: 'Active',
      email: 'kate@acme.com',
    ),
    _Employee(
      id: 'e4',
      name: 'Michael Brown',
      role: 'CFO',
      status: 'Active',
      email: 'michael@acme.com',
    ),
    _Employee(
      id: 'e5',
      name: 'Sara Johnson',
      role: 'CMO',
      status: 'On Leave',
      email: 'sara@acme.com',
    ),
  ];

  static const _treeRoots = [
    _TreeNode(
      id: 'docs',
      name: 'Documents',
      type: 'Directory',
      modified: '2024-01-10',
      children: [
        _TreeNode(
          id: 'project',
          name: 'Project',
          type: 'Directory',
          modified: '2024-02-01',
          children: [
            _TreeNode(
              id: 'report',
              name: 'Weekly Report',
              type: 'File',
              modified: '2024-02-15',
            ),
            _TreeNode(
              id: 'budget',
              name: 'Budget',
              type: 'File',
              modified: '2024-02-14',
            ),
          ],
        ),
      ],
    ),
    _TreeNode(
      id: 'photos',
      name: 'Photos',
      type: 'Directory',
      modified: '2024-01-05',
      children: [],
    ),
  ];

  static final _virtualEmployees = List.generate(
    80,
    (i) => _Employee(
      id: 'v$i',
      name: 'Person $i',
      role: i.isEven ? 'Engineer' : 'Designer',
      email: 'person$i@acme.com',
      status: i % 3 == 0 ? 'On Leave' : 'Active',
    ),
  );

  Set<Object> _selected = {};
  HUFTableSortDescriptor? _sort;
  Set<Object> _expanded = {'docs', 'project'};
  int _page = 1;

  List<HUFTableColumn<_Employee>> get _employeeColumns => [
        const HUFTableColumn(
          key: 'name',
          label: 'Name',
          flex: 2,
          valueBuilder: _nameOf,
        ),
        const HUFTableColumn(
          key: 'role',
          label: 'Role',
          valueBuilder: _roleOf,
        ),
        const HUFTableColumn(
          key: 'status',
          label: 'Status',
          valueBuilder: _statusOf,
        ),
        const HUFTableColumn(
          key: 'email',
          label: 'Email',
          flex: 2,
          allowsSorting: true,
          valueBuilder: _emailOf,
        ),
      ];

  static String _nameOf(_Employee e) => e.name;
  static String _roleOf(_Employee e) => e.role;
  static String _statusOf(_Employee e) => e.status;
  static String _emailOf(_Employee e) => e.email;

  HUFTableStatusTone _toneFor(String status) {
    return switch (status) {
      'Active' => HUFTableStatusTone.active,
      'Inactive' => HUFTableStatusTone.inactive,
      'On Leave' => HUFTableStatusTone.onLeave,
      _ => HUFTableStatusTone.custom,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hufTheme.colors;
    final paged = _employees.sublist(0, 4);

    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Table'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Esempio pratico · All Employees'),
          const Text(
            'Toolbar con chip conteggio, filtri, ordinamento, colonne visibili '
            'e ricerca — tutti collegati alla tabella sottostante.',
            style: TextStyle(height: 1.45),
          ),
          const SizedBox(height: 20),
          const TableAllEmployeesDemo(),
          const SizedBox(height: 48),
          const ShowcaseSectionTitle('Primary · dati base'),
          HUFTable<_Employee>(
            columns: _employeeColumns,
            rows: _employees,
            rowKey: (e) => e.id,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Secondary'),
          HUFTable<_Employee>(
            variant: HUFTableVariant.secondary,
            columns: _employeeColumns,
            rows: _employees,
            rowKey: (e) => e.id,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Selezione multipla'),
          HUFTable<_Employee>(
            columns: _employeeColumns,
            rows: _employees,
            rowKey: (e) => e.id,
            selectionMode: HUFTableSelectionMode.multiple,
            selectedKeys: _selected,
            onSelectionChanged: (keys) => setState(() => _selected = keys),
            showSelectionSummary: true,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Stato vuoto'),
          HUFTable<_Employee>(
            columns: _employeeColumns,
            rows: const [],
            rowKey: (e) => e.id,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Ordinamento'),
          HUFTable<_Employee>(
            columns: _employeeColumns,
            rows: _sortEmployees,
            rowKey: (e) => e.id,
            sortDescriptor: _sort,
            onSortChange: (d) => setState(() => _sort = d),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Celle custom'),
          HUFTable<_Employee>(
            selectionMode: HUFTableSelectionMode.multiple,
            selectedKeys: _selected,
            onSelectionChanged: (keys) => setState(() => _selected = keys),
            columns: [
              const HUFTableColumn(
                key: 'id',
                label: 'Worker ID',
                flex: 2,
                cellBuilder: _workerIdCell,
              ),
              HUFTableColumn(
                key: 'member',
                label: 'Member',
                flex: 3,
                allowsSorting: true,
                cellBuilder: (context, row) => Row(
                  children: [
                    HUFAvatar(
                      initials: row.name
                          .split(' ')
                          .map((p) => p[0])
                          .take(2)
                          .join(),
                      size: HUFAvatarSize.small,
                      color: HUFAvatarColor.accent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.name,
                            style: TextStyle(
                              color: colors.cardForeground,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            row.email,
                            style: TextStyle(
                              color: colors.cardMutedForeground,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              HUFTableColumn(
                key: 'role',
                label: 'Role',
                valueBuilder: _roleOf,
              ),
              HUFTableColumn(
                key: 'status',
                label: 'Status',
                cellBuilder: (context, row) => HUFTableStatusBadge(
                  label: row.status,
                  tone: _toneFor(row.status),
                ),
              ),
              HUFTableColumn(
                key: 'actions',
                label: '',
                flex: 1,
                minWidth: 48,
                cellBuilder: (context, row) => Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: colors.cardForeground,
                    ),
                  ),
                ),
              ),
            ],
            rows: _sortEmployees.take(4).toList(),
            rowKey: (e) => e.id,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Righe espandibili'),
          HUFTable<_TreeNode>(
            columns: const [
              HUFTableColumn(
                key: 'name',
                label: 'Name',
                flex: 2,
                isTreeColumn: true,
                valueBuilder: _treeName,
              ),
              HUFTableColumn(
                key: 'type',
                label: 'Type',
                valueBuilder: _treeType,
              ),
              HUFTableColumn(
                key: 'modified',
                label: 'Date Modified',
                flex: 2,
                valueBuilder: _treeModified,
              ),
            ],
            rows: _treeRoots,
            rowKey: (n) => n.id,
            childrenOf: (n) => n.children,
            expandedKeys: _expanded,
            onExpandedChange: (keys) => setState(() => _expanded = keys),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Paginazione'),
          HUFTable<_Employee>(
            columns: _employeeColumns,
            rows: paged,
            rowKey: (e) => e.id,
            footer: HUFTablePaginationFooter(
              currentPage: _page,
              totalPages: 2,
              totalItems: 8,
              pageSize: 4,
              onPageChanged: (p) => setState(() => _page = p),
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Virtualizzazione · zebra'),
          HUFTable<_Employee>(
            columns: _employeeColumns
                .where((c) => c.key != 'status')
                .toList(),
            rows: _virtualEmployees,
            rowKey: (e) => e.id,
            striped: true,
            maxBodyHeight: 280,
          ),
        ],
      ),
    );
  }

  static String _treeName(_TreeNode n) => n.name;
  static String _treeType(_TreeNode n) => n.type;
  static String _treeModified(_TreeNode n) => n.modified;

  static Widget _workerIdCell(BuildContext context, _Employee row) {
    final colors = context.hufTheme.colors;
    return Row(
      children: [
        Text(
          '#${row.id.padLeft(7, '0')}',
          style: TextStyle(
            color: colors.cardForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: row.id));
          },
          icon: Icon(
            Icons.copy_outlined,
            size: 18,
            color: colors.cardMutedForeground,
          ),
        ),
      ],
    );
  }
}
