<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function pmClicked(row)
{
	highlightOn(row);
}

function rowDblClicked(customer_id)
{
	if (customer_id != null) {
		setValue("customer_id",customer_id);
	}
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	//doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('payment');
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#DDDDDD">
              <td width="30"><img src="../shared/images/refresh.gif" onclick="doPost()"></td>
              <th width="150">Short Name</th>
              <th width="200">Full Name </th>
              <th width="300">Address</th>
              <th width="150">Telepone</th>
              <th width="100">Fax</th>
              <th width="180">Website</th>
              <th width="150">Country</th>
              <td width="">&nbsp;</td>
            </tr>
            
</table>

<div style="overflow:scroll; height:350px; width:100%">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<CompanyEntity> cus = task.getCustomerList();
	for (int i = 0; i < cus.size(); i++) {
		CompanyEntity cu = cus.get(i);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>				
                <tr onClick="pmClicked(this)" onDblClick="rowDblClicked(<%=cu.getIdInt()%>)" bgcolor="<%=bgcolor%>">
                  <th width="30" align="right" bgcolor="#DDDDDD"><%=i+1%>&nbsp;</th>
                  <td width="150"><%=cu.short_name%>&nbsp;</td>
                  <td width="200"><%=cu.full_name%>&nbsp;</td>
                  <td width="300"><%=cu.address1%>&nbsp;</td>
                  <td width="150"><%=cu.telephone%>&nbsp;</td>
                  <td width="100"><%=cu.fax%>&nbsp;</td>
                  <td width="180"><%=cu.website.trim()%>&nbsp;</td>
				  <td width="150"><%=cu.getCountry().short_name%>&nbsp;</td>
				  <td>&nbsp;</td>
    </tr>
<%
	}
%>				
</table></div>
<table id="payment_buttons" width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
          <tr>
            <td>&nbsp;</td>
			<td width="60" align="right" style="display:"><img src="images/report.jpg" onClick="doTask(3);"></td>
            <td width="60" align="right"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
<input type="hidden" name="customer_id"   id="customer_id"    value="cu.short_name">


