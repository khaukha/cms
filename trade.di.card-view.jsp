<%
	DeliveryEntity delivery = task.getDelivery();
	PurchaseContractEntity contract = delivery.getContract();
	task.doCardView(delivery);
	double pending_tons = delivery.getOpenTons();
	List packings = dao.getPackingDao().selectAll();
	BatchEntity batch = delivery.getBatch();
	ibu.ucms.biz.trade.FieldBuzz fb = biz.getTrade().getFieldBuzz();
	List<OptionEntity> batch_list = task.getFreeBatchList(delivery.batch_no);
%>

<script language="javascript">

getObj("main_window").width = "<%=delivery.isNull()?"1000":""%>";

function new_DI()
{
	var name = "Delivery Instruction";
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract for this " + name);
		return;
	}	
	if (addNewListItemById("inst_id","New Item") >= 0) doPost();
}

function sav_DI()
{
	if (getValue("inst_id") != 0) {
		doTask(1);
	}
}

function del_DI()
{
	var inst_id = getValue("inst_id");
	if (inst_id == 0) {
		alert("Please select a Delivery Instruction");
		return;
	}
	if (inst_id < 0) return;
	if (confirm("Are you sure to delete " + getSelectedText("inst_id"))) {
		doTask(3);
	}
}

function toContract()
{
	document.formMain.action = "trade.purchase.jsp";
	document.formMain.submit();
}

function toWnPage(wn_id)
{
	setValue("view",1);
	setValue("wn_id",wn_id);
	document.formMain.action = "warehouse.weighing.jsp";
	doPost();
}

function toQrPage(qr_id)
{
	setValue("view",1);
	setValue("qr_id",qr_id);
	document.formMain.action = "quality.qr.jsp";
	doPost();
}

function saveWeightNote(wn_id, no)
{
	setValue("wn_id", wn_id);
	setValue("no", no);
	doTask(5);
}

function deleteWeightNote(wn_id, ref_number)
{
	if (confirm("Are you sure to delete " + ref_number + "?")) {
		setValue("wn_id", wn_id);
		doTask(6);
	}
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">			
<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
			<tr>
				<th width="240" style="color:#FF0000">DELIVERY INSTRUCTION</th>
				<td width="60" align="right">Status &nbsp;</td>
				<td width="80" align="center"><select name="filter_status" id="filter_status" class="style11" style="width:80" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
				<td width="60" align="right">Seller &nbsp;</td>
				<td width="200" align="center"><select name="filter_seller" id="filter_seller" size=1 class="style11" style="width:200" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),requester.getInt("filter_seller"),"All")%></select></td>
				<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>
<table width="100%"  border="0" class="style2" cellpadding="0" cellspacing="1">
	<tr bgcolor="#DDDDDD">
		<th width="120">Contract Ref</th>
		<th width="150">DI Ref</th>
		<th>Detail</th>
	</tr>
	<tr valign="top">
		<td><select name="contract_id" size=25 class="style11" id="contract_id" style="width:120px;" onChange="setValue('inst_id',0);itemSelected(this)"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(contract),sc.contract_id,"All")%></select></td>
		<td><select name="inst_id" size=25 class="style11" id="inst_id" style="width:150px;" onChange="doPost()"><%=Html.selectOptionsX(contract.getDeliveries(), delivery.getIdLong(),"All")%></select></td>
		<td><div style="border-style:solid; border-width:1; width:auto; border-right:0; height:317"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
            <tr>
              <td width="20%" align="right">Contract Ref. &nbsp;</td>
              <td><a href="javascript:toContract();"><strong><%=delivery.getContract().getRefNumber()%></strong></a></td>
              <td width="20%" align="right">Supplier &nbsp;</td>
              <td width="30%" align="left"><strong><%=delivery.getContract().getSeller().short_name%></strong></td>
            </tr>
            
            <tr>
              <td align="right">DI Ref. &nbsp;</td>
              <td><strong><%=delivery.getRefNumber()%> (<%=delivery.getIdLong()%>)</strong></td>
              <td align="right">Quality &nbsp;</td>
              <td align="left"><strong><%=delivery.getGrade().getQuality().short_name%></strong></td>
            </tr>
            <tr>
              <td align="right">Date &nbsp;</td>
              <td><strong><%=DateTime.dateToStr(delivery.date)%></strong></td>
              <td align="right">Grade &nbsp;</td>
              <td align="left"><strong><%=delivery.getGrade().short_name%></strong></td>
            </tr>
            
            <tr style="display:<%=user.isIbero()?"":"none"%>">
              <td align="right">FieldBuzz API URL &nbsp;</td>
              <td colspan="2" style="color:#0000FF"><strong><%=CMS.API_URL%></strong></td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr style="display:<%=user.isIbero()?"":"none"%>">
              <td align="right">Batch No &nbsp;</td>
              <td colspan="2"><select name="batch_no" id="batch_no" class="style2" style="width:100%;" <%=batch.isCompleted()?"disabled":""%>><%=Html.selectOptions(batch_list,delivery.batch_no,"")%></select></td>
              <td>&nbsp;<a href="JavaScript:doTask(7)">Reload</a></td>
              <td>&nbsp;</td>
            </tr>
            <tr style="display:<%=user.isIbero()?"":"none"%>">
              <td align="right">UCFA Commission &nbsp;</td>
              <td><input type="text" name="commission_rate" id="commission_rate" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(delivery.commission_rate,2)%>" <%=batch.isCompleted()?"disabled":""%>>&nbsp;UGX/Kg</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            
            <tr>
              <td align="right">Packing &nbsp;</td>
              <td><select name="packing_id" id="packing_id" class="style2" style="width:100%;"><%=Html.selectOptions(packings,delivery.packing_id,"")%></select></td>
              <td align="right">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td align="right">Tons &nbsp;</td>
              <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2"><tr>
			  	<td width="80"><input type="text" name="tons" id="tons" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(delivery.tons,4)%>"></td>
				<td align="right">Bags &nbsp;</td>
			  	<td align="right" width="80"><input type="text" name="no_of_bags" id="no_of_bags" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(delivery.no_of_bags,0)%>"></td>
			  </tr></table></td>
              <td align="right">Delivered &nbsp;</td>
              <td align="left"><strong><%=Numeric.numberToStr(delivery.delivered_tons)%></strong> Mts</td>
            </tr>
            <tr>
              <td align="right">Delivery Warehouse &nbsp;</td>
              <td><select name="warehouse_id" id="warehouse_id" class="style2" style="width:100%;" onChange=""><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(location_id),delivery.warehouse_id,"")%></select></td>
              <td align="right">Pending &nbsp;</td>
              <td align="left"><strong><%=Numeric.numberToStr(pending_tons)%></strong> Mts</td>
            </tr>
            
            <tr>
              <td align="right">Proposed Date &nbsp;</td>
              <td><%=Html.datePicker("proposed_date",delivery.proposed_date)%></td>
              <td align="right">Delivery Date &nbsp;</td>
              <td><strong><%=DateTime.dateToStr(delivery.delivery_date)%></strong></td>
            </tr>
            <tr>
              <td align="right">Truck No &nbsp;</td>
              <td><input type="text" name="truck_no" id="truck_no" class="style2" style="width:80;" value="<%=delivery.truck_no%>"></td>
              <td align="right">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td align="right">Remarks &nbsp;</td>
              <td colspan="4"><textarea name="remark" rows="4" class="style2" id="remark" style="width:100%"><%=delivery.remark%></textarea></td>
              </tr>
            <tr>
              <td align="right" height="24">Completed &nbsp;</td>
              <td><%=Html.completionCheckBox(delivery)%></td>
              <td>&nbsp;</td>
              <td style="font-weight:bold">&nbsp;</td>
            </tr>
            <tr>
              <td align="right" height="24">Created By &nbsp;</td>
              <td><strong><%=delivery.getUser().full_name%></strong>&nbsp;</td>
              <td align="right">&nbsp;</td>
              <td style="font-weight:bold">&nbsp;</td>
            </tr>
          </table>
		</div></td>
	</tr>
	<tr>
		<td style="color:#0033FF"><strong> &nbsp; Weight Notes: </strong></td>
		<td><div style="display:<%=displayed%>"><img id="new_btn" src="images/new.gif" border="0" width="15" height="15" onClick="new_DI()"> <img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="del_DI()"></div></td>
		<td><table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
            <tr>
              <td width="20"><img id="save_btn_" src="images/update.gif" border="0" onClick="sav_DI()" style="display:<%=displayed%>"></td>
			  <th style="color:#FF0000"><%=fb.getMessage()%></th>
              <td align="right" width="60"><img src="../shared/images/print.jpg" border="0" onClick="print_DSI('di')"></td>
			  <td align="right" width="60"><img src="../shared/images/listview.jpg" border="0" onClick="setValue('view',0);doPost();"></td>
            </tr>
          </table></td>
	</tr>
</table>
<div style="border-style:solid; border-width:1; border-left:0; width:auto">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
        <tr bgcolor="#DDDDDD">
          <th width="42">Id</th>
          <th width="120">WN Ref. </th>
          <th width="94">Date</th>
          <th width="100">Truck No.</th>
          <th width="60">Area</th>
          <th width="80">Packing</th>
          <th width="50">Bags</th>
          <th width="60">Gross<br>(Kgs)</th>
          <th width="40">Bags<br>(Kgs)</th>
          <th width="60">Husks<br>(Kgs)</th>
          <th width="60">Tare<br>(Kgs)</th>
          <th width="60">Net<br>(Kgs)</th>
          <th width="40">Done</th>
          <th width="50">&nbsp;</th>
          <th width="50">&nbsp;</th>
          <th>QR Ref. </th>
      </tr>
<%
	fb.setMessage("");
	WnImportEntity _wn = delivery.newWeightNote();
	_wn.setNew();
	_wn.no_of_bags = delivery.no_of_bags - delivery.delivered_bags;
	_wn.bags_weight = _wn.getBagsWeight();
	_wn.tare_weight = _wn.bags_weight;
	_wn.net_weight = (delivery.tons - delivery.delivered_tons)*1000;
	_wn.gross_weight = _wn.net_weight + _wn.tare_weight;
	List<WnImportEntity> wns = delivery.getWeightNotes();
	//wns.add(_wn);
	int no = 1;
	WnImportEntity sum = dao.getWnImportDao().newEntity();
	for (int i = 0; i < wns.size(); i++) {
		WnImportEntity wn = wns.get(i);
		sum.add(wn);
		String wn_color = Action.getColor(wn.status);
		String qr_color = Action.getColor(wn.getQualityReport().status);
%>
              <input type="hidden" name="wn_id_<%=no%>"  id="wn_id_<%=no%>"  value="<%=wn.getIdLong()%>"> 
              <tr id="<%=wn.isNull()?"_new_wn_":""%>" onClick="highlightOn(this,2);" style="display:<%=wn.isNull()?"none":""%>">
                <td bgcolor="#DDDDDD" align="right"><a href="JavaScript:toWnPage(<%=wn.getIdLong()%>)"><strong><%=wn.getIdLong()%></strong></a>&nbsp;</td>
                <td><input type="text" name="wn_ref_number_<%=i%>" id="wn_ref_number_<%=i%>" class="style11" style="width:120;" value="<%=wn.getRefNumber()%>"></td>
                <td><%=Html.datePicker("wn_date_"+i, wn.date,"style11")%></td>
                <td><input type="text" name="wn_truck_no_<%=i%>" id="wn_truck_no_<%=i%>" class="style11" style="width:100;" value="<%=wn.truck_no%>" onKeyUp="toUpper(this)"></td>
                <td><select name="wn_area_id_<%=i%>" id="wn_area_id_<%=i%>" class="style11" style="width:60;"><%=Html.selectOptions(dao.getAreaDao().getByWarehouseId(wn.warehouse_id), wn.area_id, "")%></select></td>
                <td><select name="wn_packing_id_<%=i%>" id="wn_packing_id_<%=i%>" class="style11" style="width:80;"><%=Html.selectOptions(packings,wn.packing_id,"")%></select></td>
                <td><input type="text" name="wn_no_of_bags_<%=i%>" id="wn_no_of_bags_<%=i%>" class="style2" style="width:50; text-align:right" value="<%=Numeric.numberToStr(wn.no_of_bags,0)%>"></td>
                <td><input type="text" name="wn_gross_weight_<%=i%>" id="wn_gross_weight_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.gross_weight,1)%>"></td>
                <td><input type="text" name="wn_bags_weight_<%=i%>" id="wn_bags_weight_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.bags_weight,1)%>"></td>
                <td><input type="text" name="wn_tare_balance_<%=i%>" id="wn_tare_balance_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.tare_balance,1)%>"></td>
                <td><input type="text" name="wn_tare_weight_<%=i%>" id="wn_tare_weight_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.tare_weight,1)%>" readonly></td>
                <td><input type="text" name="wn_net_weight_<%=i%>" id="wn_net_weight_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.net_weight,1)%>" readonly></td>
                <td align="center"><%=Html.checkBox("wn_status_"+i, wn.status, null, wn.isNull()||wn.isPaid()?"disabled":"")%></td>
                <td align="center"><a href="JavaScript:saveWeightNote(<%=wn.getIdLong()%>)">Save</a></td>
                <td align="center"><a href="JavaScript:deleteWeightNote(<%=wn.getIdLong()%>,'<%=wn.getRefNumber()%>')">Delete</a></td>
                <td style="color:<%=qr_color%>"><a href="JavaScript:toQrPage(<%=wn.qr_id%>)"><%=wn.getQualityReport().getRefNumber()%></a></td>
              </tr>
<%
		no++;
	}
%>
              <tr class="style2" style="background:#DDDDDD">
                <td align="center"><img src="../shared/images/new.gif" title="Create New WN" onClick="show('_new_wn_');" style="display:none"></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.no_of_bags,0)%></strong>&nbsp;&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.gross_weight,1)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.bags_weight,1)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.tare_balance,1)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.tare_weight,1)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.net_weight,1)%></strong>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
</table>
</div>		  	  
	<input type="hidden" name="no" id="no" value="0">	
	<input type="hidden" name="wn_id" id="wn_id" value="0">	
	<input type="hidden" name="qr_id" id="qr_id" value="0">	
	<input type="hidden" name="wn_type" id="wn_type" value="I">	
	  
</form>	  

<script language="javascript">
	if (<%=delivery.getIdLong()%> == -1) {	
		var idx = addNewListItem(document.formMain.inst_id,"<%=delivery.getRefNumber()%>");
	}	
</script>
