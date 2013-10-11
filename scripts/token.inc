<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">

	private class Token {

		private long SessionTTL = 10*60;                     // Session Time To Live (seconds)

		private string UserName;
		private long TimeStamp = 0;

		private string TOKEN;

		public Token(string userName, RSACryptoServiceProvider csp){
			long timeStamp = DateTime.UtcNow.Ticks;

			string authSecureData = userName + timeStamp.ToString();		
			byte[] data = Encoding.ASCII.GetBytes(authSecureData);

			SHA1Managed sha = new SHA1Managed();
			byte[] hash = sha.ComputeHash(data);

			byte[] signature = csp.SignHash(hash, CryptoConfig.MapNameToOID("sha1"));

			// Hash-Based Message Authentication Code (HMAC)
			string hmac = (BitConverter.ToString(signature)).Replace("-", string.Empty);

			TOKEN = (BitConverter.ToString(Encoding.ASCII.GetBytes(userName))).Replace("-", string.Empty) + ":" + timeStamp.ToString() + ":" + hmac;
		}

		public Token(string TOKEN){
			this.TOKEN = TOKEN;	
		}

		public string getUserName(){
			return UserName;
		}

		public bool valid(RSACryptoServiceProvider csp){
			bool valid = false;

			string[] tokenFields = TOKEN.Split(new Char [] {':'});
			if (tokenFields.Length<3) return false;

			string userName       = Encoding.ASCII.GetString(HEX2bytesArray(tokenFields[0]));
			long   timeStamp      = Convert.ToInt64(tokenFields[1]);
			byte[] signature      = HEX2bytesArray(tokenFields[2]);
	
			string authSecureData = userName + timeStamp.ToString();		
			byte[] data           = Encoding.ASCII.GetBytes(authSecureData);

			SHA1Managed sha = new SHA1Managed();
			byte[] hash = sha.ComputeHash(data);

			if(csp.VerifyHash(hash, CryptoConfig.MapNameToOID("sha1"), signature)){
				valid = true;
				this.UserName = userName;
				this.TimeStamp = timeStamp;	
			}

			return valid;
		}
	
		public bool expired() {
			bool expired = true;

			long SessionTimeSec = (DateTime.UtcNow.Ticks - this.TimeStamp) / 10000000;

			if (SessionTimeSec < SessionTTL) expired = false;

			return expired;
		}
	

		public string ToString(){
			return (TOKEN);			
		}

		private static byte[] HEX2bytesArray(String hex) {
			int NumberChars = hex.Length / 2;
			byte[] bytes = new byte[NumberChars];
			using (StringReader sr = new StringReader(hex)) {
				for(int i = 0; i < NumberChars; i++)
					bytes[i] = Convert.ToByte(new string(new char[2]{(char)sr.Read(), (char)sr.Read()}), 16);
			}
			return (bytes);
		}
	}
</script>
