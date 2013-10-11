# IIS ARR Authentication Helper #

## What is it?##
It is C# script for IIS which allows to delegate authentication from frontend to backend server in cases where it is impossible to do through ARR, for example in isolated networks and different forests where your backend server have no AD relationships with domain where frontend server located.

## How it works? ##
This script uses HMAC (<a href="http://en.wikipedia.org/wiki/Hash-based_message_authentication_code">Hash-based Message Authentication Code</a>). For signing, script uses private key of certificate, and for signature checking it uses public key which should be deployed to all backend servers.<br><br>
For signing uses <a href="http://en.wikipedia.org/wiki/RSA_(algorithm)">RSA algorithm</a>.<br><br>
Token which includes <b>UserName</b>, <b>TimeStamp</b> and <b>Signature</b> transmitted to backend server throught client cookies. Then on backend side it is checked against data substitution.<br><br>
Each token has TTL.<br>
![alt tag](https://github.com/Serjeo722/IIS_ARR_AUTH_Helper/blob/master/doc/schema.png?raw=true)
## Requirements ##
1) IIS 7.0 or higher<br>
2) deployed ARR(<a href="http://www.iis.net/downloads/microsoft/application-request-routing">Application Request Routing</a>) module<br>
3) deployed <a href="http://www.iis.net/downloads/microsoft/url-rewrite">URL Rewrite</a> module<br>


## How to deploy it? ##
