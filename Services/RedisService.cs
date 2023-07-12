using StackExchange.Redis;

namespace WeWakeAPI.Services
{
    public class RedisService : IDisposable,IRedisService
    {
        private readonly IConnectionMultiplexer _redis;
        private readonly ISubscriber _subscriber;

        public RedisService(IConfiguration config)
        {
            string connString = config.GetConnectionString("RedisDB");
            console.log($"Here {connString}");
            _redis = ConnectionMultiplexer.Connect(connString);
            console.log($"REDIS STATUS {_redis.GetStatus()}");
            _subscriber = _redis.GetSubscriber();
            _subscriber.Subscribe("test", (RedisChannel channel, RedisValue message) => console.log(message));
        }

        public void SubscribeToGroup(string groupId, Action<string, string> handler)
        {
            _subscriber.Subscribe(groupId, (channel, message) =>
            {
                handler(channel, message);
            });
        }

        public void PublishToGroup(string groupId, string message)
        {
            console.log("inside");
            _subscriber.Publish(groupId.ToString(), message);
        }

        public void Dispose()
        {
            _redis.Close();
            _redis.Dispose();
        }


    }

    public interface IRedisService{
        public void SubscribeToGroup(string groupId,Action<string,string> handler);
        public void PublishToGroup(string groupId, string message);

    }

}
