<div style="border:thin; border-style:solid; border-width:1; width:100%;" align="center">
		<table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
          <tr>
            <td width="15%" align="right">Pricing Type &nbsp;</td>
            <td width="18%"><strong><%=contract.getContractType().short_name%></strong></td>
            <td width="15%" align="right">Fixation &nbsp;</td>
            <td width="18%"><strong><%=contract.isFixed()?"Fixed":"Unfixed"%></strong></td>
            <td width="15%" align="right">Contract Tons &nbsp;</td>
            <td width="19%"><strong><%=Numeric.numberToStr(contract.tons,4)%></strong></td>
            </tr>
          <tr>
            <td width="15%" align="right">Contract Ref &nbsp;</td>
            <td width="18%"><strong><%=contract.getRefNumber()%></strong></td>
            <td width="15%" align="right">Terminal Month &nbsp;</td>
            <td width="18%"><strong><%=DateTime.dateToTerminalMonth(contract.terminal_month)%></strong></td>
            <td width="15%" align="right">Fixed Tons &nbsp;</td>
            <td width="19%"><strong><%=Numeric.numberToStr(contract.fixed_tons,4)%></strong></td>
            </tr>
          <tr>
            <td align="right">Contract Date &nbsp;</td>
            <td><strong><%=DateTime.dateToStr(contract.contract_date)%></strong></td>
            <td align="right">Differential &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.differential_price,2)%></strong></td>
            <td align="right">Unfixed Tons &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.getUnfixedTons(),4)%><%//=ref.getFloat("unfixed_tons",3)%></strong></td>
            </tr>
          <tr>
            <td align="right">Buyer &nbsp;</td>
            <td><strong><%=contract.getBuyer().short_name%></strong></td>
            <td align="right">Average Price (USD) &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.contract_price,2)%><%//=ref.getFloat("contract_price",2)%></strong></td>
            <td align="right">Fixed Lots &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.getFixedLots(),0)%><%//=ref.getInt("fixed_lots")%></strong></td>
            </tr>
          <tr style="display:">
            <td align="right">Seller &nbsp;</td>
            <td><%=contract.getSeller().short_name%></td>
            <td align="right">Average Price (<%=location.currency%>) &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.contract_price_local,_dec)%></strong></td>
            <td align="right">Unfixed Lots &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.getUnfixedLots(),0)%><%//=ref.getInt("unfixed_lots")%></strong></td>
            </tr>
          <tr style="display:">
            <td align="right">Terminal Market &nbsp;</td>
            <td><strong><%=contract.getGrade().getQuality().terminal_market%></strong></td>
            <td align="right">Average Ex.Rate &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.exchange_rate,0)%></strong></td>
            <td align="right">Delivered Tons &nbsp;</td>
            <td><strong><%=Numeric.numberToStr(contract.delivered_tons,4)%></strong></td>
            </tr>
        </table>			
</div>