namespace WeWakeAPI.Exceptions
{
    public class BadRequestException : Exception
    {
        public object Message { get; set; }
        public BadRequestException(string res) : base(res)
        {
            Message = new { success = false, message = res };
        }

    }
}
