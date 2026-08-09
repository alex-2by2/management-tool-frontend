import 'package:flutter/material.dart';

import '../data/health_api.dart';
import '../domain/system_health.dart';

class HealthMonitorScreen
    extends StatefulWidget {
  const HealthMonitorScreen({
    super.key,
    required this.api,
  });

  final HealthApi api;

  @override
  State<HealthMonitorScreen>
      createState() =>
          _HealthMonitorScreenState();
}

class _HealthMonitorScreenState
    extends State<
        HealthMonitorScreen> {
  SystemHealth? health;

  bool loading = true;

  String? error;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      health =
          await widget.api
              .getHealth();
    } catch (e) {
      error = e.toString();
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
          'SYSTEM HEALTH',
          style:
              TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _load,
            icon:
                const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
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
              : error != null
                  ? _errorView()
                  : health == null
                      ? _errorView()
                      : RefreshIndicator(
                          color:
                              const Color(
                            0xFFA78BFA,
                          ),
                          onRefresh:
                              _load,
                          child:
                              _content(
                            health!,
                          ),
                        ),
    );
  }

  Widget _content(
    SystemHealth data,
  ) {
    return ListView(
      padding:
          const EdgeInsets.all(16),
      children: [
        _overallStatus(data),
        const SizedBox(
          height: 14,
        ),
        Row(
          children: [
            Expanded(
              child:
                  _componentCard(
                'BACKEND',
                data.backend,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child:
                  _componentCard(
                'DATABASE',
                data.database,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        _runtimeCard(data.runtime),
        const SizedBox(
          height: 14,
        ),
        _memoryCard(data.memory),
      ],
    );
  }

  Widget _overallStatus(
    SystemHealth data,
  ) {
    final healthy =
        data.status ==
            'healthy';

    final color = healthy
        ? const Color(
            0xFF22C55E,
          )
        : const Color(
            0xFFF59E0B,
          );

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha: 0.07,
        ),
        borderRadius:
            BorderRadius.circular(
          25,
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
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.12,
              ),
              shape:
                  BoxShape.circle,
            ),
            child:
                Icon(
              healthy
                  ? Icons
                      .check_rounded
                  : Icons
                      .warning_amber_rounded,
              color:
                  color,
              size: 26,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  healthy
                      ? 'SYSTEM HEALTHY'
                      : 'SYSTEM DEGRADED',
                  style:
                      TextStyle(
                    color:
                        color,
                    fontSize:
                        12,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Last checked ${_checkedAt(data.checkedAt)}',
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _componentCard(
    String label,
    HealthComponent component,
  ) {
    final healthy =
        component.status ==
            'healthy';

    final color = healthy
        ? const Color(
            0xFF22C55E,
          )
        : const Color(
            0xFFEF4444,
          );

    return Container(
      padding:
          const EdgeInsets.all(15),
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
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                const TextStyle(
              color:
                  Colors.white38,
              fontSize:
                  7,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(
                  color:
                      color,
                  shape:
                      BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                component.status
                    .toUpperCase(),
                style:
                    TextStyle(
                  color:
                      color,
                  fontSize:
                      8,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            component.latencyMs ==
                    null
                ? '--'
                : '${component.latencyMs!.toStringAsFixed(1)} ms',
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontSize:
                  16,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _runtimeCard(
    RuntimeHealth runtime,
  ) {
    return _panel(
      title:
          'RUNTIME',
      icon:
          Icons.memory_rounded,
      children: [
        _row(
          'VERSION',
          runtime.version,
        ),
        _row(
          'ENVIRONMENT',
          runtime.environment,
        ),
        _row(
          'COMMIT',
          runtime.commitSha ??
              'UNKNOWN',
        ),
        _row(
          'NODE',
          runtime.nodeVersion,
        ),
        _row(
          'UPTIME',
          _uptime(
            runtime.uptimeSeconds,
          ),
        ),
      ],
    );
  }

  Widget _memoryCard(
    MemoryHealth memory,
  ) {
    final usedMb =
        memory.heapUsed /
            1024 /
            1024;

    final totalMb =
        memory.heapTotal /
            1024 /
            1024;

    return _panel(
      title:
          'MEMORY',
      icon:
          Icons.bar_chart_rounded,
      children: [
        _row(
          'RSS',
          _mb(memory.rss),
        ),
        _row(
          'HEAP USED',
          '${usedMb.toStringAsFixed(1)} MB',
        ),
        _row(
          'HEAP TOTAL',
          '${totalMb.toStringAsFixed(1)} MB',
        ),
        _row(
          'EXTERNAL',
          _mb(memory.external),
        ),
      ],
    );
  }

  Widget _panel({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(17),
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
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
        children: [
          Row(
            children: [
              Icon(
                icon,
                color:
                    const Color(
                  0xFFA78BFA,
                ),
                size: 18,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize:
                      9,
                  fontWeight:
                      FontWeight.w900,
                  letterSpacing:
                      1,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 9,
      ),
      child:
          Row(
        children: [
          SizedBox(
            width: 90,
            child:
                Text(
              label,
              style:
                  const TextStyle(
                color:
                    Colors.white24,
                fontSize:
                    7,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child:
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  textAlign:
                      TextAlign.end,
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        8,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child:
          Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color:
                Colors.redAccent,
            size: 40,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'HEALTH CHECK FAILED',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  10,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          OutlinedButton(
            onPressed:
                _load,
            child:
                const Text(
              'RETRY',
            ),
          ),
        ],
      ),
    );
  }

  String _mb(int bytes) {
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }

  String _uptime(int seconds) {
    final days =
        seconds ~/ 86400;

    final hours =
        (seconds % 86400) ~/ 3600;

    final minutes =
        (seconds % 3600) ~/ 60;

    return '${days}d ${hours}h ${minutes}m';
  }

  String _checkedAt(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    final local =
        date.toLocal();

    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}:'
        '${local.second.toString().padLeft(2, '0')}';
  }
}
