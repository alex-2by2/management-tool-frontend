import 'package:flutter/material.dart';

import '../domain/feature_flag.dart';
import 'feature_flag_controller.dart';

class FeatureFlagScreen
    extends StatefulWidget {
  const FeatureFlagScreen({
    super.key,
    required this.controller,
  });

  final FeatureFlagController
      controller;

  @override
  State<FeatureFlagScreen>
      createState() =>
          _FeatureFlagScreenState();
}

class _FeatureFlagScreenState
    extends State<
        FeatureFlagScreen> {
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
          const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        title: const Text(
          'FEATURE TOGGLES',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body:
          AnimatedBuilder(
        animation:
            widget.controller,
        builder:
            (context, _) {
          if (
            widget.controller
                .loading
          ) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xFFA78BFA),
              ),
            );
          }

          if (
            widget.controller
                    .features
                    .isEmpty
          ) {
            return const Center(
              child: Text(
                'NO FEATURES',
                style: TextStyle(
                  color:
                      Colors.white24,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            );
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
                      .features
                      .length,
              itemBuilder:
                  (
                context,
                index,
              ) {
                return _featureCard(
                  widget.controller
                      .features[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _featureCard(
    FeatureFlag feature,
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
              feature.enabled
                  ? const Color(
                      0xFF22C55E,
                    ).withValues(
                      alpha: 0.16,
                    )
                  : Colors.white
                      .withValues(
                      alpha: 0.06,
                    ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          _icon(feature),
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
                Text(
                  feature.name,
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
                  height: 5,
                ),
                Text(
                  feature.description,
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                    height:
                        1.45,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Row(
                  children: [
                    _chip(
                      feature.enabled
                          ? 'ENABLED'
                          : 'DISABLED',
                      feature.enabled
                          ? const Color(
                              0xFF22C55E,
                            )
                          : Colors.white38,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    _chip(
                      feature.environment,
                      const Color(
                        0xFFA78BFA,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Switch.adaptive(
            value:
                feature.enabled,
            activeColor:
                const Color(
              0xFF8B5CF6,
            ),
            onChanged:
                (value) async {
              await widget
                  .controller
                  .toggle(
                feature,
                value,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _icon(
    FeatureFlag feature,
  ) {
    return Container(
      width: 42,
      height: 42,
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF8B5CF6,
        ).withValues(
          alpha: 0.09,
        ),
        shape:
            BoxShape.circle,
      ),
      child:
          const Icon(
        Icons
            .toggle_on_rounded,
        color:
            Color(0xFFA78BFA),
        size: 21,
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
}
