using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class modules_chat : BaseUserControl
{
	protected void Page_Load(object sender, EventArgs e)
	{
		EndChatButton.Attributes.Add("onclick", "window.close();");
		SendButton.Attributes.Add("reset", "document.getElementById('MessageTextBox').focus();");
		TimeLabel.Text = DateTime.Now.Hour.ToString() + ":" + DateTime.Now.Minute.ToString() + ":" + DateTime.Now.Second.ToString();
		if (Application[Request.QueryString["ChatID"]] == null)
		{
			List<string> list = new List<string>();
			Application[Request.QueryString["ChatID"]] = list;
		}
		else
		{
			List<string> list = (List<string>)Application[Request.QueryString["ChatID"]];
			string msg = "";
			foreach (string item in list)
			{
				msg += item;
			}
			ChatTextBox.Text = msg;
		}
	}
	protected void SendButton_Click(object sender, EventArgs e)
	{
		List<string> list = (List<string>)Application[Request.QueryString["ChatID"]];
		string time = DateTime.Now.Hour.ToString() + ":" + DateTime.Now.Minute.ToString() + ":" + DateTime.Now.Second.ToString();
		string msg = string.Format("({0}) {1}: {2} {3}", time, Page.User.Identity.Name.ToUpper(),  MessageTextBox.Text, Environment.NewLine);
		list.Add(msg);
		Application.Clear();
		Application[Request.QueryString["ChatID"]] = list;
		MessageTextBox.Text = "";
		MessageTextBox.Focus();
	}
}
