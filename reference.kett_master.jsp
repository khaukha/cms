<%@include file="authentication.jsp"%>
<%	

	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
	String displayed = task.isReadOnly() ? "none" : "";	
	KettDAO mdao = dao.getKettDao();	
	task.getKett().doTask();
%>
<div align="center" style="background-color:#DDDDDD"><strong>KETT Moisture Discount Table</strong></div>
<table width="100%" border="0" class="style11" cellpadding="0" cellspacing="1">
		<tr bgcolor="#DDDDDD">
		  <th rowspan="2" width="40">Moist<br />(%)</th>
		  <th colspan="2">0.0</th>
		  <th colspan="2">0.1</th>
		  <th colspan="2">0.2</th>
		  <th colspan="2">0.3</th>
		  <th colspan="2">0.4</th>
		  <th colspan="2">0.5</th>
		  <th colspan="2">0.6</th>
		  <th colspan="2">0.7</th>
		  <th colspan="2">0.8</th>
		  <th colspan="2">0.9</th>
		  <th>&nbsp;</th>
	    </tr>
		<tr bgcolor="#DDDDDD">
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th width="36">ISO</th>
		  <th width="36" style="color:#0000FF">Disc.</th>
		  <th>&nbsp;</th>
	    </tr>
<%	
	for (int i = 15; i <= 25; i++) {
%>
		<tr>
		  <th bgcolor="#DDDDDD"><%=i%></th>
<%	
		for (int j = 0; j <= 9; j++) {
			double kp = (double)i + ((double)j)/10; 
			KettEntity en = mdao.getByKettPercent(kp);
%>		
		  <td><input name="iso_percent_<%=i%>_<%=j%>"   id="iso_percent_<%=i%>_<%=j%>"   type="text"  style="width:100%; text-align:right; color:#000000; font-weight:normal" class="style11" value="<%=Numeric.numberToStr(en.iso_percent,2)%>"></td>
		  <td><input name="discount_percent_<%=i%>_<%=j%>" id="discount_percent_<%=i%>_<%=j%>" type="text"  style="width:100%; text-align:right; color:#0000FF; font-weight:normal" class="style11" value="<%=Numeric.numberToStr(en.discount_percent,2)%>"></td>
<%
		}
%>
		  <td bgcolor="#DDDDDD">&nbsp;</td>
	    </tr>
<%		
	}
%>		
</table>
<div align="center" style="background-color:#DDDDDD"><img src="images/update.gif" width="15" height="15" onClick="doTask(1)"></div>


