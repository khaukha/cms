<%
	int dec = average ? 2 : 2;
%>
<script language="javascript">
function sumScreen()
{
	//var sum = toFloat(getValue("above_sc20")) + toFloat(getValue("below_sc12"));
	var sum = toFloat(getValue("below_sc12"));
	for (var i = 12; i <= 19; i++) {
		sum += toFloat(getValue("sc" + i));
	}
	sum = sum.toFixed(2);
	setText("sum_screen", formatNumber(sum,2,false));
}

function sumBB()
{
	var bb = parseFloat(getValue("black")) + parseFloat(getValue("broken"));
	bb = bb.toFixed(2);
	setValue("black_broken",formatNumber(bb,2));
	//screenChanged(this);
}

function sumDefects()
{
	var defects = 
  		parseFloat(getValue("cherry")) +
  		parseFloat(getValue("unripe")) +

  		parseFloat(getValue("big_stones")) +
  		parseFloat(getValue("medium_stones")) +
  		parseFloat(getValue("small_stones")) +

  		parseFloat(getValue("big_sticks")) +
  		parseFloat(getValue("medium_sticks")) +
  		parseFloat(getValue("small_sticks")) +
		parseFloat(getValue("broken")) +
		parseFloat(getValue("black")) + 
  		parseFloat(getValue("half_black")) +
  		parseFloat(getValue("husks")) +

  		parseFloat(getValue("white")) +
  		parseFloat(getValue("withered")) +
  		parseFloat(getValue("stinkers")) +
  		parseFloat(getValue("floats")) +
  		parseFloat(getValue("moldy")) +

  		parseFloat(getValue("insect_slightly")) +
  		parseFloat(getValue("insect_half")) +

  		parseFloat(getValue("bhp"));
  		//parseFloat(getValue("sound"));
		
	defects = defects.toFixed(2);
	setText("sum_defects",formatNumber(defects,2));



}

function screenChanged(obj)
{    
	if (obj != null) formatPercentNumber(obj);
	sumScreen();
}

function dataChanged(obj)
{
	formatPercentNumber(obj);
	sumDefects();	
}

function doUpdate(id)
{
    if (getValue(id) == 0) {
		alert("Please select item to save.");
		return;
	}

	if (getValue("grade_id") != grade_id) {
		if (!confirm("Grade has been changed. Continue update?")) {
			return;
		} 
	}
	var sum = toFloat(getText("sum_screen"));
	doTask(1);
	/*
	if (sum != 100) {
		if (confirm("Total percent of screen size is not equal 100%. Continue update ?")) {
			doTask(1);
		} else {
			return;
		}
	} else {
		doTask(1);
	}
	 */
}

</script>
<div id="quality_input_div" style="border-style:solid; border-width:1; width:100%; border-right:0; border-bottom:0; display:">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" bgcolor="" class="style2">
	<tr>
		<td width="120" align="right">Color &nbsp;</td>
		<td width="200"><input type="text" name="color" id="color" class="style2" style="width:200;" value="<%=quality_report.color%>" <%=readonly%>></td>
		<td width="100" align="right">Smell &nbsp;</td>
		<td><input type="text" name="smell" id="smell" class="style2" style="width:200;" value="<%=quality_report.smell%>" <%=readonly%>></td>
	</tr>
</table>
</div>
<div id="quality_input_div" style="border-style:solid; border-width:1; width:100%; height:; border-right:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" bgcolor="" class="style2">
                    <tr>
					<td width="35%" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
                        <tr bgcolor="#DDDDDD">
                          <th width="180">Type Of Defects</th>
                          <th>%</th>
                        </tr>
                        <tr>
                          <td align="right">Moisture &nbsp;</td>
                          <td><input name="moisture" type="text" id="moisture" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.moisture,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr>
                          <td align="right">Unhulled Cherryies/Pods &nbsp;</td>
                          <td><input name="cherry" type="text" id="cherry" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.cherry,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Unripe beans &nbsp;</td>
                          <td><input name="unripe" type="text" id="unripe" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.unripe,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Big stones &nbsp;</td>
                          <td><input name="big_stones" type="text" id="big_stones" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.big_stones,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Medium stones &nbsp;</td>
                          <td><input name="medium_stones" type="text" id="medium_stones" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.medium_stones,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Small stones &nbsp;</td>
                          <td><input name="small_stones" type="text" id="small_stones" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.small_stones,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Big sticks &nbsp;</td>
                          <td><input name="big_sticks" type="text" id="big_sticks" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.big_sticks,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Medium sticks &nbsp;</td>
                          <td><input name="medium_sticks" type="text" id="medium_sticks" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.medium_sticks,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Small sticks &nbsp;</td>
                          <td><input name="small_sticks" type="text" id="small_sticks" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.small_sticks,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>


                        <tr>
                          <td align="right">Broken beans &nbsp;</td>
                          <td><input name="broken" type="text" id="broken" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.broken,dec)%>" onChange="sumBB(this);dataChanged(this);" <%=readonly%>></td>
                        </tr>
						
                        <tr>
                          <td align="right">Black beans &nbsp;</td>
                          <td><input name="black" type="text" id="black" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.black,dec)%>" onChange="sumBB(this);dataChanged(this);" <%=readonly%>></td>
                        </tr>

                      </table></td>
					
					
                      <td width="35%" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
                        <tr bgcolor="#DDDDDD">
                          <th width="180">Type Of Defects</th>
                          <th>%</th>
                        </tr>
                        <tr>
                          <td align="right">Half black beans &nbsp;</td>
                          <td><input name="half_black" type="text" id="half_black" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.half_black,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr>
                          <td align="right">Husks &nbsp;</td>
                          <td><input name="husks" type="text" id="husks" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.husks,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr>
                          <td align="right">Bleached beans/Chalky whites &nbsp;</td>
                          <td><input name="white" type="text" id="white" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.white,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Withered beans &nbsp;</td>
                          <td><input name="withered" type="text" id="withered" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.withered,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Stinkers &nbsp;</td>
                          <td><input name="stinkers" type="text" id="stinkers" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.stinkers,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Floats &nbsp;</td>
                          <td><input name="floats" type="text" id="floats" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.floats,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Moldy beans &nbsp;</td>
                          <td><input name="moldy" type="text" id="moldy" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.moldy,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Insect damaged slightly &nbsp;</td>
                          <td><input name="insect_slightly" type="text" id="insect_slightly" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.insect_slightly,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">Insect damaged half &nbsp;</td>
                          <td><input name="insect_half" type="text" id="insect_half" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.insect_half,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>

                        <tr>
                          <td align="right">BHP &nbsp;</td>
                          <td><input name="bhp" type="text" id="bhp" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.bhp,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>


                        <tr>
                          <td align="right">Sound beans &nbsp;</td>
                          <td><input name="sound" type="text" id="sound" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sound,dec)%>" onChange="dataChanged(this)" <%=readonly%>></td>
                        </tr>
						
                      </table></td>
                      <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
                        <tr bgcolor="#DDDDDD">
                          <th width="50%">Screen Size</th>
                          <th>%</th>
                        </tr>
                        <tr bgcolor="#EEEEEE" style="display:none">
                          <td align="right">Screen 19 &nbsp;</td>
                          <td><input name="sc19" type="text" id="sc19" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc19,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 18 &nbsp;</td>
                          <td><input name="sc18" type="text" id="sc18" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc18,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 17 &nbsp;</td>
                          <td><input name="sc17" type="text" id="sc17" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc17,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 16 &nbsp;</td>
                          <td><input name="sc16" type="text" id="sc16" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc16,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 15 &nbsp;</td>
                          <td><input name="sc15" type="text" id="sc15" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc15,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 14 &nbsp;</td>
                          <td><input name="sc14" type="text" id="sc14" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc14,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 13 &nbsp;</td>
                          <td><input name="sc13" type="text" id="sc13" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc13,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 12 &nbsp;</td>
                          <td><input name="sc12" type="text" id="sc12" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.sc12,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                          <td align="right">Screen 12- &nbsp;</td>
                          <td><input name="below_sc12" type="text" id="below_sc12" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(quality_report.below_sc12,dec)%>" onChange="screenChanged(this)" <%=readonly%>></td>
                        </tr>
                        <tr>
                          <td align="right">&nbsp;</td>
                          <td><label id="sum_screen" style="width:60px; text-align:right; font-weight:bold">0.00</label></td>
                        </tr>
                        <tr>
                          <td align="right">Total Defects (%)&nbsp;</td>
                          <td><label id="sum_defects" style="width:60px; text-align:right; font-weight:bold; color:#FF0000">0.00</label></td>
                        </tr>
                      </table></td>
                    </tr>
</table>

</div>

<div id="cup_test_input" style="border-style:solid; border-width:1; border-top:0; width:100%; display:">
<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
                    <tr bgcolor="#DDDDDD">
                      <th scope="col">&nbsp;</th>
                      <th width="17%" scope="col">Cup 1</th>
                      <th width="17%" scope="col">Cup 2 </th>
                      <th width="17%" scope="col">Cup 3 </th>
                      <th width="17%" scope="col">Cup 4 </th>
                      <th width="17%" scope="col">Cup 5 </th>
                    </tr>
<%
	for (int t = 1; t <= 5; t++) {
%>
					<tr>
                      <th scope="row" align="right" bgcolor="#DDDDDD">Test <%=t%> &nbsp;</th>
	<%					  
		for (int c = 1; c <= 5; c++) {
			int cup_test_id = quality_report.getCupTest(c,t).cup_test_id;
			if (cup_test_id == 0 && quality_report.user_id == 0 && t <= 2) {
				cup_test_id = 0;
			}
	%>
                      <td align="center"><select name="cup<%=c%>_test<%=t%>_id" id="cup<%=c%>_test<%=t%>_id" class="style2" style="width:100%;" <%=disabled%>><%=Html.selectOptions(dao.getCupTestMasterDao().selectAll(),cup_test_id,"")%></select></td>
	<%
		}
	%>
				  </tr>
			
<%		
	}
%>					
</table>
</div>
<script language="javascript">
	sumScreen();
	sumDefects();
</script>