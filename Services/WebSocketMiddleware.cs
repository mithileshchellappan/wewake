using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Concurrent;
using System.Net.WebSockets;
using System.Text;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;
using WeWakeAPI.Utils;

namespace WeWakeAPI.WebSockets
{
    public class WebSocketMiddleware
    {
        private static ConcurrentDictionary<string, ConcurrentDictionary<string, WebSocket>> _groupSockets = new();
        private readonly RequestDelegate _next;
        private ChatService _chatService;

        public WebSocketMiddleware(RequestDelegate next,ChatService chatService)
        {
            _next = next;
            _chatService = chatService;
        }

        public async Task Invoke(HttpContext context)
        {

            string bearerToken = context.Request.Query["auth"].ToString();
            var (isValid,UserId,Name) = JWTHasher.ValidateToken(bearerToken);
            if (!isValid || bearerToken.IsNullOrEmpty())
            {
                context.Response.StatusCode = 401;
                await context.Response.WriteAsync("Unauthorized");
                return;
            }

            if (!context.WebSockets.IsWebSocketRequest)
            {
                await _next.Invoke(context);
                return;
            }

            CancellationToken ct = context.RequestAborted;
            WebSocket currentSocket = await context.WebSockets.AcceptWebSocketAsync();
            string groupId = context.Request.Query["group"].ToString();
            string socketId = Guid.NewGuid().ToString();

            var groupSockets = _groupSockets.GetOrAdd(groupId, new ConcurrentDictionary<string, WebSocket>());
            groupSockets.TryAdd(socketId, currentSocket);

            try
            {
                while (true)
                {
                    if (ct.IsCancellationRequested)
                        break;

                    var response = await ReceiveStringAsync(currentSocket, ct);
                    if (string.IsNullOrEmpty(response))
                    {
                        if (currentSocket.State != WebSocketState.Open)
                            break;

                        continue;
                    }

                    await SendToGroup(groupId, response,currentSocket, _chatService,ct);
                }
            }
            finally
            {
                groupSockets.TryRemove(socketId, out _);
                if (groupSockets.IsEmpty)
                    _groupSockets.TryRemove(groupId, out _);

                await currentSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "closing", ct);
                currentSocket.Dispose();
            }
        }

        private static Task SendStringAsync(WebSocket socket, dynamic data, CancellationToken ct = default)
        {
            var buffer = Encoding.UTF8.GetBytes(data);
            var segment = new ArraySegment<byte>(buffer);
            console.log(data);
            return socket.SendAsync(segment, WebSocketMessageType.Text, true, ct);
        }

        private static async Task<string> ReceiveStringAsync(WebSocket socket, CancellationToken ct = default)
        {
            var buffer = new ArraySegment<byte>(new byte[8192]);
            using (var ms = new System.IO.MemoryStream())
            {
                WebSocketReceiveResult result;
                do
                {
                    ct.ThrowIfCancellationRequested();
                    result = await socket.ReceiveAsync(buffer, ct);
                    ms.Write(buffer.Array, buffer.Offset, result.Count);
                }
                while (!result.EndOfMessage);

                ms.Seek(0, System.IO.SeekOrigin.Begin);
                if (result.MessageType != WebSocketMessageType.Text)
                    return null;

                using (var reader = new System.IO.StreamReader(ms, Encoding.UTF8))
                {
                    return await reader.ReadToEndAsync();
                }
            }
        }

  
        private static async Task SendToGroup(string groupId, string data, WebSocket senderSocket, ChatService _chatService, CancellationToken ct = default)
        {
            try
            {
                if (!_groupSockets.TryGetValue(groupId, out var groupSockets))
                    return;
                console.log(data);
                var jsonData = JsonConvert.DeserializeObject<ChatWSRequest>(data);
                console.log(jsonData.MessageId);

                var tasks = new List<Task>();
                foreach (var socket in groupSockets)
                {
                    if (socket.Value.State != WebSocketState.Open || socket.Value == senderSocket)
                        continue;

                    tasks.Add(SendStringAsync(socket.Value, data, ct));
                }

                await Task.WhenAll(tasks);
                Chat chat = new Chat(Guid.Parse(jsonData.MessageId), Guid.Parse(groupId), Guid.Parse(jsonData.SenderId), jsonData.SenderName, jsonData.Data);
                _chatService.AddMessage(chat);
            }
            catch(Exception e)
            {
                console.log(e.Message);
            }
        }

    }

    public static class WebSocketMiddlewareExtension
    {
        public static IApplicationBuilder UseWebSocketMiddleware(this IApplicationBuilder builder,string route)
        {
            return builder.Map(route, app =>
            {
                app.UseMiddleware<WebSocketMiddleware>();
            });
        }
    }
}
