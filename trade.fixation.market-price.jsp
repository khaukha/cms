<%@ page contentType="text/html; charset=iso-8859-1"%>
<%@ page import="java.util.*,pc.sql.data.*,ibu.ucms.*, ibu.ucms.entity.*;" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>
<body>

<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		//response.sendRedirect("logon.jsp");	
		//return;
	}

	ibu.ucms.biz.trade.Fixation task = user.getBiz().getTrade().fixation;	
	PriceFixationEntity fixation = task.getPriceFixation();	
%>


<script language="javascript">
	var sData = dialogArguments;
	sData.value = <%=fixation.getMarketPrice()%>;
	window.close();
</script>
</body>
</html>
