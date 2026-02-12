<script language="javascript">
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
<div style="border-style:solid; border-width:1; border-left:0; width:auto">

<table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
        <tr bgcolor="#DDDDDD" style="font-weight:bold" align="center">
          <th width="30">Id</th>
          <th width="130">WN Ref. </th>
          <th width="94">Date</th>
          <th width="100">Truck No.</th>
          <th width="60">Area</th>
          <th width="80">Packing</th>
          <th width="50">Bags</th>
          <th width="60">Gross<br>(Kgs)</th>
          <th width="60">Bags<br>(Kgs)</th>
          <th width="60">Adj.<br>(Kgs)</th>
          <th width="60">Tare<br>(Kgs)</th>
          <th width="60">Net<br>(Kgs)</th>
          <th width="40">Comp.</th>
          <th width="50">&nbsp;</th>
          <th width="50">&nbsp;</th>
          <th>QR Ref. </th>
          </tr>
<%
	WnImportEntity _wn = delivery.newWeightNote();
	_wn.setNew();
	_wn.no_of_bags = delivery.no_of_bags - delivery.delivered_bags;
	_wn.bags_weight = _wn.getBagsWeight();
	_wn.tare_weight = _wn.bags_weight;
	_wn.net_weight = (delivery.tons - delivery.delivered_tons)*1000;
	_wn.gross_weight = _wn.net_weight + _wn.tare_weight;
	List<WnImportEntity> wns = delivery.getWeightNotes();
	wns.add(_wn);
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
                <td><input type="text" name="wn_ref_number_<%=i%>" id="wn_ref_number_<%=i%>" class="style2" style="width:130;" value="<%=wn.getRefNumber()%>"></td>
                <td><%=Html.datePicker("wn_date_"+i, wn.date)%></td>
                <td><input type="text" name="wn_truck_no_<%=i%>" id="wn_truck_no_<%=i%>" class="style2" style="width:100;" value="<%=wn.truck_no%>" onKeyUp="toUpper(this)"></td>
                <td><select name="wn_area_id_<%=i%>" id="wn_area_id_<%=i%>" class="style2" style="width:60;"><%=Html.selectOptions(dao.getAreaDao().getByWarehouseId(wn.warehouse_id), wn.area_id, "")%></select></td>
                <td><select name="wn_packing_id_<%=i%>" id="wn_packing_id_<%=i%>" class="style2" style="width:80;"><%=Html.selectOptions(packings,wn.packing_id,"")%></select></td>
                <td><input type="text" name="wn_no_of_bags_<%=i%>" id="wn_no_of_bags_<%=i%>" class="style2" style="width:50; text-align:right" value="<%=Numeric.numberToStr(wn.no_of_bags,0)%>"></td>
                <td><input type="text" name="wn_gross_weight_<%=i%>" id="wn_gross_weight_<%=i%>" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.gross_weight,1)%>"></td>
                <td><input type="text" name="wn_bags_weight_<%=i%>" id="wn_bags_weight_<%=i%>" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.bags_weight,1)%>"></td>
                <td><input type="text" name="wn_tare_balance_<%=i%>" id="wn_tare_balance_<%=i%>" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.tare_balance,1)%>"></td>
                <td><input type="text" name="wn_tare_weight_<%=i%>" id="wn_tare_weight_<%=i%>" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.tare_weight,1)%>" readonly></td>
                <td><input type="text" name="wn_net_weight_<%=i%>" id="wn_net_weight_<%=i%>" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wn.net_weight,1)%>" readonly></td>
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
