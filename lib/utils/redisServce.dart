import 'dart:async';

import 'package:alarm_test/constants/api.dart';
import 'package:redis/redis.dart';

class RedisSubscriber {
  List<String> channels = [];
  late PubSub pubsub;
  static final RedisSubscriber _redisSubscriber = RedisSubscriber._internal();
  late Command cmd;
  late StreamController<Map<String, String>> _messageStreamController =
      StreamController<Map<String, String>>.broadcast();

  factory RedisSubscriber() {
    return _redisSubscriber;
  }

  RedisSubscriber._internal();

  Stream<Map<String, String>> get messageStream =>
      _messageStreamController.stream;

  Future<void> connectAndSubscribe(List<String> channels) async {
    print("here" + channels.toString());
    this.channels = channels;
    final conn = RedisConnection();
    cmd = await conn.connectSecure(redisUrl, 6380);

    cmd.send_object(['AUTH', redisPass]).then((response) {
      if (response.toString().toLowerCase() == 'ok') {
        print('Connected to Redis');
        this.pubsub = PubSub(cmd);
        this.channels.add("test");
        pubsub.subscribe(this.channels);
        final stream = pubsub.getStream();

        stream.listen((msg) {
          if (msg is List && msg.length >= 3) {
            final channel = msg[1]?.toString();
            final message = msg[2]?.toString();
            if (channel != null && message != null) {
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
    this.pubsub.subscribe([channel]);
  }

  void dispose() {
    _messageStreamController.close();
    cmd.send_object(['UNSUBSCRIBE', ...channels]);
    cmd.send_object(['QUIT']);
  }
}
