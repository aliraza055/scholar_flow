import 'package:flutter/material.dart';
import 'package:scholar_flow/Constants/app_theme.dart';
import 'package:scholar_flow/Services/marks_services.dart';

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

  // Tumhare subjects — apne hisaab se change karo
  final List<String> _subjects = [
    'Principal of Psychology',
    'SQA',
    'Game Programming',
    'Newtork Security',
  ];
  String _selectedSubject = 'Game Programming';
  Future<void> _save() async {
    final mid = double.tryParse(_midCtrl.text);
    final fin = double.tryParse(_finalCtrl.text);

    if (mid == null || fin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Valid marks enter karo')));
      return;
    }
    if (mid > 100 || fin > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks 100 se zyada nahi ho sakti')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks added Successfully! ')),
      );
      _midCtrl.clear();
      _finalCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.studentName),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subject dropdown ──
            const Text('Subject'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubject,
                  isExpanded: true,
                  items: _subjects
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSubject = val!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Midterm ──
            const Text(
              'Midterm Marks (out of 100)',
              //style: ,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _midCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0 - 100',
                filled: true,
                //  fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Final ──
            const Text(
              'Final Marks (out of 100)',
              //   style: AppTheme.headingMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _finalCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0 - 100',
                filled: true,
                //   fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Save button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  //    backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Marks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Existing marks list ──
            const Text('Saved Marks'),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: _marksService.getMarksStream(widget.studentId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('Koi marks nahi hain abhi'),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final d = docs[i].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(d['subject'] ?? ''),
                        subtitle: Text(
                          'Mid: ${d['midterm']}  Final: ${d['final']}  Total: ${d['total']}',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            d['grade'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
