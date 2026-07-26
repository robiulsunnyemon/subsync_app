import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';

class InvoiceViewerView extends StatefulWidget {
  final String filePath;
  final String fileType; // 'pdf' or 'csv'

  const InvoiceViewerView({
    super.key,
    required this.filePath,
    required this.fileType,
  });

  @override
  State<InvoiceViewerView> createState() => _InvoiceViewerViewState();
}

class _InvoiceViewerViewState extends State<InvoiceViewerView> {
  int totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final bool isPdf = widget.fileType.toLowerCase() == 'pdf';

    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.tertiary,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isPdf ? 'Tax Invoice (PDF)' : 'Tax Report (CSV)',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new, color: AppColors.primary),
            tooltip: 'Open in external app',
            onPressed: () async {
              await OpenFile.open(widget.filePath);
            },
          ),
        ],
      ),
      body: isPdf ? _buildPdfView() : _buildCsvView(),
    );
  }

  Widget _buildPdfView() {
    return Stack(
      children: [
        PDFView(
          filePath: widget.filePath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: currentPage,
          fitPolicy: FitPolicy.BOTH,
          onRender: (pages) {
            setState(() {
              totalPages = pages ?? 0;
              isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              errorMessage = error.toString();
            });
          },
          onPageChanged: (page, total) {
            setState(() {
              currentPage = page ?? 0;
            });
          },
        ),
        if (!isReady && errorMessage.isEmpty)
          const Center(child: CircularProgressIndicator()),
        if (errorMessage.isNotEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Error loading PDF: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        if (isReady && totalPages > 0)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCsvView() {
    try {
      final File file = File(widget.filePath);
      if (!file.existsSync()) {
        return const Center(child: Text('CSV File not found.'));
      }

      final String content = file.readAsStringSync();
      final List<String> lines = content
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        return const Center(child: Text('CSV File is empty.'));
      }

      List<String> metaLines = [];
      List<String> tableHeaders = [];
      List<List<String>> dataRows = [];

      int headerIndex = -1;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains(',')) {
          final parts = lines[i].split(',');
          if (parts.length > 2) {
            headerIndex = i;
            tableHeaders = parts.map((e) => e.replaceAll('"', '').trim()).toList();
            break;
          }
        }
        metaLines.add(lines[i]);
      }

      if (headerIndex != -1) {
        for (int i = headerIndex + 1; i < lines.length; i++) {
          final rowParts = lines[i].split(',').map((e) => e.replaceAll('"', '').trim()).toList();
          if (rowParts.isNotEmpty && rowParts.any((element) => element.isNotEmpty)) {
            dataRows.add(rowParts);
          }
        }
      } else {
        // Fallback: If no line has > 2 columns, treat all lines with comma as simple key-value pairs
        for (var line in lines) {
          if (line.contains(',')) {
            dataRows.add(line.split(',').map((e) => e.replaceAll('"', '').trim()).toList());
          }
        }
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata Card (Report Title, Period, Tax Payer)
            if (metaLines.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: metaLines.map((meta) {
                    if (meta.contains(',')) {
                      final parts = meta.split(',');
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          children: [
                            Text(
                              '${parts[0].replaceAll('"', '').trim()}: ',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                parts.sublist(1).join(', ').replaceAll('"', '').trim(),
                                style: AppTextStyles.body.copyWith(color: AppColors.neutral),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Text(
                        meta.replaceAll('"', '').trim(),
                        style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Table Data Card
            if (tableHeaders.isNotEmpty)
              Card(
                color: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColors.neutral.withValues(alpha: 0.2)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.08)),
                    columns: tableHeaders.map((header) {
                      return DataColumn(
                        label: Text(
                          header,
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: dataRows.map((row) {
                      return DataRow(
                        cells: List.generate(tableHeaders.length, (index) {
                          final String text = index < row.length ? row[index] : '';
                          return DataCell(
                            Text(
                              text,
                              style: AppTextStyles.body.copyWith(fontSize: 12.sp),
                            ),
                          );
                        }),
                      );
                    }).toList(),
                  ),
                ),
              )
            else if (dataRows.isNotEmpty)
              Card(
                color: AppColors.white,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: dataRows.map((r) => ListTile(title: Text(r.join(' : ')))).toList(),
                  ),
                ),
              )
            else
              const Center(child: Text('No table data found in CSV.')),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Text('Failed to read CSV content: $e'),
      );
    }
  }
}
