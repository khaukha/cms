
<%
	ImportChart task = user.getBiz().getManagement().getChart().getImportChart();
	sc.filter_grade_id = requester.getInt("filter_grade_id", 9);
	sc.report_date_from = requester.getDate("report_date_from");
	int screen = requester.getInt("screen", 16);
	String defect = requester.getString("defect", "foreign_matter");
%>


<script language="javascript">
getObj("main_window").width = "";

</script>

<form method="POST" name="formMain" action="" onSubmit="">				  
	<%@include file="posted-fields.jsp"%>
<table width="100%" cellpadding="0" cellspacing="1" class="style11">
			  <tr align="center" bgcolor="#EEEEEE">
				<td width="80">Chart</td>
				<td width="80">Quality &nbsp;</td>
				<td width="180">Grade</td>
				<td width="100">Screen</td>
				<td width="100">Spec.</td>
				<td width="94">From</td>
				<td width="94">To</td>
				<td width="54">&gt;= (Mt)</td>
				<td width="54" align="right">&nbsp;</td>
  			    <td>&nbsp;</td>
			  </tr>
			  <tr>
			    <td><select name="chart_type" id="chart_type" size=1 class="style11" style="width:100%;" onChange="doPost();">
             	  <option value="I" <%=chart_type=='I'?"selected":""%>>Import</option>
             	  <option value="E" <%=chart_type=='E'?"selected":""%>>Export</option>
             	</select></td>
			    <td><select name="quality_id" id="quality_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.quality_id)%></select></td>
			    <td><select name="filter_grade_id" id="filter_grade_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
			    <td><select name="screen" id="screen" size=1 class="style11" style="width:100%;" onChange="doPost();">
             	  <option value="18" <%=screen==18?"selected":""%>>Screen 18+</option>
             	  <option value="17" <%=screen==17?"selected":""%>>Screen 17+</option>
             	  <option value="16" <%=screen==16?"selected":""%>>Screen 16+</option>
             	  <option value="15" <%=screen==15?"selected":""%>>Screen 15+</option>
             	  <option value="14" <%=screen==14?"selected":""%>>Screen 14+</option>
             	  <option value="13" <%=screen==13?"selected":""%>>Screen 13+</option>
             	  <option value="12" <%=screen==12?"selected":""%>>Screen 13-</option>
             	</select></td>
			    <td><select name="defect" id="defect" size=1 class="style11" style="width:100%;" onChange="doPost();">
             	  <option value="moisture" <%=defect.equals("moisture")?"selected":""%>>Moisture</option>
             	  <option value="foreign_matter" <%=defect.equals("foreign_matter")?"selected":""%>>FM</option>
             	  <option value="black" <%=defect.equals("black")?"selected":""%>>Black</option>
             	  <option value="broken" <%=defect.equals("broken")?"selected":""%>>Broken</option>
             	  <option value="brown" <%=defect.equals("brown")?"selected":""%>>Brown</option>
             	  <option value="moldy" <%=defect.equals("moldy")?"selected":""%>>Moldy</option>
             	</select></td>
			    <td><%=Html.datePicker("report_date_from",sc.report_date_from,"style11")%></td>
			    <td><%=Html.datePicker("report_date_to",sc.report_date_to,"style11")%></td>
			    <td align="center"><input name="min_tons" type="text" id="min_tons" style="width:54; text-align:right" class="style11" value="<%=Numeric.numberToStr(requester.getInt("min_tons",100),0,"")%>"></td>
			    <td align="center"><a href="JavaScript:doPost()">Submit</a> </td>
                <td align="right">&nbsp;</td>
    </tr>
</table>

<div><img border="0" src="<%=task.getServletUrl()%>"/></div>
    	
</form>

