import 'package:flutter/material.dart';

import '../data/audit_api.dart';
import '../domain/audit_event.dart';

class AuditTimelineScreen
    extends StatefulWidget {
  const AuditTimelineScreen({
    super.key,
    required this.api,
  });

  final AuditApi api;

  @override
  State<AuditTimelineScreen>
      createState() =>
          _AuditTimelineScreenState();
}

class _AuditTimelineScreenState
    extends State<
        AuditTimelineScreen> {
  List<AuditEvent> events =
      const [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
    });

    try {
      events =
          await widget.api.list();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
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
          'AUDIT TIMELINE',
          style:
              TextStyle(
            fontSize:
                12,
            fontWeight:
                FontWeight.w900,
            letterSpacing:
                1.3,
          ),
        ),
      ),
      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        Color(
                      0xFFA78BFA,
                    ),
                  ),
                )
              : RefreshIndicator(
                  color:
                      const Color(
                    0xFFA78BFA,
                  ),
                  onRefresh:
                      _load,
                  child:
                      events.isEmpty
                          ? _empty()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                30,
                              ),
                              itemCount:
                                  events.length,
                              itemBuilder:
                                  (
                                context,
                                index,
                              ) {
                                return _event(
                                  events[index],
                                );
                              },
                            ),
                ),
    );
  }

  Widget _event(
    AuditEvent event,
  ) {
    final color =
        _categoryColor(
      event.category,
    );

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(
                color:
                    color,
                shape:
                    BoxShape.circle,
              ),
            ),
            Container(
              width: 1,
              height: 78,
              color:
                  Colors.white
                      .withValues(
                alpha: 0.07,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 13,
        ),
        Expanded(
          child: Container(
            margin:
                const EdgeInsets
                    .only(
              bottom: 12,
            ),
            padding:
                const EdgeInsets
                    .all(15),
            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withValues(
                alpha: 0.045,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border:
                  Border.all(
                color:
                    Colors.white
                        .withValues(
                  alpha: 0.06,
                ),
              ),
            ),
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(
                        _pretty(
                          event.action,
                        ),
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              10,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      _time(
                        event.createdAt,
                      ),
                      style:
                          const TextStyle(
                        color:
                            Colors.white24,
                        fontSize:
                            7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  _actor(event),
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                  ),
                ),
                if (event.targetId !=
                    null) ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Target: ${event.targetId}',
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.white24,
                      fontSize:
                          7,
                    ),
                  ),
                ],
                if (event.metadata
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _metadata(
                      event.metadata,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.white24,
                      fontSize:
                          7,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _actor(
    AuditEvent event,
  ) {
    final actor =
        event.actor;

    if (actor == null) {
      return 'Unknown actor';
    }

    return actor['fullName']
            ?.toString() ??
        actor['username']
            ?.toString() ??
        'Unknown actor';
  }

  String _metadata(
    Map<String, dynamic> data,
  ) {
    return data.entries
        .map(
          (entry) =>
              '${entry.key}: ${entry.value}',
        )
        .join(' • ');
  }

  String _pretty(
    String value,
  ) {
    return value
        .replaceAll(
          '_',
          ' ',
        )
        .toUpperCase();
  }

  String _time(
    DateTime? value,
  ) {
    if (value == null) {
      return '';
    }

    final local =
        value.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Color _categoryColor(
    String category,
  ) {
    switch (category) {
      case 'security':
        return const Color(
          0xFFEF4444,
        );

      case 'user':
        return const Color(
          0xFF22D3EE,
        );

      case 'feature':
        return const Color(
          0xFFA78BFA,
        );

      case 'notification':
        return const Color(
          0xFFF59E0B,
        );

      case 'session':
        return const Color(
          0xFF22C55E,
        );

      default:
        return Colors.white38;
    }
  }

  Widget _empty() {
    return const Center(
      child:
          Text(
        'NO AUDIT EVENTS',
        style:
            TextStyle(
          color:
              Colors.white24,
          fontSize:
              9,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }
}
