<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function rowClicked(row)
{
	highlightOn(row);
}

function rowDblClicked(fixation_date)
{
	if (fixation_date != null) {
		setValue("fixation_date",fixation_date);
	}
	setValue("view",1);
	doPost();
}

</script>
<table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
            <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'">
              <td width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" class="style3"></td>
              <td width="68" rowspan="2">Hedge<br />Date</td>
              <td width="68" rowspan="2">Fixation<br />Date</td>
              <th width="60" rowspan="2">Terminal Market</th>
              <th width="60" rowspan="2">Terminal Month</th>
              <th colspan="3">Hedge</th>
              <td rowspan="2">Remark</td>
              <td width="15" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'">
              <th width="80">Lots</th>
              <th width="80">Mts</th>
              <th width="80">Level</th>
            </tr>
</table>

<div id="hedge_list_view" style="overflow:scroll; height:350px; width:100%">		  
			  <table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
<%
	List<HedgingEntity> hedgings = task.getDetails();
	for (int i = 0; i < hedgings.size(); i++) {
		HedgingEntity hedging = hedgings.get(i);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>				
                <tr onClick="rowClicked(this)" onDblClick="rowDblClicked('<%=hedging.fixation_date%>')" bgcolor="<%=bgcolor%>">
                  <td width="30" align="right"><%=i+1%></td>
                  <td width="68" align="center"><%=DateTime.dateToStr(hedging.hedge_date)%></td>
                  <td width="68" align="center"><%=DateTime.dateToStr(hedging.fixation_date)%></td>
                  <td width="60" align="center"><%=hedging.getQuality().terminal_market%></td>
                  <td width="60" align="center"><%=DateTime.dateToTerminalMonth(hedging.terminal_month)%></td>
                  <td width="80" align="right"><%=Numeric.numberToStr(hedging.hedge_lots,0)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(hedging.getHedgeTons(),2)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(hedging.hedge_price,2)%>&nbsp;</td>
				  <td width=""><%=hedging.remark%></td>
                  </tr>
<%
	}
%>				
          </table>
</div>
<div id="hedge_report" style="display:none; padding:1"><%@include file="report.parameter.jsp"%></div>
<table id="hedge_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
			<td width="60" align="right" style="display:"><img src="images/report.jpg" width="55" height="18" onClick="doReport('hedge','',3);"></td>
            <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
	<input type="hidden" name="fixation_date" id="fixation_date" value="">

