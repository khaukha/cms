<%@include file="grade.jsp"%>
<%
	SaleContractEntity contract = task.getContract();
	task.doTask(contract);
	//sc.contract_id = contract.getIdLong();
	if (!contract.isNull() && sc.task_id != -1) {
		sc.quality_id = contract.getGrade().quality_id;
	} 
	if (contract.isNull())
	{
		contract.contract_type = 'O';
		contract.last_date = DateTime.lastDateOfMonth(DateTime.getCurDate());
	}
	QualityEntity quality = dao.getQualityDao().getById(sc.quality_id);
	

	String dis = contract.getIdLong()==0?"disabled":"";
	
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var completed = <%=contract.status == 2%>;
var readonly = <%=task.isReadOnly()%>;

/////////////////////////////////////////////
function new_Contract()
{
	if (addNewListItemById("contract_id","New Item") >= 0) doPost();
}

function del_Contract()
{
	if (confirm("Are you sure to delte " + getSelectedText("contract_id"))) doTask(3);
}

function contractTypeChange(o)
{
    contractTypeChanged(o, '<%=contract.contract_type%>', <%=contract.isFixed()%>);
}

function save()
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
	if (getValue("status") == 3) {
		if (!confirm("Are you sure to cancel contract <%=contract.getRefNumber()%>")) {
			return;
		}
	}
	doTask(1);
}

function contractPriceCtsChange(obj)
{
	formatNumberObj(obj,2);	
	var price_cts = toFloat(obj.value);
	var obj = getObj("contract_price");
	obj.value = (price_cts * 22.0462).toFixed(2);
	formatNumberObj(obj,2);	
	differentialChange();
}

function toSample(type, check)
{
	if (check) {
		setValue("type",type);
		toPage("quality.sample.jsp");
	} else {
		alert("This option is not selected.");
	}
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">			
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr>
		<td width="100"><img src="images/sales-contract.jpg"></td>
		<td width="100"><select name="filter_status" id="filter_status" class="style11" style="width:100" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"Status (All)")%></select></td>
		<td width="120"><select name="filter_buyer_id" id="filter_buyer_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"Buyer (All)")%></select></td>
		<td width="200"><select name="filter_grade_id" id="filter_grade_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getGradeFilter(),sc.filter_grade_id,"Grade (All)")%></select></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>	  

	<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
          <tr bgcolor="#DDDDDD">
            <th width="120px">Contract</th>
            <th>Detail (<%=contract.getIdLong()%>)</th>
          </tr>
          <tr>
            <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
  <tr>
    <td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:120;" onChange="itemSelected(this);"><%=Html.selectOptionsX(dao.getSaleContractDao().getList(contract),contract.getIdLong(),"All")%></select></td>
  </tr>
  <tr style="display:<%=displayed%>">
    <td>
		<img src="../shared/images/new.gif" onClick="new_Contract()" title="Create a new contract">
		<img src="../shared/images/delete.gif" onClick="del_Contract()" title="Delete the selected contract" style="display:none">
	</td>
  </tr>
</table>
</td>
            <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
              <tr>
                <td><table width="100%"  border="1" cellspacing="0" cellpadding="0">
                  <tr>
                    <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                      <tr>
                        <td width="50%" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                          <tr>
                            <td width="26%" align="right" class="style2">Contract Ref. &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
								<tr>
									<td width="100"><input type="text" name="ref_number" id="ref_number" class="style2" style="width:100px; font-weight:bold; color:<%=Action.getColor(contract.status)%>" value="<%=contract.getRefNumber()%>" ></td>
									<td><%//=contract.getIdLong()%>&nbsp;</td>
    								<td align="right">Date <%=mandatory%> &nbsp;</td>
    								<td width="94"><%=Html.datePicker("contract_date",contract.contract_date)%></td>
								</tr>
						  </table>                          </tr>
                          <tr>
                            <td align="right" class="style2">Cust. Ref.&nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
								<tr>
									<td width="100"><input type="text" name="bric_ref" id="bric_ref" class="style2" style="width:100px;" value="<%=contract.bric_ref%>" <%=dis%>></td>
									<td align="right">Buyer Ref.&nbsp;</td>
									<td width="94"><input type="text" name="buyer_ref" id="buyer_ref" class="style2" style="width:94;" value="<%=contract.buyer_ref%>" <%=dis%>></td>
								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Buyer &nbsp;</td>
                            <td><select name="buyer_id" id="buyer_id" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptions(dao.getCompanyDao().getBuyers(),contract.buyer_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Quality <%=mandatory%> &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
								<tr>
									<td width="100"><select name="quality_id" id="quality_id" class="style2" style="width:100%;" onChange="doTask(-1);//qualityChanged(this);" <%=dis%>><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.quality_id,"Select Quality")%></select></td>
									<td align="right">Crop &nbsp;</td>
									<td width="94"><input type="text" name="crop" id="crop" class="style2" style="width:100%;" value="<%=contract.crop%>" onKeyUp="toUpper(this)" <%=dis%>></td>
								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Grade <%=mandatory%> &nbsp;</td>
                            <td><select name="grade_id" id="grade_id" class="style2" style="width:100%;" onChange="gradeChanged(this);" <%=dis%>><%=Html.selectOptions(dao.getGradeDao().getByQuality(sc.quality_id),contract.grade_id,"Select Grade")%></select></td>
                          </tr>

                          <tr>
                            <td align="right">Packing &nbsp;</td>
                            <td><select name="packing_id" id="packing_id" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptions(dao.getPackingDao().selectAll(),contract.packing_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td colspan="2"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
								<tr>
									<td width="26%" align="right">Kgs Per Bag &nbsp;</td>
                                    <td width="60"><input type="text" name="kg_per_bag" id="kg_per_bag" class="style2" style="width:60px; text-align:right" value="<%=contract.kg_per_bag%>" onChange="calculateBags()" <%=dis%>></td>
                                    <td align="right">Tons &nbsp;</td>
                                    <td width="60"><input type="text" name="tons" id="tons" class="style2" style="width:60px; text-align:right" value="<%=contract.tons%>" onChange="calculateBags();calculateLots();" <%=dis%>></td>
								    <td align="right">Bags &nbsp;</td>
								    <td width="60"><input type="text" name="no_of_bags" id="no_of_bags" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(contract.no_of_bags,0)%>" <%=dis%>></td>
								</tr>
								<tr>
                            		<td align="right">Lot Size &nbsp;</td>
									<td><input type="text" name="tons_per_lot" id="tons_per_lot" class="style2" style="width:60px; text-align:right" value="<%=contract.tons_per_lot%>" onChange="calculateLots()" <%=dis%>></td>
                                    <td align="right">Shipped &nbsp;</td>
									<td align="right"><strong><%=Numeric.numberToStr(contract.delivered_tons,3)%></strong></td>
									<td align="right">Lots &nbsp;</td>
									<td><input name="no_of_lots" type="text" id="no_of_lots" class="style2" style="width:60px; text-align:right" value="<%=contract.no_of_lots%>" onChange="" <%=dis%>></td>
								</tr>
							</table></td>
                          </tr>
                          <tr>
                            <td align="right">Sales Term &nbsp;</td>
                            <td><select name="contract_term_id" id="contract_term_id" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptions(dao.getContractTermDao().selectAll(),contract.contract_term_id,"")%></select></td>
                          </tr>						  
                          <tr>
                            <td align="right">Payment Term &nbsp;</td>
                            <td><select name="payment_term_id" id="payment_term_id" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptions(dao.getPaymentTermDao().selectAll(),contract.payment_term_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Shipment Period &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr class="style2">
							    <td width="36px" align="right">From &nbsp;</td>
                                <td><%=Html.datePicker("first_date",contract.first_date)%></td>
                                <td width="30px" align="right">&nbsp; To &nbsp;</td>
                                <td><%=Html.datePicker("last_date",contract.last_date)%></td>
                              </tr>
                            </table></td>
                          </tr>
	                          <tr>
                            <td align="right">Destination &nbsp;</td>
                            <td><select name="destination_id" id="destination_id" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptions(dao.getPortDao().selectAll(),contract.destination_id,"")%></select></td>
                          </tr>
	                          <tr>
	                            <td align="right">Forwarder &nbsp;</td>
	                            <td><select name="forwarder_id" id="forwarder_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getServices(),contract.forwarder_id,"")%></select></td>
                          </tr>

	                          <tr>
                            <td align="right">UCDA Ref &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
								<tr>
									<td width="100"><input type="text" name="ucda_ref" id="ucda_ref" class="style2" style="width:94;" value="<%=contract.ucda_ref%>" onKeyUp="toUpper(this)" <%=dis%>></td>
									<td align="right">Received UCDA Draft &nbsp;</td>
									<td width="94"><%=Html.datePicker("received_ucda_date",contract.received_ucda_date)%></td>
								</tr>
								</table></td>
                          </tr>

	                          <tr>
                            <td align="right">Sent UCDA Draft &nbsp;</td>
                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
								<tr>
									<td width="100"><%=Html.datePicker("sent_ucda_date",contract.sent_ucda_date)%></td>
									<td align="right">Endorsed By UCDA &nbsp;</td>
									<td width="94"><%=Html.datePicker("endorsed_ucda_date",contract.endorsed_ucda_date)%></td>
								</tr>
								</table></td>
                          </tr>
	                          <tr>
	                            <td align="right">Samples &nbsp;</td>
	                            <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
								<tr bgcolor="#DDDDDD">
									<td width="33%" align="center"><a href="JavaScript:toSample('A',<%=contract.approval_sample%>)">Approval</a></td>
									<td width="33%" align="center"><a href="JavaScript:toSample('P',<%=contract.preshipment_sample%>)">Pre-Shipment</a></td>
									<td width="34%" align="center"><a href="JavaScript:toSample('S',<%=contract.shipment_sample%>)">Shipment</a></td>
								</tr>
								<tr bgcolor="#EEEEEE">
								  <td align="center"><%=Html.checkBox("approval_sample", contract.approval_sample)%></td>
								  <td align="center"><%=Html.checkBox("preshipment_sample", contract.preshipment_sample)%></td>
								  <td align="center"><%=Html.checkBox("shipment_sample", contract.shipment_sample)%></td>
								  </tr>
								</table></td>
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
                        <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">

	                          <tr>
                            <td width="120" align="right">Arbitration &nbsp;</td>
                            <td><select name="arbitration_id" id="arbitration_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getArbitrationDao().selectAll(), contract.arbitration_id, "")%></select></td>
                          </tr>

                          <tr>
                            <td align="right">Condition &nbsp;</td>
                            <td><textarea name="conditions" id="conditions" rows="2" class="style2" style="width:100%" <%=dis%>><%=contract.conditions%></textarea></td>
                          </tr>

                          <tr>
                            <td align="right">Weights &nbsp;</td>
                            <td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="style2">
								<tr>
									<td width="180"><input type="text" name="weights" id="weights" class="style2" style="width:180;" value="<%=contract.weights%>" <%=dis%>></td>
									<td width="150" align="right">Franchise &nbsp;</td>
									<td width="40"><input type="text" name="franchise" id="franchise" class="style2" style="width:40px; text-align:right" value="<%=contract.franchise%>" <%=dis%>></td>
									<td width="20">&nbsp;%&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
							</table></td>
                          </tr>

                          <tr>
                            <td align="right">Remarks &nbsp;</td>
                            <td><textarea name="remarks" id="remarks" rows="5" class="style2" style="width:100%" <%=dis%>><%=contract.remarks%></textarea></td>
                          </tr>
	
						</table><div style="padding-top:0px"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
								<tr>
									<td width="132px" align="right"><em><strong>Type:</strong></em> <%=mandatory%> &nbsp;</td>
		                            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
										<tr>
											<td width="132"><select name="contract_type" id="contract_type" class="style2" style="width:132px;" onchange="contractTypeChange(this)" <%=dis%>><%=Html.selectOptions(dao.getContractTypeDao().getSalesTypeList(),contract.contract_type,"")%></select></td>
											<td>&nbsp;</td>
										</tr>
									</table></td>
								</tr>
                <tr id="is_PTBF_">
                  <td align="right">Pricing &nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
				  		<tr>
							<td width="80"><input name="is_PTBF" id="is_PTBF_0" type="radio" value="0" <%=contract.is_PTBF?"":"checked"%> onClick="pricingTypeChanged(this,true)" disabled />Out right</td>
							<td width="  "><input name="is_PTBF" id="is_PTBF_1" type="radio" value="1" <%=contract.is_PTBF?"checked":""%> onClick="pricingTypeChanged(this,true)" disabled />PTBF</td>
						</tr>
				  </table></td>
                </tr>
		                        <tr>
                            		<td align="right">Status &nbsp;</td>
                            		<td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
										<tr>
											<td width="80"><input name="pricing_type" id="pricing_type_fixed"   type="radio" value="F" <%=contract.isFixed()?"checked":""%> onClick="pricingTypeChanged(this,true)" disabled />Fixed</td>
											<td width="72"><input name="pricing_type" id="pricing_type_unfixed" type="radio" value="U" <%=!contract.isFixed()?"checked":""%> onClick="pricingTypeChanged(this,true)" disabled />Unfixed</td>
											<td width="  "><strong><%=DateTime.dateToStr(contract.fixation_date)%></strong> &nbsp; <strong>(<%=contract.fixed_tons%> / <%=contract.unfixed_tons%>)</strong></td>
										</tr>
									</table></td>
                          		</tr>
                          <tr>
                            <td align="right">Terminal Market &nbsp;</td>
                            <td><strong><%=quality.terminal_market%></strong></td>
                          </tr>						  
                          <tr>
                            <td align="right">Terminal Month <%=mandatory%> &nbsp;</td>
                            <td><select name="terminal_month" id="terminal_month" class="style2" style="width:132px;" <%=dis%>><%=Html.selectOptions(Terminal.getListByDate(sc.quality_id, contract.last_date, 12), contract.terminal_month, "")%></select></td>
                          </tr>			
                          <tr>
                            <td align="right">Fixation Option &nbsp;</td>
                            <td><input name="fixation_option" id="fixation_option_b" type="radio" value="B" <%=contract.fixation_option=='B'?"checked":""%> />Buyer &nbsp;&nbsp;&nbsp;&nbsp;
							    <input name="fixation_option" id="fixation_option_s" type="radio" value="S" <%=contract.fixation_option=='S'?"checked":""%>/>Seller</td>
                          </tr>
                          <tr style="display:">
                            <td align="right">Currency &nbsp;</td>
                            <td><select name="price_unit_id" id="price_unit_id" class="style2" style="width:132px;" onChange="priceUnitChanged(this)"><%=Html.selectOptions(dao.getPriceUnitDao().selectAll(),contract.price_unit_id,"")%></select></td>
                          </tr>
                          <tr style="display:<%=contract.isLocalSales()?"":"none"%>">
                            <td align="right">Contract Price &nbsp;</label>&nbsp;</td>
                            <td><input name="contract_price_local" type="text" id="contract_price_local" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.contract_price_local,_dec)%>" onBlur="contractPriceLocalChange(this);" <%=dis%>>&nbsp;<label id="contract_price_local_txt_"><%=location.currency+"/Mt"%> &nbsp;</label></td>
                          </tr>
                          <tr style="display:<%=contract.isLocalSales()?"":"none"%>">
                            <td align="right">Exchange Rate &nbsp;</td>
                            <td><input name="exchange_rate" type="text" id="exchange_rate" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.exchange_rate,0)%>" onBlur="exchangeRateChange(this);" <%=dis%>>&nbsp;<%=location.currency+"/USD"%></td>
                          </tr>
                          <tr style="display:<%=contract.isLocalSales()?"none":""%>">
                            <td align="right">Contract Price &nbsp;</label>&nbsp;</td>
                            <td><input name="contract_price_cts" type="text" id="contract_price_cts" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.contract_price_cts,2)%>" onChange="contractPriceCtsChange(this);" <%=dis%>>&nbsp;Cts/Lb &nbsp;</td>
                          </tr>
                          <tr style="display:<%=contract.isLocalSales()?"":""%>">
                            <td align="right">Equivalent &nbsp;</label>&nbsp;</td>
                            <td><input name="contract_price" type="text" id="contract_price" class="style2" style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.contract_price,2)%>"  readonly <%=dis%>>&nbsp;USD/Mt &nbsp;</td>
                          </tr>
                          <tr>
                            <td align="right">Hedge Price &nbsp;</td>
                            <td><input name="hedge_price" type="text" id="hedge_price" class="style2"  style="width:132px; text-align:right" value="<%=Numeric.numberToStr(contract.hedge_price,2)%>" onBlur="hedgePriceChange(this);" <%=dis%>><label id="hedge_price_txt_">&nbsp;USD/Mt</label></td>
                          </tr>
                          <tr>
                            <td align="right">Differential &nbsp;</td>
                            <td><input name="differential_price" type="text" id="differential_price" class="style2" style="width:132px; text-align:right" onFocus="" value="<%=Numeric.numberToStr(contract.differential_price,2)%>" <%=dis%>>&nbsp;<label id="differential_price_txt_">&nbsp;</label></td>
                          </tr>

							</table>
						</div></td>
                      </tr>
					  <tr style="display:none">
					  	<td>&nbsp;</td>
					  	<td>&nbsp;</td>
					  </tr>
                    </table></td>
                  </tr>
                </table></td>
              </tr>
			  <tr>
			    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="20"><img id="save_btn_" src="../shared/images/update.gif" width="15" height="15" border="0" onClick="save()" style="display:<%=displayed%>" title="Save the current contract"></td>
					  <td>&nbsp;</td>
                      <td align="right" style="display:">&nbsp;</td>					  
                      <td align="right" width="60"><img src="../shared/images/print.jpg" width="55" height="18" onClick="doPrint(10)" title="Print the current contract"></td>					  	
					  <td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" onClick="doListView();" title="Back to list view screen"></td>
                    </tr>
                  </table></td>
		      </tr>
              <tr style="padding-bottom:1; display:<%=contract.isCancelled()?"":""%>">
              	<td><%@include file="trade.sales.shipping.jsp"%></td>
              </tr>
      		  <tr style="padding-bottom:1; display:<%=contract.isCancelled()?"":""%>">
        		<td><%@include file="trade.sales_price-fixation.jsp"%></td>
      		  </tr>
     	</table></td>
     </tr>	  		  
  </table>
	<input type="hidden" name="inst_id"  id="inst_id"  value="0">	
	<input type="hidden" name="type"  id="type"  value="">	
</form>

<script language="javascript">
	if (<%=contract.getIdLong()%> == -1) {	
		var idx = addNewListItem(document.formMain.contract_id,"<%=contract.getRefNumber()%>");
		setValue("conditions","As per the conditions of the European contract for coffee");
		setValue("weights","Net Shipped Weights");
		setValue("franchise",0.5);
		setValue("packing_id",1);
		setValue("grade_id",35);
		setValue("payment_term_id",1);
		setValue("contract_term_id", 10);
		setValue("arbitration_id", 2);
		setValue("payment_term_id",5);
		setValue("ucda_ref",'<%=location_id==1?"C.119.":"C.229."%>');
		setValue("provisional_price", "1,574.00");
		setValue("kg_per_bag", 60);
		setValue("price_unit_id", 2);
		if (<%=sc.task_id == 0%>) setValue("tons_per_lot", 10);
	}
	
</script>