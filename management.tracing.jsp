<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.management.Tracing tracing = user.getBiz().getManagement().getTracing();
	tracing.getOwner().clearFocus();
	tracing.setFocus(true);
%>

<%@include file="header.jsp"%>

<%
	SaleContractEntity ct = tracing.doTask();
%>

  <!------------------------------------------------------------>
  <!-- SECTION 1:                                             -->
  <!-- If you want, edit the styles for the remainder if the  -->
  <!-- document.                                              -->
  <!------------------------------------------------------------>
  <STYLE>

   /*                                                          */
   /* Styles for the tree.                                     */
   /*                                                          */
   SPAN.TreeviewSpanArea A {
     font-size: 9pt; 
     font-family: Arial, Helvetica, sans-serif;/* verdana,helvetica; */
     text-decoration: none;
     color: black;}
   SPAN.TreeviewSpanArea A:hover {
     color: '#820082';}

   /*                                                          */
   /* Styles for the remainder of the document.                */
   /*            
                                                 */
/*												 
   BODY {
     background-color: white;}
   TD {
     font-size: 9pt; 
     font-family: Arial, Helvetica, sans-serif;} /*verdana,helvetica;}*/
*/
  </STYLE>


<link href="style.css" rel="stylesheet" type="text/css">


<form method="POST" name="formMain" action="" onSubmit="">
<%@include file="posted-fields.jsp"%>	

  <SCRIPT>
  // Note that this script is not related with the tree itself.  
  // It is just used for this example.
  function getQueryString(index) {
    var paramExpressions;
    var param
    var val
    paramExpressions = window.location.search.substr(1).split("&");
    if (index < paramExpressions.length) {
      param = paramExpressions[index]; 
      if (param.length > 0) {
        return eval(unescape(param));
      }
    }
    return ""
  }
  </SCRIPT>


  <!------------------------------------------------------------>
  <!-- SECTION 3:                                             -->
  <!-- Code for browser detection. DO NOT REMOVE.             -->
  <!------------------------------------------------------------>
  <SCRIPT src="../shared/treeview/ua.js"></SCRIPT>

  <!-- Infrastructure code for the TreeView. DO NOT REMOVE.   -->
  <SCRIPT src="../shared/treeview/ftiens4.js"></SCRIPT>

  <!-- Scripts that define the tree. DO NOT REMOVE.           -->
 <!-- <SCRIPT src="demoFramelessNodes.js"></SCRIPT> -->
<script language="javascript">

//
// Copyright (c) 2006 by Conor O'Mahony.
// For enquiries, please email GubuSoft@GubuSoft.com.
// Please keep all copyright notices below.
// Original author of TreeView script is Marcelino Martins.
//
// This document includes the TreeView script.
// The TreeView script can be found at http://www.TreeView.net.
// The script is Copyright (c) 2006 by Conor O'Mahony.
//
// You can find general instructions for this file at www.treeview.net.
//

USETEXTLINKS = 1
STARTALLOPEN = 0
USEFRAMES = 0
USEICONS = 0
WRAPTEXT = 1
PRESERVESTATE = 1

ICONPATH = '../shared/treeview/'

//
// The following code constructs the tree.  This code produces a tree that looks like:
// 
// Tree Options
//  - Expand for example with pics and flags
//    - United States
//      - Boston
//      - Tiny pic of New York City
//      - Washington
//    - Europe
//      - London
//      - Lisbon
//  - Types of node
//    - Expandable with link
//      - London
//    - Expandable without link
//      - NYC
//    - Opens in new window
//

foldersTree = gFld("<b><%=ct.getRefNumber()%></b>", "demoFrameless.html")
  foldersTree.treeID = "Frameless"
<%
	for (WnAllocationEntity wna : tracing.getWnAllocations(ct)) {
		WnEntity wn = wna.getWeightNote();
		out.println(tracing.addNode(1, "foldersTree", wn.ref_number, "javascript:undefined"));
	}
%> 
  aux1 = insFld(foldersTree, gFld("Expand for example with pics and flags", "javascript:undefined"))
    aux2 = insFld(aux1, gFld("United States", "demoFrameless.html?pic=%22beenthere_unitedstates%2Egif%22"))
      insDoc(aux2, gLnk("S", "Boston", "demoFrameless.html?pic=%22beenthere_boston%2Ejpg%22"))
      insDoc(aux2, gLnk("S", "Tiny pic of New York City", "demoFrameless.html?pic=%22beenthere_newyork%2Ejpg%22"))
      insDoc(aux2, gLnk("S", "Washington", "demoFrameless.html?pic=%22beenthere_washington%2Ejpg%22"))
    aux2 = insFld(aux1, gFld("Europe", "demoFrameless.html?pic=%22beenthere_europe%2Egif%22"))
      insDoc(aux2, gLnk("S", "London", "demoFrameless.html?pic=%22beenthere_london%2Ejpg%22"))
      insDoc(aux2, gLnk("S", "Lisbon", "demoFrameless.html?pic=%22beenthere_lisbon%2Ejpg%22"))
  aux1 = insFld(foldersTree, gFld("Types of node", "javascript:undefined"))
    aux2 = insFld(aux1, gFld("Expandable with link", "demoFrameless.html?pic=%22beenthere_europe%2Egif%22"))
      insDoc(aux2, gLnk("S", "London", "demoFrameless.html?pic=%22beenthere_london%2Ejpg%22"))
    aux2 = insFld(aux1, gFld("Expandable without link", "javascript:undefined"))
      insDoc(aux2, gLnk("S", "NYC", "demoFrameless.html?pic=%22beenthere_newyork%2Ejpg%22"))
    insDoc(aux1, gLnk("B", "Opens in new window", "http://www.treeview.net/treemenu/demopics/beenthere_pisa.jpg"))

</script>

 </HEAD>

 
 <!------------------------------------------------------------->
 <!-- SECTION 4:                                              -->
 <!-- Change the <BODY> tag for use with your site.           -->
 <!------------------------------------------------------------->
 <BODY bgcolor="white" leftmargin="0" topmargin="0" marginheight="0" marginwidth="0"  onResize="if (navigator.family == 'nn4') window.location.reload()">


 <!------------------------------------------------------------->
 <!-- SECTION 5:                                              -->
 <!-- The main body of the page, including the table          -->
 <!-- structure that contains the tree and the contents.      -->
 <!------------------------------------------------------------->
 <TABLE cellpadding="0" cellspacing="0" border="0" width="772">
  <TR>
   <TD width="178" valign="top">

    <TABLE cellpadding="4" cellspacing="0" border="0" width="100%">
     <TR>
      <TD bgcolor="#ECECD9">

        <TABLE cellspacing="0" cellpadding="2" border="0" width="100%">
         <TR>
          <TD bgcolor="white">


 <!------------------------------------------------------------->
 <!-- SECTION 6:                                              -->
 <!-- Build the tree.                                         -->
 <!------------------------------------------------------------->

 <!------------------------------------------------------------->
 <!-- IMPORTANT NOTICE:                                       -->
 <!-- Removing the following link will prevent this script    -->
 <!-- from working.  Unless you purchase the registered       -->
 <!-- version of TreeView, you must include this link.        -->
 <!-- If you make any unauthorized changes to the following   -->
 <!-- code, you will violate the user agreement.  If you want -->
 <!-- to remove the link, see the online FAQ for instructions -->
 <!-- on how to obtain a version without the link.            -->
 <!------------------------------------------------------------->
 <TABLE border=0 class="style2">
 	<TR>
		<TD width="120"><FONT size=-2><A style="font-size:9pt;text-decoration:none;color:silver" href="http://www.treemenu.net/" target=_blank>Select a Sale</A></FONT></TD>
	</TR>
 	<TR>
		<TD><select name="contract_id" id="contract_id" size="1" class="style2" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(dao.getSaleContractDao().selectAll(),sc.contract_id,"")%></select></TD>
	</TR>
 </TABLE>

 <SPAN class=TreeviewSpanArea>
  <SCRIPT>initializeDocument()</SCRIPT>
  <NOSCRIPT>
   A tree for site navigation will open here if you enable JavaScript in your browser.
  </NOSCRIPT>
 </SPAN>


 <!------------------------------------------------------------->
 <!-- SECTION 7:                                              -->
 <!-- And now we have the continuation of the body of the     -->
 <!-- page, after the tree.  Replace this entire section with -->
 <!-- your site's HTML.                                       -->
 <!------------------------------------------------------------->
          </TD>
         </TR>
        </TABLE>

       </TD>
      </TR>
     </TABLE>

    </TD>
    <TD bgcolor="white" valign="top">

     <TABLE cellpadding="10" cellspacing="0" border="0" width="100%">
      <TR>
       <TD>

        <SCRIPT>
         // This code is needed only for this demo, not for your site
         var picURL
         picURL = getQueryString(0)
         if (picURL.length > 0)
           document.write("<img src=http://www.treeview.net/treemenu/demopics/" + picURL + "><br><br>");
        </SCRIPT>

        <H4>Frameless Layout For Treeview</H4>
        <P>This is the demo for the frameless layout of the TreeView. For instructions on
        this type of layout and others, check the online 
        <A HREF="http://www.treeview.net/tv/instructions.asp">Instructions</A> on 
        the Web page.</P>
        <P>To simplify the demo, most links on the tree actually reload the same page (only 
        with different arguments for different pictures).  In your site, you will probably 
        be linking to different pages, and many of them will also contain the tree.  This 
        way the user can jump from page to page clicking the tree.</P>
        <P>Note how some of the expandable/collapsible nodes have a hyperlink on their 
        name (the folder itself can load a page) and others don't. The two types were mixed 
        here for demo purposes.</P>

       </TD>
      </TR>
     </TABLE>

    </TD>
   </TR>
  </TABLE>


</form>

<%@include file="footer.jsp"%>

