using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;

namespace WeWakeAPI.Hubs
{
    public class ChatHub : Hub
    {
        public void SendMessageToGroup(string groupId, string userId, string userName, string message)
        {
            Clients.All.ReceiveMessage(message);
            Clients.Group(groupId).ReceiveMessage(userId, userName, message);
        }

        public Task JoinGroup(string groupId)
        {
            return Groups.Add(Context.ConnectionId, groupId);
        }

        public Task LeaveGroup(string groupId)
        {
            return Groups.Remove(Context.ConnectionId, groupId);
        }

        public override Task OnConnected()
        {
            JoinGroup("");
            return base.OnConnected();
        }
    }
}
