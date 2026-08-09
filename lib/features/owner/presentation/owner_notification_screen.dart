import 'package:flutter/material.dart';

import '../data/owner_notification_api.dart';

class OwnerNotificationScreen
    extends StatefulWidget {
  const OwnerNotificationScreen({
    super.key,
    required this.api,
  });

  final OwnerNotificationApi api;

  @override
  State<OwnerNotificationScreen>
      createState() =>
          _OwnerNotificationScreenState();
}

class _OwnerNotificationScreenState
    extends State<
        OwnerNotificationScreen> {
  final titleController =
      TextEditingController();

  final messageController =
      TextEditingController();

  String type =
      'announcement';

  String target =
      'all';

  String channel =
      'in_app';

  bool sending = false;

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
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
        title:
            const Text(
          'GLOBAL NOTIFICATIONS',
          style:
              TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body:
          ListView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        children: [
          _field(
            controller:
                titleController,
            label:
                'TITLE',
            hint:
                'Notification title',
            maxLines: 1,
          ),
          const SizedBox(
            height: 12,
          ),
          _field(
            controller:
                messageController,
            label:
                'MESSAGE',
            hint:
                'Write your announcement...',
            maxLines: 6,
          ),
          const SizedBox(
            height: 12,
          ),
          _dropdown(
            label:
                'TYPE',
            value:
                type,
            values: const [
              'announcement',
              'system',
              'security',
              'update',
            ],
            onChanged:
                (value) {
              if (value != null) {
                setState(() {
                  type =
                      value;
                });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          _dropdown(
            label:
                'TARGET',
            value:
                target,
            values: const [
              'all',
              'owners',
              'admins',
              'support',
              'users',
            ],
            onChanged:
                (value) {
              if (value != null) {
                setState(() {
                  target =
                      value;
                });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          _dropdown(
            label:
                'CHANNEL',
            value:
                channel,
            values: const [
              'in_app',
              'push',
              'both',
            ],
            onChanged:
                (value) {
              if (value != null) {
                setState(() {
                  channel =
                      value;
                });
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton.icon(
            onPressed:
                sending
                    ? null
                    : _send,
            icon:
                const Icon(
              Icons
                  .campaign_rounded,
              size: 18,
            ),
            label:
                Text(
              sending
                  ? 'SENDING...'
                  : 'PUBLISH NOTIFICATION',
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController
        controller,
    required String label,
    required String hint,
    required int maxLines,
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
        hintText:
            hint,
        labelStyle:
            const TextStyle(
          color:
              Colors.white38,
          fontSize:
              8,
          fontWeight:
              FontWeight.w900,
        ),
        hintStyle:
            const TextStyle(
          color:
              Colors.white20,
          fontSize:
              9,
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

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> values,
    required ValueChanged<String?>
        onChanged,
  }) {
    return DropdownButtonFormField<
        String>(
      value:
          value,
      dropdownColor:
          const Color(
        0xFF171821,
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
      items:
          values.map(
        (item) =>
            DropdownMenuItem(
          value:
              item,
          child:
              Text(
            item.toUpperCase(),
          ),
        ),
      ).toList(),
      onChanged:
          onChanged,
    );
  }

  Future<void> _send() async {
    final title =
        titleController.text
            .trim();

    final message =
        messageController.text
            .trim();

    if (title.isEmpty ||
        message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content:
              Text(
            'Title and message are required.',
          ),
        ),
      );
      return;
    }

    setState(() {
      sending = true;
    });

    try {
      await widget.api.create(
        title:
            title,
        message:
            message,
        type:
            type,
        target:
            target,
        channel:
            channel,
      );

      titleController.clear();
      messageController.clear();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content:
                Text(
              'Notification published.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          sending = false;
        });
      }
    }
  }
}
