import 'package:flutter/material.dart';

import 'owner_user_controller.dart';

class OwnerUserScreen
    extends StatefulWidget {
  const OwnerUserScreen({
    super.key,
    required this.controller,
  });

  final OwnerUserController
      controller;

  @override
  State<OwnerUserScreen>
      createState() =>
          _OwnerUserScreenState();
}

class _OwnerUserScreenState
    extends State<OwnerUserScreen> {
  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.controller.load();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        title: const Text(
          'USER CONTROL',
          style: TextStyle(
            fontWeight:
                FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          _filters(),
          Expanded(
            child:
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
                      .users
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
                      8,
                      16,
                      30,
                    ),
                    itemCount:
                        widget.controller
                            .users
                            .length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      return _userCard(
                        widget.controller
                            .users[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller:
                searchController,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            decoration:
                InputDecoration(
              hintText:
                  'Search users...',
              hintStyle:
                  const TextStyle(
                color:
                    Colors.white24,
                fontSize: 10,
              ),
              prefixIcon:
                  const Icon(
                Icons.search_rounded,
                size: 18,
              ),
              filled: true,
              fillColor:
                  Colors.white
                      .withValues(
                alpha: 0.04,
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
            onChanged: (value) {
              widget.controller
                  .setSearch(value);
            },
            onSubmitted: (_) {
              widget.controller
                  .load();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child:
                    _filter(
                  label:
                      'ROLE',
                  value:
                      widget.controller
                          .role,
                  values: const [
                    'owner',
                    'admin',
                    'support',
                    'user',
                  ],
                  onChanged:
                      widget.controller
                          .setRole,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child:
                    _filter(
                  label:
                      'STATUS',
                  value:
                      widget.controller
                          .status,
                  values: const [
                    'active',
                    'disabled',
                  ],
                  onChanged:
                      widget.controller
                          .setStatus,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              IconButton(
                onPressed:
                    widget.controller
                        .load,
                icon:
                    const Icon(
                  Icons
                      .filter_alt_rounded,
                  color:
                      Color(
                    0xFFA78BFA,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filter({
    required String label,
    required String? value,
    required List<String> values,
    required ValueChanged<String?>
        onChanged,
  }) {
    return DropdownButtonFormField<
        String>(
      value: value,
      dropdownColor:
          const Color(
        0xFF151620,
      ),
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            9,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Colors.white24,
          fontSize:
              7,
        ),
        filled: true,
        fillColor:
            Colors.white.withValues(
          alpha: 0.04,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child:
              Text('ALL'),
        ),
        ...values.map(
          (item) =>
              DropdownMenuItem(
            value: item,
            child:
                Text(
              item.toUpperCase(),
            ),
          ),
        ),
      ],
      onChanged:
          onChanged,
    );
  }

  Widget _userCard(
    Map<String, dynamic> user,
  ) {
    final status =
        user['status']
            ?.toString() ??
        'active';

    final role =
        user['role']
            ?.toString() ??
        'user';

    final disabled =
        status == 'disabled';

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white
                .withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          21,
        ),
        border:
            Border.all(
          color:
              disabled
                  ? Colors.red
                      .withValues(
                      alpha: 0.18,
                    )
                  : Colors.white
                      .withValues(
                      alpha: 0.06,
                    ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor:
                const Color(
              0xFF8B5CF6,
            ).withValues(
              alpha: 0.12,
            ),
            child:
                Text(
              _initial(
                user['fullName'],
              ),
              style:
                  const TextStyle(
                color:
                    Color(
                  0xFFA78BFA,
                ),
                fontWeight:
                    FontWeight.w900,
              ),
            ),
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
                  user['fullName']
                          ?.toString() ??
                      'Unknown',
                  maxLines: 1,
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
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${user['email'] ?? ''}',
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    _chip(
                      role,
                      const Color(
                        0xFFA78BFA,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    _chip(
                      status,
                      disabled
                          ? Colors.red
                          : Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected:
                (action) =>
                    _handleAction(
              user,
              action,
            ),
            itemBuilder:
                (context) => [
              PopupMenuItem(
                value:
                    disabled
                        ? 'enable'
                        : 'disable',
                child:
                    Text(
                  disabled
                      ? 'Enable account'
                      : 'Disable account',
                ),
              ),
              const PopupMenuItem(
                value:
                    'revoke_sessions',
                child:
                    Text(
                  'Revoke sessions',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
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
            TextStyle(
          color:
              color,
          fontSize:
              6,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  String _initial(
    dynamic value,
  ) {
    final text =
        value?.toString() ?? '';

    if (text.isEmpty) {
      return '?';
    }

    return text
        .trim()
        .substring(0, 1)
        .toUpperCase();
  }

  Future<void> _handleAction(
    Map<String, dynamic> user,
    String action,
  ) async {
    final id =
        user['id']?.toString();

    if (id == null) {
      return;
    }

    if (action == 'disable' ||
        action == 'enable') {
      await widget.controller
          .updateStatus(
        userId: id,
        status:
            action == 'disable'
                ? 'disabled'
                : 'active',
      );
    }

    if (action ==
        'revoke_sessions') {
      await widget.controller
          .revokeSessions(id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content:
                Text(
              'User sessions revoked.',
            ),
          ),
        );
      }
    }
  }

  Widget _empty() {
    return const Center(
      child:
          Text(
        'NO USERS FOUND',
        style:
            TextStyle(
          color:
              Colors.white24,
          fontSize:
              9,
          fontWeight:
              FontWeight.w900,
          letterSpacing:
              1.2,
        ),
      ),
    );
  }
}
