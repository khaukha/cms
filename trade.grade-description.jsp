<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*, pc.jsp.*, pc.sql.data.*, ngv.share.dao.*, ngv.share.entity.*, ibu.ucms.*, ibu.ucms.dao.*, ibu.ucms.entity.*;" %>

<%
    User user = CMS.getUser(pageContext);
	DAO dao = user.getDao();
	if (user == null || !user.isAuthenticated()) {
		//response.sendRedirect("logon.jsp");	
		//return;
	}
	Request req = Request.get(request);
	int grade_id = req.getInt("grade_id");
	GradeEntity grade = dao.getGradeDao().getById(grade_id);	
	SearchCriteriaEntity sc = user.getSearchCriteria();
	sc.set();
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Select Grade Description</title>

<link href="style.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/Utils.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

function doSelection(obj)
{	
  var no = obj.value;
  var sData = dialogArguments;
  var txt = getValue("description_" + no);//oEnterName.value
  //alert(txt);
  sData.sDescription = txt;
  sData.updateDescription();
	
}

function doClose()
{	
	//window.returnValue = ;
	window.close();
}

</SCRIPT>

</head>

<body>
<form id="form1" name="form1" method="post" action="" style="width:100%">
<label class="style2">Select Description for <%=req.getString("grade")%></label>
<div style="border:thin; border-style:solid; border-width:1; width:100%;" align="center">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr bgcolor="#CCCCCC">
		<th width="60px">&nbsp;</th>
		<th>Description</th>
		<th width="120px">Selected</th>
	</tr>
<%
	List<GradeDescriptionEntity> gds = grade.getDescriptions();	
	for (int no = 1; no <= gds.size(); no++) {
		GradeDescriptionEntity gd = gds.get(no-1);
%>	
	<tr>
		<td>&nbsp;</td>
		<td><textarea name="description_<%=no%>" id="description_<%=no%>" rows="6" class="style2" style="width:100%;" readonly><%=gd.description%></textarea></td>
		<td align="center"><input type="radio" name="selection" id="selection_<%=no%>" value="<%=no%>" onClick="doSelection(this)">&nbsp;</td>
	</tr>
<%
	}
	gds = null;
%>	
	<tr>
		<td><input type="submit" name="Submit" value="Submit" style="display:none" /></td>
		<td align="center"><input class="style2" type="button" name="Close" value="Close" onClick="doClose()"></td>
		<td>&nbsp;</td>
	</tr>
</table>
</div>    
</form>
</body>
</html>
