using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class modules_booking : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
		if (!Page.User.Identity.IsAuthenticated)
		{
			BookingLogin.DestinationPageUrl = Request.RawUrl;
		}
		if (Page.User.Identity.IsAuthenticated)
		{
			AnonymousPanel.Visible = false;
			List<int> hourList = new List<int>();
			List<int> minList = new List<int>();
			for (int i = 1; i <= 24; i++)
			{
				hourList.Add(i);
			}
			for (int i = 0; i <= 60; i += 10)
			{
				minList.Add(i);
			}
			HourDropDownList.DataSource = hourList;
			HourDropDownList.DataBind();
			MinutsDropDownList.DataSource = minList;
			MinutsDropDownList.DataBind();

			switch (ModuleData)
			{
				case "booking":
				BookingPanel.Visible = true;
				;
				break;

				case "taxi":
				TaxiPanel.Visible = true;
				;
				break;

				case "airport":
				AirportPanel.Visible = true;
				;
				break;

				case "vip":
				VIPPanel.Visible = true;
				;
				break;

				case "children":
				ChildrenPanel.Visible = true;
				;
				break;

				default:
				;
				break;

			}
		}
    }
}
