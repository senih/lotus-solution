﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class modules_ajax : BaseUserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{
		Label1.Text = DateTime.Now.ToString();
	}
	protected void Button1_Click(object sender, EventArgs e)
	{
		Label2.Text = DateTime.Now.ToString();
	}
}
