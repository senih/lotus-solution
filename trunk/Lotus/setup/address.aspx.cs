using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;

public partial class setup_address : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (!IsPostBack)
		{
			DropDownList1.DataSource = Data.GetXmlElements(@"D:\webs\lotus-solution\Lotus\App_Data\CityRegion.xml");
			DropDownList1.DataBind();
		}
	}
	protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
	{
		DropDownList2.Enabled = true;
		DropDownList2.DataSource = Data.GetXmlChildElements(@"D:\webs\lotus-solution\Lotus\App_Data\CityRegion.xml", DropDownList1.SelectedItem.Text);
		DropDownList2.DataBind();
	}
}
