<%
	//String can_modify = auto_weighing ? "readonly" : "";
	if (contract.active) {
		bal_tons = Numeric.round(contract.tons - contract.delivered_tons,3);		
		bal_msg = " " + Numeric.round(contract.tons,3) + " - " + Numeric.round(contract.delivered_tons,3) + " = " + bal_tons + " Mts";
		if (bal_tons < 0) {
			double percent = contract.tons > 0 ? Numeric.round(-bal_tons*100/contract.tons,2) :100;
			bal_msg = "Over: " + bal_msg + " (" + percent + "%)";
		} 
	}
%>

<%@include file="warehouse.weighing.card-view.wnr_1.jsp"%>				

