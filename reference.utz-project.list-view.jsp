<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function rowClicked(row)
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

function genReport()
{
	//doReport('utz','',5);
	doTask(5);
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
            <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
              <td width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" class="style3"></td>
              <td width="60" rowspan="2">Crop</td>
              <th width="300" rowspan="2">Seller</th>
              <th width="200" rowspan="2">Address</th>
              <th colspan="3">Volume (Mts) (<strong><%=sc.filter_crop-1%></strong>)&nbsp;</th>
              <th colspan="4">Volume (Mts) (<strong><%=sc.filter_crop%></strong>)&nbsp;</th>
              <td width="70" rowspan="2">Registered<br />Volume<br /><strong>+/-</strong></td>
              <td width="16" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
              <th width="70">Registered</th>
              <th width="70">Delivered</th>
              <th width="70">Balance</th>
              <th width="70">Registered</th>
              <th width="70">UTZ</th>
              <th width="70">4C</th>
              <th width="70">Balance</th>
            </tr>            
</table>

<div style="overflow:scroll; height:350px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
<%
	List<UtzProjectEntity> uts = task.getDetails();
	UtzProjectEntity sum = dao.getUtzProjectDao().newEntity();
	UtzProjectEntity lsum = dao.getUtzProjectDao().newEntity();
	int no = 0;
	for (int i = 0; i < uts.size(); i++) {
		UtzProjectEntity ut = uts.get(i);
		if (over_register && ut.open_tons >= 0) continue;
	    UtzProjectEntity last = dao.getUtzProjectDao().getByKey(ut.crop-1, ut.seller_id);		
		sum.add(ut);
		lsum.add(last);
		String bgcolor = (no++)%2==1?"":"#CCFFFF";
		String wcolor = ut.delivered_tons > ut.registered_tons ? "#FF0000" : "";
%>				
                <tr onClick="rowClicked(this)" onDblClick="rowDblClicked(<%=ut.getSeller().getIdInt()%>)" bgcolor="<%=bgcolor%>" style="color:<%=wcolor%>">
                  <td width="30" align="right"><%=i+1%></td>
                  <td width="60" align="center"><%=ut.crop%></td>
                  <td width="300"><%=ut.getSeller().short_name%>&nbsp;</td>
                  <td width="200"><%=ut.getSeller().address1%>&nbsp;</td>

                  <td width="70" align="right"><%=Numeric.numberToStr(last.registered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(last.delivered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(last.open_tons,3)%>&nbsp;</td>

                  <td width="70" align="right"><%=Numeric.numberToStr(ut.registered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ut.delivered_utz_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ut.delivered_4c_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ut.open_tons,3)%>&nbsp;</td>

                  <td width="70" align="right"><%=Numeric.numberToStr(ut.registered_tons - last.registered_tons,3)%>&nbsp;</td>
    </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                <tr align="right" bgcolor="#DDDDDD">
                  <td width="" align="right">&nbsp;</td>

                  <th width="70" align="right"><%=Numeric.numberToStr(lsum.registered_tons,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(lsum.delivered_tons,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(lsum.open_tons,3)%>&nbsp;</th>

                  <th width="70" align="right"><%=Numeric.numberToStr(sum.registered_tons,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.delivered_utz_tons,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.delivered_4c_tons,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.open_tons,3)%>&nbsp;</th>

                  <th width="70" align="right"><%=Numeric.numberToStr(sum.registered_tons - lsum.registered_tons,3)%>&nbsp;</th>
				  <td width="16">&nbsp;</td>
  </tr>
</table>

<div id="utz_report" style="display:none;"><%@include file="report.parameter.jsp"%></div>

<table id="utz_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
			<td width="60" align="right" style="display:"><img src="images/report.jpg" width="55" height="18" onClick="genReport();"></td>
            <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>	
<input type="hidden" name="customer_id"   id="customer_id"    value="cu.short_name">
