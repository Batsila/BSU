namespace Lab2.Common.Models
{
    public class ContentResponse
    {
        public ContentResponse(byte[] data)
        {
            Data = data;
        }

        public byte[] Data { get; set; }
    }
}
