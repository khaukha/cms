<%@include file="header.jsp"%>

<%
	sc.contract_type = ' ';
	task.doReport();
	String task_name = task.getOwner().getTaskName();
	int report_id = requester.getInt("report_id",2);	
	sc.filter_status = 0;

	java.sql.Date month_end = sc.getMonthEnd();
    java.sql.Date st_arabica = Terminal.getInstance(1).getStartFromMonthEnd(month_end);
    java.sql.Date st_robusta = Terminal.getInstance(2).getStartFromMonthEnd(month_end);

	java.sql.Date tm_arabica = requester.getDate("tm_arabica", st_arabica);	
	java.sql.Date tm_robusta = requester.getDate("tm_robusta", st_robusta);	

%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "800";
var post = true;

function getReportId()
{
	return parseInt(getValue("report_id"));
}
	
function reportSelected()
{
	post = true;
	
	hide("grade_sort");
	hide("yield_type");
	hide("date_report");
  	hide("date_filter");
	hide("contract_type_filter"); 
	hide("date_type_filter"); 
	setText("date_name",""); 
	setText("to_month_txt","To Month"); 
	setText("from_month_txt","From Month"); 
  	hide("month_end");
	show("from_month_");
	show("to_month_");
  	hide("month_end_stock");
  	hide("recalculate_");
  	hide("po_");
	
	switch (getReportId()) {
	  case <%=Report.EXPORT_SCHEDULE%>: //Export Schedule	  	
	  	break;
	  case <%=Report.STOCK%>:  // Stock
	  case <%=Report.POSITION%>:  //Position	  	
	  case <%=Report.STOCK_COUNT%>:  //Stock Count
	  	show("date_report"); 
		break;
	  case <%=Report.YIELD%>:  //Yield
	  	show("yield_type"); 
	  	show("date_filter"); 
		break;
	  case <%=Report.DAILY_STOCK%>:  //Daily Stock
	  	break;
	  case <%=Report.LONG_SHORT%>: // Long Short
	    break;
	  case <%=Report.IMPORT_SCHEDULE%>: // Import Schedule
	    break;
	  case <%=Report.DIFF_VALUATION%>: // Diff Evaluation
	  	show("date_filter");
	  	show("date_type_filter");
	  	show("contract_type_filter");
		setText("date_name",""); 
		break;	 
	  case <%=Report.VALUE_ADDED%>: //Input/Output
	  	show("po_");
	  	show("month_end");
	  	show("tm_robusta_");
	  	show("tm_arabica_");
		setText("date_name","(Terminal Month)"); 
	    break;   
	  case <%=Report.AVERAGE_DIFF_VALUATION%>: // Avg Diff Evaluation
	  	show("month_end");
		setValue("contract_type", ' ');
		setText("date_name","(Terminal Month)"); 
	  	hide("tm_robusta_");
	  	hide("tm_arabica_");
		break;
	  case <%=Report.MONTH_END_STOCK%>:
	    show("month_end_stock");
		break;		
	  case <%=Report.SAMPLE_DESPATCH%>:
	  case <%=Report.DAILY_ACTIVITIES%>:
	  	show("date_filter");
		break;
	  case <%=Report.MATERIAL_STOCK%> :
		hide("to_month_");
	  	hide("tm_robusta_");
	  	hide("tm_arabica_");
	    break;
	  case <%=Report.STOCK_FORECAST%> :
	  	break;
	  case <%=Report.POSITION_TRADE%>:
	  	show("recalculate_");
	  	show("date_filter");
		break;
	  case <%=Report.QUALITY_DISCOUNT%>:
	  case <%=Report.QUALITY_FOLLOW_UP%>:
	  case <%=Report.FINAL_INVOICES%>:  //Final Invoices
	  case <%=Report.SALES_POSITION%>:
	  	show("date_filter");
		break;
	  case <%=Report.MOPSS%>:
	  case <%=Report.MONTHLY_RESULT%>:
	  case <%=Report.DIFF_POSITION%>:
	  	//show("date_filter");
		post = false;
	  	show("month_end");
	  	hide("from_month_");
		hide("tm_arabica_");
		hide("tm_robusta_");
		setText("to_month_txt","Month"); 
		break;
	  //case <%=Report.MONTHLY_RESULT%>:
	  //	show("month_end");
	  //	hide("to_month_");
	  //	hide("tm_arabica_");
	  //	hide("tm_robusta_");
	  //	setText("from_month_txt","Month"); 
	  //    break;
	  case <%=Report.HEDGE_PERFORMANCE%> :
		setText("date_name","(Contract Date)"); 
	  	show("date_filter");
	    break;
	  case <%=Report.SHIPMENT%> :
		setText("date_name","(Shipment Date)"); 
	  	show("date_filter");
	    break;
	}
}

function doReport()
{
	switch (getReportId()) {
	  case <%=Report.EXPORT_SCHEDULE%>: //Export Schedule	  	
	  case <%=Report.STOCK%>:  // Stock
	  case <%=Report.POSITION%>:  //Position	  	
	  case <%=Report.STOCK_COUNT%>:  //Stock Count
	  case <%=Report.YIELD%>:  //Yield
	  case <%=Report.DAILY_STOCK%>:  //Daily Stock
	  case <%=Report.LONG_SHORT%>: // Long Short
	  case <%=Report.IMPORT_SCHEDULE%>: // Import Schedule
	  case <%=Report.DIFF_VALUATION%>: // Diff Evaluation
	  case <%=Report.VALUE_ADDED%>: //Input/Output
	  case <%=Report.AVERAGE_DIFF_VALUATION%>: // Avg Diff Evaluation
	  case <%=Report.MONTH_END_STOCK%>:
	  case <%=Report.DAILY_ACTIVITIES%>:
	  case <%=Report.MATERIAL_STOCK%> :
		break;
	  case <%=Report.POSITION_TRADE%>:
	    var date_from  = getValue("report_date_from");
	    var date_to    = getValue("report_date_to");
		var month_from = getMonth(date_from);
		var month_to   = getMonth(date_to);
		var year_from  = getYear(date_from);
		var year_to    = getYear(date_to);
	  	if (month_from == 0 || month_to == 0 || year_from == 0 || year_to == 0) {
			alert("Please select date filters.");
			return;
		}
	  	if ((month_from != month_to) || (year_from != year_to)) {
			alert("Date filters must be in the same month and year.");
			return;
		}
		break;
	  case <%=Report.QUALITY_DISCOUNT%>:
		break;
	}
	doTask(1);
}

function monthEndChange()
{
	if (post) {
		doPost();
	}
}

</script>

<form method="POST" name="formMain" action="" onSubmit="">				  
<img src="images/reports.jpg">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr class="style2" bgcolor="#EEEEEE">
	  <th width="150px" align="center">Reports</th>
	  <th align="left">Detail</th>
  </tr>
	<tr>
	  <td valign="top"><select name="report_id" size=20 class="style2" id="report_id" style="width:100%;" onChange="reportSelected()"><%=Html.selectOptions(dao.getReportDao().getByTaskName(task_name),report_id)%></select></td>
	  <td  valign="top">
<div style="border-style:solid; border-width:1; width:100%; height:306" class="style2">
<div style="padding-left:20px; padding-top:32px; padding-bottom:32px">Submit more information for creating report <label id="date_name">&nbsp;</label></div>

<table id="grade_sort_" style="display:none" width="100%"  border="0" cellpadding="1" cellspacing="0" class="style2">
	<tr style="display:">
		<td width="120" rowspan="2" align="right">Order By &nbsp;</td>
		<td><input name="sort_by" type="radio" id="grade" value="grade" checked>Grade Name</td>
	</tr>
	<tr>
		<td><input name="sort_by" type="radio" id="grade_code" value="grade_code">Grade Code</td>
	</tr>
</table>

<table id="yield_type" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="150" rowspan="2" align="right">Yield By &nbsp;</td>
		<td><input name="yield" type="radio" id="grade" value="1" checked=> Grade</td>
	</tr>
	<tr>
	  <td><input name="yield" type="radio" id="seller" value="0"> Seller</td>
	  </tr>
</table>

<table id="date_report" style="display:" width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr>
		<td width="150" align="right">Date &nbsp;</td>
		<td><%=Html.datePicker("report_date",requester.getDate("report_date",DateTime.getCurDate()))%></td>
	</tr>
</table>

<table id="date_filter" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="150" align="right">From Date &nbsp;</td>
		<td width="100"><%=Html.datePicker("report_date_from",requester.getDate("report_date_from",DateTime.getCurDate()))%></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right">To Date &nbsp;</td>
		<td><%=Html.datePicker("report_date_to",requester.getDate("report_date_to",DateTime.getCurDate()))%></td>
		<td>&nbsp;</td>
	</tr>
</table>

<table id="date_type_filter"  style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="150" align="right">Date Type &nbsp;</td>
		<td><select name="date_type" id="date_type" size=1 class="style2" style="width:110px;" onChange="">
              <option value="C" <%=sc.date_type=='C'?"selected":""%>>Contract Date</option>
              <option value="P" <%=sc.date_type=='P'?"selected":""%>>Payment Date</option>
            </select></td>
	</tr>
</table>						  
<table id="contract_type_filter" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="150" align="right">Contract Type &nbsp;</td>
		<td><select name="contract_type" id="contract_type" size=1 class="style2" style="width:110px;" onChange="">
              <option value=" " <%=sc.contract_type==' '?"selected":""%>>All</option>
              <option value="O" <%=sc.contract_type=='O'?"selected":""%>>Out right</option>
              <option value="T" <%=sc.contract_type=='T'?"selected":""%>>TBF</option>
              <option value="C" <%=sc.contract_type=='C'?"selected":""%>>Consignment</option>
              <option value="F" <%=sc.contract_type=='F'?"selected":""%>>FOB</option>
            </select></td>
	</tr>
</table>						  
<table id="month_end" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr id="from_month_">
	  <td width="150" align="right"><label id="from_month_txt">From Month</label> &nbsp;</td>
	  <td width="60"><select name="from_month" id="from_month" class="style2" style="width:100%;"><%=Html.selectOptions(Html.months, sc.from_month)%></select></td>
	  <td width="60"><select name="from_year" id="from_year" class="style2" style="width:100%;"><%=Html.selectOptions(Html.years, sc.from_year)%></select></td>
	  <td>&nbsp;</td>
	  </tr>
	<tr id="to_month_">
	  	<td width="150" align="right"><label id="to_month_txt">To Month</label> &nbsp;</td>
	  	<td width="60"><select name="month" id="month" class="style2" style="width:100%;" onchange="monthEndChange()"><%=Html.selectOptions(Html.months,sc.month)%></select></td>
	  	<td width="60"><select name="year" id="year" class="style2" style="width:100%;" onchange="monthEndChange()"><%=Html.selectOptions(Html.years,sc.year)%>
		</select></td>
		<td>&nbsp;</td>
	  </tr>
	  <tr id="tm_robusta_">
		  <td align="right">Terminal Month &nbsp;</td>
		  <td colspan="2"><select name="tm_robusta" id="tm_robusta" class="style2" style="width:100%;"><%=Html.selectOptions(Terminal.getListByMonthEnd(2,month_end,5),tm_robusta,"")%></select></td>
		  <td>&nbsp;LIFFE</td>
	  </tr>
	  <tr id="tm_arabica_">
		  <td align="right">Terminal Month &nbsp;</td>
		  <td colspan="2"><select name="tm_arabica" id="tm_arabica" class="style2" style="width:100%;"><%=Html.selectOptions(Terminal.getListByMonthEnd(1,month_end,5),tm_arabica,"")%></select></td>
		  <td>&nbsp;NYC</td>
	  </tr>
</table>

<table id="po_" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	  <tr>
	    <td width="150" align="right">For PO &nbsp;</td>
	    <td><select name="inst_id" id="inst_id" class="style2" style="width:150;"><%=Html.selectOptionsX(dao.getProcessingDao().list(false),sc.inst_id,"All")%></select></td>
	    </tr>
</table>

<table id="month_end_stock_" style="display:none" width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr>
		<td width="150" rowspan="2" align="right">Select Option &nbsp;</td>
		<td width="25"><input name="export_base_on" type="radio" id="warehouse" value="W" checked=></td>
		<td>In Stock</td>
	</tr>
	<tr>
		<td><input name="export_base_on" type="radio" id="account"   value="A"></td>
		<td>In Accounts</td>
	</tr>
</table>

<table id="recalculate_" style="display:" width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
		<td width="150" align="right">Recalculate &nbsp;</td>
		<td><%=Html.checkBox("recalculate",false)%> (It may take long time if this option is selected.)</td>
	</tr>
</table>


</div>
	  </td>
	</tr>
	
	<tr>
	  <td>&nbsp;</td>
		<td><table width="100%"  border="0" cellspacing="1" cellpadding="0">
            <tr>
              <td><img src="images/update.gif" width="15" height="15" border="0" onClick="doReport(1)" title="Start to generate the report."></td>
            </tr>
          </table></td>
    </tr>
</table>
	  <input type="hidden" name="uid"  id="uid"  value="<%=user.getuid()%>">
	  <input type="hidden" name="task_id"  id="task_id"  value="0">
	  <input type="hidden" name="view" id="view" value="<%=requester.getInt("view")%>">	  
  	  <input type="hidden" name="browser"  id="browser"  value="0">
</form>

<script language="javascript">
	var sort_by = "<%=requester.getString("sort_by","grade")%>";
	getObj(sort_by).checked = true;
	reportSelected();
</script>

<%@include file="footer.jsp"%>
