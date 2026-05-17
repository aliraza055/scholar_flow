import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_flow/Services/firebase_services.dart';
import 'package:scholar_flow/Services/students.services.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';

class ManageStudentsPage extends StatelessWidget {
  ManageStudentsPage({super.key});

  final StudentServices _studentServices = StudentServices();
  final FirebaseServices _firebaseServices = FirebaseServices();

  // ── Avatar color cycle (same palette as AttendanceScreen) ────────────────
  Color _avatarColor(int index) {
    const colors = [
      Color(0xFF3B7DD8),
      Color(0xFF7C5CBF),
      Color(0xFF0F9E7B),
      Color(0xFFD4522A),
      Color(0xFF1A8FA8),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentServices.getAllStudents(),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final students = (!isLoading && snapshot.hasData)
              ? snapshot.data!.docs
              : [];
          final total = students.length;

          return Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              _buildHeader(context, total),
              const SizedBox(height: 8),

              // ── Student List ─────────────────────────────────────────────
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1A73E8),
                          strokeWidth: 2.5,
                        ),
                      )
                    : students.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        physics: const BouncingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final doc = students[index];
                          final data = doc.data() as Map<String, dynamic>;
                          return _StudentCard(
                            key: ValueKey(doc.id),
                            docId: doc.id,
                            data: data,
                            index: index,
                            avatarColor: _avatarColor(index),
                            studentServices: _studentServices,
                            onEdit: () =>
                                _showEditDialog(context, doc.id, data),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: const Color(0xFF1A3A6E),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.person_add_rounded, size: 20),
        label: const Text(
          'Add Student',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2041), Color(0xFF1A3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon + back button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  // Icon badge
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'Manage Students',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Add, edit or remove students from your class.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              // Stats row
              Row(
                children: [
                  _HeaderStat(
                    label: 'Total',
                    value: '$total',
                    icon: Icons.people_rounded,
                  ),
                  const SizedBox(width: 10),
                  _HeaderStat(
                    label: 'Enrolled',
                    value: '$total',
                    icon: Icons.school_rounded,
                    valueColor: const Color(0xFF4ADE80),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF1A73E8).withOpacity(0.15),
              ),
            ),
            child: const Icon(
              Icons.person_off_rounded,
              size: 36,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No students found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap "Add Student" to enroll your first student.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // ── Add Dialog ────────────────────────────────────────────────────────────

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final semController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => _StudentDialog(
        title: 'Add Student',
        nameController: nameController,
        rollController: rollController,
        semController: semController,
        confirmLabel: 'Add',
        confirmColor: const Color(0xFF1A3A6E),
        onConfirm: () async {
          if (nameController.text.isNotEmpty ||
              rollController.text.isNotEmpty ||
              semController.text.isNotEmpty) {
            FirebaseServices().uploadStudent(
              context,
              name: nameController.text,
              rollNo: rollController.text,
              semester: semController.text,
            );
          } else {
            ToastError().showToast(
              message: 'please fulfil the data ',
              bgColor: Colors.red,
            );
          }
        },
      ),
    );
  }

  // ── Edit Dialog ───────────────────────────────────────────────────────────

  void _showEditDialog(
    BuildContext context,
    String studentId,
    Map<String, dynamic> data,
  ) {
    final nameController = TextEditingController(text: data['name']);
    final rollController = TextEditingController(text: data['rollNo']);
    final semController = TextEditingController(
      text: data['semester']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => _StudentDialog(
        title: 'Edit Student',
        nameController: nameController,
        rollController: rollController,
        semController: semController,
        confirmLabel: 'Update',
        confirmColor: const Color(0xFF1A3A6E),
        onConfirm: () async {
          await _studentServices.updateStudent(studentId, {
            'name': nameController.text.trim(),
            'rollNo': rollController.text.trim(),
            'semester': semController.text.trim(),
          });

          Navigator.pop(context);
          ToastError().showToast(
            message: 'Student updated successfully!',
            bgColor: Colors.green,
          );
        },
      ),
    );
  }
}

// ── Student Card ──────────────────────────────────────────────────────────────

class _StudentCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  final int index;
  final Color avatarColor;
  final StudentServices studentServices;
  final VoidCallback onEdit;

  const _StudentCard({
    super.key,
    required this.docId,
    required this.data,
    required this.index,
    required this.avatarColor,
    required this.studentServices,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? '';
    final rollNo = data['rollNo'] ?? '';
    final semester = data['semester']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────────
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [avatarColor, avatarColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Name + Roll ──────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D1B2A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Roll: $rollNo  •  Sem: $semester',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Actions menu ─────────────────────────────────────────────
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  _confirmDelete(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 8,
              color: Colors.white,
              icon: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Color(0xFF1A3A6E),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D1B2A),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_rounded,
                        size: 16,
                        color: Color(0xFFEF4444),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Student',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0D1B2A),
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${data['name']}" from the class?',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await studentServices.deleteStudent(docId);
              ToastError().showToast(
                message: 'Student deleted',
                bgColor: Colors.red,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header Stat Widget ────────────────────────────────────────────────────────

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _HeaderStat({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.7)),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Student Dialog ───────────────────────────────────────────────────

class _StudentDialog extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController rollController;
  final TextEditingController semController;
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _StudentDialog({
    required this.title,
    required this.nameController,
    required this.rollController,
    required this.semController,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Dialog header ────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: confirmColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    confirmLabel == 'Add'
                        ? Icons.person_add_rounded
                        : Icons.edit_rounded,
                    size: 20,
                    color: confirmColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Fields ───────────────────────────────────────────────────
            _StyledField(
              controller: nameController,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 14),
            _StyledField(
              controller: rollController,
              label: 'Roll No',
              icon: Icons.tag_rounded,
            ),
            const SizedBox(height: 14),
            _StyledField(
              controller: semController,
              label: 'Semester',
              icon: Icons.school_outlined,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // ── Actions ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Styled Text Field ─────────────────────────────────────────────────────────

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const _StyledField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0D1B2A),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A3A6E), width: 1.5),
        ),
      ),
    );
  }
}
