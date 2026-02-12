<%
	pc.jsp.Response responser = usr.getResponse();
	String message = responser.getMessage();
%>
<form name="viewReport" action="FileDownload" method="POST" target="_blank">
	<input type="hidden" name="uid"  id="uid"  value="<%=usr.getuid()%>">
	<input type="hidden" name="file_name"	id="file_name"	value="<%=responser.getReport()%>" />
	<input type="hidden" name="work_path"	id="work_path"	value="<%=usr.getWorkPath()%>" />	
</form>

<script type="text/javascript" language="javascript">

setValue("browser",(isMac() || isOpera()) ? "1" : "0");

var m_report = "<%=responser.getReport()%>";
if (m_report != "null") {
	document.viewReport.target = (isMac() || isOpera()) ? "" : "_blank";
	document.viewReport.submit()
	<%responser.setReport(null);%>
}

if (message != "null") {
	alert(message);
}

</script>

