import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scholar_flow/Models/marks_model.dart';
import 'package:scholar_flow/Services/marks_services.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';

class AddMarksPage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const AddMarksPage({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<AddMarksPage> createState() => _AddMarksPageState();
}

class _AddMarksPageState extends State<AddMarksPage> {
  final _marksService = MarksService();
  final _midCtrl = TextEditingController();
  final _finalCtrl = TextEditingController();
  bool _isLoading = false;

  final List<String> _subjects = [
    'Principal of Psychology',
    'SQA',
    'Game Programming',
    'Network Security',
  ];
  String _selectedSubject = 'SQA';

  double? _previewTotal;
  String? _previewGrade;

  @override
  void initState() {
    super.initState();
    _midCtrl.addListener(_updatePreview);
    _finalCtrl.addListener(_updatePreview);
  }

  void _updatePreview() {
    final mid = double.tryParse(_midCtrl.text);
    final fin = double.tryParse(_finalCtrl.text);
    if (mid != null && fin != null) {
      final total = (mid * 0.4) + (fin * 0.6);
      setState(() {
        _previewTotal = total;
        _previewGrade = MarksModel.calculateGrade(total);
      });
    } else {
      setState(() {
        _previewTotal = null;
        _previewGrade = null;
      });
    }
  }

  @override
  void dispose() {
    _midCtrl.dispose();
    _finalCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final mid = double.tryParse(_midCtrl.text);
    final fin = double.tryParse(_finalCtrl.text);

    if (mid == null || fin == null) {
      ToastError().showToast(
        message: 'Enter Valid Marks!',
        bgColor: Colors.red,
      );
      return;
    }
    if (mid > 100 || fin > 100) {
      ToastError().showToast(
        message: 'Marks cannot be more than 100!',
        bgColor: Colors.red.shade500,
      );
      return;
    }

    setState(() => _isLoading = true);

    await _marksService.saveMarks(
      studentId: widget.studentId,
      subject: _selectedSubject,
      midterm: mid,
      finalMarks: fin,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ToastError().showToast(
        message: 'Marks Saved Successfully!',
        bgColor: Colors.green,
      );
      _midCtrl.clear();
      _finalCtrl.clear();
    }
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return const Color(0xFF10B981);
      case 'B+':
      case 'B':
        return const Color(0xFF1A73E8);
      case 'C+':
      case 'C':
        return const Color(0xFFF59E0B);
      case 'D':
        return const Color(0xFFEF8C2B);
      default:
        return const Color(0xFFEF4444);
    }
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
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _buildHeader(context),

          // ── Scrollable Body ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Subject Dropdown ────────────────────────────────────
                  _SectionLabel(text: 'Select Subject'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE8ECF4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubject,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D1B2A),
                        ),
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A3A6E).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF1A3A6E),
                            size: 18,
                          ),
                        ),
                        items: _subjects
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedSubject = val!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Marks Input ─────────────────────────────────────────
                  _SectionLabel(text: 'Enter Marks'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MarksInputCard(
                          label: 'Midterm',
                          weight: '40%',
                          hint: '0–100',
                          controller: _midCtrl,
                          accentColor: const Color(0xFF1A3A6E),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _MarksInputCard(
                          label: 'Final',
                          weight: '60%',
                          hint: '0–100',
                          controller: _finalCtrl,
                          accentColor: const Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),

                  // ── Grade Preview ───────────────────────────────────────
                  if (_previewTotal != null && _previewGrade != null) ...[
                    const SizedBox(height: 14),
                    _GradePreviewCard(
                      total: _previewTotal!,
                      grade: _previewGrade!,
                      gradeColor: _gradeColor(_previewGrade!),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ── Save Button ─────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3A6E),
                        disabledBackgroundColor: const Color(
                          0xFF1A3A6E,
                        ).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Save Marks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Saved Marks Header ──────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F2041), Color(0xFF1A3A6E)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Saved Marks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D1B2A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Saved Marks Stream ──────────────────────────────────
                  StreamBuilder(
                    stream: _marksService.getMarksStream(widget.studentId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A3A6E),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE8ECF4)),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 42,
                                  color: Color(0xFFB0BEC5),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No marks saved yet',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final d = doc.data() as Map<String, dynamic>;
                          return _SavedMarkCard(
                            data: d,
                            gradeColor: _gradeColor(d['grade'] ?? 'F'),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
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
              // Top row: back button + icon badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                'Add Marks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.studentName,
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
                    label: 'Midterm',
                    value: '40%',
                    icon: Icons.history_edu_rounded,
                  ),
                  const SizedBox(width: 10),
                  _HeaderStat(
                    label: 'Final',
                    value: '60%',
                    icon: Icons.school_rounded,
                    valueColor: const Color(0xFF818CF8),
                  ),
                  const SizedBox(width: 10),
                  _HeaderStat(
                    label: 'Pass',
                    value: '≥50%',
                    icon: Icons.check_circle_outline_rounded,
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
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
        letterSpacing: 0.4,
      ),
    );
  }
}

// ── Header Stat ───────────────────────────────────────────────────────────────

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
                    fontSize: 14,
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

// ── Marks Input Card ──────────────────────────────────────────────────────────

class _MarksInputCard extends StatelessWidget {
  final String label;
  final String weight;
  final String hint;
  final TextEditingController controller;
  final Color accentColor;

  const _MarksInputCard({
    required this.label,
    required this.weight,
    required this.hint,
    required this.controller,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1B2A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  weight,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: -0.5,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: accentColor.withOpacity(0.2),
                letterSpacing: -0.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grade Preview Card ────────────────────────────────────────────────────────

class _GradePreviewCard extends StatelessWidget {
  final double total;
  final String grade;
  final Color gradeColor;

  const _GradePreviewCard({
    required this.total,
    required this.grade,
    required this.gradeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPassing = total >= 50;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradeColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gradeColor.withOpacity(0.25), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projected Grade',
                  style: TextStyle(
                    fontSize: 11,
                    color: gradeColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Total: ${total.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: gradeColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPassing ? 'Pass ✓' : 'Fail ✗',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: gradeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Saved Mark Card ───────────────────────────────────────────────────────────

class _SavedMarkCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color gradeColor;

  const _SavedMarkCard({required this.data, required this.gradeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: Row(
        children: [
          // Grade badge
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                data['grade'] ?? 'F',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Subject + chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['subject'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B2A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MarkChip(label: 'Mid', value: '${data['midterm'] ?? 0}'),
                    const SizedBox(width: 6),
                    _MarkChip(label: 'Final', value: '${data['final'] ?? 0}'),
                    const SizedBox(width: 6),
                    _MarkChip(
                      label: 'Total',
                      value: '${data['total'] ?? 0}%',
                      highlight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mark Chip ─────────────────────────────────────────────────────────────────

class _MarkChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MarkChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFF1A3A6E).withOpacity(0.08)
            : const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: highlight ? const Color(0xFF1A3A6E) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
