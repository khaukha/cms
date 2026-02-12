<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.quality.Sample task = user.getBiz().getQuality().getSample();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>
<%
	if (sc.type == 'Q') sc.type = ' ';
%>
<%if (sc.isListView()) {%><%@include file="quality.sample.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="quality.sample.card-view.jsp"%><%}%>

<%@include file="footer.jsp"%>

