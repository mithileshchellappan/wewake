import 'dart:async';
import 'dart:convert';

import 'package:alarm_test/constants/api.dart';
import 'package:redis/redis.dart';

class RedisSubscriber {
  final List<String> channels;
  final Function(String) messageListener;

  late Command cmd;
  late StreamController<Map<String, String>> _messageStreamController;

  RedisSubscriber({
    required this.channels,
    required this.messageListener,
  }) {
    _messageStreamController =
        StreamController<Map<String, String>>.broadcast();
  }

  Stream<Map<String, String>> get messageStream =>
      _messageStreamController.stream;

  Future<void> connectAndSubscribe() async {
    final conn = RedisConnection();
    cmd = await conn.connectSecure(redisUrl, 6380);

    cmd.send_object(['AUTH', redisPass]).then((response) {
      if (response.toString().toLowerCase() == 'ok') {
        print('Connected to Redis');
        final pubsub = PubSub(cmd);
        this.channels.add("test");
        pubsub.subscribe(this.channels);
        final stream = pubsub.getStream();

        stream.listen((msg) {
          if (msg is List && msg.length >= 3) {
            final channel = msg[1]?.toString();
            final message = msg[2]?.toString();
            if (channel != null && message != null) {
              final formattedMessage = '$channel: $message';
              messageListener(formattedMessage);
              _messageStreamController
                  .add({"group": channel, "message": message});
            }
          }
        });
      } else {
        print('Authentication failed!');
      }
    });
  }

  void appendChannel(String channel) {
    channels.add(channel);
    cmd.send_object(['SUBSCRIBE', channel]);
  }

  void dispose() {
    _messageStreamController.close();
    cmd.send_object(['UNSUBSCRIBE', ...channels]);
    cmd.send_object(['QUIT']);
  }
}
