// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logingestorfrontend/APIs/api_service.dart';
import '../Model/log.dart';
import 'package:flutter/foundation.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<List<Log>> futureLogs;
  int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;

  final TextEditingController levelController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController resourceIdController = TextEditingController();
  final TextEditingController timestampController = TextEditingController();
  final TextEditingController traceIdController = TextEditingController();
  final TextEditingController spanIdController = TextEditingController();
  final TextEditingController commitController = TextEditingController();
  final TextEditingController metadataController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    futureLogs = ApiService.fetchLogs();
  }


  void _searchLogs() {
    final level = levelController.text;
    final message = messageController.text;
    final resourceId = resourceIdController.text;
    final timestamp = timestampController.text;
    final traceId = traceIdController.text;
    final spanId = spanIdController.text;
    final commit = commitController.text;
    final metadata = metadataController.text;

    setState(() {
      futureLogs = ApiService.searchLogs(
        level: level,
        message: message,
        resourceId: resourceId,
        timestamp: timestamp,
        traceId: traceId,
        spanId: spanId,
        commit: commit,
        metadata: metadata,
      );
    });
  }

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Log Ingestor",
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 94, 9, 180),
                fontWeight: FontWeight.bold,
                fontSize: 48,
                fontStyle: FontStyle.italic,
              ),
            ),
            ),
          ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchFields(
                levelController: levelController,
                messageController: messageController,
                resourceIdController: resourceIdController,
                timestampController: timestampController,
                traceIdController: traceIdController,
                spanIdController: spanIdController,
                commitController: commitController,
                metadataController: metadataController,
                onSearch: _searchLogs,
              )
            ),
           
            Expanded(
              child: FutureBuilder<List<Log>>(
                future: futureLogs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: PaginatedDataTable(
                          //header: const Text("Logs"),
                          columns: const [
                            DataColumn(label: Text("Level")),
                            DataColumn(label: Text("Message")),
                            DataColumn(label: Text("Resource ID")),
                            DataColumn(label: Text("Timestamp")),
                            DataColumn(label: Text("Trace ID")),
                            DataColumn(label: Text("Span ID")),
                            DataColumn(label: Text("Commit")),
                            DataColumn(label: Text("Metadata")),
                            DataColumn(label: Text("Actions")),
                          ],
                          source: LogDataSource(snapshot.data!, context),
                          rowsPerPage: _rowPerPage,
                          onRowsPerPageChanged: (rowsPerPage) {
                            setState(() {
                              _rowPerPage = rowsPerPage ??
                                  PaginatedDataTable.defaultRowsPerPage;
                            });
                          }),
                    );
                  } else {
                    return const Text("No logs founds");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchFields extends StatelessWidget {
  final TextEditingController levelController;
  final TextEditingController messageController;
  final TextEditingController resourceIdController;
  final TextEditingController timestampController;
  final TextEditingController traceIdController;
  final TextEditingController spanIdController;
  final TextEditingController commitController;
  final TextEditingController metadataController;
  final VoidCallback onSearch;

  const SearchFields({
    Key? key,
    required this.levelController,
    required this.messageController,
    required this.resourceIdController,
    required this.timestampController,
    required this.traceIdController,
    required this.spanIdController,
    required this.commitController,
    required this.metadataController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: levelController,
          decoration: const InputDecoration(labelText: "Level"),
        ),
        TextField(
          controller:  messageController,
          decoration: const InputDecoration(labelText: "Message"),
        ),
        TextField(
          controller: resourceIdController,
          decoration: const InputDecoration(labelText: "Rescource ID"),
        ),
        TextField(
          controller: timestampController,
          decoration: const InputDecoration(labelText: "Timestamp"),
        ),
        TextField(
          controller: traceIdController,
          decoration: const InputDecoration(labelText: "Trace ID"),
        ),
        TextField(
          controller: spanIdController,
          decoration: const InputDecoration(labelText: "Span ID"),
        ),
        TextField(
          controller: commitController,
          decoration: const InputDecoration(labelText: "Commit"),
        ),
        TextField(
          controller: metadataController,
          decoration: const InputDecoration(labelText: "Metadata"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSearch, 
          child: Text("Search"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 94, 9, 180),
          )
          )
      ],
    );
  }

}



class LogDataSource extends DataTableSource {
  final List<Log> logs;
  final BuildContext context;

  LogDataSource(this.logs, this.context);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= logs.length) return null!;
    final log = logs[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(log.level)),
        DataCell(Text(log.message)),
        DataCell(Text(log.resourceId)),
        DataCell(Text(log.timestamp)),
        DataCell(Text(log.traceId)),
        DataCell(Text(log.spanId)),
        DataCell(Text(log.commit)),
        DataCell(Text(log.metadata)),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(log.id),
          )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => logs.length;
  @override
  int get selectedRowCount => 0;

  void _showDeleteConfirmationDialog(int logId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Log"),
          content: Text("Are you sure you want to delete this log"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: ()  async {
                await ApiService.deleteLog(logId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Log deleted"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      }
    );
  }
}
