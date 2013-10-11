<%@ Application Language="C#" %>
<!-- #include File = "token.inc" -->
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="System.Security.Cryptography.X509Certificates" %>


<script runat="server">

	String certificateSubject = "CN=FE2BE-Authentication";  // please, delete spaces around =

	X509Certificate2 certificate = null;

	protected void Application_PreRequestHandlerExecute(object sender, EventArgs e) {

		if (certificate == null) certificate = getCertificate(certificateSubject);

		if(certificate != null){
			// create a new session and send to user Cookie (TOKEN) with user name, timestamp and HMAC

			string userName = Request.ServerVariables["LOGON_USER"];

			if (String.Compare(userName, "", true) != 0) {

				Token token = new Token(userName, (RSACryptoServiceProvider)certificate.PrivateKey);

				HttpCookie TOKEN_Cookie = new HttpCookie("TOKEN");
				   	   TOKEN_Cookie.Value = token.ToString();
				Response.Cookies.Add(TOKEN_Cookie);

				Response.Redirect(Request.RawUrl);
			} else 
				throw new System.Exception("please turn on authentication on IIS server, LOGON_USER is null");
		} else
			throw new System.Exception("Error: couldn't find "+certificateSubject+" certificate");
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