using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Services;

public partial class modules_operator : BaseUserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{
		DataView dv = new DataView(Data.GetResults());
		ResultsGridView.DataSource = dv;
		ResultsGridView.DataBind();
	}
}
