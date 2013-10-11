<% @ Page Language="C#" %>
<%

	Response.Write("<h1>Backend server</h><br>");
	Response.Write("<table border=1>");

	foreach (string var in Request.ServerVariables) {

		if(var!="HTTP_AUTHORIZATION" &&
		   var!="ALL_HTTP" && 
		   var!="ALL_RAW" &&
		   var!="AUTH_PASSWORD" &&
		   var!="CERT_SERIALNUMBER" &&
		   var!="AUTH_PASSWORD" &&
	   	   var!="HTTP_X_ARR_LOG_ID"){
			Response.Write("<tr><td>"+var + "</td><td>" + Request[var] + "</td></tr>");
		}
	}

	Response.Write("</table>");

%>