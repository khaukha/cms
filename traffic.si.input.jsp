<script language="javascript">
function calculateBags()
{
	var tons = toFloat(getValue("tons"));
	var kg = toFloat(getValue("kg_per_bag"));
	if (kg <= 0) kg = 60;
	var num = formatNumber((tons*1000+kg-1)/kg,0,false);
	var o = getObj("no_of_bags");
	//setValue("no_of_bags",num);
	o.value = num;
	formatNumberObj(o,0);
	//
}	
</script>
<div style="border:thin; border-style:solid; border-width:1; border-right:none; width:100%; display:">
<table width="100%"  border="0" cellspacing="1" cellpadding="0">
                  <tr>
                    <td width="50%" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                      <tr>
                        <td align="right" width="150">Sales Ref &nbsp;</td>
                        <td style="font-weight:bold"><a href="javascript:doLink('trade.sales.jsp')"><%=contract.getRefNumber()%></a></td>
						<td width="120" align="right">SI Ref.&nbsp;</td>
						<td width="140"><strong><%=shipping.getRefNumber()%></strong></td>
                      </tr>
                      <tr>
                        <td align="right">Date &nbsp;</td>
                        <td><strong><%=DateTime.dateToStr(shipping.date)%></strong></td>
						<td align="right">Type &nbsp;</td>
						<td><strong><%=shipping.getContract().isLocalSales()?"Local Sales":"Export"%></strong>&nbsp;</td>
                      </tr>
                      <tr>
                        <td align="right">Buyer &nbsp;</td>
                        <td><strong><%=shipping.getContract().getBuyer().short_name%></strong></td>
						<td align="right">Client Ref. &nbsp;</td>
						<td><strong><%=shipping.getContract().bric_ref%></strong></td>
                      </tr>
                      <tr>
                        <td align="right">Buyer Ref.&nbsp;</td>
						<td><strong><%=shipping.getContract().buyer_ref%></strong></td>
						<td align="right">Contract Mts &nbsp;</td>
						<td><strong><%=contract.tons%> / <%=contract.no_of_bags%></strong></td>
                      </tr>
                      <tr>
                        <td align="right">Quality &nbsp;</td>
                        <td colspan="3"><strong><%=shipping.getContract().getGrade().getQuality().short_name%> - <%=shipping.getContract().getGrade().short_name%></strong></td>
                      </tr>
                      <tr>
						<td align="right">UCDA Ref. &nbsp;</td>
						<td><strong><%=contract.ucda_ref%></strong></td>
                        <td align="right">&nbsp;</td>
                        <td><strong><%//=contract.getForwarder().short_name%></strong>&nbsp;</td>
                      </tr>
                      <tr>
                        <td align="right">Shipment Bag &nbsp;</td>
						<td><select name="packing_id" id="packing_id" class="style2" style="width:100%;" onChange=""><%=Html.selectOptions(dao.getPackingDao().selectAll(),shipping.packing_id,"")%></select></td>
						<td align="right">Kg per bag &nbsp;</td>
                        <td><input type="text" name="kg_per_bag" id="kg_per_bag" class="style2" style="width:70px; text-align:right" value="<%=shipping.kg_per_bag%>" onChange="calculateBags()"></td>
                      </tr>
                      <tr style="display:">
                        <td align="right">Tons &nbsp;</td>
						<td><input type="text" name="tons" id="tons" class="style2" style="width:70px; text-align:right" value="<%=shipping.tons%>" onChange="calculateBags();"></td>
                        <td align="right">Bags &nbsp;</td>
                        <td width="70"><input type="text" name="no_of_bags" id="no_of_bags" class="style2" style="width:70; text-align:right" value="<%=Numeric.numberToStr(shipping.no_of_bags,0)%>"></td>
                      </tr>
                      <tr>
                        <td align="right">Containers &nbsp;</td>
                        <td><input type="text" name="no_of_containers" id="no_of_containers" class="style2" style="width:70px; text-align:right" value="<%=shipping.no_of_containers%>"></td>
						<td align="right">Dri-Bags (kg) &nbsp;</td>
						<td><input type="text" name="dri_bags" id="dri_bags" class="style2" style="width:70px; text-align:right" value="<%=shipping.dri_bags%>"></td>
                      </tr>
                      <tr style="display:">
                        <td align="right">Shipping From &nbsp;</td>
                        <td><%=Html.datePicker("first_date",shipping.first_date)%></td>
						<td align="right">To &nbsp;</td>
                        <td><%=Html.datePicker("last_date",shipping.last_date)%></td>
                      </tr>
                      <tr>
                        <td align="right">Stuffing Date&nbsp;</td>
                        <td><%=Html.datePicker("stuffing_date",shipping.stuffing_date)%></td>
                        <td align="right">Stuffing At &nbsp;</td>
                        <td><select name="warehouse_id" id="warehouse_id" class="style2" style="width:150;" onChange=""><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(location_id),shipping.warehouse_id,"")%></select></td>
                      </tr>
                      <tr>
                        <td align="right">B/L No. &nbsp;</td>
                        <td><input type="text" name="bill_of_lading_no" id="bill_of_lading_no" class="style2" style="width:150px;" value="<%=shipping.bill_of_lading_no%>"></td>
						<td align="right">B/L Date &nbsp;</td>
						<td><%=Html.datePicker("bill_of_lading_date",shipping.bill_of_lading_date)%></td>
                      </tr>					  
					  <tr>
    					<td align="right">Booking No &nbsp;</td>
    					<td colspan="3"><input type="text" name="booking_no" id="booking_no" class="style2" style="width:100%;" value="<%=shipping.booking_no%>" onKeyUp="toUpper(this);"></td>
  					</tr>
					  <tr>
					    <td align="right">ICO Lot No &nbsp;</td>
					    <td colspan="3"><input type="text" name="ico_lot_no" id="ico_lot_no" class="style2" style="width:100%;" value="<%=shipping.ico_lot_no%>" onKeyUp="toUpper(this);"></td>
				      </tr>
					  <tr style="display:">
					    <td align="right">Forwarder &nbsp;</td>
					    <td colspan="3" ><select name="forwarder_id" id="forwarder_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getServices(),shipping.forwarder_id,"")%></select></td>
					    </tr>
                    </table></td>
                    <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
  <tr>
    <td colspan="2" align="right">Shipper &nbsp;</td>
    <td colspan="5" ><select name="shipper_id" id="shipper_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getShippers(),shipping.shipper_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Consignee &nbsp;</td>
    <td colspan="5" valign="top"><select name="consignee_id" id="consignee_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getBuyers(),shipping.consignee_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Notify Party &nbsp;</td>
    <td colspan="5" valign="top"><select name="notify_party_id" id="notify_party_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getBuyers(),shipping.notify_party_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Notify Party 2 &nbsp;</td>
    <td colspan="5" valign="top"><select name="notify_party2_id" id="notify_party2_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getBuyers(),shipping.notify_party2_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Shipping Line &nbsp;</td>
    <td colspan="5" valign="top"><select name="shipping_line_id" id="shipping_line_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getShippingLineDao().selectAll(),shipping.shipping_line_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Ocean Vessel &nbsp;</td>
    <td colspan="5" valign="top"><input type="text" name="ocean_vessel" id="ocean_vessel" class="style2" style="width:100%;" value="<%=shipping.ocean_vessel%>"></td>
  </tr>
  <tr>
    <td colspan="2" align="right">ETS &nbsp;</td>
    <td colspan="2"><%=Html.datePicker("ocean_vessel_ets",shipping.ocean_vessel_ets)%></td>
    <td align="right">ETA &nbsp;</td>
    <td colspan="2"><%=Html.datePicker("ocean_vessel_eta",shipping.ocean_vessel_eta)%></td>
    </tr>
  <tr>
    <td colspan="2" align="right">Port of Loading &nbsp;</td>
    <td colspan="5"><select name="port_loading_id" id="port_loading_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getPortDao().selectAll(),shipping.port_loading_id,"")%></select></td>
  </tr>
  <tr style="display:none">
    <td colspan="2" align="right">Transhipment Port &nbsp;</td>
    <td colspan="5"><select name="port_transit_id" id="port_transit_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getPortDao().selectAll(),shipping.port_transit_id,"")%></select></td>
  </tr>
  <tr style="display:">
    <td colspan="2" align="right">Destination Port &nbsp;</td>
    <td colspan="5"><select name="destination_id" id="destination_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getPortDao().selectAll(),shipping.destination_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Shipment Type &nbsp;</td>
    <td colspan="5"><select name="shipment_type" id="shipment_type" class="style2" style="width:100%;">
        <option value="" <%=shipping.shipment_type.equals("")?"selected":""%>></option>
        <option value="FCL/FCL" <%=shipping.shipment_type.equals("FCL/FCL")?"selected":""%>>FCL/FCL</option>
        <option value="LCL/FCL" <%=shipping.shipment_type.equals("LCL/FCL")?"selected":""%>>LCL/FCL</option>
    </select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Weight Cert. By &nbsp;</td>
    <td colspan="5"><select name="weight_controller_id" id="weight_controller_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getControllers(),shipping.weight_controller_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Quality Cert. By &nbsp;</td>
    <td colspan="5"><select name="quality_controller_id" id="quality_controller_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getControllers(),shipping.quality_controller_id,"")%></select></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Fumigation &nbsp;</td>
    <td colspan="5"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
		<tr>
    		<td width="20"><%=Html.checkBox("fumigation",shipping.fumigation)%></td>
    		<td width="60" align="right">Tally</td>
    		<td width="20"><%=Html.checkBox("tally",shipping.tally)%></td>
    		<td  align="right">Kraft Paper</td>
    		<td width="20"><%=Html.checkBox("kraft_paper",shipping.kraft_paper)%></td>
    		<td width="100" align="right">Carton Board</td>
    		<td width="20" align="right"><%=Html.checkBox("carton_board",shipping.carton_board)%></td>
		</tr>
	</table></td>
  </tr>
  <tr>
    <td colspan="2" align="right">Samples &nbsp;</td>
    <td colspan="5"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
							<tr bgcolor="#DDDDDD">
							  <td width="33%" align="center">Approval</td>
							  <td width="33%" align="center">Pre-Shipment</td>
							  <td width="34%" align="center">Shipment</td>
						  </tr>
							<tr bgcolor="#EEEEEE">
								<td align="center"><%=contract.approval_sample?"Yes":"No"%></td>
								<td align="center"><%=contract.preshipment_sample?"Yes":"No"%></td>
								<td align="center"><%=contract.shipment_sample?"Yes":"No"%></td>
							</tr>
						</table></td>
  </tr>
</table></td>
                  </tr>
				</table>
				
<hr />
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
              <tr>
                <td width="150" align="right">Freight &nbsp;</td>
                <td><input type="text" name="freight" id="freight" class="style2" style="width:100%;" value="<%=shipping.freight%>"></td>
                </tr>
              <tr>
                <td align="right">Marking On Bags &nbsp;</td>
                <td><textarea name="marking_on_bags" id="marking_on_bags" rows="7" class="style2" style="width:100%"><%=shipping.marking_on_bags%></textarea></td>
                </tr>
              <tr>
                <td align="right">Remark &nbsp;</td>
                <td><textarea name="remark" id="remark" rows="4" class="style2" style="width:100%"><%=shipping.remark%></textarea></td>
              </tr>
              <tr>
                <td align="right">Completed &nbsp;</td>
                <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
					<tr>
						<td><%=Html.completionCheckBox(shipping)%></td>
						<td align="right"><em>Ordered By </em> <strong><%=shipping.getUser().full_name%></strong> &nbsp;</td>
					</tr>
				</table></td>
                </tr>
            </table>				
</div>			