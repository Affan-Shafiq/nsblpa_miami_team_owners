import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/theme.dart';
import '../../../services/firebase_service.dart';

import '../../../models/contract_model.dart';

class TeamContracts extends StatefulWidget {
  const TeamContracts({super.key});

  @override
  State<TeamContracts> createState() => _TeamContractsState();
}

class _TeamContractsState extends State<TeamContracts> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Players', 'Staff', 'Sponsorships', 'Active', 'Expired'];
  
  // Controllers for new contract form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  
  String _selectedType = 'player';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  
  bool _isRefreshing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  // Refresh contracts list
  Future<void> _refreshContracts() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Add a small delay to show refresh animation
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getTeamContracts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final contractDocs = snapshot.data?.docs ?? [];
        final contracts = contractDocs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Contract.fromJson(data);
        }).toList();

        if (contracts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No contracts available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Contract data will appear here once added by admin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                
              ],
            ),
          );
        }

        // Filter contracts based on selection
        List<Contract> filteredContracts = contracts;
        if (_selectedFilter == 'Players') {
          filteredContracts = contracts.where((c) => c.type == 'player').toList();
        } else if (_selectedFilter == 'Staff') {
          filteredContracts = contracts.where((c) => c.type == 'staff').toList();
        } else if (_selectedFilter == 'Sponsorships') {
          filteredContracts = contracts.where((c) => c.type == 'sponsorship').toList();
        } else if (_selectedFilter == 'Active') {
          filteredContracts = contracts.where((c) => c.status == 'active').toList();
        } else if (_selectedFilter == 'Expired') {
          filteredContracts = contracts.where((c) => c.status == 'expired').toList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team Contracts',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contract management for players, staff, and sponsorships',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _showAddContractDialog(context);
                    },
                    backgroundColor: AppTheme.primaryColor,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Filter and Refresh Row
              Row(
                children: [
                  Text(
                    'Filter by: ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: _filters.map((String filter) {
                      return DropdownMenuItem<String>(
                        value: filter,
                        child: Text(filter),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFilter = newValue;
                        });
                      }
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _isRefreshing ? null : _refreshContracts,
                    icon: _isRefreshing 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                    tooltip: 'Refresh contracts',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contract Stats
              Row(
                children: [
                  Expanded(
                    child: _buildContractStatCard(
                      context,
                      'Total Contract',
                      contracts.length.toString(),
                      Icons.description,
                      AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildContractStatCard(
                      context,
                      'Active Contract',
                      contracts.where((c) => c.status == 'active').length.toString(),
                      Icons.check_circle,
                      AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildContractStatCard(
                      context,
                      'Expired Contract',
                      contracts.where((c) => c.status == 'expired').length.toString(),
                      Icons.warning,
                      AppTheme.errorColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contracts List
              if (filteredContracts.isNotEmpty) ...[
                ...filteredContracts.map((contract) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getContractTypeColor(contract.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        contract.type == 'player' ? Icons.person : Icons.work,
                        color: _getContractTypeColor(contract.type),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      contract.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${contract.type.toUpperCase()} • ${contract.status.toUpperCase()}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          'Duration: ${_calculateDuration(contract.startDate, contract.endDate)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(contract.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        contract.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(contract.status),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildContractDetailRow(
                              contract.type == 'sponsorship' ? 'Sponsorship Type' : 'Position',
                              contract.position,
                              Icons.work,
                            ),
                            const SizedBox(height: 8),
                            _buildContractDetailRow(
                              'Annual Value',
                              currencyFormat.format(contract.salary),
                              Icons.attach_money,
                            ),
                            const SizedBox(height: 8),
                            _buildContractDetailRow(
                              'Start Date',
                              DateFormat('MMM dd, yyyy').format(contract.startDate),
                              Icons.calendar_today,
                            ),
                            const SizedBox(height: 8),
                            _buildContractDetailRow(
                              'End Date',
                              DateFormat('MMM dd, yyyy').format(contract.endDate),
                              Icons.event,
                            ),
                            const SizedBox(height: 16),
                            // Action buttons
                            if (contract.status == 'active') ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        _showTerminateContractDialog(context, contract);
                                      },
                                      icon: const Icon(Icons.cancel),
                                      label: const Text('Terminate Contract'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ] else ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No contracts found',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters or add a new contract',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildContractStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4, width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractDetailRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getContractTypeColor(String type) {
    switch (type) {
      case 'player':
        return AppTheme.primaryColor;
      case 'staff':
        return AppTheme.secondaryColor;
      case 'sponsorship':
        return AppTheme.accentColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.successColor;
      case 'expired':
        return AppTheme.errorColor;
      case 'pending':
        return AppTheme.warningColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    
    if (years > 0) {
      return months > 0 ? '$years year${years > 1 ? 's' : ''}, $months month${months > 1 ? 's' : ''}' : '$years year${years > 1 ? 's' : ''}';
    } else {
      return '$months month${months > 1 ? 's' : ''}';
    }
  }

  // Show dialog to add new contract
  void _showAddContractDialog(BuildContext context) {
    _nameController.clear();
    _positionController.clear();
    _salaryController.clear();
    _termsController.clear();
    _selectedType = 'player';
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 365));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contract'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _selectedType == 'sponsorship' ? 'Company Name' : 'Name',
                  hintText: _selectedType == 'sponsorship' ? 'Enter company name' : 'Enter person name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: _selectedType == 'sponsorship' ? 'Sponsorship Type' : 'Position',
                  hintText: _selectedType == 'sponsorship' ? 'Enter sponsorship type (e.g., Equipment, Venue, Media)' : 'Enter position/role',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Annual Value',
                  hintText: 'Enter annual value amount',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Contract Type',
                ),
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'player', child: Text('Player')),
                  DropdownMenuItem(value: 'staff', child: Text('Staff')),
                  DropdownMenuItem(value: 'sponsorship', child: Text('Sponsorship')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Start: ${DateFormat('MMM dd, yyyy').format(_startDate)}'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text('End: ${DateFormat('MMM dd, yyyy').format(_endDate)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _termsController,
                decoration: InputDecoration(
                  labelText: _selectedType == 'sponsorship' ? 'Sponsorship Details' : 'Contract Terms',
                  hintText: _selectedType == 'sponsorship' ? 'Enter sponsorship details, benefits, and obligations' : 'Enter contract terms and conditions',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addContract();
              Navigator.pop(context);
            },
            child: const Text('Add Contract'),
          ),
        ],
      ),
    );
  }

  // Add new contract to Firebase
  void _addContract() async {
    if (_nameController.text.isEmpty || 
        _positionController.text.isEmpty || 
        _salaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    try {
      final salary = double.tryParse(_salaryController.text);
      if (salary == null || salary <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid annual value amount'),
          ),
        );
        return;
      }

      final contract = Contract(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        position: _positionController.text,
        salary: salary,
        startDate: _startDate,
        endDate: _endDate,
        status: 'active',
        teamId: 'miami', // TODO: Get from AppConfig
      );

      await FirebaseService.addContract(contract);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contract added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding contract: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show dialog to terminate contract
  void _showTerminateContractDialog(BuildContext context, Contract contract) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminate Contract'),
        content: Text(
          'Are you sure you want to terminate the contract for ${contract.name}? '
          'This action will change the contract status to expired.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _terminateContract(contract.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminate Contract'),
          ),
        ],
      ),
    );
  }

  // Terminate contract by updating status
  void _terminateContract(String contractId) async {
    try {
      await FirebaseService.updateContractStatus(contractId, 'expired');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contract terminated successfully'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error terminating contract: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
