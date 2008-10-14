using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;

public partial class modules_address_to : System.Web.UI.UserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (!IsPostBack)
		{
			string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
			cityTo.DataSource = Data.GetXmlElements(path);
			cityTo.DataBind();
		}
	}
	protected void cityTo_SelectedIndexChanged(object sender, EventArgs e)
	{
		string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
		if (cityTo.SelectedValue != "Please select city")
			regionTo.Enabled = true;
		else
			regionTo.Enabled = false;
		regionTo.DataSource = Data.GetXmlChildElements(path, cityTo.SelectedItem.Text);
		regionTo.DataBind();
	}
}
