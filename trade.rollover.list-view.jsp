<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function rowClicked(row, contract_id)
{
	highlightOn(row);
	setValue("contract_id", contract_id);
}

function rowDblClicked(contract_id)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	setValue("view",1);
	doPost();
}

</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#DDDDDD">
              <td width="42" onClick="doPost()"><img src="../shared/images/refresh.gif" class="style3"></td>
              <td width="70">Rolling<br />Date</td>
              <td width="100">Contract Ref</td>
              <td width="60">Terminal<br />Month</td>
              <th width="80">Diff.</th>
              <th width="80">Stopp<br />Loss</th>
              <th width="300">Remark</th>
              <td width="16">&nbsp;</td>
            </tr>
</table>

<div id="rollover_list_view" style="overflow:scroll; height:350px; width:100%">		  
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<ContractRolloverEntity> rolls = task.getDetails();
	for (int i = 0; i < rolls.size(); i++) {
		ContractRolloverEntity roll = rolls.get(i);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>				
                <tr onClick="rowClicked(this,<%=roll.contract_id%>)" onDblClick="rowDblClicked(<%=roll.contract_id%>)" bgcolor="<%=bgcolor%>">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=roll.getIdLong()%></th>
                  <td width="70" align="center"><%=DateTime.dateToStr(roll.rolling_date)%></td>
                  <td width="100"><%=roll.getContract().getRefNumber()%></td>
                  <td width="60" align="center"><%=DateTime.dateToTerminalMonth(roll.terminal_month)%></td>
                  <td width="80" align="right"><%=Numeric.numberToStr(roll.differential_price,0)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(roll.getStopLoss(),2)%></td>
                  <td width="300"><%=roll.remark%>&nbsp;</td>
                  </tr>
<%
	}
%>				
</table>
</div>

<div id="rollover_report" style="width:100%; display:none"><%@include file="report.parameter.jsp"%></div>

<table id="rollover_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
			<td width="60" align="center" style="display:"><img src="images/report.jpg" width="55" height="18" onClick="doReport('rollover','',4);"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
</td>

	<input type="hidden" name="contract_id" id="contract_id" value="0">

