<%@ page import="ibu.ucms.biz.traffic.allocation.*" %>
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.Allocation task = user.getBiz().getTraffic().getAllocation();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";
%>


<%@include file="header.jsp"%>

<script language="javascript" src="warehouse.allocation.js"></script>

<%
	IAllocation alloc_class = task.getAllocation();
	InstructionEntity instr = alloc_class.getInstruction();
	task.doTask(instr);
%>
<form method="POST" name="formMain" action="" onSubmit="">		
	<%@include file="posted-fields.jsp"%>

	<%if (sc.isListView()) {%><%@include file="traffic.allocation.list-view.jsp"%><%}%>
	<%if (sc.isCardView()) {%><%@include file="traffic.allocation.card-view.jsp"%><%}%>

</form>

<%@include file="footer.jsp"%>

