<%@include file="authentication.jsp"%>
<%	
	//DAO dao = user.getDao();	
	CompanyDAO mdao     = dao.getCompanyDao();	

	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
	String displayed = task.isReadOnly() ? "none" : "";	

	long selected_id = task.getSelectedId();
	
	CompanyEntity en = mdao.getById(selected_id); 
	selected_id = task.doTask(en);
%>

    <table width="100%" border="0" class="style2" cellpadding="0" cellspacing="0">
      <tr valign="top" bgcolor="#DDDDDD">
	  	<th width="200" align="center" class="style1">Value</th>
        <th align="center">Detail</th>
      </tr>
      <tr>
	  	<td valign="top"><select name="selected_id" id="selected_id" size="26" class="style2" style="width:100%" onChange="doPost()"><%=Html.selectOptions(mdao.selectAll(), en.getIdInt())%></select></td>
        <td align="center" valign="center">
<table width="100%" border="0" align="center" cellspacing="1" class="style2">
		<tr>
		  <th align="right" class="style2">Table</th>
		  <td>&nbsp;</td>
		  <td align="" class="style1">COMPANY_MASTER</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr>
			<td width="98" align="right">ID</td>
			<td width="10">&nbsp;</td>
			<td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td width="10">&nbsp;</td>
		</tr>
          <tr>
            <th align="right" class="style2">Short Name </th>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:100%" value="<%=en.short_name%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">Full Name</th>
            <td>&nbsp;</td>
            <td><input name="full_name" type="text" id="full_name" style="width:100%" value="<%=en.full_name%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right">Address</th>
            <td>&nbsp;</td>
            <td><input name="address1" id="address1"  type="text" class="style2" style="width:100%" value="<%=en.address1%>" /></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right">&nbsp;</th>
            <td>&nbsp;</td>
            <td><input name="address2" id="address2"  type="text" class="style2" style="width:100%" value="<%=en.address2%>" /></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">E-Mail</th>
            <td>&nbsp;</td>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
                <tr>
                  <td width="40%"><input name="email" type="text" id="email" style="width:100%" value="<%=en.email%>"></td>
                  <td align="right">Website &nbsp;</td>
                  <td width="40%"><input name="website" type="text" id="website" style="width:100%" value="<%=en.website%>"></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">Telephone</th>
            <td>&nbsp;</td>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
                <tr>
                  <td width="40%"><input name="telephone" type="text" id="telephone" style="width:100%" value="<%=en.telephone%>"></td>
                  <td align="right">Fax &nbsp;</td>
                  <td width="40%"><input name="fax" type="text" id="fax" style="width:100%" value="<%=en.fax%>"></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">Country</th>
            <td>&nbsp;</td>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
                <tr>
                  <td width="40%"><select name="country_id" id="country_id"  style="width:100%"><%=Html.selectOptions(dao.getCountryDao().selectAll(),en.country_id,"")%></select></td>
                  <td align="right">Location &nbsp;</td>
                  <td width="40%"><select name="location_id" id="location_id"  style="width:100%"><%=Html.selectOptions(dao.getLocationDao().selectAll(),en.location_id,"")%></select></td>
                </tr>
              </table>
			</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">Type</th>
            <td>&nbsp;</td>
            <td>
				<table width="100%"  border="0" bgcolor="#EEEEEE" class="style2">
                  <tr align="left">
                    <td><%=Html.checkBox("is_buyer", en.is_buyer)%>Buyer</td>					
                    <td><%=Html.checkBox("is_seller",en.is_seller)%>Seller</td>
                    <td><%=Html.checkBox("is_shipper",en.is_shipper)%>Shipper</td>
                    <td><%=Html.checkBox("is_controller",en.is_controller)%>Controller</td>
                    <td><%=Html.checkBox("is_service",en.is_service)%>Service</td>
                  </tr>
                </table>
			</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <th align="right" class="style2">Active</th>
            <td>&nbsp;</td>
            <td><%=Html.checkBox("active",en.active)%></td>
            <td>&nbsp;</td>
          </tr>
</table>

</td>
      </tr>
	  <tr style="display:<%=displayed%>">
	  	<td valign="middle"><img src="images/new.gif" width="15" height="15" onClick="doAddNew()">
			<img src="images/delete.gif" width="15" height="15" onClick="doDelete()"></td>
	  	<td align="left" valign="middle"><img src="images/update.gif" width="15" height="15" onClick="doTask(1)"></td>
	  </tr>
    </table>

<script language="javascript">
	if (<%=selected_id%> == -1) {		
		var idx = addNewListItem(document.formMain.selected_id, "New Item");
	}
</script>
