<%@ page import="org.apache.commons.fileupload.*, java.util.List, java.io.File, java.util.Iterator" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<%

boolean isMultipart = FileUpload.isMultipartContent(request); 
if(!isMultipart){
out.print("False!");
}
else
out.print("True!");
%>
</body>
</html>
