<%
	if (!tr.isNull()) {
		bal_tons = Numeric.round(tr.trucking_tons - tr.delivered_tons,3);
		bal_msg = " " + Numeric.round(tr.trucking_tons,3) + " - " + Numeric.round(tr.delivered_tons,3) + " = " + bal_tons + " Mts";
	}
%>
<%@include file="warehouse.weighing.card-view.wnr_1.jsp"%>				
