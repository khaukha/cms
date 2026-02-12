<%@include file="grade.jsp"%>

<%
	PurchaseContractEntity contract = task.getContract();
	task.doTask(contract);
	//sc.contract_id = contract.getIdLong();
	if (!contract.isNull() && sc.task_id != -1) {
		sc.quality_id = contract.getGrade().quality_id;
	} else {
		contract.contract_type = 'O';
	}
	QualityEntity quality = dao.getQualityDao().getById(sc.quality_id);	
	String disa = contract.getIdLong()==0 ?"disabled":"";	
	UtzProjectEntity utz = contract.getUtzProject();	
	QualityDiscountEntity qa = contract.getGrade().getQualityDiscount();
	String qa_readonly = "readonly";
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript" type="text/javascript">

getObj("main_window").width = "";
var completed = <%=contract.status == 2%>;
var readonly = <%=task.getPermission() != 3%>;
/////////////////////////////////////////////

function priceUnitChange(obj)
{
	if (obj == null) {
		obj = getObj("price_unit_id");
	}
	var pid = parseInt(obj.value);
	switch (parseInt(obj.value)) {
		case 1: 
			setText("price_usd", "Contract Price"); 
			setText("price_local", "Equivalent"); 			
			break;
		case 3: 
			setText("price_usd", "Equivalent"); 
			setText("price_local", "Contract Price"); 			
			break;
	}
	setEnabled("contract_price_local", pid == 3);
	setEnabled("contract_price", pid == 1);
	setText("price_usd", pid != 1 ? "Equivalent" : "Contract Price"); 
	setText("price_local", pid == 3 ? "Contract Price" : "Equivalent"); 			
}

function contractTypeChange(o)
{
    contractTypeChanged(o, "<%=contract.contract_type%>", <%=contract.isFixed()%>);
}


function contractPriceLocalChange(obj)
{
	formatNumberObj(obj,2);	
	differentialChange();
}

function contractPriceChanged(obj)
{
	differentialChange();
	formatNumberObj(obj,2);	
}


function saveContract()
{
	if (getValue("contract_id") == 0) {
		alert("Please select a contract.");
		return;
	}
	var tm = getValue("terminal_month");
	if (tm == "" || tm == "1970-01-01") {
		alert("Please select terminal month.");
		return;
	}
	if (getValue("contract_date") == "") {
		alert("Please input contract date.");
		return;
	}
	if (getValue("contract_type") == "") {
		alert("Please select contract type.");
		return;
	}
	if (getValue("grade_id") == 0) {
		alert("Please select Quality and Grade.");
		return;
	}
	if (getValue("exchange_rate") == 0) {
		//alert("Please input exchange rate.");
		//return;
	}
	doTask(1);
}

function calculateExchange(o,l)
{
	var vnd_euro = toFloat(getValue("vnd_eur"));
	var usd_euro = toFloat(getValue("usd_eur"));
	if (usd_euro > 0) {
		var vnd_usd = vnd_euro / usd_euro;
		setValue("vnd_usd", formatNumber(vnd_usd,0));
	}
	formatNumberObj(o,l);
}
	
function selectMarketPrice()
{
	var o = getObj("market_price");
	if (<%=contract.getIdLong()%> <= 0) {
		//save();
		alert("Please save the contract to get the new value.");
		return;
	}
	var url = "trade.purchase.market-price.jsp?uid=<%=user.getuid()%>&contract_id=<%=contract.getIdLong()%>";
	var vReturnValue = window.showModalDialog(url,o,"status:false;dialogWidth:0px;dialogHeight:0px;center:yes");
}
	
</script>
<form method="POST" name="formMain" action="" onSubmit="">
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="100"><img src="images/purchase-offer.jpg"></td>
		<td width="50">Status &nbsp;</td>
		<td width="100"><select name="filter_status" id="filter_status" class="style11" style="width:100" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
		<td width="50">&nbsp; Seller &nbsp;</td>
		<td width="250"><select name="filter_seller" id="filter_seller" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),requester.getInt("filter_seller"),"All")%></select></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>	
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
  <tr bgcolor="#EEEEEE">
    <th width="120px">Contract</th>
    <th>Detail (<%=contract.getIdLong()%>)</th>
  </tr>
  <tr>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:100%;" onChange="itemSelected(this);"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(contract),contract.getIdLong(),"All")%></select></td>
      </tr>
      <tr>
        <td><img src="../shared/images/new.gif" border="0" width="15" height="15" title="Create New Contract" onClick="new_Contract()">
			<img src="../shared/images/delete.gif" title="Delete The Selected Contract" onClick="del_Contract()" style="display:">
		</td>
      </tr>
    </table></td>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><div style="border-style:solid; border-width:1; width:auto">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="40%" valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
                          <tr>
                            <td width="32%" align="right" class="style2">Purchase Ref. &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
  								<tr>
									<td width="100"><input type="text" name="ref_number" id="ref_number" class="style2" style="width:100px; font-weight:bold; color:<%=Action.getColor(contract.status)%>" value="<%=contract.getRefNumber()%>" <%=disa%>></td>
									<td align="right">Date <%=mandatory%> &nbsp;</td>
    								<td align="right" width="94"><%=Html.datePicker("contract_date",contract.contract_date,null,disa)%></td>
  								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Seller &nbsp;</td>
                            <td><select name="seller_id" id="seller_id" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(dao.getCompanyDao().getSellers(),contract.seller_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Quality <%=mandatory%> &nbsp;</td>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
								<tr>
									<td width="120"><select name="quality_id" id="quality_id" class="style2" style="width:100%;" onChange="doTask(-1);" <%=disa%>><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.quality_id,"Select Quality")%></select></td>
									<td align="right">Crop &nbsp;</td>
									<td width="94"><select name="crop" id="crop" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(Html.years,contract.crop,"")%></select></td>
								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Grade <%=mandatory%> &nbsp;</td>
                            <td><select name="grade_id" id="grade_id" class="style2" style="width:100%;" onChange="gradeChanged(this);" <%=disa%>><%=Html.selectOptions(dao.getGradeDao().getByQuality(sc.quality_id),contract.grade_id,"Select Grade")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Packing &nbsp;</td>
                            <td><select name="packing_id" id="packing_id" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(dao.getPackingDao().selectAll(),contract.packing_id,"")%></select></td>
                          </tr>
						
						<tr>
							<td align="right">Kgs Per Bag &nbsp;</td>
							<td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2"><tr>
								<td width="60"><input type="text" name="kg_per_bag" id="kg_per_bag" class="style2" style="width:60px; text-align:right" value="<%=contract.kg_per_bag%>" onChange="calculateBags()" <%=disa%>></td>
								<td align="right">Tons &nbsp;</td>
								<td width="60"><input type="text" name="tons" id="tons" class="style2" style="width:60px; text-align:right" value="<%=contract.tons%>" onChange="calculateBags();calculateLots();" <%=disa%>></td>
								<td width="50" align="right">Bags &nbsp;</td>
							    <td width="60" align="right"><input type="text" name="no_of_bags" id="no_of_bags" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(contract.no_of_bags,0)%>" <%=disa%>></td>
							</tr></table></td>
						</tr>

						<tr>
							<td align="right">Lot Size &nbsp;</td>
							<td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2"><tr>
								<td width="60"><input type="text" name="tons_per_lot" id="tons_per_lot" class="style2" style="width:60px; text-align:right" value="<%=contract.tons_per_lot%>" onChange="calculateLots()" <%=disa%>></td>
                            	<td align="right">Delivered &nbsp;</td>
 								<td align="right" width="60"><strong><%=Numeric.numberToStr(contract.delivered_tons,3)%></strong></td>
								<td width="50" align="right">Lots &nbsp;</td>
								<td width="60" align="right"><input name="no_of_lots" type="text" id="no_of_lots" class="style2" style="width:60px; text-align:right" value="<%=contract.no_of_lots%>" onChange="" <%=disa%>></td>
							</tr></table></td>
						</tr>
						  
                          <tr>
                            <td align="right">Destination &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2"><tr>
									<td width="130"><select name="destination_id" id="destination_id" class="style2" style="width:130;" <%=disa%>><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(location_id),contract.destination_id)%></select></td>
									<td align="right">Last date &nbsp;</td>
									<td width="94" align="right"><%=Html.datePicker("last_date",contract.last_date,null,disa)%></td>
							</tr></table></td>
                          </tr>
                          <tr>
                            <td align="right">Purchase Term &nbsp;</td>
                            <td><select name="contract_term_id" id="contract_term_id" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(dao.getContractTermDao().selectAll(),contract.contract_term_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Payment Term &nbsp;</td>
                            <td><select name="payment_term_id" id="payment_term_id" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(dao.getPaymentTermDao().selectAll(),contract.payment_term_id,"")%></select></td>
                          </tr>
	             <tr>
                   <td align="right">Arbitration &nbsp;</td>
                   <td><select name="arbitration_id" id="arbitration_id" class="style2" style="width:100%;" <%=disa%>><%=Html.selectOptions(dao.getArbitrationDao().selectAll(), contract.arbitration_id, "")%></select></td>
                  </tr>
	             <tr>
	               <td align="right">Remark &nbsp;</td>
	               <td><textarea name="remarks" id="remarks" rows="4" class="style2" style="width:100%" <%=disa%>><%=contract.remarks%></textarea></td>
	               </tr>						

                          <tr>
                            <td align="right">Status &nbsp;</td>
                            <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
								<tr>
									<td width="100"><select name="status" id="status" class="style2" style="width:100" onChange="statusChange(this)"><%=Html.selectOptions(dao.getStatusDao().selectAll(),contract.status)%></select></td>
									<td align="right">Date &nbsp;</td>
									<td align="right" width="94"><%=Html.datePicker("completed_date",contract.completed_date, null, contract.isPending()?"disabled":"")%></td>
								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Created By&nbsp;</td>
                            <td align="left"><strong><%=contract.getUser().full_name%></strong>&nbsp;</td>
                          </tr>
              </table></td>
              <td>		  
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr style="padding-top:0px">
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="65%"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
                <tr>
                  <td width="132" align="right"><em><strong>Type:</strong></em> &nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
				  		<tr>
							<td><select name="contract_type" id="contract_type" class="style2" style="width:132px;" onchange="contractTypeChange(this)"><%=Html.selectOptions(dao.getContractTypeDao().getPurchaseTypeList(),contract.contract_type,"")%></select></td>
						</tr>
				  </table></td>
				</tr>
                <tr id="is_PTBF_">
                  <td align="right">Pricing &nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
				  		<tr>
							<td width="80"><input name="is_PTBF" id="is_PTBF_0" type="radio" value="0" <%=contract.is_PTBF?"":"checked"%> onClick="checkOutRight(true,  <%=contract.isFixed()%>)" disabled />Out right</td>
							<td width="  "><input name="is_PTBF" id="is_PTBF_1" type="radio" value="1" <%=contract.is_PTBF?"checked":""%> onClick="checkOutRight(false, <%=contract.isFixed()%>)" disabled />PTBF</td>
						</tr>
				  </table></td>
                </tr>
                <tr>
                  <td align="right">Status &nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
				  		<tr>
							<td width="80"><input name="pricing_type" id="pricing_type_fixed"   type="radio" value="F" <%=contract.isFixed()?"checked":""%> onClick="pricingTypeChanged(this,true)" disabled />Fixed</td>
							<td width="72"><input name="pricing_type" id="pricing_type_unfixed" type="radio" value="U" <%=!contract.isFixed()?"checked":""%> onClick="pricingTypeChanged(this,true)" disabled />Unfixed</td>
							<td><strong><%=DateTime.dateToStr(contract.fixation_date)%></strong> &nbsp; <strong>(<%=contract.fixed_tons%> / <%=contract.unfixed_tons%>)</strong></td>
						</tr>
				  </table></td>
                </tr>

                          <tr>
                            <td align="right">Terminal Market &nbsp;</td>
                            <td><strong><%=quality.terminal_market%></strong></td>
                          </tr>						  
                          <tr>
                            <td align="right">Terminal Month <%=mandatory%> &nbsp;</td>
                            <td><select name="terminal_month" id="terminal_month" class="style2" style="width:132px;" <%=contract.getRollovers().size()>1?"disabled": disa%>><%=Html.selectOptions(Terminal.getListByDate(sc.quality_id, contract.contract_date, 12), contract.terminal_month, "")%></select></td>
                          </tr>			
                          <tr>
                            <td align="right">Market Price &nbsp;</td>
                            <td><input name="market_price" type="text" id="market_price" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.market_price,2)%><%//=Numeric.numberToStr(contract.getMarketPrice(),2)%>" <%=contract.isNull()?"disabled":""%>></td>
                          </tr>
                          <tr>
                            <td align="right">Fixation Option &nbsp;</td>
                            <td><input name="fixation_option" id="fixation_option_b" type="radio" value="B" <%=contract.fixation_option=='B'?"checked":""%> />Buyer &nbsp;&nbsp;&nbsp;&nbsp;
							    <input name="fixation_option" id="fixation_option_s" type="radio" value="S" <%=contract.fixation_option=='S'?"checked":""%>/>Seller</td>
                          </tr>
                          <tr>
                            <td align="right">Currency &nbsp;</td>
                            <td><select name="price_unit_id" id="price_unit_id" class="style2" style="width:132px;" onChange="priceUnitChange(this)"><%=Html.selectOptions(dao.getPriceUnitDao().selectAll(),contract.price_unit_id,"")%></select></td>
                          </tr>
                          <tr id="exchange_rate_">
                            <td align="right">Exchange Rate &nbsp;</td>
                            <td><input type="text" name="exchange_rate" id="exchange_rate" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.exchange_rate,2)%>" onChange="exchangeRateChange(this);" <%=disa%>>&nbsp;USD/<%=location.currency%></td>
                          </tr>
                          <tr id="contract_price_local_">
                            <td align="right"><label id="price_local">Contract Price</label> &nbsp;</td>
                            <td><input name="contract_price_local" type="text" id="contract_price_local" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.contract_price_local,0)%>" onChange="contractPriceLocalChange(this);" <%=disa%>>&nbsp;<%=location.currency%>/Mt&nbsp;</td>
                          </tr>
                          <tr>
                            <td align="right"><label id="price_usd">Equivalent &nbsp;</label>&nbsp;</td>
                            <td><input name="contract_price" type="text" id="contract_price" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.contract_price,2)%>" onChange="contractPriceChanged(this);" <%=disa%>>&nbsp;<label id="contract_price_txt_">USD/Mt &nbsp;</label></td>
                          </tr>
                          <tr>
                            <td align="right">Hedge Price &nbsp;</td>
                            <td><input name="hedge_price" type="text" id="hedge_price" class="style2"  style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.hedge_price,2)%>" onChange="hedgePriceChange(this);" <%=disa%>>&nbsp;<label id="hedge_price_txt">USD/Mt</label></td>
                          </tr>
                          <tr>
                            <td align="right">Differential &nbsp;</td>
                            <td><input name="differential_price" type="text" id="differential_price" class="style2" style="width:132px; text-align:right" onFocus="" value="<%=Numeric.numberToStr(contract.differential_price,2)%>" <%=disa%>>&nbsp;<label id="differential_price_txt">USD/Mt&nbsp;</label></td>
                          </tr>
                          <tr>
                            <td align="right">Withholding Tax &nbsp;</td>
                            <td><input name="withholding_tax_percent" type="text" id="withholding_tax_percent" class="style2" style="width:132px; text-align:right" onFocus="" value="<%=Numeric.numberToStr(contract.withholding_tax_percent,2)%>" <%=disa%>>&nbsp;%</td>
                          </tr>
                        </table></td>
                        <td valign="top" style="display:"><%@include file="quality.discount.jsp"%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr style="display:none">
                  <td>&nbsp;</td>
                </tr>
              </table></td>
            </tr>
          </table>
        </div></td>
      </tr>
      <tr>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><img id="save_btn_" src="../shared/images/update.gif" width="15" height="15" border="0" title="Save The Current Contract" onClick="saveContract()" style="display:<%=displayed%>"></td>
			<td>&nbsp;</td>
            <td align="right" width="60"><img src="../shared/images/print.jpg" width="55" height="18" onClick="doPrint(10)" title="Print Contract"></td>
            <td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" title="Back To List View Screen" onClick="doListView();"></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
    <tr style="padding-bottom:1; padding-left:1; display:<%=contract.isNull()?"none":""%>">
		<td><%@include file="trade.purchase.delivery.jsp"%></td>
	</tr>
      <tr style="padding-bottom:1; padding-left:1 ">
        <td><%@include file="trade.purchase_price-fixation.jsp"%></td>
      </tr>
</table>	
	<input type="hidden" name="inst_id"  id="inst_id"  value="0">	
	<input type="hidden" name="no" id="no" value="0">	
</form>

<script language="javascript">

	if (<%=contract.getIdLong()%> == -1) {		
		var new_contract = "<%=contract.getRefNumber()%>";
		var idx = addNewListItem(document.formMain.contract_id,new_contract);
		var remarks = 
			"Please advise delivery two days prior in order to avoid late payment. " +
			"Delivery of coffee below contracted specifications is only accepted with discounts as per the attachment with is an intergral part of this contract. " +
			"Price is excluding packaging. ";
		if (!<%=contract.isFixed()%>) {
			remarks += "\n\nFinal exchange rate will be based on the exchange rate in delivery date.";
		}
		setValue("location_id", <%=usr.getLocationId()%>)
		setValue("remarks", remarks);
		setValue("arbitration_id",4);
		setValue("packing_id",4);
		setValue("contract_term_id",1);
		setValue("payment_term_id",2);
		setValue("destination_id",2);
		setValue("grade_id",19);
		setValue("buyer_id", 1)	;	
		setValue("price_unit_id", 3)	;	
		setValue("kg_per_bag", 60);
		if (<%=sc.task_id == 0%>) setValue("tons_per_lot", 10);
	}
	
	if (!completed && <%=!contract.isNull()%>) {
		contractTypeChange(null);
	}
	priceUnitChange(getObj("price_unit_id"));
</script>