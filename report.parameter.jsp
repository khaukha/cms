<%
	int report_status = requester.getInt("report_status",1);
%>

<script language="javascript" type="text/javascript">
	function generateReport()
	{
		if (task_id == 0) 	{
			doGenerateReport();
		} else {
			setValue("task_id", task_id);
			document.formMain.submit()
		}
	}
	
	function closeReport()
	{
		if (report_id == null) {
			cancelGenerateReport()
		} else {
			cancelReport(report_id);
		}
	}
</script>

<div style="border:thin; border-style:solid; border-width:0; border-top:1 width:100%; height:150px;" align="left">
<br />
<label id="report_text" style="font-weight:bold;" class="style2">&nbsp;&nbsp;&nbsp;&nbsp;Submit more information for creating report</label>&nbsp;&nbsp;<label id="report_filter" style="font-weight:bold;" class="style2">&nbsp;</label>
<br />
			  <table width="1000"  border="0" class="style2" cellspacing="1" cellpadding="0">
                
                <tr style="padding-top:12px">
                  <td width="10">&nbsp;</td>
                  <th width="150" align="right">From Date &nbsp;</th>
                  <td width="100"><%=Html.datePicker("report_date_from",sc.report_date_from)%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <th align="right">To Date &nbsp;</th>
                  <td><%=Html.datePicker("report_date_to",sc.report_date_to)%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr id="date_type_" style="display:none">
                  <td>&nbsp;</td>
                  <th align="right">Date Type &nbsp;</th>
                  <td><select name="date_type" id="date_type" class="style2" style="width:120;">
              			<option value="C" <%=sc.date_type=='C'?"selected":""%>>Contract Date</option>
<%if (task.getTaskName().equals("purchase")) {%><option value="D" <%=sc.date_type=='D'?"selected":""%>>Delivery Date</option><%}%>
<%if (task.getTaskName().equals("sales")) {%>   <option value="S" <%=sc.date_type=='S'?"selected":""%>>Shipment Date</option><%}%>						
<%if (task.getTaskName().equals("payment")) {%> <option value="P" <%=sc.date_type=='P'?"selected":""%>>Payment Date</option><%}%>						
            		</select></td>
                  <td>&nbsp;</td>
                </tr>
                
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>
				  	<img src="images/update.gif" width="15" height="15" onClick="generateReport();" title="Begin generating report.">&nbsp;
				  	<img src="images/delete.gif" width="15" height="15" onClick="closeReport();" title="Close"></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
		    </table>
</div>