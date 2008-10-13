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
			string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
			DropDownList1.DataSource = Data.GetXmlElements(path);
			DropDownList1.DataBind();
		}
	}
	protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
	{
		string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
		if (DropDownList1.SelectedValue != "Please select city")
			DropDownList2.Enabled = true;
		else
			DropDownList2.Enabled = false;
		DropDownList2.DataSource = Data.GetXmlChildElements(path, DropDownList1.SelectedItem.Text);
		DropDownList2.DataBind();
	}
}
