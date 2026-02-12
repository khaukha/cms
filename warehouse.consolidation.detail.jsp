<script language="javascript">

var busy = false;
function doConsolidation(o, wn_id)
{
	if (busy) {
		alert("Please wait the process finish before select next item.");
		return;
	}
	busy = true;
	setValue("wn_id", wn_id);
	doTask(o.checked ? 2 : 3);
}

function doSort(sort_field)
{
	setValue("sort_field", sort_field);
	doPost();
}

</script>
<div style="width:100%; border:1; border-style:solid">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">
	  <th width="120"><a href="JavaScript:doSort('wn.ref_number')">WN Ref</a></th>
	  <th width="120">Contract Ref</th>
	  <th width="60">Date</th>
	  <th width="60">Area</th>
	  <th width="120">Cons. Ref.</th>
	  <th width="">Grade</th>
	  <th width="100">Packing</th>
      <th width="50">Bags</th>
      <th width="60">Mts</th>
      <th width="45">Moist.</th>
      <th width="20"><img src="../shared/images/refresh.gif" onclick="doPost()" /></th>
      <th width="16">&nbsp;</th>
  </tr>
</table>
<div style="overflow:scroll; height:300px; width:100%;"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
<%
	WnConsolidationEntity _wnc = wnc;
	List<WnImXpEntity> wns = task.getUnConsolidatedWns();
	double total_tons = 0;
	int total_bags = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnImXpEntity wn = wns.get(i);
		_wnc = wn.getConsolidation().getWnConsolidation();
		total_tons += wn.net_weight/1000;
		total_bags += wn.no_of_bags;
		String color = Action.getColor(wn.isConsolidated()?2:1);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>
	<%@include file="warehouse.consolidation.row.jsp"%>
<%
	}
	List<WnWncEntity> wn_wncs = wnc.getWnWncs();
	for (int i = 0; i < wn_wncs.size(); i++) {
		WnWncEntity wn_wnc = wn_wncs.get(i);
		WnImXpEntity wn = wn_wnc.getWeightNote();
		//if (_wnc.isNull()) 
		_wnc = wn_wnc.getWnConsolidation();
		total_tons += wn.net_weight/1000;
		String color = Action.getColor(wn.isConsolidated()?2:1);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>
	<%@include file="warehouse.consolidation.row.jsp"%>
<%		
	}
%>

</table>
</div>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">
	  <th align="right">Total</th>
      <th width="50" align="right"><%=Numeric.numberToStr(total_bags,0)%>&nbsp;</th>
      <th width="60" align="right"><%=Numeric.numberToStr(total_tons,4)%>&nbsp;</th>
      <th width="45">&nbsp;</th>
      <th width="20">&nbsp;</th>
      <th width="16">&nbsp;</th>
  </tr>
</table>
</div>

<input type="hidden" name="wn_id" id="wn_id" value="0">	
<script language="javascript">
	//setValue("sort_field", "<%=sc.sort_field%>");
</script>
