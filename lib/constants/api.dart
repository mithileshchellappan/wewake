const baseUrl =
    String.fromEnvironment('Server_Url', defaultValue: "192.168.0.130:5022");

const redisUrl = String.fromEnvironment('Redis_Url',
    defaultValue: "weWakeRedis.redis.cache.windows.net");
const redisPass = String.fromEnvironment('Redis_Pass',
    defaultValue: "VgcWLEHLQ90xpqUAHNhXBJ6WLiD619XTdAzCaHqvdNI=");

const apiRoute = "http://${baseUrl}/api";
const wsRoute = "ws://${baseUrl}/ws";
