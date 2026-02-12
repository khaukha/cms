
<%
	ExportChart task = user.getBiz().getManagement().getChart().getExportChart();
	boolean sumary = requester.getBoolean("sumary", true);    
%>


<script language="javascript">
getObj("main_window").width = "";

function qualityClick(o)
{
	doPost();
}

</script>

<form method="POST" name="formMain" action="" onSubmit="">				  
	<%@include file="posted-fields.jsp"%>
<table width="100%" cellpadding="0" cellspacing="1" class="style2">
			  <tr>
				<td width="60" align="right" style="font-weight:bold">Select &nbsp;</td>
				<td width="60"><select name="chart_type" id="chart_type" size=1 class="style11" style="width:100%;" onChange="doPost();">
             	  <option value="I" <%=chart_type=='I'?"selected":""%>>Import</option>
             	  <option value="E" <%=chart_type=='E'?"selected":""%>>Export</option>
             	</select></td>
    			<td width="60" align="right">Quality &nbsp;</td>
    			<td width="80" align="left"><select name="quality_id" id="quality_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.quality_id)%></select></td>
				<td width="200"><select name="filter_grade_id" id="filter_grade_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnExportDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
				<td width="20">&nbsp;</td>
    			<td width="150" align="left" style="display:<%=sc.filter_grade_id==0?"":"none"%>">
					<input name="sumary" type="radio" value="1" <%=sumary?"checked":""%> onclick="doPost()" />Sumary &nbsp;&nbsp;
    				<input name="sumary" type="radio" value="0" <%=!sumary?"checked":""%> onclick="doPost()" />Detail
				</td>
				<td>&nbsp;</td>
  			  </tr>
</table>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width="80">&nbsp;</td>
		<td><img border="0" src="<%=task.getServletUrl()%>"/></td>
	</tr>
</table>	

    	
</form>

<%//@include file="footer.jsp"%>
