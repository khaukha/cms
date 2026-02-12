<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Fixation task = user.getBiz().getTrade().getFixation();
	task.getOwner().clearFocus();
	task.setFocus(true);
	user.getSearchCriteria().filter_status = 0;	
	user.getSearchCriteria().type = 'P';
%>

<%@include file="header.jsp"%>

<script language="JavaScript" src="trade.js"></script>

<%if (sc.isListView()) {%><%@include file="trade.fixation.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.fixation.card-view.jsp"%><%}%>

<%@include file="footer.jsp"%>

