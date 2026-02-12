<%
	sc.location_id = 0;
    sc.filter_source_id = 0;
	sc.filter_destination_id = 0;

    sc.type = 'Q';
	char qr_type = sc.qr_type;//task.getQrType();
	task.doTask();	
%>
<link href="../shared/style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function rowClicked(row,qr_id)
{
	if (qr_id != null) setValue("qr_id",qr_id);
	highlightOn(row);
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('qr');
}

</script>

<%if (sc.qr_type == Const.QR_IMPORT) {%><%@include file="quality.qr.list-view.im.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_IN_PRO) {%><%@include file="quality.qr.list-view.ip.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_EX_PRO) {%><%@include file="quality.qr.list-view.xp.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_EXPORT) {%><%@include file="quality.qr.list-view.ex.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_TRUCKING) {%><%@include file="quality.qr.list-view.tr.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_RECEIVING) {%><%@include file="quality.qr.list-view.re.jsp"%><%}%>
<%if (sc.qr_type == Const.QR_SAMPLE) {%><%@include file="quality.qr.list-view.sa.jsp"%><%}%>
<div id="qr_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="qr_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center"><%@include file="paging.jsp"%></td>
		<td width="60" align="center"><img src="../shared/images/report.jpg" width="55" height="18" onClick="doReport('qr');"></td>
		<td width="60" align="center"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
	</tr>
</table>
<input type="hidden" name="qr_id"  id="qr_id"  value="0">

	

