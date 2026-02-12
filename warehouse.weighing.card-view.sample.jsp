<script language="javascript">
function showSamples(cbx)
{
	for (var i = 0; ; i++) {	
		var o = getObj("wns_" + i);
		if (o == null) break;
		//if (o.title != "New Samples") 
		showObj(o,cbx.checked);
	}
}

var count = 0;
function saveSample(no)
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	var nw = toFloat(getValue("wns_net_weight_" + no));
	if (nw <= 0) {
		alert("Invalid Net Weight.");
		return;
	}
	if (count > 0) return;
	count++; 
	setValue("no", no);
	doTask(9);
	count--;
}

function deleteSample(no)
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	if (<%=wn.isCompleted()%>) {
		alert("Completed Weight Note can not be modified.");
		return;
	}
	if (getValue("wns_id_"   + i) == -1) {
		setValue("wns_id_"   + i, 0);
		hide("wns_" + i);
		return;
	} 
	if (confirm("Delete " + getValue("wns_ref_number_" + no) + "?")) {
		setValue("no", no);
		doTask(10);
	}
}

</script>

<table id="_sample_" style="display:" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
  <tr style="font-weight:bold" bgcolor="#EEEEEE" align="center">
    <th width="24">&nbsp;</th>
    <th width="120">Sample Ref</th>
    <th width="60">Date</th>
    <th width="40">Time</th>
    <th width="60">Kgs</th>
    <th colspan="2" align="left">Show<%=Html.checkBox("show_wns",requester.getBoolean("show_wns",true),"showSamples(this)")%></th>
    <th>&nbsp;</th>
  </tr>
<%
	List<WnrSampleEntity> wnss = wn.getWnrSamples();
	WnrSampleEntity wns = dao.getWnrSampleDao().newEntity(wn);
	wnss.add(wns);
	for (int i = 0; i < wnss.size(); i++) {
		wns = wnss.get(i);
%>
  <input type="hidden" name="wns_id_<%=i%>" id="wns_id_<%=i%>"  value="<%=wns.getIdLong()%>" />
    <tr id="<%=wns.isNull()?"new_sample":"wns_"+i%>" style="display:<%=wns.isNull()?"none":""%>">
    <th align="right"><%=i+1%>&nbsp;</th>
    <td><input type="text" name="wns_ref_number_<%=i%>" id="wns_ref_number_<%=i%>" class="style11" style="width:120px;" value="<%=wns.getRefNumber()%>" readonly /></td>
    <td align="center"><input type="text" name="wns_date_<%=i%>" id="wns_date_<%=i%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wns.date)%>" /></td>
    <td align="center"><input type="text" name="wns_time_<%=i%>" id="wns_time_<%=i%>" class="style11" style="width:40px; text-align:center" value="<%=DateTime.timeToStr(wns.time)%>" readonly /></td>
    <td align="center"><input type="text" name="wns_net_weight_<%=i%>" id="wns_net_weight_<%=i%>" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wns.net_weight,1)%>" /></td>
    <td align="center"><a href="JavaScript:deleteSample(<%=i%>)">Delete</a></td>
    <td align="center"><a href="JavaScript:saveSample(<%=i%>)">Save</a></td>
    <th>&nbsp;</th>
  </tr>
<%
	}
%>
  <tr style="font-weight:bold" bgcolor="#EEEEEE" align="center">
    <th width="24"><img src="../shared/images/new.gif" onclick="show('new_sample')" style="cursor:pointer; display:<%=displayed%>" /></th>
    <th>Total Sample</th>
    <th>&nbsp;</th>
    <th>&nbsp;</th>
    <th align="right"><%=Numeric.numberToStr(wn.sample_weight,1)%>&nbsp;</th>
    <th width="40">&nbsp;</th>
    <th width="40">&nbsp;</th>
    <th>&nbsp;</th>
  </tr>
</table>
<script language="javascript">
	showSamples(getObj("show_wns_"));
	sample_weight = <%=wn.sample_weight%>;
</script>
