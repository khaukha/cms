<table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
  									<tr>
										<td width="32%" align="right">Tons &nbsp;</td>
    									<td width="60px"><input type="text" name="tons" id="tons" class="style2" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(contract.tons)%>" onChange="tonsChanged();"></td>
    									<td align="right">Lot Size &nbsp;</td>
										<td width="60px"><input type="text" name="tons_per_lot" id="tons_per_lot" class="style2" style="width:60px; text-align:right" value="<%=contract.tons_per_lot%>" /></td>
										<td align="right">&nbsp;</td>
										<td width="60px"><input name="no_of_lots" type="text" id="no_of_lots" class="style2" style="width:60px; text-align:right" value="<%=contract.no_of_lots%>" onChange=""></td>										
  									</tr>
								<tr>
									<td align="right">Tons per Lot &nbsp;</td>
									<td width="120"><select name="destination_id" id="destination_id" class="style2" style="width:120;"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),contract.destination_id)%></select></td>
									<td align="right">Last date &nbsp;</td>
									<td width="94">&nbsp;</td>
								</tr>
								</table>