<%
	task.doTask();
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";
var table = 'trade.fixation.list-view';

function fxClicked(row,contract_id,contract_type)
{
	if (contract_id != null) {
		//setValue("contract_id",contract_id);
	}
	if (contract_type != null) {
		//setValue("contract_type",contract_type);
	}
	highlightOn(row,0);
}

function fxDblClicked(row,contract_id,contract_type)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	if (contract_type != null) {
		setValue("contract_type",contract_type);
	}
	setValue('view',1);
	doTask();	
}

function genReport(txt, task_id)
{
	doReport("fixation",txt,task_id);
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
	  <td><%@include file="finance.fixation.filter.jsp"%></td>
    </tr>
	<tr id="fixation_list_view">
	  <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
            <tr align="center" bgcolor="#EEEEEE" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
              <td width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" class="style3"></td>
              <th width="90" rowspan="2" onClick="doSort(table,'ct.ref_number')">Contract Ref.</th>
              <th width="110" rowspan="2" onClick="doSort(table,'seller_buyer')"><%=sc.type=='S'?"Buyer":"Seller"%></th>
              <th rowspan="2" width="60">Market</th>
              <th width="70" rowspan="2">Month</th>
              <th width="70" rowspan="2">Diff.</th>
              <th width="70" rowspan="2">Fixation<br />Date</th>
              <th width="70" rowspan="2">Ex.Rate</th>
              <th colspan="2">Avg. Price </th>
              <th colspan="3">Fixation Tons</th>
              <th colspan="2">Fixation Lots </th>
              <td width="15" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#EEEEEE" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
              <th width="70">USD</th>
              <th width="80"><%=location.currency%></th>
              <th width="70">Delivered</th>
              <th width="70">Fixed</th>
              <th width="70">Unfixed</th>
              <th width="70">Fixed</th>
              <th width="70">Unfixed</th>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td><div style="overflow:scroll; height:250px;">		  
			  <table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style11">
<%
	ContractEntity sum = dao.getPurchaseContractDao().newEntity();//task.getContract(0);
	for (int i = 0; i < cts.size(); i++) {
		PurchaseContractEntity ct = cts.get(i);
		int status = ct.isFixed() ? 2 : 1;
		String color = Action.getColor(status);
		sum.add(ct);
%>				
                <tr onClick="fxClicked(this,<%=ct.getIdLong()%>,'<%=ct.contract_type%>')" onDblClick="fxDblClicked(this,<%=ct.getIdLong()%>,'<%=ct.contract_type%>');">
                  <td width="30" align="right"><%=i+1%></td>
                  <td width="90" style="color:<%=color%>"><%=ct.getRefNumber()%></td>
                  <td width="110"><%=ct.type=='S'?ct.getBuyer().short_name:ct.getSeller().short_name%></td>
                  <td width="60" align="center"><%=ct.getGrade().getQuality().terminal_market%></td>
                  <td width="70" align="center"><%=DateTime.dateToTerminalMonth(ct.terminal_month)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.differential_price,2)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(ct.fixation_date)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.exchange_rate,2)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.contract_price,2)%></td>
                  <td width="80" align="right"><%=Numeric.numberToStr(ct.contract_price_local,_dec)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.delivered_tons)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.fixed_tons)%></td>
                  <td width="70" align="right"><%=ct.unfixed_tons > 0 ? Numeric.numberToStr(ct.unfixed_tons) : "-&nbsp;&nbsp;"%></td>
                  <td width="70" align="center"><%=ct.fixed_lots > 0 ? ct.fixed_lots : "-"%></td>
                  <td width="72" align="center"><%=ct.unfixed_lots > 0 ? ct.unfixed_lots : "-"%></td>
                </tr>				
<%			
	}
%>				
          </table>
</div></td>
        </tr>
        <tr>
          <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#EEEEEE" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
                  <th  align="center">Total</th>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.delivered_tons,3)%></strong></td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.fixed_tons,3)%></strong></td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.unfixed_tons,3)%></strong></td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.fixed_lots,0)%></strong></td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.unfixed_lots,0)%></strong></td>
				  <td width="16">&nbsp;</td>
                </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>
	<tr id="fixation_report" style="display:none">
		<td><%@include file="report.parameter.jsp"%></td>
	</tr>
	<tr id="fixation_buttons" style="display:">
		<td><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td width="">&nbsp;</td>
            <td width="60" align="right"><img src="../shared/images/report.jpg" onClick="genReport('(Fixation Date)',5)"></td>
            <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
          </tr>
        </table></td>
	</tr>
</table>

<input type="hidden" name="contract_id"   id="contract_id"    value="0">


