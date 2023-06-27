using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using WeWakeAPI.Models;

namespace WeWakeAPI.Utils
{
    public class JWTHasher
    {
        private const string Secret = "db3OIsj+BXE9NZDy0t8W3TcNekrF+2d/1sFnWG4HnV8TZY30iTOdtVWbWvB1GlOgJuQZdcF2Luqm/hccMw==";
        public static string GenerateToken(User user)
        {
            try
            {
                var symmetricKey = Convert.FromBase64String(Secret);
                var tokenHandler = new JwtSecurityTokenHandler();

                var now = DateTime.UtcNow;
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new[]
                 {
                  new Claim(ClaimTypes.Sid,user.UserId.ToString()),
                  new Claim(ClaimTypes.GivenName,user.Name.ToString())
                 }),
                    Expires = now.AddDays(30),
                    SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(symmetricKey), SecurityAlgorithms.HmacSha256Signature)
                };

                var stoken = tokenHandler.CreateToken(tokenDescriptor);
                var token = tokenHandler.WriteToken(stoken);
                return token;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }

        public static (bool, Guid,String) ValidateToken(string token)
        {
            var symmetricKey = Convert.FromBase64String(Secret);
            var tokenHandler = new JwtSecurityTokenHandler();

            try
            {
                var validationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(symmetricKey),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };

                tokenHandler.ValidateToken(token, validationParameters, out SecurityToken validatedToken);

                var jwtToken = (JwtSecurityToken)validatedToken;
                var payload = jwtToken.Payload;
                var UserId = new Guid(payload.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Sid)?.Value);
                var Name = payload.Claims.FirstOrDefault(c => c.Type == ClaimTypes.GivenName)?.Value ;
                Console.WriteLine(UserId);


                return (true, UserId,Name);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return (false, Guid.Empty,null);
            }
        }
    }
}
