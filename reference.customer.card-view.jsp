<%
	String displayed = task.isReadOnly() ? "none" : "";	
%>

<script language="javascript" type="text/javascript">
function utz(checked)
{
	if (getValue("customer_id") <= 0) {
		return;
	}
	if (checked == null) {
		checked = <%=cust.is_utz%>;
	}
	//getObj("view_").style.paddingTop = checked ? "4px" : "60px";
	show("utz_proj_", checked);
	
}


function add()
{
	if (addNewListItemById("customer_id","New Item") >= 0) {
		doPost();
	}
}

function save()
{
	if (getValue("customer_id") == 0) {
		alert("Please select item to save.");
		return;
	}
	doTask(1);
}

function remove()
{
	removeItem("customer_id", 2);
}

function saveUtz(no)
{
	if (getValue("crop_" + no) == 0) {
		alert("Please Select a Crop.");
		return;
	}
	setValue("no", no);
	doTask(3);
}

function deleteUtz(no)
{
	if (confirm("Are you sure to delete this item ?")) {
		setValue("no", no);
		doTask(4);
	}
}

</script>
<table width=""  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="300" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th>Customer</th>
			</tr>
			<tr>
				<td><select name="customer_id" id="customer_id" size=25 class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getCustomerList(),cust.getIdInt(),"All")%></select></td>
			</tr>
			<tr>
				<td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2" style="display:<%=displayed%>">
						<tr>
							<td width="20"><img src="../shared/images/new.gif" title="New Customer" onClick="add()"></td>
							<td><img src="../shared/images/delete.gif" title="Delete Selected Customer" onClick="remove()"></td>
						</tr>
				</table></td>
			</tr>
		</table></td>
		
		<td width="650" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th>Details</th>
			</tr>
			<tr>
				<td><div id="view_" style="border-style:solid; border-width:1; width:100%; height:340px; padding:1; padding-top:4px;" class="style11"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
					<tr>
						<td width="120" align="right">ID &nbsp;</td>
						<td><strong><%=cust.getIdInt()%></strong></td>
					</tr>
					<tr>
					  <td align="right">TIN No &nbsp;</td>
					  <td><input name="tax_ref" type="text" id="tax_ref" style="width:100" value="<%=cust.tax_ref%>"></td>
				  </tr>
					<tr>
						<td align="right">Short Name &nbsp;</td>
						<td><input name="short_name" type="text" id="short_name" style="width:100%" value="<%=cust.short_name%>"></td>
					</tr>
					<tr>
						<td align="right">Full Name &nbsp;</td>
						<td><input name="full_name" type="text" id="full_name" style="width:100%" value="<%=cust.full_name%>"></td>
					</tr>
					<tr>
						<td align="right">Address &nbsp;</td>
						<td><input name="address1" id="address1"  type="text" class="style2" style="width:100%" value="<%=cust.address1%>" /></td>
					</tr>
					<tr>
						<td align="right">&nbsp;</td>
						<td><input name="address2" id="address2"  type="text" class="style2" style="width:100%" value="<%=cust.address2%>" /></td>
					</tr>
					<tr>
						<td align="right">Telephone &nbsp;</td>
						<td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
								<tr>
									<td width="180"><input name="telephone" type="text" id="telephone" style="width:100%" value="<%=cust.telephone%>"></td>
									<td align="right" width="80">Fax &nbsp;</td>
									<td><input name="fax" type="text" id="fax" style="width:100%" value="<%=cust.fax%>"></td>
								</tr>
						</table></td>
					</tr>
					<tr>
						<td align="right">Email &nbsp;</td>
						<td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
								<tr>
									<td width="180"><input name="email" type="text" id="email" style="width:100%" value="<%=cust.email%>"></td>
									<td align="right" width="80">Website &nbsp;</td>
									<td><input name="website" type="text" id="website" style="width:100%" value="<%=cust.website%>"></td>
								</tr>
						</table></td>
					</tr>
					<tr>
					  <td align="right">Country &nbsp;</td>
					  <td><select name="country_id" id="country_id" class="style2" style="width:180;"><%=Html.selectOptions(dao.getCountryDao().selectAll(),cust.country_id,"")%></select></td>
				  </tr>
					<tr>
						<td align="right" width="120">Type &nbsp;</td>
						<td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
								<tr>
									<td><%=Html.checkBox("is_seller", cust.is_seller)%>Seller</td>
									<td><%=Html.checkBox("is_buyer", cust.is_buyer)%>Buyer</td>
									<td><%=Html.checkBox("is_shipper", cust.is_shipper)%>Shipper</td>
									<td><%=Html.checkBox("is_service", cust.is_service)%>Service</td>
									<td><%=Html.checkBox("is_controller", cust.is_controller)%>Controller</td>
								</tr>
						</table></td>
					</tr>

					<tr>
					  <td align="right">Project &nbsp;</td>
					  <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
					  	<tr>
							<td width="91"><%=Html.checkBox("is_utz", cust.is_utz,"utz(this.checked)")%>Utz/4C</td>
							<td><%//=Html.checkBox("is_4c",  cust.is_4c, "_4c(this.checked)")%></td>
						</tr>
					  </table></td>
				  </tr>
					
					<tr>
						<td align="right">Active &nbsp;</td>
						<td><%=Html.checkBox("active", cust.active)%></td>
					</tr>
					<tr id="utz_proj_" style="display:<%=cust.is_utz?"":"none"%>">
						<td colspan="2"><%@include file="reference.customer.utz.jsp"%></td>
					</tr>
				</table>
				</div></td>
			</tr>
			<tr>
				<td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
						<tr>
							<td><img id="save_btn_" src="../shared/images/update.gif" title="Save Current Customer" onClick="save()" style="display:<%=displayed%>">&nbsp;</td>
							<td align="right"><img src="../shared/images/listview.jpg" title="Back To List View Screen" onClick="setView(0);doPost();"></td>
						</tr>
				</table></td>
			</tr>
		</table></td>
	</tr>
</table>

<input type="hidden" name="no"  id="no"  value="0">

<script language="javascript" type="text/javascript">
	if (<%=cust.getIdInt()%> == -1) {		
		var idx = addNewListItem(document.formMain.customer_id, "<%=cust.short_name%>");
	}
	utz(null);
</script>