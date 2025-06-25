import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:pb_lms/views/user_screen/bread_crumb/bread_crumb_course.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AssignmentScreen extends StatefulWidget {
  final int assignmentId;
  const AssignmentScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _submissionLinkController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  Map<String, dynamic>? _submittedAssignment;
  bool _submissionChecked = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StudentProvider>(context, listen: false);
    provider.getSubmittedAssignment(widget.assignmentId);
    _loadSubmittedAssignment();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _submissionLinkController.dispose();
    super.dispose();
  }

  Future<void> _loadSubmittedAssignment() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    try {
      final response = await provider.getSubmittedAssignment(
        widget.assignmentId,
      );
      if (response['status']) {
        setState(() {
          _submittedAssignment = response['submission'];
          _contentController.text = _submittedAssignment!['content'] ?? '';
          _submissionLinkController.text =
              _submittedAssignment!['submissionLink'] ?? '';
        });
      }
    } catch (e) {
      print('No submission found: $e');
    } finally {
      setState(() {
        _submissionChecked = true;
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final provider = Provider.of<StudentProvider>(context, listen: false);

    try {
      final result = await provider.submitAssignment(
        _contentController.text.trim(),
        _submissionLinkController.text.trim(),
        widget.assignmentId,
      );

      if (result['status']) {
        setState(() {
          _submittedAssignment = result['submission'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Assignment submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception(result['message'] ?? 'Submission failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildSubmissionForm() {
    final provider = Provider.of<StudentProvider>(context);
    final bool isReadOnly = _submittedAssignment != null && _submissionChecked;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           isReadOnly? 'Your Assignment' : 'Submit Your Assignment',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Content Text Area
          Text(
            'Assignment Content',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          provider.isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : TextFormField(
                  controller: _contentController,
                  maxLines: 6,
                  readOnly: isReadOnly,
                  decoration: InputDecoration(
                    hintText: 'Enter your assignment content here...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter assignment content';
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 16),

          // Submission Link
          Text(
            'Submission Link (Optional)',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          provider.isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : TextFormField(
                  controller: _submissionLinkController,
                  readOnly: isReadOnly,
                  decoration: InputDecoration(
                    hintText: 'https://example.com/your-project',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.link, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasAbsolutePath) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 24),

          // Submit Button
          if (!isReadOnly)
            provider.isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitAssignment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(12, 201, 70, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Submitting...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Submit Assignment',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
        ],
      ),
    );
  }

  Widget _buildSubmissionStatus() {
    if (!_submissionChecked || _submittedAssignment == null) return Container();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Assignment Submitted',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${_submittedAssignment!['status']?.toString().toUpperCase() ?? 'UNKNOWN'}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
          if (_submittedAssignment!['submittedAt'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Submitted on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(_submittedAssignment!['submittedAt']))}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.green[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final assignment = provider.selectedAssignment!;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const BreadCrumb(), // Fixed at the top
            Text(
              'Assignment Submission',
              style: GoogleFonts.poppins(
                fontSize: TextStyles.headingLarge(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            // The rest of the content scrolls
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.isLoading
                        ? Shimmer.fromColors(
                            period: const Duration(seconds: 3),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 44,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        : Wrap(
                            runSpacing: 10,
                            children: [
                              Text(
                                'Find Details for the assignment ',
                                style: GoogleFonts.poppins(),
                              ),
                              Text(
                                '${assignment.title}',
                                style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 10),
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(assignment.description ?? ''),
                    const SizedBox(height: 12),
                    _buildSubmissionStatus(),
                    _buildSubmissionForm(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
