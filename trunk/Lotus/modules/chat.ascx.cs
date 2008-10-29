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
		chatId = (string)Session["ChatID"];
		if (Page.User.Identity.IsAuthenticated && chatId != null)
		{
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
				int start = 0;
				if (list.Count > 10)
					start = list.Count - 10;

				for (int i = start; i < list.Count; i++)
				{
					ChatPlaceHolder.Controls.Add(new LiteralControl("<div>" + list[i] + "</div>"));
				}
			}
		}
		else
		{
			Response.Redirect("booking.aspx");
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

	/// <summary>
	/// Handles the Click event of the EndChatButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void EndChatButton_Click(object sender, EventArgs e)
	{
		if (Page.User.IsInRole("Operators Subscribers"))
			Response.Redirect("operator.aspx");
		else
			Response.Redirect("booking.aspx");
	}
}
