using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class setup_chat : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{
		TimeLabel.Text = DateTime.Now.Hour.ToString() + ":" + DateTime.Now.Minute.ToString() + ":" + DateTime.Now.Second.ToString();
		MessageTextBox.Focus();
		if (!IsPostBack)
		{
			List<string> list = new List<string>();
			Application.Clear();
			Application["proba"] = list;
		}
		else
		{
			List<string> list = (List<string>)Application["proba"];
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
		List<string> list = (List<string>)Application["proba"];
		string msg = MessageTextBox.Text + Environment.NewLine;
		list.Add(msg);
		Application.Clear();
		Application["proba"] = list;
		MessageTextBox.Text = "";
		MessageTextBox.Focus();
	}
}
