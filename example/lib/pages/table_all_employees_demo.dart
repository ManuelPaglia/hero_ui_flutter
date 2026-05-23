import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

/// Modello dipendente per l'esempio "All Employees".
class TableEmployee {
  const TableEmployee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.workerType,
    this.avatarColor = HUFAvatarColor.accent,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String workerType;
  final HUFAvatarColor avatarColor;
}

/// Dashboard tabella dipendenti con toolbar (filtri, sort, colonne, ricerca).
class TableAllEmployeesDemo extends StatefulWidget {
  const TableAllEmployeesDemo({super.key});

  @override
  State<TableAllEmployeesDemo> createState() => _TableAllEmployeesDemoState();
}

class _TableAllEmployeesDemoState extends State<TableAllEmployeesDemo> {
  static const _workerTypes = ['Employee', 'Contractor', 'Intern'];

  static const _columnKeys = {
    'id': 'Worker ID',
    'member': 'Member',
    'role': 'Role',
    'workerType': 'Worker Type',
    'actions': 'Actions',
  };

  static final List<TableEmployee> _seedEmployees = [
    const TableEmployee(
      id: '4586936',
      name: 'Alex Turner',
      email: 'alex@acme.com',
      role: 'Product Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586937',
      name: 'Emily Davis',
      email: 'emily@acme.com',
      role: 'Designer',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586938',
      name: 'John Smith',
      email: 'john@acme.com',
      role: 'CTO',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586939',
      name: 'Kate Moore',
      email: 'kate@acme.com',
      role: 'CEO',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586940',
      name: 'Sara Johnson',
      email: 'sara@acme.com',
      role: 'CMO',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.defaultColor,
    ),
    const TableEmployee(
      id: '4586941',
      name: 'Michael Brown',
      email: 'michael@acme.com',
      role: 'CFO',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586942',
      name: 'Oliver Johnson',
      email: 'oliver.johnson@acme.com',
      role: 'DevOps Engineer',
      workerType: 'Contractor',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586943',
      name: 'Isabella Johnson',
      email: 'isabella@acme.com',
      role: 'Marketing Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586944',
      name: 'Daniel Lee',
      email: 'daniel@acme.com',
      role: 'Backend Engineer',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586945',
      name: 'Sophia Chen',
      email: 'sophia@acme.com',
      role: 'Frontend Engineer',
      workerType: 'Intern',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586946',
      name: 'Liam Wilson',
      email: 'liam@acme.com',
      role: 'Sales Lead',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.defaultColor,
    ),
    const TableEmployee(
      id: '4586947',
      name: 'Mia Garcia',
      email: 'mia@acme.com',
      role: 'HR Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586948',
      name: 'Noah Martinez',
      email: 'noah@acme.com',
      role: 'Data Analyst',
      workerType: 'Contractor',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586949',
      name: 'Ava Robinson',
      email: 'ava@acme.com',
      role: 'UX Researcher',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586950',
      name: 'Ethan Clark',
      email: 'ethan@acme.com',
      role: 'Security Engineer',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586951',
      name: 'Charlotte Hall',
      email: 'charlotte@acme.com',
      role: 'Legal Counsel',
      workerType: 'Contractor',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586952',
      name: 'James Allen',
      email: 'james@acme.com',
      role: 'Support Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.defaultColor,
    ),
    const TableEmployee(
      id: '4586953',
      name: 'Amelia Young',
      email: 'amelia@acme.com',
      role: 'Content Strategist',
      workerType: 'Intern',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586954',
      name: 'Benjamin King',
      email: 'benjamin@acme.com',
      role: 'Finance Analyst',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586955',
      name: 'Harper Wright',
      email: 'harper@acme.com',
      role: 'QA Engineer',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586956',
      name: 'Lucas Scott',
      email: 'lucas@acme.com',
      role: 'Mobile Developer',
      workerType: 'Contractor',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586957',
      name: 'Evelyn Green',
      email: 'evelyn@acme.com',
      role: 'Operations Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586958',
      name: 'Henry Baker',
      email: 'henry@acme.com',
      role: 'IT Administrator',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.defaultColor,
    ),
    const TableEmployee(
      id: '4586959',
      name: 'Ella Adams',
      email: 'ella@acme.com',
      role: 'Product Designer',
      workerType: 'Intern',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586960',
      name: 'Jack Nelson',
      email: 'jack@acme.com',
      role: 'Account Executive',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586961',
      name: 'Scarlett Hill',
      email: 'scarlett@acme.com',
      role: 'Brand Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586962',
      name: 'Wyatt Campbell',
      email: 'wyatt@acme.com',
      role: 'Solutions Architect',
      workerType: 'Contractor',
      avatarColor: HUFAvatarColor.warning,
    ),
    const TableEmployee(
      id: '4586963',
      name: 'Grace Mitchell',
      email: 'grace@acme.com',
      role: 'People Partner',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.danger,
    ),
    const TableEmployee(
      id: '4586964',
      name: 'Leo Perez',
      email: 'leo@acme.com',
      role: 'Growth Manager',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.defaultColor,
    ),
    const TableEmployee(
      id: '4586965',
      name: 'Chloe Roberts',
      email: 'chloe@acme.com',
      role: 'Technical Writer',
      workerType: 'Intern',
      avatarColor: HUFAvatarColor.accent,
    ),
    const TableEmployee(
      id: '4586966',
      name: 'Mason Carter',
      email: 'mason@acme.com',
      role: 'Platform Engineer',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.success,
    ),
    const TableEmployee(
      id: '4586967',
      name: 'Zoey Phillips',
      email: 'zoey@acme.com',
      role: 'Customer Success',
      workerType: 'Employee',
      avatarColor: HUFAvatarColor.warning,
    ),
  ];

  late List<TableEmployee> _employees;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Set<String> _typeFilters = Set<String>.from(_workerTypes);
  Set<String> _visibleColumns = Set<String>.from(_columnKeys.keys);
  HUFTableSortDescriptor? _sort =
      const HUFTableSortDescriptor(columnKey: 'member', ascending: true);

  @override
  void initState() {
    super.initState();
    _employees = List<TableEmployee>.from(_seedEmployees);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TableEmployee> get _filteredEmployees {
    return _employees.where((employee) {
      if (_typeFilters.isNotEmpty &&
          !_typeFilters.contains(employee.workerType)) {
        return false;
      }
      if (_searchQuery.isEmpty) return true;
      final haystack =
          '${employee.id} ${employee.name} ${employee.email} ${employee.role} ${employee.workerType}'
              .toLowerCase();
      return haystack.contains(_searchQuery);
    }).toList();
  }

  void _toast(String title, {String? description, HUFAlertColor? color}) {
    context.showHufToast(
      options: HUFShowToastOptions(
        title: title,
        description: description,
        color: color ?? HUFAlertColor.defaultColor,
        durationSeconds: 2,
      ),
    );
  }

  void _copyId(TableEmployee employee) {
    Clipboard.setData(ClipboardData(text: employee.id));
    _toast('ID copiato', description: '#${employee.id}');
  }

  void _viewEmployee(TableEmployee employee) {
    _toast('Dettaglio dipendente', description: employee.name);
  }

  void _editEmployee(TableEmployee employee) {
    _toast(
      'Modifica in corso',
      description: employee.name,
      color: HUFAlertColor.accent,
    );
  }

  Future<void> _deleteEmployee(TableEmployee employee) async {
    final confirmed = await context.showHufAlertDialog<bool>(
      options: HUFShowAlertDialogOptions(
        icon: const Icon(Icons.delete_outline),
        color: HUFAlertColor.danger,
        title: 'Eliminare ${employee.name}?',
        description:
            'Il dipendente verrà rimosso dall\'elenco. Questa azione è irreversibile nella demo.',
        actions: [
          HUFButton(
            label: 'Annulla',
            variant: HUFButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          HUFButton(
            label: 'Elimina',
            variant: HUFButtonVariant.danger,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _employees.removeWhere((e) => e.id == employee.id);
    });
    _toast(
      'Dipendente eliminato',
      description: employee.name,
      color: HUFAlertColor.danger,
    );
  }

  Widget _filterPopoverContent() {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Worker type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.hufTheme.colors.cardForeground,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          HUFCheckboxGroup<String>(
            values: _typeFilters,
            onChanged: (values) => setState(() => _typeFilters = values),
            children: [
              for (final type in _workerTypes)
                HUFCheckbox(
                  optionValue: type,
                  label: type,
                  size: HUFCheckboxSize.small,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Nessuna voce selezionata = tutti i tipi',
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: context.hufTheme.colors.cardMutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortPopoverContent() {
    const sortKeys = ['member', 'role', 'id', 'workerType'];
    final current = _sort?.columnKey ?? 'member';

    return SizedBox(
      width: 200,
      child: HUFRadioButtonGroup<String>(
        value: current,
        onChanged: (key) {
          setState(() {
            final ascending = _sort?.columnKey == key
                ? !(_sort?.ascending ?? true)
                : true;
            _sort = HUFTableSortDescriptor(
              columnKey: key,
              ascending: ascending,
            );
          });
        },
        children: [
          for (final key in sortKeys)
            HUFRadioButton(
              optionValue: key,
              label: _columnKeys[key]!,
              size: HUFRadioButtonSize.small,
            ),
        ],
      ),
    );
  }

  Widget _columnsPopoverContent() {
    final toggleable = _columnKeys.keys.where((k) => k != 'actions');

    return SizedBox(
      width: 220,
      child: HUFCheckboxGroup<String>(
        values: _visibleColumns,
        onChanged: (keys) {
          final dataColumns = keys.where((k) => k != 'actions').toSet();
          if (dataColumns.isEmpty) return;
          setState(() {
            _visibleColumns = {...dataColumns, 'actions'};
          });
        },
        children: [
          for (final key in toggleable)
            HUFCheckbox(
              optionValue: key,
              label: _columnKeys[key]!,
              size: HUFCheckboxSize.small,
            ),
        ],
      ),
    );
  }

  List<HUFTableColumn<TableEmployee>> _buildColumns() {
    final colors = context.hufTheme.colors;
    final all = <HUFTableColumn<TableEmployee>>[
      HUFTableColumn(
        key: 'id',
        label: 'Worker ID',
        flex: 2,
        allowsSorting: true,
        valueBuilder: (e) => e.id,
        cellBuilder: (context, row) => _WorkerIdCell(
          employee: row,
          onCopy: () => _copyId(row),
        ),
      ),
      HUFTableColumn(
        key: 'member',
        label: 'Member',
        flex: 3,
        allowsSorting: true,
        valueBuilder: (row) => row.name,
        cellBuilder: (context, row) => _MemberCell(employee: row),
      ),
      HUFTableColumn(
        key: 'role',
        label: 'Role',
        flex: 2,
        allowsSorting: true,
        valueBuilder: _roleOf,
      ),
      HUFTableColumn(
        key: 'workerType',
        label: 'Worker Type',
        flex: 2,
        allowsSorting: true,
        valueBuilder: _workerTypeOf,
      ),
      HUFTableColumn(
        key: 'actions',
        label: '',
        flex: 2,
        minWidth: 120,
        alignment: Alignment.centerRight,
        cellBuilder: (context, row) => _ActionsCell(
          onView: () => _viewEmployee(row),
          onEdit: () => _editEmployee(row),
          onDelete: () => _deleteEmployee(row),
          foreground: colors.cardForeground,
          danger: colors.danger,
          surface: colors.cardSecondary,
          dangerSurface: colors.dangerSoft,
        ),
      ),
    ];

    return all.where((c) => _visibleColumns.contains(c.key)).toList();
  }

  static String _roleOf(TableEmployee e) => e.role;
  static String _workerTypeOf(TableEmployee e) => e.workerType;

  @override
  Widget build(BuildContext context) {
    final colors = context.hufTheme.colors;
    final filtered = _filteredEmployees;
    final totalCount = _employees.length;
    final filteredCount = filtered.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'All Employees',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.cardForeground,
                  ),
            ),
            const SizedBox(width: 12),
            HUFChip(
              label: '$filteredCount',
              size: HUFChipSize.small,
              variant: HUFChipVariant.outlined,
            ),
            if (filteredCount != totalCount) ...[
              const SizedBox(width: 8),
              Text(
                'di $totalCount',
                style: TextStyle(
                  color: colors.cardMutedForeground,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 720;
            final toolbarButtons = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                HUFButton(
                  label: 'Filter',
                  variant: HUFButtonVariant.secondary,
                  size: HUFButtonSize.medium,
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  popover: HUFButtonPopover(
                    showArrow: true,
                    child: _filterPopoverContent(),
                  ),
                ),
                HUFButton(
                  label: 'Sort',
                  variant: HUFButtonVariant.secondary,
                  size: HUFButtonSize.medium,
                  icon: Icon(
                    _sort?.ascending ?? true
                        ? Icons.sort_rounded
                        : Icons.sort_by_alpha_rounded,
                    size: 18,
                  ),
                  popover: HUFButtonPopover(
                    showArrow: true,
                    child: _sortPopoverContent(),
                  ),
                ),
                HUFButton(
                  label: 'Columns',
                  variant: HUFButtonVariant.secondary,
                  size: HUFButtonSize.medium,
                  icon: const Icon(Icons.view_column_outlined, size: 18),
                  popover: HUFButtonPopover(
                    showArrow: true,
                    child: _columnsPopoverContent(),
                  ),
                ),
              ],
            );

            final search = HUFInput(
              hintText: 'Search...',
              controller: _searchController,
              type: HUFInputType.text,
              icon: const Icon(Icons.search_rounded),
              clear: true,
              isFullWidth: true,
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  toolbarButtons,
                  const SizedBox(height: 12),
                  search,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: toolbarButtons),
                const SizedBox(width: 16),
                SizedBox(width: 280, child: search),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        HUFTable<TableEmployee>(
          columns: _buildColumns(),
          rows: filtered,
          rowKey: (e) => e.id,
          sortDescriptor: _sort,
          onSortChange: (descriptor) => setState(() => _sort = descriptor),
          emptyState: HUFTableEmptyState(
            message: _searchQuery.isNotEmpty || _typeFilters.length < 3
                ? 'No results found'
                : 'No employees yet',
          ),
        ),
      ],
    );
  }
}

class _WorkerIdCell extends StatelessWidget {
  const _WorkerIdCell({
    required this.employee,
    required this.onCopy,
  });

  final TableEmployee employee;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = context.hufTheme.colors;
    return Row(
      children: [
        Text(
          '#${employee.id}',
          style: TextStyle(
            color: colors.cardForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        HUFButton.iconOnly(
          icon: Icon(
            Icons.copy_outlined,
            size: 18,
            color: colors.cardMutedForeground,
          ),
          variant: HUFButtonVariant.ghost,
          size: HUFButtonSize.small,
          onPressed: onCopy,
        ),
      ],
    );
  }
}

class _MemberCell extends StatelessWidget {
  const _MemberCell({required this.employee});

  final TableEmployee employee;

  @override
  Widget build(BuildContext context) {
    final colors = context.hufTheme.colors;
    final initials = employee.name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    return Row(
      children: [
        HUFAvatar(
          initials: initials,
          size: HUFAvatarSize.small,
          color: employee.avatarColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.cardForeground,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                employee.email,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.cardMutedForeground,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsCell extends StatelessWidget {
  const _ActionsCell({
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.foreground,
    required this.danger,
    required this.surface,
    required this.dangerSurface,
  });

  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color foreground;
  final Color danger;
  final Color surface;
  final Color dangerSurface;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _ActionIconButton(
          icon: Icons.visibility_outlined,
          background: surface,
          foreground: foreground,
          onPressed: onView,
        ),
        const SizedBox(width: 8),
        _ActionIconButton(
          icon: Icons.edit_outlined,
          background: surface,
          foreground: foreground,
          onPressed: onEdit,
        ),
        const SizedBox(width: 8),
        _ActionIconButton(
          icon: Icons.delete_outline,
          background: dangerSurface,
          foreground: danger,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: foreground),
        ),
      ),
    );
  }
}
