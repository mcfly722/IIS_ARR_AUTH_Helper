<%@ Application Language="C#" %>
<!-- #include File = "token.inc" -->
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="System.Security.Cryptography.X509Certificates" %>

<script runat="server">

	String certificateSubject = "CN=FE2BE-Authentication";   // please, delete spaces around =

	X509Certificate2 certificate = null;

	void Application_OnPostAuthorizeRequest(object sender, EventArgs e){

		if (certificate == null) certificate = getCertificate(certificateSubject);

		if (certificate != null){

			HttpCookie TOKEN_Cookie = Request.Cookies["TOKEN"];

			if (TOKEN_Cookie != null){

				Token token = new Token(TOKEN_Cookie.Value);
				
				if (token.valid((RSACryptoServiceProvider)certificate.PublicKey.Key)){
					if (!token.expired()){
						// Session valid
						GenericIdentity identity = new GenericIdentity(token.getUserName(), "Forms");
					        CustomPrincipal principal = new CustomPrincipal(identity);                                
					        Context.User = principal;

						// process content
					} else {
						// clear TOKEN cookie and refrest URL (get new token from frontend)
						TOKEN_Cookie.Expires = DateTime.Now.AddDays(-1d);
						Response.Cookies.Add(TOKEN_Cookie);
						
						// reopen site
						Response.Redirect(Request.RawUrl);
						Response.End();
					}			
				} else 
					throw new System.Exception("Your TOKEN is not valid. If error remains, please, clear your cookie and ensure that both sertificates ("+ certificateSubject +") on frontend and backend servers are match.");
			} else 
				throw new System.Exception("Check, that you have been forwarded from Frontend site (TOKEN cookie should be exist).");
		} else 
			throw new System.Exception("Couldn't find "+certificateSubject+" certificate");
	}

	private class CustomPrincipal : IPrincipal {  
      
 	   public CustomPrincipal(IIdentity identity) {
	        Identity = identity;
           }
 
 	   public bool IsInRole(string role) {
 	   	return false;
	   }
 
    	   public IIdentity Identity {
        	get; private set;
    	   }
	}

	private X509Certificate2 getCertificate(String certSubject) {

		X509Store store = new X509Store(StoreLocation.LocalMachine);
		store.Open(OpenFlags.ReadOnly);

		X509Certificate2Collection scollection = store.Certificates.Find(X509FindType.FindBySubjectDistinguishedName, certSubject, false);

		foreach (X509Certificate2 certificate in scollection) 
			return certificate;

		return null; // certificate not found (error)
	}
</script>
