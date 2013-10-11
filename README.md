# IIS ARR Authentication Helper #

## What is it?##
It is C# script for IIS which allows you to delegate authentication from frontend to backend server in cases where it is impossible to do through ARR, for example in isolated networks where your backend server have no AD relationships with domain where frontend server located.

## How it works? ##
Script used <b>private key</b> of certificate to sign token data {UserName & TimeStamp}. To validate it, used <b>public key</b> which should be deployed to all your backend servers.<br><br>
Token includes <b>UserName</b>, <b>TimeStamp</b> and <b>Signature</b>. It is transmitted to backend server using client cookie. Then, it is checked for case of substitution and TTL expiry.<br><br>
![alt tag](https://github.com/Serjeo722/IIS_ARR_AUTH_Helper/blob/master/doc/schema.png?raw=true)
## Requirements ##
1) IIS 7.0 or higher<br>
2) deployed ARR(<a href="http://www.iis.net/downloads/microsoft/application-request-routing">Application Request Routing</a>) module<br>
3) deployed <a href="http://www.iis.net/downloads/microsoft/url-rewrite">URL Rewrite</a> module<br>
4) ASP.NET<br>
5) <a href="http://msdn.microsoft.com/en-us/library/bfsktky3.aspx">makecert</a> tool to generate certificate<br>

## How to deploy it? ##
1) Generate certificate with private key.<br>
2) Install certificate with private key on frontend server and on backend server to Computer\Personal store (backend need only public key).<br>
3) Give to appool user, permission to read certificate private key.<br>
4) Add to your URL Rewrite rule condition "route to backend only if {HTTP_COOKIE} match \*TOKEN=\*".<br>
5) Copy <b>frontend_global.asax</b> script to frontend site directory and rename it to <b>global.asax</b>.<br>
6) Copy <b>backend_global.asax</b> script to backend site directory and rename it to <b>global.asax</b>.<br>
7) Copy <b>token.inc</b> script to both frontend and backend sites and use <b>default.aspx</b> on backend side to check your authentication.<br>
8) Modify <b>global.asax</b> script <b>certificateSubject</b> variable on both sites, put there your certificate subject (ensure, that you have no spaces around <b>=</b> sign).<br>
9) Turn on your authentication method on frontend site and anonymous authentication on backend.<br>
10) Syncronize UTC time on both servers.<br>
<br>
That's all. If your did everything correctly, you will see your authenticated user name in AUTH_USER variable on backend side.<br>
## License ##
<a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache 2.0</a>
