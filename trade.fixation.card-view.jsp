
<%
	ContractEntity contract = task.doTask();
	String ex_show = sc.type == Const.PURCHASE ? "" : "";
	String displayed = task.isReadOnly() ? "none" : "";
	boolean is_consignment = contract.contract_type == Const.CONSIGNMENT;
	sc.is_fixed = 0;
	List<ContractTypeEntity> ct_types = sc.type == 'P' ? dao.getContractTypeDao().getPurchaseTypeFilter() : dao.getContractTypeDao().getSalesTypeFilter();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var terminal_market_id = <%=contract.getGrade().getQuality().getTerminalMarketId()%>;
var readonly = <%=task.isReadOnly()%>;

function selectMarketPrice(fixation_id, o)
{
	if (fixation_id <= 0) {
		alert("Please save the fixation to get the new value.");
		return;
	}
	var url = "trade.fixation.market-price.jsp?uid=<%=user.getuid()%>&fixation_id=" + fixation_id;
	var vReturnValue = window.showModalDialog(url,o,"status:false;dialogWidth:0px;dialogHeight:0px;center:yes");
}

function saveFixation(no)
{
	if (<%=contract.contract_type == Const.OUTRIGHT%>) return;
	if (readonly) {
		alert("You can not update this item.");
		return;
	}
	setValue("no",no);
	doTask(1);
}

function deleteFixation(no)
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

function newFixation()
{
	if (getValue("contract_id") <= 0) {
		alert("Please select a contract.");
		return;
	}
	show("new_fixation_");
	//setValue("fixation_date_" + no, getNewDate());
}

function rowClicked(row,contract_id)
{
	if (contract_id != null) setValue("contract_id",contract_id);
	highlightOn(row);
}

function baseCurrencyChange(o,no)
{
	setDisabled("fixation_contract_price_local_" + no, o.value == 'U');
	setDisabled("fixation_contract_price_" + no,     o.value == 'V');
}

function tonsChanged(type,no)
{
	var tons_per_lot = <%=contract.tons_per_lot%>;<%//=ref.getDoubleValue("tons_per_lot")%>
	var tons = toFloat(getValue(type + "_tons_" + no));
	var lots = tonToLot(tons,terminal_market_id,tons_per_lot);
	setValue(type + "_no_of_lots_" + no,lots);
}	

function lotsChanged(type,no)
{
	var tons_per_lot = <%=contract.tons_per_lot%>;<%//=ref.getDoubleValue("tons_per_lot")%>
	var lots = toFloat(getValue(type + "_no_of_lots_" + no));
	var tons = formatNumber(lotToTon(lots,terminal_market_id,tons_per_lot),3,true);
	setValue(type + "_tons_" + no,tons);
}	

function hedgePriceChanged(type,no)
{
	if (getValue("fixation_base_currency_" + no) == 'V') {
		return;
	}
	
	var hprice = toFloat(getValue(type + "_hedge_price_" + no));
	var diff   = toFloat(getValue(type + "_differential_price_" + no));		
	var contract_price = hprice + diff;
	setValue(type + "_contract_price_" + no, formatNumber(contract_price,2,true));
	var exchange_rate  = toFloat(getValue(type + "_exchange_rate_" + no));
	var	contract_price_local = contract_price*exchange_rate;
	setValue(type + "_contract_price_local_" + no, formatNumber(contract_price_local,0,true));
	
}
</script>
<form method="POST" name="formMain" action="" onSubmit="">
<%@include file="posted-fields.jsp"%>	

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td><img src="images/fixation.jpg"></td>
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
    			<td><select name="contract_id" size=28 class="style11" id="contract_id" style="width:100%;" onchange="itemSelected(this);"><%=Html.selectOptionsX(task.getContractDao().getList(), sc.contract_id, "All")%></select></td>
  			</tr>
		</table></td>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
              <tr bgcolor="#EEEEEE">
                <th width="120">Type</th>
                <th width="120">Status</th>
                <th width="120">Contract Type</th>
                <th width=""><label id="seller_buyer_header">Seller</label></th>
                <th width="150">Buyer</th>
                </tr>
              <tr>
                <td><%@include file="inc/filter.contract.jsp"%></td>
                <td><%@include file="inc/filter.status.jsp"%></td>
                <td><select name="filter_contract_type" id="filter_contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(ct_types,sc.filter_contract_type,"All")%></select></td>
                <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
                <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
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
            <th width="96">Fixation<br />Date</th>
            <th width="40">Lots</th>
            <th width="72">Tons</th>
            <th width="72">Hedge<br>Price</th>
            <th width="72">Differential</th>
            <th width="72">Base<br />Currency</th>
            <th width="72" style="display:<%=ex_show%>">Exchange<br />Rate</th>
            <th width="72">Price<br />USD</th>
            <th width="90" style="display:<%=ex_show%>">Price<br /><%=location.currency%></th>
            <th width="24">Sav</th>
            <th width="24">Del</th>
            <th>&nbsp;</th>
          </tr>
<%
	String ro = contract.contract_type == Const.OUTRIGHT ? "" : "";
	List<PriceFixationEntity> fxs = contract.getPriceFixations();
	PriceFixationEntity fx = dao.getPriceFixationDao(sc.type).newEntity(contract);
	fx.exchange_rate = 0;
	fxs.add(fx);
	for (int i = 0; i < fxs.size(); i++) {
		fx = fxs.get(i);
		//PriceFixationEntity fixation = fx;
		String row_id = (i == fxs.size()-1) ? "new_fixation_" : "fixation_" + i;
		String row_dp = (i == fxs.size()-1) ? "none" : "";
%>
          <tr align="center" id="<%=row_id%>" style="display:<%=row_dp%>">
		    <input type="hidden" name="fixation_id_<%=i%>" id="fixation_id_<%=i%>" value="<%=fx.getIdLong()%>">
            <th bgcolor="#EEEEEE"><%=fx.getIdLong()%></th>
            <td><%=Html.datePicker("fixation_fixation_date_" + i,fx.fixation_date)%></td>
            <td><input type="text" name="fixation_no_of_lots_<%=i%>"			id="fixation_no_of_lots_<%=i%>"			class="style2" style="width:40px; text-align:right" value="<%=fx.no_of_lots%>" onChange="lotsChanged('fixation',<%=i%>)"  <%=ro%>></td>
            <td><input type="text" name="fixation_tons_<%=i%>" 					id="fixation_tons_<%=i%>"				class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(fx.tons)%>" onChange="tonsChanged('fixation',<%=i%>)" <%=ro%>></td>
            <td><input type="text" name="fixation_hedge_price_<%=i%>"			id="fixation_hedge_price_<%=i%>"		class="style2" style="width:70px; text-align:right"	value="<%=Numeric.numberToStr(fx.hedge_price,2)%>" onChange="hedgePriceChanged('fixation',<%=i%>)" <%=ro%>></td>
            <td><input type="text" name="fixation_differential_price_<%=i%>"	id="fixation_differential_price_<%=i%>" class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(contract.differential_price,2)%>" readonly></td>
            <td><select name="fixation_base_currency_<%=i%>" id="fixation_base_currency_<%=i%>" size=1 class="style2" style="width:100%;" onchange="baseCurrencyChange(this,<%=i%>)"><%=Html.selectOptions(dao.getCurrencyDao().selectAll(), fx.base_currency)%></select></td>
            <td style="display:<%=ex_show%>"><input type="text" name="fixation_exchange_rate_<%=i%>" id="fixation_exchange_rate_<%=i%>" class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(fx.exchange_rate,2)%>" <%=ro%> <%=fx.isNull()?"disabled":""%>></td>
            <td><input type="text" name="fixation_contract_price_<%=i%>" id="fixation_contract_price_<%=i%>" class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(fx.contract_price,2)%>" <%=ro%> <%=fx.base_currency=='V'?"disabled":ro%>></td>
            <td style="display:<%=ex_show%>"><input type="text" name="fixation_contract_price_local_<%=i%>" id="fixation_contract_price_local_<%=i%>" class="style2" style="width:90px; text-align:right" value="<%=Numeric.numberToStr(fx.contract_price_local,_dec)%>" <%=ro%> <%=fx.base_currency=='U'?"disabled":ro%>></td>
            <td><img src="../shared/images/update.gif" width="15" height="15" border="0" onClick="saveFixation(<%=i%>)" style="display:<%=displayed%>"></td>
            <td><img src="../shared/images/delete.gif" width="15" height="15" border="0" onClick="deleteFixation(<%=i%>)" style="display:<%=displayed%>"></td>
            <td>&nbsp;</td>
          </tr>
<%		  
	}
%>
          <tr align="center" bgcolor="#DDDDDD">
            <td><img src="../shared/images/new.gif" width="15" height="15" onClick="newFixation()" style="display:<%=displayed%>"></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td style="display:<%=ex_show%>">&nbsp;</td>
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
		<td align="right" style="display:">&nbsp;</td>
        <td align="right" width="60"><img src="../shared/images/print.jpg" width="55" height="18" onClick="doPrint(3)"></td>
		<td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" onClick="setValue('view',0);doTask();"></td>
    </tr>
</table>

	<input type="hidden" name="no"  id="no"  value="0">
	<input type="hidden" name="fixation_id" id="fixation_id" value="0">
</form>	

