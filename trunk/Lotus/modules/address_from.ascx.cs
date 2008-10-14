using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;

public partial class modules_address : System.Web.UI.UserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{
		if (!IsPostBack)
		{
			string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
			cityFrom.DataSource = Data.GetXmlElements(path);
			cityFrom.DataBind();
		}
	}
	protected void cityFrom_SelectedIndexChanged(object sender, EventArgs e)
	{
		string path = Server.MapPath("~/App_Data/") + "CityRegion.xml";
		if (cityFrom.SelectedValue != "Please select city")
			regionFrom.Enabled = true;
		else
			regionFrom.Enabled = false;
		regionFrom.DataSource = Data.GetXmlChildElements(path, cityFrom.SelectedItem.Text);
		regionFrom.DataBind();
	}
}
