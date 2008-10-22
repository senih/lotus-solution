using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Security;
using Services;
using System.Data.SqlTypes;

public partial class modules_operator : BaseUserControl
{
	string bookingId;
	protected void Page_Load(object sender, EventArgs e)
	{
		TimeLabel.Text = DateTime.Now.ToString();
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var source = (from b in db.bookings
					  join p in db.pages on b.page_id equals p.page_id
					  where (b.status == "NEW")
					  orderby b.id descending
					  select new
					  {
						  ID = b.id,
						  User = b.user_name,
						  Service = p.title,
						  Date = b.submited_date.ToString(),
						  Status = b.status
					  }).Distinct();
		ResultsGridView.DataSource = source;
		ResultsGridView.DataBind();
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the ResultsGridView control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void ResultsGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		GetDetails();
	}

	/// <summary>
	/// Gets the details.
	/// </summary>
	private void GetDetails()
	{
		LotusDataContext db = new LotusDataContext();
		var source1 = from b in db.bookings
					  join p in db.pages on b.page_id equals p.page_id
					  where (b.id == int.Parse(ResultsGridView.SelectedDataKey.Value.ToString()))
					  orderby b.id descending
					  select new
					  {
						  ID = b.id,
						  User = b.user_name,
						  Service = p.title,
						  Date = b.submited_date.ToString(),
						  Status = b.status
					  };

		var s = from d in db.form_datas
				join p in db.form_field_definitions on d.form_field_definition_id equals p.form_field_definition_id
				where (d.form_data_id == int.Parse(ResultsGridView.SelectedDataKey.Value.ToString()))
				orderby d.form_data_id descending
				select new
				{
					p.form_field_name,
					p.input_type,
					d.value1,
					d.value2,
					d.value3,
					d.value4,
					d.value5,
					d.value6
				};
		DataTable table = new DataTable();
		table.Columns.Add("Name", typeof(string));
		table.Columns.Add("Value", typeof(string));
		foreach (var item in s)
		{
			if (item.input_type != "header" && item.input_type != "lblNoName" && item.input_type != "label")
			{
				DataRow dr = table.NewRow();
				dr["Name"] = item.form_field_name;
				if (item.value1 != null)
					dr["Value"] = item.value1.ToString();
				else
					if (item.value2 != null)
						dr["Value"] = item.value2.ToString();
					else
						if (item.value3 != null)
							dr["Value"] = item.value3.ToString();
						else
							if (item.value4 != null)
								dr["Value"] = item.value4.ToString();
							else
								if (item.value5 != null)
									dr["Value"] = item.value5.ToString();
								else
									if (item.value6 != null)
										dr["Value"] = item.value6.Value.ToShortDateString();
				table.Rows.Add(dr);
			}
		}

		DataView dv = new DataView(table);
		DetailsGridView.DataSource = dv;
		DetailsGridView.DataBind();
		DetailsView.DataSource = source1;
		DetailsView.DataBind();
		if (DetailsView.Rows[2].Cells[1].Text == "Taxi")
		{
			ChatButton.Visible = true;
			bookingId = ResultsGridView.SelectedDataKey.Value.ToString();
			string query = EncodingDecoding.EncodeMd5(bookingId);
			string value = string.Format("window.open('chat.aspx?ChatID={0}',null,'height=530, width=530, left=200, top=150, status= no, resizable= no, scrollbars=no, toolbar=no, location=no, menubar=no ');", query);
			ChatButton.Attributes.Add("onclick", value);
		}
		else
			ChatButton.Visible = false;
		DetailsPanel.Visible = true;
		ResultsGridView.Visible = false;
		OperatorRadioButtonList.Visible = false;
	}

	/// <summary>
	/// Handles the Click event of the BackButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void BackButton_Click(object sender, EventArgs e)
	{
		DetailsPanel.Visible = false;
		if (OperatorRadioButtonList.SelectedValue == "archive")
		{
			ArchivesPanel.Visible = true;
			ChatLogDataList.Visible = false;
		}
		else
			ResultsGridView.Visible = true;
		OperatorRadioButtonList.Visible = true;
	}

	/// <summary>
	/// Handles the Click event of the AcceptedButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void AcceptedButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		if (DetailsView.Rows[2].Cells[1].Text == "Taxi")
		{
			string path = Server.MapPath("~/App_Data/Logs/") + "BookingLogNo_" + bookingId.ToString() + ".xml";
			List<string> list = new List<string>();
			list = (List<string>)Application[EncodingDecoding.EncodeMd5(bookingId.ToString())];
			if (list != null)
				Data.CreateLog(list, path);
			Application.Clear();
		}
		string status = "ACCEPTED";
		Data.UpdateBooking(bookingId, "", status);
		Response.Redirect(Request.RawUrl);
	}

	/// <summary>
	/// Handles the Click event of the DeclineButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void DeclineButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		string status = "DECLINED";
		Data.UpdateBooking(bookingId, "", status);
		Response.Redirect(Request.RawUrl);
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the OperatorRadioButtonList control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void OperatorRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
	{
		if (OperatorRadioButtonList.SelectedValue == "archive")
		{
			Session["StartIndex"] = 0;
			LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
			var source2 = (from b in db.bookings
						   join p in db.pages on b.page_id equals p.page_id
						   where (b.status != "NEW")
						   orderby b.id descending
						   select new
						   {
							   ID = b.id,
							   User = b.user_name,
							   Service = p.title,
							   Date = b.submited_date.ToString(),
							   Status = b.status
						   }).Distinct();
			ArchivesGridView.DataSource = source2.Skip(0).Take(20);
			ArchivesGridView.DataBind();

			List<ListItem> items = new List<ListItem>();
			items.Add(new ListItem("All", "All"));
			foreach (MembershipUser user in Membership.GetAllUsers())
			{
				items.Add(new ListItem(user.UserName, user.UserName));
			}
			UsersDropDownList.DataSource = items;
			UsersDropDownList.DataBind();
			SearchResultsLabel.Text = "";
			ResultsGridView.Visible = false;
			UsersGridView.Visible = false;
			ArchivesPanel.Visible = true;
			AcceptedButton.Visible = false;
			DeclineButton.Visible = false;
			UserDetailsView.Visible = false;
			ChatButton.Visible = false;
		}
		if (OperatorRadioButtonList.SelectedValue == "active")
		{
			ArchivesPanel.Visible = false;
			UsersGridView.Visible = false;
			ChatLogDataList.Visible = false;
			ResultsGridView.Visible = true;
			AcceptedButton.Visible = true;
			DeclineButton.Visible = true;
			ChatLogButton.Visible = false;
			UserDetailsView.Visible = false;
		}

		if (OperatorRadioButtonList.SelectedValue == "users")
		{
			UsersGridView.DataSource = Membership.GetAllUsers();
			UsersGridView.DataBind();

			ResultsGridView.Visible = false;
			ArchivesPanel.Visible = false;
			UsersGridView.Visible = true;
			UserDetailsView.Visible = false;
		}
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the ArchivesGridView control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void ArchivesGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext();
		var source1 = from b in db.bookings
					  join p in db.pages on b.page_id equals p.page_id
					  where (b.id == int.Parse(ArchivesGridView.SelectedDataKey.Value.ToString()))
					  orderby b.id descending
					  select new
					  {
						  ID = b.id,
						  User = b.user_name,
						  Service = p.title,
						  Date = b.submited_date.ToString(),
						  Status = b.status
					  };

		var s = from d in db.form_datas
				join p in db.form_field_definitions on d.form_field_definition_id equals p.form_field_definition_id
				where (d.form_data_id == int.Parse(ArchivesGridView.SelectedDataKey.Value.ToString()))
				orderby d.form_data_id descending
				select new
				{
					p.form_field_name,
					p.input_type,
					d.value1,
					d.value2,
					d.value3,
					d.value4,
					d.value5,
					d.value6
				};
		DataTable table = new DataTable();
		table.Columns.Add("Name", typeof(string));
		table.Columns.Add("Value", typeof(string));
		foreach (var item in s)
		{
			if (item.input_type != "header" && item.input_type != "lblNoName" && item.input_type != "label")
			{
				DataRow dr = table.NewRow();
				dr["Name"] = item.form_field_name;
				if (item.value1 != null)
					dr["Value"] = item.value1.ToString();
				else
					if (item.value2 != null)
						dr["Value"] = item.value2.ToString();
					else
						if (item.value3 != null)
							dr["Value"] = item.value3.ToString();
						else
							if (item.value4 != null)
								dr["Value"] = item.value4.ToString();
							else
								if (item.value5 != null)
									dr["Value"] = item.value5.ToString();
								else
									if (item.value6 != null)
										dr["Value"] = item.value6.Value.ToShortDateString();
				table.Rows.Add(dr);
			}
		}

		DataView dv = new DataView(table);
		DetailsGridView.DataSource = dv;
		DetailsGridView.DataBind();
		DetailsView.DataSource = source1;
		DetailsView.DataBind();
		DetailsPanel.Visible = true;
		ArchivesPanel.Visible = false;
		if (DetailsView.Rows[2].Cells[1].Text == "Taxi")
			ChatLogButton.Visible = true;
		OperatorRadioButtonList.Visible = false;
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the UsersGridView control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void UsersGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		ProfileCommon profile = Profile.GetProfile(UsersGridView.SelectedDataKey.Value.ToString());
		List<ProfileCommon> list = new List<ProfileCommon>();
		list.Add(profile);
		UserDetailsView.DataSource = list;
		UserDetailsView.DataBind();
		UserDetailsView.Visible = true;
	}

	/// <summary>
	/// Handles the Click event of the ChatLogButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void ChatLogButton_Click(object sender, EventArgs e)
	{
		ChatLogDataList.Visible = true;
		List<string> list = Data.GetLog(ArchivesGridView.SelectedDataKey.Value.ToString());
		ChatLogDataList.DataSource = list;
		ChatLogDataList.DataBind();
	}

	/// <summary>
	/// Handles the Click event of the SearchButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void SearchButton_Click(object sender, EventArgs e)
	{
		string service = ServiceDropDownList.SelectedValue;
		string userName = UsersDropDownList.SelectedValue;
		DateTime minDateTime = SqlDateTime.MinValue.Value;
		DateTime maxDateTime = SqlDateTime.MaxValue.Value;
		DateTime fromDateTime = minDateTime;
		DateTime toDateTime = maxDateTime;
		DateTime.TryParse(FromDatePicker.txtDate.Text, out fromDateTime);
		DateTime.TryParse(ToDatePicker.txtDate.Text, out toDateTime);
		if (fromDateTime < minDateTime || fromDateTime > maxDateTime)
			fromDateTime = minDateTime;
		if (toDateTime < minDateTime || toDateTime > maxDateTime)
			toDateTime = maxDateTime;

		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var q = (from b in db.bookings
				 join p in db.pages on b.page_id equals p.page_id
				 where (b.status != "NEW") && (p.title == service || service == "All") && (b.user_name == userName || userName == "All") &&
				 (b.submited_date >= fromDateTime && b.submited_date <= toDateTime)
				 orderby b.id descending
				 select new
				 {
					 ID = b.id,
					 User = b.user_name,
					 Service = p.title,
					 Date = b.submited_date.ToString(),
					 Status = b.status
				 }).Distinct();

		ArchivesGridView.DataSource = q;
		ArchivesGridView.DataBind();
		if (q.Count() == 0)
			SearchResultsLabel.Text = "No results found";
		else
			SearchResultsLabel.Text = "";
	}

	/// <summary>
	/// Handles the Click event of the NextLinkButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void NextLinkButton_Click(object sender, EventArgs e)
	{
		int startIndex = (int)Session["StartIndex"];
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var source2 = (from b in db.bookings
					   join p in db.pages on b.page_id equals p.page_id
					   where (b.status != "NEW")
					   orderby b.id descending
					   select new
					   {
						   ID = b.id,
						   User = b.user_name,
						   Service = p.title,
						   Date = b.submited_date.ToString(),
						   Status = b.status
					   }).Distinct();
		int itemNumber = source2.Count();
		if (startIndex + 20 <= itemNumber)
			startIndex += 20;
		Session["StartIndex"] = startIndex;
		ArchivesGridView.DataSource = source2.Skip(startIndex).Take(20);
		ArchivesGridView.DataBind();
	}

	/// <summary>
	/// Handles the Click event of the PreviousLinkButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void PreviousLinkButton_Click(object sender, EventArgs e)
	{
		int startIndex = (int)Session["StartIndex"];
		if (startIndex > 0)
			startIndex -= 20;
		Session["StartIndex"] = startIndex;
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var source2 = (from b in db.bookings
					   join p in db.pages on b.page_id equals p.page_id
					   where (b.status != "NEW")
					   orderby b.id descending
					   select new
					   {
						   ID = b.id,
						   User = b.user_name,
						   Service = p.title,
						   Date = b.submited_date.ToString(),
						   Status = b.status
					   }).Distinct();
		ArchivesGridView.DataSource = source2.Skip(startIndex).Take(20);
		ArchivesGridView.DataBind();
	}
}
