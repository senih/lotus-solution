using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class modules_chat : BaseUserControl
{
	protected string chatId;
	protected void Page_Load(object sender, EventArgs e)
	{
		string service = "";
		if (Page.User.Identity.IsAuthenticated && !Page.User.IsInRole("Operators Subscribers"))
		{
			service = (string)Session["Service"];
			chatId = (string)Session["ChatID"];
		}
		else
			chatId = Request.QueryString["ChatID"];
		if (Page.User.IsInRole("Operators Subscribers") || service == "taxi")
		{
			EndChatButton.Attributes.Add("onclick", "window.close();");
			SendButton.Attributes.Add("reset", "document.getElementById('MessageTextBox').focus();");
			DateTime localTime = DateTime.Now.ToUniversalTime().AddHours(1);
			TimeLabel.Text = localTime.Hour.ToString() + ":" + localTime.Minute.ToString() + ":" + localTime.Second.ToString();
			if (Application[chatId] == null)
			{
				List<string> list = new List<string>();
				Application[chatId] = list;
			}
			else
			{
				List<string> list = (List<string>)Application[chatId];
				string msg = "";
				foreach (string item in list)
				{
					msg += item;
				}
				ChatTextBox.Text = msg;
			}
		}
		else
		{
			ChatPanel.Visible = false;
			ThankYouPanel.Visible = true;
		}
	}

	/// <summary>
	/// Handles the Click event of the SendButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void SendButton_Click(object sender, EventArgs e)
	{
		List<string> list = (List<string>)Application[chatId];
		string time = DateTime.Now.Hour.ToString() + ":" + DateTime.Now.Minute.ToString() + ":" + DateTime.Now.Second.ToString();
		string msg = string.Format("({0}) {1}: {2} {3}", time, Page.User.Identity.Name.ToUpper(),  MessageTextBox.Text, Environment.NewLine);
		list.Add(msg);
		Application.Clear();
		Application[chatId] = list;
		MessageTextBox.Text = "";
		MessageTextBox.Focus();
	}
}
