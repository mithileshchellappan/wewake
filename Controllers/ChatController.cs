using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;

namespace WeWakeAPI.Controllers
{
    [Route("api/Chat")]
    [ApiController]
    public class ChatController : ControllerBase
    {
        private readonly ChatService _chatService;
        private readonly GroupService _groupService;

        public ChatController(ChatService chatService, GroupService groupService)
        {
            _chatService = chatService;
            _groupService = groupService;
        }

        [HttpGet("id/{groupId}")]
        public async Task<IActionResult> GetLastMessageId(Guid groupId)
        {
            try
            {
                _groupService.CheckIfGroupExists(groupId);
                Guid lastId = await _chatService.GetLastMessageId(groupId);

                if(lastId == Guid.Empty)
                {
                    return Ok(new { success=true, noMessages=true });
                }
                else
                {
                    return Ok(new { success = true, messageId = lastId });
                }

            }
            catch (Exception e)
            {
                console.log(e);
                return BadRequest(e.Message);
            }
        }

        [HttpGet("{groupId}")]
        public async Task<IActionResult> GetGroupChat(Guid groupId)
        {
            try
            {
                _groupService.CheckIfGroupExists(groupId);
                List<Chat> chats = await _chatService.GetChat(groupId);

                return Ok(new {success=true, chats});

            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}
