import 'package:flutter/material.dart';

import '../domain/user_session.dart';
import 'session_controller.dart';

class SessionScreen
    extends StatefulWidget {
  const SessionScreen({
    super.key,
    required this.controller,
  });

  final SessionController
      controller;

  @override
  State<SessionScreen>
      createState() =>
          _SessionScreenState();
}

class _SessionScreenState
    extends State<SessionScreen> {
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
        0xFF05060A,
      ),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        title:
            const Text(
          'ACTIVE SESSIONS',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w900,
            letterSpacing:
                1.2,
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                () async {
              await widget
                  .controller
                  .revokeOthers();
            },
            child:
                const Text(
              'REVOKE OTHERS',
              style:
                  TextStyle(
                fontSize:
                    8,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ],
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
                    .sessions
                    .isEmpty
          ) {
            return _empty();
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
                ListView.builder(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                10,
                16,
                30,
              ),
              itemCount:
                  widget.controller
                      .sessions
                      .length,
              itemBuilder:
                  (
                context,
                index,
              ) {
                return _sessionCard(
                  widget.controller
                      .sessions[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _sessionCard(
    UserSession session,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              session.current
                  ? const Color(
                      0xFF8B5CF6,
                    ).withValues(
                      alpha: 0.25,
                    )
                  : Colors.white
                      .withValues(
                      alpha: 0.06,
                    ),
        ),
      ),
      child:
          Row(
        children: [
          _platformIcon(
            session.platform,
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                          Text(
                        session
                            .deviceName,
                        maxLines:
                            1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              11,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                    if (session
                        .current) ...[
                      const SizedBox(
                        width: 7,
                      ),
                      _currentBadge(),
                    ],
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  _platformText(
                    session,
                  ),
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  _activeText(
                    session,
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
          ),
          if (!session.current)
            IconButton(
              tooltip:
                  'Revoke session',
              onPressed:
                  () =>
                      _confirmRevoke(
                session,
              ),
              icon:
                  const Icon(
                Icons
                    .logout_rounded,
                color:
                    Colors.white38,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _currentBadge() {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF22C55E,
        ).withValues(
          alpha: 0.1,
        ),
        borderRadius:
            BorderRadius.circular(
          6,
        ),
      ),
      child:
          const Text(
        'THIS DEVICE',
        style:
            TextStyle(
          color:
              Color(
            0xFF22C55E,
          ),
          fontSize:
              6,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  Widget _platformIcon(
    SessionPlatform platform,
  ) {
    final icon =
        switch (platform) {
      SessionPlatform.android =>
        Icons
            .phone_android_rounded,
      SessionPlatform.ios =>
        Icons
            .phone_iphone_rounded,
      SessionPlatform.web =>
        Icons
            .language_rounded,
      SessionPlatform.unknown =>
        Icons
            .devices_other_rounded,
    };

    return Container(
      width: 42,
      height: 42,
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha: 0.06,
        ),
        shape:
            BoxShape.circle,
      ),
      child:
          Icon(
        icon,
        color:
            const Color(
          0xFFA78BFA,
        ),
        size: 20,
      ),
    );
  }

  String _platformText(
    UserSession session,
  ) {
    final platform =
        session.platform.name
            .toUpperCase();

    if (session.ipAddress ==
        null) {
      return platform;
    }

    return '$platform • ${session.ipAddress}';
  }

  String _activeText(
    UserSession session,
  ) {
    final date =
        session.lastActiveAt;

    if (date == null) {
      return 'ACTIVITY UNKNOWN';
    }

    final difference =
        DateTime.now()
            .difference(
      date.toLocal(),
    );

    if (difference.inMinutes <
        1) {
      return 'ACTIVE NOW';
    }

    if (difference.inHours <
        1) {
      return '${difference.inMinutes} MIN AGO';
    }

    if (difference.inDays <
        1) {
      return '${difference.inHours} HR AGO';
    }

    return '${difference.inDays} DAYS AGO';
  }

  Future<void>
      _confirmRevoke(
    UserSession session,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context:
          context,
      builder:
          (context) {
        return AlertDialog(
          title:
              const Text(
            'Revoke session?',
          ),
          content:
              Text(
            'This will sign out ${session.deviceName}.',
          ),
          actions: [
            TextButton(
              onPressed:
                  () =>
                      Navigator.pop(
                context,
                false,
              ),
              child:
                  const Text(
                'CANCEL',
              ),
            ),
            FilledButton(
              onPressed:
                  () =>
                      Navigator.pop(
                context,
                true,
              ),
              child:
                  const Text(
                'REVOKE',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await widget.controller
        .revoke(
      session,
    );
  }

  Widget _empty() {
    return const Center(
      child:
          Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons
                .devices_other_outlined,
            color:
                Colors.white24,
            size:
                50,
          ),
          SizedBox(
            height:
                12,
          ),
          Text(
            'NO ACTIVE SESSIONS',
            style:
                TextStyle(
              color:
                  Colors.white38,
              fontSize:
                  10,
              fontWeight:
                  FontWeight.w900,
              letterSpacing:
                  1.2,
            ),
          ),
        ],
      ),
    );
  }
}
