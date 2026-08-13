import 'package:flutter/material.dart';

import 'owner_dashboard_controller.dart';
import 'widgets/owner_glass_card.dart';

class OwnerDashboardScreen
    extends StatefulWidget {
  const OwnerDashboardScreen({
    super.key,
    required this.controller,
  });

  final OwnerDashboardController
      controller;

  @override
  State<OwnerDashboardScreen>
      createState() =>
          _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState
    extends State<
        OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();

    widget.controller.load();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFF030409,
      ),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        title:
            const Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              'OWNER CONSOLE',
              style:
                  TextStyle(
                fontSize:
                    13,
                fontWeight:
                    FontWeight.w900,
                letterSpacing:
                    1.4,
              ),
            ),
            Text(
              'SYSTEM CONTROL',
              style:
                  TextStyle(
                color:
                    Colors.white38,
                fontSize:
                    7,
                letterSpacing:
                    1.8,
              ),
            ),
          ],
        ),
      ),
      body:
          AnimatedBuilder(
        animation:
            widget.controller,
        builder:
            (
          context,
          _,
        ) {
          if (
            widget.controller
                .loading
          ) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(
                  0xFFA78BFA,
                ),
              ),
            );
          }

          if (
            widget.controller
                    .error !=
                null
          ) {
            return _error();
          }

          return RefreshIndicator(
            color:
                const Color(
              0xFFA78BFA,
            ),
            onRefresh:
                widget.controller
                    .load,
            child:
                ListView(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                8,
                16,
                30,
              ),
              children: [
                _systemStatus(),
                const SizedBox(
                  height: 12,
                ),
                _userStatistics(),
                const SizedBox(
                  height: 12,
                ),
                _runtime(),
                const SizedBox(
                  height: 12,
                ),
                _controlMenu(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _systemStatus() {
    return OwnerGlassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'SYSTEM STATUS',
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Expanded(
                child:
                    _status(
                  'API',
                  widget.controller
                      .apiStatus,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child:
                    _status(
                  'DATABASE',
                  widget.controller
                      .databaseStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userStatistics() {
    return OwnerGlassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'USERS',
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Expanded(
                child:
                    _stat(
                  'TOTAL',
                  widget.controller
                      .totalUsers,
                ),
              ),
              Expanded(
                child:
                    _stat(
                  'ADMIN',
                  widget.controller
                      .adminUsers,
                ),
              ),
              Expanded(
                child:
                    _stat(
                  'SUPPORT',
                  widget.controller
                      .supportUsers,
                ),
              ),
              Expanded(
                child:
                    _stat(
                  'USERS',
                  widget.controller
                      .normalUsers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _runtime() {
    final seconds =
        widget.controller
            .uptimeSeconds;

    return OwnerGlassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'RUNTIME',
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Icon(
                Icons
                    .memory_rounded,
                color:
                    Color(
                  0xFF22D3EE,
                ),
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                _uptime(seconds),
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize:
                      11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                'v${widget.controller.version}',
                style:
                    const TextStyle(
                  color:
                      Colors.white38,
                  fontSize:
                      9,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.controller
                    .environment
                    .toUpperCase(),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlMenu() {
    return OwnerGlassCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'CONTROL CENTER',
          ),
          const SizedBox(
            height: 8,
          ),
          _menuItem(
            Icons
                .people_alt_outlined,
            'User Control',
            '/owner/users',
          ),
          _menuItem(
            Icons
                .toggle_on_outlined,
            'Feature Toggles',
            '/owner/features',
          ),
          _menuItem(
            Icons
                .notifications_active_outlined,
            'Global Notifications',
            '/owner/notifications',
          ),
          _menuItem(
            Icons
                .storage_outlined,
            'Backup Manager',
            '/owner/backups',
          ),
          _menuItem(
            Icons
                .key_outlined,
            'API Keys',
            '/owner/api-keys',
          ),
          _menuItem(
            Icons
                .history_rounded,
            'Audit Timeline',
            '/owner/audit',
          ),
          _menuItem(
            Icons
                .rocket_launch_outlined,
            'Deployment',
            '/owner/deployment',
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      contentPadding:
          EdgeInsets.zero,
      leading:
          Icon(
        icon,
        color:
            Colors.white54,
        size: 19,
      ),
      title:
          Text(
        title,
        style:
            const TextStyle(
          color:
              Colors.white,
          fontSize:
              10,
          fontWeight:
              FontWeight.w700,
        ),
      ),
      trailing:
          const Icon(
        Icons
            .chevron_right_rounded,
        color:
            Colors.white24,
        size: 18,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          route,
        );
      },
    );
  }

  Widget _status(
    String title,
    String value,
  ) {
    final healthy =
        value == 'healthy';

    return Container(
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            (healthy
                    ? const Color(
                        0xFF22C55E,
                      )
                    : const Color(
                        0xFFEF4444,
                      ))
                .withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration:
                BoxDecoration(
              color:
                  healthy
                      ? const Color(
                          0xFF22C55E,
                        )
                      : const Color(
                          0xFFEF4444,
                        ),
              shape:
                  BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child:
                Text(
              title,
              style:
                  const TextStyle(
                color:
                    Colors.white70,
                fontSize:
                    8,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          Text(
            healthy
                ? 'OK'
                : 'DOWN',
            style:
                TextStyle(
              color:
                  healthy
                      ? const Color(
                          0xFF22C55E,
                        )
                      : const Color(
                          0xFFEF4444,
                        ),
              fontSize:
                  7,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String label,
    int value,
  ) {
    return Column(
      children: [
        Text(
          value.toString(),
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                20,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
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
            letterSpacing:
                0.8,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,
      style:
          const TextStyle(
        color:
            Colors.white38,
        fontSize:
            8,
        fontWeight:
            FontWeight.w900,
        letterSpacing:
            1.6,
      ),
    );
  }

  Widget _error() {
    return Center(
      child:
          Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons
                .admin_panel_settings_outlined,
            color:
                Colors.white24,
            size: 50,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'OWNER CONSOLE UNAVAILABLE',
            style:
                TextStyle(
              color:
                  Colors.white54,
              fontSize:
                  10,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          FilledButton(
            onPressed:
                widget.controller
                    .load,
            child:
                const Text(
              'RETRY',
            ),
          ),
        ],
      ),
    );
  }

  String _uptime(
    int seconds,
  ) {
    final days =
        seconds ~/ 86400;

    final hours =
        (seconds % 86400) ~/ 3600;

    final minutes =
        (seconds % 3600) ~/ 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    }

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    return '${minutes}m';
  }
}

_menuItem(
  Icons.devices_rounded,
  'Active Sessions',
  '/owner/sessions',
),
