using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class modules_chat : BaseUserControl
{
	string bookingId;
	List<string> list = new List<string>();
	protected void Page_Load(object sender, EventArgs e)
	{
		bookingId = Request.QueryString["bookingID"];
		if (Page.User.Identity.IsAuthenticated && bookingId != null)
		{
			LoggedInPanel.Visible = true;
			AnonymousPanel.Visible = false;
			if (Application[bookingId] != null)
			{
				list = (List<string>)Application[bookingId];
			}
			else
			{
				Application[bookingId] = list;
			}
			foreach (string line in list)
			{
				ChatTextBox.Text += line;
			}
		}

	}
	protected void SendButton_Click(object sender, EventArgs e)
	{
		string msg = Page.User.Identity.Name + " says: " + MessageTextBox.Text + Environment.NewLine;
		list = (List<string>)Application[bookingId];
		list.Add(msg);
		Application.Clear();
		Application[bookingId] = list;
		MessageTextBox.Text = "";
		MessageTextBox.Focus();
	}
	protected void EndChatButton_Click(object sender, EventArgs e)
	{
		Application.Clear();
	}
}
