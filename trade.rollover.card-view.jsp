
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var terminal_market_id = <%=contract.getGrade().getQuality().getTerminalMarketId()%>;
var readonly = <%=task.isReadOnly()%>;

function saveRollover(no)
{
	if (<%=contract.contract_type == Const.OUTRIGHT%>) return;
	if (readonly) {
		alert("You can not update this item.");
		return;
	}
	if (getValue("contract_id") == 0) {
		alert("Please select a contract.");
	}
	setValue("no",no);
	doTask(1);
}

function deleteRollover(no)
{
	if (<%=contract.contract_type == Const.OUTRIGHT%>) return;
	if (readonly) {
		alert("You can not delete this item.");
		return;
	}
	if (confirm("Are you sure to delte this item?")) {
		setValue("no",no);
		doTask(2);
	}
}

function newRollover()
{
	if (getValue("contract_id") <= 0) {
		alert("Please select a contract.");
		return;
	}
	show("new_rollover_");
}

function rowClicked(row,contract_id)
{
	if (contract_id != null) setValue("contract_id",contract_id);
	highlightOn(row);
}

/////////////////////////////////////////////
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td><img src="images/rollover.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td width="150"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
  			<tr bgcolor="#EEEEEE">
    			<th>Contract</th>
  			</tr>
  			<tr>
    			<td><select name="contract_id" size=28 class="style11" id="contract_id" style="width:100%;" onChange="itemSelected(this);"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(),sc.contract_id,"All")%></select></td>
  			</tr>
		</table></td>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
              <tr bgcolor="#EEEEEE">
                <th width="120">Type</th>
                <th width="120">Status</th>
                <th width="120">Fixation</th>
                <th width="120">Contract Type</th>
                <th width="180"><label id="seller_buyer_header">Seller</label></th>
                <th width="180">Buyer</th>
                </tr>
              <tr>
                <td><select name="type" id="type" size=7 class="style11" style="width:100%;" onchange="doPost()">
                		          <option id="<%=Const.PURCHASE%>" value="<%=Const.PURCHASE%>" selected>Purchase</option>
		                          <%//writer.setSelected("type", requester.getChar("type",Const.PURCHASE));%>
        		          </select></td>
                <td><%@include file="inc/filter.status.jsp"%></td>
                <td><%@include file="inc/filter.fixation.jsp"%></td>
                <td><select name="contract_type" id="contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();">
              <option value=" " <%=sc.contract_type==' '?"selected":""%>>All</option>
              <option value="T" <%=sc.contract_type=='T'?"selected":""%>>TBF</option>
              <option value="C" <%=sc.contract_type=='C'?"selected":""%>>Consignment</option>
            </select></td>
                <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
                <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td><%@include file="trade.contract.jsp"%></td>
          </tr>
		  <tr>
		  	<td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
          <tr bgcolor="#DDDDDD">
            <th width="40"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
            <th width="96">Rolling<br />Date</th>
            <th width="80">Terminal<br />Month</th>
            <th width="72">Differential</th>
            <th width="72">Stop<br />Loss</th>
            <th width="250">Remark</th>
            <th width="50">&nbsp;</th>
            <th width="50">&nbsp;</th>
            <th>&nbsp;</th>
          </tr>
<%
	List<ContractRolloverEntity> rolls = contract.getRollovers();	
	ContractRolloverEntity roll = dao.getContractRolloverDao().newEntity(contract);	
	roll.setNew();
	rolls.add(roll);
	for (int i = 0; i < rolls.size(); i++) {
		roll = rolls.get(i);
		String row_id = (roll.getIdLong() <= 0) ? "new_rollover_" : "rollover_" + i;
		String row_dp = (roll.getIdLong() <= 0) ? "none" : "";
%>
          <tr align="center" id="<%=row_id%>" style="display:<%=row_dp%>">
		    <input type="hidden" name="roll_id_<%=i%>" id="roll_id_<%=i%>" value="<%=roll.getIdLong()%>">
            <th bgcolor="#EEEEEE"><%=roll.isNew() ? "New" : "" + roll.getIdLong()%></th>
            <td><%=Html.datePicker("rolling_date_" + i,roll.rolling_date)%></td>
            <td><select name="terminal_month_<%=i%>" id="terminal_month_<%=i%>" class="style2" style="width:80px;"><%=Html.selectOptions(Terminal.getListByDate(sc.quality_id, roll.rolling_date, 6), roll.terminal_month)%></select></td>
            <td><input type="text" name="differential_price_<%=i%>"	id="differential_price_<%=i%>" class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(roll.differential_price,2)%>"  /></td>
            <td align="right"><%=Numeric.numberToStr(roll.getStopLoss(),2)%>&nbsp;</td>
            <td><input type="text" name="remark_<%=i%>"	id="remark_<%=i%>" class="style2" style="width:100%;" value="<%=roll.remark%>"  /></td>
            <td><a href="javascript:saveRollover(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
            <td><a href="javascript:deleteRollover(<%=i%>)" style="display:<%=displayed%>">Delete</a></td>
            <td>&nbsp;</td>
          </tr>
<%		  
	}
%>
          <tr align="center" bgcolor="#DDDDDD">
            <td><img src="../shared/images/new.gif" width="15" height="15" onClick="newRollover()" style="display:<%=displayed%>"></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table></td>
		  </tr>
        </table></td>
	</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
    	<td>&nbsp;</td>
        <td align="right" width="60"><img src="../shared/images/print.jpg" width="55" height="18" onClick="doPrint(3)"></td>
        <td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" onClick="doListView()"></td>
    </tr>
</table>

	<input type="hidden" name="no"  id="no"  value="0">
	<input type="hidden" name="roll_id" id="roll_id" value="0">
	

<script language="javascript">
	if (readonly) {
		//setCompletedElements("contract_id");
	}
	setValue("view",1);
</script>