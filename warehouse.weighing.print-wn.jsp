<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="ibu.ucms.*,pc.system.*,pc.util.*,pc.sql.data.*,ibu.ucms.biz.warehouse.weighing.*,ibu.ucms.entity.*, ngv.share.entity.*"%>

<%	
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.Weighing task = user.getBiz().getWareHouse().weighing;
	
	if (!user.isAuthenticated()) {
		//response.sendRedirect("logon.jsp");
		return;
	}
	
	WnEntity wn = task.getSelectedWn();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>WEIGHT NOTE RECEIPT</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<table  width="480px" align="center">
	<tr>
		<td><table width="100%" align="center">
	<tr height="24">
		<td>&nbsp;</td>
	</tr>
	<tr height="56" style="font-family:Arial, Helvetica, sans-serif;font-size:28px;font-weight:bold">
		<td align="center"><%//=rs.getString("wn_ref_number")%></td>
	</tr>
	<tr height="56" style="font-family:Arial, Helvetica, sans-serif;font-size:24px;font-weight:bold">
		<td align="center">WEIGHT NOTE</td>
	</tr>
</table></td>
	</tr>
	<tr>
		<td><table width="100%"  border="1" cellspacing="0" cellpadding="0">
  <tr height="72">
    <td align="center" style="font-family:Arial, Helvetica, sans-serif;font-size:24px;font-weight:bold"><%=wn.getRefNumber()%></td>
  </tr>
          <tr>
            <td><table width="100%"  style="font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:normal">
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td width="120">Quality</td>
			<td><%=wn.getGrade().getQuality().short_name%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Grade</td>
			<td><%=wn.getGrade().short_name%></td>
		</tr>
		<tr height="36">
		  <td>&nbsp;</td>
		  <td>Code</td>
		  <td><%=wn.getGrade().grade_code%></td>
		  </tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Gross (Mt)</td>
			<td><%=Numeric.numberToStr(wn.gross_weight/1000)%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Tare (Mt)</td>
			<td><%=Numeric.numberToStr(wn.tare_weight/1000)%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Net (Mt)</td>
			<td><%=Numeric.numberToStr(wn.net_weight/1000)%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Quantity Packages</td>
			<td><%="" + wn.no_of_bags + " " + wn.getPacking().short_name + "(s)"%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Date</td>
			<td><%=DateTime.dateToStr(wn.date)%></td>
		</tr>
		<tr height="36">
		  <td>&nbsp;</td>
		  <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><img src='<%="temp/bc_"+user.getUserName()+user.getLoginCount()+".jpeg"%>'></td>
              </tr>
          </table></td>
		  </tr>
		<tr>
			<td width="10">&nbsp;</td>
			<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold"><%="" + wn.no_of_bags + "/" + wn.getIdLong()%><%//="" + rs.getInt("no_of_bags") + "/" + rs.getString("id")%></td>
			<td style="font-size:12px;font-style:italic" align="right"><%=DateTime.date_timeToStr(new java.util.Date())%></td>
		</tr>
	</table></td>
          </tr>
        </table></td>
	</tr>
</table>


</body>
</html>
<%
	//rs.close();
%>