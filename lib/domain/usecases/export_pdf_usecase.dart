import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../entities/goal_entity.dart';
import '../entities/transaction_entity.dart';

/// Builds a PDF report from goals and transactions.
class ExportPdfUseCase {
  const ExportPdfUseCase();

  Future<Uint8List> call({
    required List<GoalEntity> goals,
    required List<TransactionEntity> transactions,
    required String userName,
  }) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd/MM/yyyy', 'es_MX');
    final numFmt = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(userName, dateFmt),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummarySection(goals, numFmt),
          pw.SizedBox(height: 24),
          _buildGoalsTable(goals, numFmt),
          pw.SizedBox(height: 24),
          _buildTransactionsTable(transactions, goals, numFmt, dateFmt),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(String userName, DateFormat dateFmt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'WalletFY — Reporte de Ahorros',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF6366F1),
              ),
            ),
            pw.Text(
              'Generado: ${dateFmt.format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Text(
          'Usuario: $userName',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
        pw.Divider(color: PdfColors.indigo200, thickness: 1),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context ctx) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('WalletFY — Ahorro que Inspira',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
        pw.Text('Página ${ctx.pageNumber} de ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
      ],
    );
  }

  pw.Widget _buildSummarySection(
      List<GoalEntity> goals, NumberFormat numFmt) {
    final totalSaved = goals.fold(0.0, (s, g) => s + g.currentAmount);
    final totalTarget = goals.fold(0.0, (s, g) => s + g.targetAmount);
    final completed = goals.where((g) => g.isCompleted).length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.indigo50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _statBox('Total Ahorrado', numFmt.format(totalSaved)),
          _statBox('Meta Total', numFmt.format(totalTarget)),
          _statBox('Metas Activas', '${goals.length}'),
          _statBox('Completadas', '$completed'),
        ],
      ),
    );
  }

  pw.Widget _statBox(String label, String value) => pw.Column(
        children: [
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF6366F1))),
          pw.Text(label,
              style: const pw.TextStyle(
                  fontSize: 10, color: PdfColors.grey700)),
        ],
      );

  pw.Widget _buildGoalsTable(List<GoalEntity> goals, NumberFormat numFmt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Metas de Ahorro',
            style: pw.TextStyle(
                fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1.5),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.indigo100),
              children: ['Meta', 'Ahorrado', 'Objetivo', 'Progreso', 'Racha']
                  .map((h) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(h,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10)),
                      ))
                  .toList(),
            ),
            ...goals.map((g) => pw.TableRow(
                  children: [
                    _cell('${g.emoji} ${g.title}'),
                    _cell(numFmt.format(g.currentAmount)),
                    _cell(numFmt.format(g.targetAmount)),
                    _cell('${g.progressPercent.toStringAsFixed(1)}%'),
                    _cell('🔥 ${g.streak}'),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTransactionsTable(
    List<TransactionEntity> transactions,
    List<GoalEntity> goals,
    NumberFormat numFmt,
    DateFormat dateFmt,
  ) {
    final goalMap = {for (final g in goals) g.id: g};
    final sorted = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final limited = sorted.take(100).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Historial de Transacciones (últimas ${limited.length})',
            style: pw.TextStyle(
                fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(2.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.indigo100),
              children: ['Fecha', 'Meta', 'Tipo', 'Monto', 'Nota']
                  .map((h) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(h,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10)),
                      ))
                  .toList(),
            ),
            ...limited.map((t) {
              final goal = goalMap[t.goalId];
              return pw.TableRow(
                children: [
                  _cell(dateFmt.format(t.date)),
                  _cell('${goal?.emoji ?? ''} ${goal?.title ?? 'N/A'}'),
                  _cell(_catLabel(t.category)),
                  _cell(numFmt.format(t.amount),
                      color: t.category == TransactionCategory.withdrawal
                          ? PdfColors.red700
                          : PdfColors.green700),
                  _cell(t.note ?? '-'),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {PdfColor? color}) => pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 9, color: color),
        ),
      );

  String _catLabel(TransactionCategory cat) => switch (cat) {
        TransactionCategory.deposit => 'Depósito',
        TransactionCategory.withdrawal => 'Retiro',
        TransactionCategory.scheduled => 'Programado',
      };
}
