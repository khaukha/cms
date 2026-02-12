
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

var table = 'warehouse.allocation';

getObj("main_window").width = "";

function instClicked(row,inst_id)
{
	if (inst_id != null) {  
		setValue("inst_id",inst_id);
	}
	highlightOn(row);
}

function doCardView()
{
	if (getValue("inst_id") == 0) {
		//alert("Please select a PO/SI");
		//return;
	}
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	doTask(5);
}

function cancelGenerateReport()
{
	cancelReport('allocation');
}

</script>
		  
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
      <tr>
		<td><img src="images/allocations.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<%if (sc.alloc_type=='P') {%><%@include file="traffic.allocation.list-view.po.jsp"%><%}%>
<%if (sc.alloc_type=='S') {%><%@include file="traffic.allocation.list-view.si.jsp"%><%}%>	
<%if (sc.alloc_type=='T') {%><%@include file="traffic.allocation.list-view.tr.jsp"%><%}%>	

<div id="allocation_report" style="display:none"><%@include file="report.parameter.jsp"%></div>

<table width="100%"  border="0" cellspacing="1" cellpadding="0" id="allocation_buttons">
        <tr>
			<td align="center"><%@include file="paging.jsp"%></td>
          <td width="60" align="center"><img style="display:" src="images/report.jpg" onClick="doReport('allocation');">&nbsp;</td>
    	  <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="doCardView();"></td>
        </tr>
</table>	  

	<input type="hidden" name="inst_id" id="inst_id"  value="0">
	<input type="hidden" name="search_field"   id="search_field"    value="ins.ref_number">	

