namespace WeWakeAPI.Exceptions
{
    public class NotFoundException : Exception
    {
        public object Message { get; set; }
        public NotFoundException(string res):base(res)  {
            Message = new {success=false,message=res};
        }

     }
}
