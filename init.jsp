<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" language="java"  errorPage="" %>

<%@ page import="java.util.*,java.sql.*,java.math.*,java.text.*" %>
<%@ page import="pc.util.*, pc.system.*, pc.jsp.*, pc.sql.data.*, ngv.share.*, ngv.share.entity.*, ngv.share.util.*, ngv.share.paging.*" %>
<%@ page import="ibu.ucms.*, ibu.ucms.entity.*, ngv.share.dao.*, ibu.ucms.dao.*, ibu.ucms.biz.*, ibu.ucms.fb.*" %>

<%
	if (!usr.isAuthenticated()) {
		//usr.reset();
		response.sendRedirect("logon.jsp");	
		return;
	}
	
	//usr.setActive();

	pc.jsp.Response writer    = pc.jsp.Response.get(out);
	pc.jsp.Request  requester = pc.jsp.Request.get(request);

	DAO dao = usr.getDao();
	Biz biz = usr.getBiz();
	Paging paging = dao.getPaging();
	
	LocationEntity location = usr.getLocation();
	int location_id = usr.getLocationId();	
	
	int filter_size = 7;
	int _dec = 2;
	String filter_all = "All";
	String pad = "&nbsp;&nbsp;&nbsp;&nbsp;";
	boolean average = false;
	String language = requester.getString("language","");
    String mandatory = "<label style=\"color:#FF0000\" >*</label>";
	SearchCriteriaEntity sc = usr.getSearchCriteria();
	sc.set();
	Boolean list_all = usr.isAdmin() ? null : true;
%>