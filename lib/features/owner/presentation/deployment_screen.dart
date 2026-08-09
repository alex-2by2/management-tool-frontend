import 'package:flutter/material.dart';

import '../data/deployment_api.dart';
import '../domain/runtime_info.dart';

class DeploymentScreen
    extends StatefulWidget {
  const DeploymentScreen({
    super.key,
    required this.api,
  });

  final DeploymentApi api;

  @override
  State<DeploymentScreen>
      createState() =>
          _DeploymentScreenState();
}

class _DeploymentScreenState
    extends State<DeploymentScreen> {
  RuntimeInfo? runtimeInfo;

  List<Map<String, dynamic>>
      releases = const [];

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
      runtimeInfo =
          await widget.api
              .runtime();

      releases =
          await widget.api
              .history();
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
          'RELEASE CENTER',
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
                      ListView(
                    padding:
                        const EdgeInsets
                            .all(16),
                    children: [
                      if (runtimeInfo !=
                          null)
                        _runtimeCard(
                          runtimeInfo!,
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'RELEASE HISTORY',
                        style:
                            TextStyle(
                          color:
                              Colors.white38,
                          fontSize:
                              8,
                          fontWeight:
                              FontWeight.w900,
                          letterSpacing:
                              1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...releases.map(
                        _releaseCard,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _runtimeCard(
    RuntimeInfo info,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
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
          Row(
            children: [
              const Icon(
                Icons
                    .rocket_launch_rounded,
                color:
                    Color(
                  0xFFA78BFA,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child:
                    Text(
                  'CURRENT RELEASE',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        11,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
              _badge(
                info.environment,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          _row(
            'VERSION',
            info.version,
          ),
          _row(
            'COMMIT',
            info.commitSha ??
                'UNKNOWN',
          ),
          _row(
            'NODE',
            info.nodeVersion,
          ),
          _row(
            'UPTIME',
            '${info.uptimeSeconds}s',
          ),
          _row(
            'BUILD',
            info.buildTime ??
                'UNKNOWN',
          ),
        ],
      ),
    );
  }

  Widget _releaseCard(
    Map<String, dynamic> release,
  ) {
    final status =
        release['status']
                ?.toString() ??
            'unknown';

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha: 0.035,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child:
          Row(
        children: [
          _statusIcon(status),
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
                  release['version']
                          ?.toString() ??
                      'Unknown',
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
                const SizedBox(
                  height: 5,
                ),
                Text(
                  release['commitSha']
                          ?.toString() ??
                      'No commit SHA',
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
          ),
          _badge(status),
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
        bottom: 8,
      ),
      child:
          Row(
        children: [
          SizedBox(
            width: 80,
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

  Widget _badge(
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFA78BFA,
        ).withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(
          7,
        ),
      ),
      child:
          Text(
        text.toUpperCase(),
        style:
            const TextStyle(
          color:
              Color(0xFFA78BFA),
          fontSize:
              6,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  Widget _statusIcon(
    String status,
  ) {
    final color =
        status == 'success'
            ? const Color(
                0xFF22C55E,
              )
            : status == 'failed'
                ? const Color(
                    0xFFEF4444,
                  )
                : const Color(
                    0xFFF59E0B,
                  );

    return Icon(
      status == 'success'
          ? Icons.check_circle_rounded
          : status == 'failed'
              ? Icons.error_rounded
              : Icons.pending_rounded,
      color: color,
      size: 20,
    );
  }
}
