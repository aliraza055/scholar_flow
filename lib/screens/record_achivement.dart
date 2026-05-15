// import 'package:flutter/material.dart';

// class RecordAchievementPage extends StatefulWidget {
//   const RecordAchievementPage({super.key});

//   @override
//   State<RecordAchievementPage> createState() => _RecordAchievementPageState();
// }

// class _RecordAchievementPageState extends State<RecordAchievementPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             SizedBox(height: 22),
//             const Text(
//               "Record Achievement",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1D2939),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "Log new grades into the student registry with clarity and ease.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.blueGrey),
//             ),
//             const SizedBox(height: 30),

//             // Student Details Section
//             _buildInputCard(
//               icon: Icons.group_add,
//               iconBgColor: const Color(0xFFE0E0FF),
//               iconColor: const Color(0xFF6366F1),
//               title: "Student Details",
//               label: "STUDENT ROLL NUMBER",
//               hint: "e.g F22NDOCS1M1022",
//               suffixIcon: Icons.fingerprint,
//             ),

//             const SizedBox(height: 16),

//             // Assessment Info Section
//             _buildInputCard(
//               icon: Icons.assignment,
//               iconBgColor: const Color(0xFFE0F2FE),
//               iconColor: const Color(0xFF0EA5E9),
//               title: "Assessment Info",
//               label: "ASSIGNMENT / QUIZ TITLE",
//               hint: "Final Semester Research Paper",
//               suffixIcon: Icons.edit_document,
//             ),

//             const SizedBox(height: 16),

//             // Total Marks Section
//             _buildSimpleInputCard(
//               label: "TOTAL MARKS",
//               hint: "100",
//               suffixIcon: Icons.bar_chart,
//             ),

//             const SizedBox(height: 16),

//             // Obtained Marks Section
//             _buildSimpleInputCard(
//               label: "OBTAINED MARKS",
//               hint: "0",
//               suffixIcon: Icons.stars,
//               isUnderlined: true,
//             ),

//             const SizedBox(height: 30),

//             // Confirm Button
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
//                 label: const Text(
//                   "Confirm and Post Grade",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF006692),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),
//             const Text(
//               "Grades will be immediately visible in the student sanctuary dashboard.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper for Section Cards with Header Icons
//   Widget _buildInputCard({
//     required IconData icon,
//     required Color iconBgColor,
//     required Color iconColor,
//     required String title,
//     required String label,
//     required String hint,
//     required IconData suffixIcon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: iconBgColor,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: iconColor),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueGrey,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             decoration: InputDecoration(
//               hintText: hint,
//               filled: true,
//               fillColor: const Color(0xFFE5E9F0),
//               suffixIcon: Icon(suffixIcon, color: Colors.blueGrey, size: 20),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper for Simple Numeric Input Cards
//   Widget _buildSimpleInputCard({
//     required String label,
//     required String hint,
//     required IconData suffixIcon,
//     bool isUnderlined = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF006692),
//               letterSpacing: 0.5,
//             ),
//           ),
//           TextField(
//             style: const TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFD1D5DB),
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               suffixIcon: Icon(suffixIcon, color: const Color(0xFF006692)),
//               enabledBorder: isUnderlined
//                   ? const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue, width: 2),
//                     )
//                   : InputBorder.none,
//               focusedBorder: isUnderlined
//                   ? const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue, width: 2),
//                     )
//                   : InputBorder.none,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
  // AddMarksPage mein yeh list abhi bhi maujood hai ❌
  final List<String> _subjects = [
    'Principal of Psychology', // 👈 yahan se aa rahe hain
    'SQA',
    'Game Programming',
    'Network Security',
  ];
  String _selectedSubject = 'SQA';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Marks save ho gayi ✅')));
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
