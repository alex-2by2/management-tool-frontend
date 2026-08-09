class RemoteConfigStore {
  RemoteConfigStore({
    Map<String, dynamic>? values,
  }) : _values =
            values ?? {};

  final Map<String, dynamic>
      _values;

  T? get<T>(
    String key,
  ) {
    final value =
        _values[key];

    if (value is T) {
      return value;
    }

    return null;
  }

  String getString(
    String key, {
    String fallback = '',
  }) {
    return get<String>(
          key,
        ) ??
        fallback;
  }

  int getInt(
    String key, {
    int fallback = 0,
  }) {
    return get<num>(
          key,
        )?.toInt() ??
        fallback;
  }

  bool getBool(
    String key, {
    bool fallback = false,
  }) {
    return get<bool>(
          key,
        ) ??
        fallback;
  }

  Map<String, dynamic>
      getJson(
    String key,
  ) {
    return get<
            Map<String, dynamic>>(
          key,
        ) ??
        const {};
  }
}
