<%@ page contentType="text/html; charset=iso-8859-1"%>
<%@ page language="java"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>TEST</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
.scroll
{
    FONT: 9pt arial;
    COLOR: #A2C5EC;
    background-color: #FFFFFF;
    border: medium none
}
</style>

<script language="JavaScript">
var x = 0;
function mOver()
{
x++;
window.status = x;
}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/Utils.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/stock_plan.js"></SCRIPT>
<form method="POST" name="formMain" action="" onSubmit="">	
<div style="position:inherit:static ">1233</div>
<span  id='spanLeft_'  style='border-style:solid;border-width:0;border-color:#3366FF; color:#88AAFF; text-align:center'>Warehouse Location</span>
<table bgcolor="#FFFFFF" width="100%" border="0" cellspacing="1" cellpadding="0">
  <tr>
    <td width="100" valign="top"  style="color:#EEEEEE"><input type="text" name="test" id="test"></td>
    <td bgcolor="#CCFFFF"   onMouseOver="mOver()" onMouseMove="mOver();" onClick="" style="cursor:pointer ">&nbsp;</td>
  </tr>
  <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
    <td valign="top" >Lo&#7841;i h&#7907;p &#273;&#7891;ng</td>
    <td bgcolor="#CCFFFF"   onMouseOver="mOver()" onMouseMove="mOver();" onClick="" style="cursor:pointer ">&nbsp;</td>
  </tr>
  <tr>
    
    <td width="780" valign="top"><img src="../shared/images/calendar.gif" width="20" height="20" onClick="popupStockPlan(getObj('test'))"></td>
    <td background="images/pattern.jpg">&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>

