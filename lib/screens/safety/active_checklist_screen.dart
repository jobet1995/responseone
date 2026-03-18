import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../models/checklist_model.dart';
import 'package:go_router/go_router.dart';

class ActiveChecklistScreen extends StatefulWidget {
  final String categoryId;

  const ActiveChecklistScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<ActiveChecklistScreen> createState() => _ActiveChecklistScreenState();
}

class _ActiveChecklistScreenState extends State<ActiveChecklistScreen> {
  late ChecklistCategory _category;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  void _loadChecklist() {
    // In a real app, this would come from a service or local DB
    final checklists = {
      'fire': ChecklistCategory(
        id: 'fire',
        title: 'Fire Evacuation',
        description: 'Critical steps for safety during a fire emergency.',
        colorValue: 0xFFFF9800, // Orange
        items: [
          ChecklistItem(id: 'f1', task: 'Assess the situation and call emergency services (e.g., 911).'),
          ChecklistItem(id: 'f2', task: 'Evacuate immediately if possible; do not stop for belongings.'),
          ChecklistItem(id: 'f3', task: 'Stay low to the ground to avoid smoke inhalation.'),
          ChecklistItem(id: 'f4', task: 'Check doors for heat with the back of your hand before opening.'),
          ChecklistItem(id: 'f5', task: 'Use stairs only; never use elevators during a fire.'),
          ChecklistItem(id: 'f6', task: 'Meet at a pre-designated safe assembly point outside.'),
        ],
      ),
      'flood': ChecklistCategory(
        id: 'flood',
        title: 'Flood Preparedness',
        description: 'Protect your home and family from rising water.',
        colorValue: 0xFF2196F3, // Blue
        items: [
          ChecklistItem(id: 'fl1', task: 'Move to higher ground immediately if flooding is imminent.'),
          ChecklistItem(id: 'fl2', task: 'Avoid walking or driving through floodwaters (Turn Around, Don\'t Drown).'),
          ChecklistItem(id: 'fl3', task: 'Disconnect electrical appliances to prevent shock/short circuits.'),
          ChecklistItem(id: 'fl4', task: 'Secure outdoor furniture and move valuables to upper floors.'),
          ChecklistItem(id: 'fl5', task: 'Ensure your emergency kit has clean water and non-perishable food.'),
          ChecklistItem(id: 'fl6', task: 'Stay informed via local weather alerts and news.'),
        ],
      ),
      'earthquake': ChecklistCategory(
        id: 'earthquake',
        title: 'Earthquake Safety',
        description: 'Protect yourself during and after seismic activity.',
        colorValue: 0xFF795548, // Brown
        items: [
          ChecklistItem(id: 'e1', task: 'Drop, Cover, and Hold On under sturdy furniture.'),
          ChecklistItem(id: 'e2', task: 'Stay away from windows, glass, and heavy furniture.'),
          ChecklistItem(id: 'e3', task: 'If indoors, stay inside until the shaking stops.'),
          ChecklistItem(id: 'e4', task: 'If outdoors, move to an open area away from buildings and power lines.'),
          ChecklistItem(id: 'e5', task: 'Be prepared for aftershocks; they can happen at any time.'),
          ChecklistItem(id: 'e6', task: 'Check for gas leaks and structural damage once the shaking stops.'),
        ],
      ),
    };

    setState(() {
      _category = checklists[widget.categoryId] ?? checklists['fire']!;
      _isLoading = false;
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _category.items[index].isCompleted = !_category.items[index].isCompleted;
    });
  }

  double get _progress {
    if (_category.items.isEmpty) return 0.0;
    final completedCount = _category.items.where((item) => item.isCompleted).length;
    return completedCount / _category.items.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Color primaryColor = Color(_category.colorValue);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_category.title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(primaryColor),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              itemCount: _category.items.length,
              itemBuilder: (context, index) {
                final item = _category.items[index];
                return _buildChecklistItem(item, index, primaryColor);
              },
            ),
          ),
          _buildFooter(primaryColor),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _category.description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(_progress * 100).toInt()}% COMPLETED',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '${_category.items.where((i) => i.isCompleted).length}/${_category.items.length} ITEMS',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, int index, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isCompleted ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCompleted ? color.withOpacity(0.3) : Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: ListTile(
        onTap: () => _toggleItem(index),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: item.isCompleted ? color : Colors.grey[400]!,
              width: 2,
            ),
            color: item.isCompleted ? color : Colors.transparent,
          ),
          child: Icon(
            Icons.check,
            size: 20,
            color: item.isCompleted ? Colors.white : Colors.transparent,
          ),
        ),
        title: Text(
          item.task,
          style: TextStyle(
            fontSize: 15,
            fontWeight: item.isCompleted ? FontWeight.w600 : FontWeight.normal,
            color: item.isCompleted ? AppTheme.textPrimary : AppTheme.textPrimary,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Color color) {
    if (_progress < 1.0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => context.pop(),
        child: const Text('CHECKLIST COMPLETED'),
      ),
    );
  }
}
