<%
	long po_id = sc.inst_id;
	ProcessingEntity po = dao.getProcessingDao().getById(po_id);
	if (!po.isNull()) {
		bal_tons = Numeric.round(po.ip_tons - po.xp_tons,3);
		bal_msg = " " + Numeric.round(po.ip_tons,3) + " - " + Numeric.round(po.xp_tons,3) + " = " + bal_tons + " Mts";
	}
%>

<%@include file="warehouse.weighing.card-view.wnr_1.jsp"%>				
