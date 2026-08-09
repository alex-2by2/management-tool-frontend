import 'package:flutter/material.dart';

import '../../maintenance/data/maintenance_api.dart';
import '../../maintenance/domain/maintenance_status.dart';

class MaintenanceScreen
    extends StatefulWidget {
  const MaintenanceScreen({
    super.key,
    required this.api,
  });

  final MaintenanceApi api;

  @override
  State<MaintenanceScreen>
      createState() =>
          _MaintenanceScreenState();
}

class _MaintenanceScreenState
    extends State<MaintenanceScreen> {
  final titleController =
      TextEditingController();

  final messageController =
      TextEditingController();

  bool enabled = false;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final status =
          await widget.api.status();

      _apply(status);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _apply(
    MaintenanceStatus status,
  ) {
    enabled =
        status.enabled;

    titleController.text =
        status.title;

    messageController.text =
        status.message;
  }

  Future<void> _save() async {
    if (titleController.text
        .trim()
        .isEmpty) {
      return;
    }

    if (messageController.text
        .trim()
        .isEmpty) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await widget.api.update(
        enabled: enabled,
        title:
            titleController.text
                .trim(),
        message:
            messageController.text
                .trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Maintenance settings updated.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        title:
            const Text(
          'MAINTENANCE MODE',
          style:
              TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : ListView(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  children: [
                    _statusCard(),
                    const SizedBox(
                      height: 16,
                    ),
                    _field(
                      titleController,
                      'TITLE',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _field(
                      messageController,
                      'MESSAGE',
                      maxLines: 6,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    FilledButton(
                      onPressed:
                          saving
                              ? null
                              : _save,
                      child:
                          Text(
                        saving
                            ? 'SAVING...'
                            : 'SAVE SETTINGS',
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _statusCard() {
    final color = enabled
        ? const Color(0xFFF59E0B)
        : const Color(0xFF22C55E);

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha: 0.07,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              color.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child:
          Row(
        children: [
          Icon(
            enabled
                ? Icons
                    .construction_rounded
                : Icons
                    .check_circle_rounded,
            color:
                color,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  enabled
                      ? 'MAINTENANCE ACTIVE'
                      : 'SYSTEM ONLINE',
                  style:
                      TextStyle(
                    color:
                        color,
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Control access for regular users.',
                  style:
                      TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        7,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value:
                enabled,
            onChanged:
                (value) {
              setState(() {
                enabled =
                    value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller:
          controller,
      maxLines:
          maxLines,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            10,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Colors.white38,
          fontSize:
              8,
          fontWeight:
              FontWeight.w900,
        ),
        filled: true,
        fillColor:
            Colors.white
                .withValues(
          alpha: 0.045,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }
}
