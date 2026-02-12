<%@include file="authentication.jsp"%>

<%	
	ibu.ucms.biz.warehouse.Weighing task = user.getBiz().getWareHouse().weighing;
	WnrEntity wnr = task.getSelectedWnr();
	WnEntity wn = task.getSelectedWn();
	boolean isUtz = wn.getGrade().isUtz();
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
	
	<tr height="56" style="font-family:Arial, Helvetica, sans-serif;font-size:24px;font-weight:bold">
		<td align="center" width="98" style="display:<%=isUtz?"":"none"%>"><img src="utz.gif" width="98" height="98"></td>
	    <td align="center"><%=wnr.getRefNumber()%></td>
	</tr>
	<tr height="56" style="font-family:Arial, Helvetica, sans-serif;font-size:24px;font-weight:bold; display:none">
		<td colspan="2" align="center">WEIGHT NOTE RECEIPT</td>
	</tr>
</table></td>
	</tr>
	<tr>
		<td><table width="100%"  border="1" cellspacing="0" cellpadding="0">
  <tr height="72">
    <td align="center"><img src='<%="temp/bc_"+user.getUserName()+user.getLoginCount()+".jpeg"%>'></td>
  </tr>
          <tr>
            <td><table width="100%"  style="font-family:Arial, Helvetica, sans-serif;font-size:18px;font-weight:normal">
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Grade</td>
			<td><%=wn.getGrade().short_name%></td>
		</tr>
		<tr height="36" style="display:">
			<td width="10">&nbsp;</td>
			<td>Gross (Mt)</td>
			<td><%=Numeric.numberToStr(wnr.gross_weight/1000)%></td>
		</tr>
		<tr height="36" style="display:">
			<td width="10">&nbsp;</td>
			<td>Tare (Mt)</td>
			<td><%=Numeric.numberToStr(wnr.tare_weight/1000)%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Net (Mt)</td>
			<td><%=Numeric.numberToStr(wnr.net_weight/1000)%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Packing</td>
			<td><%=wnr.no_of_bags + " (" + wnr.getPacking().short_name+")"%></td>
		</tr>
		<tr height="36">
			<td width="10">&nbsp;</td>
			<td>Date</td>
			<td><%=DateTime.dateToStr(wnr.date)%></td>
		</tr>
		<tr height="36" style="display:<%=wn.getInstruction().getContract().isNull()?"none":""%>">
		  <td>&nbsp;</td>
		  <td>Supplier</td>
		  <td><%=wn.getInstruction().getContract().getSeller().short_name%></td>
		  </tr>
			<td width="10">&nbsp;</td>
			<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold">Printed<%//="" + wnr.no_of_bags + "/" + wnr.getIdLong()%></td>
			<td style="font-size:12px;font-style:italic; font-weight:bold"><%=DateTime.date_timeToStr(new java.util.Date())%></td>
		</tr>
	</table></td>
          </tr>
        </table></td>
	</tr>
</table>


</body>
</html>
