﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Services;

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
		ArchivesGridView.DataSource = source2;
		ArchivesGridView.DataBind();
	}

	protected void ResultsGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		GetDetails();
	}

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
			string value = string.Format("window.open('chat.aspx?ChatID={0}',null,'height=300, width=430,status= no, resizable= no, scrollbars=no, toolbar=no, location=no, menubar=no ');", query);
			ChatButton.Attributes.Add("onclick", value);
		}
		else
			ChatButton.Visible = false;
		DetailsPanel.Visible = true;
		ResultsGridView.Visible = false;
		OperatorRadioButtonList.Visible = false;
	}

	protected void BackButton_Click(object sender, EventArgs e)
	{
		DetailsPanel.Visible = false;
		if (OperatorRadioButtonList.SelectedValue == "archive")
			ArchivesGridView.Visible = true;
		else
			ResultsGridView.Visible = true;
		OperatorRadioButtonList.Visible = true;
	}

	protected void AcceptedButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		if (DetailsView.Rows[2].Cells[1].Text == "Taxi")
		{
			string path = Server.MapPath("~/App_Data/Logs/") + "BookingLogNo_" + bookingId.ToString() + ".xml";
			List<string> list = new List<string>();
			list = (List<string>)Application[EncodingDecoding.EncodeMd5(bookingId.ToString())];
			//TODO Kreiranjeto na XML file ne raboti uste
			//Data.CreateLog(list, path);
			Application.Clear();
		}
		string status = "ACCEPTED";
		Data.UpdateBooking(bookingId, "", status);
		Response.Redirect(Request.RawUrl);
	}
	protected void DeclineButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		string status = "DECLINED";
		Data.UpdateBooking(bookingId, "", status);
		Response.Redirect(Request.RawUrl);
	}
	protected void OperatorRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
	{
		if (OperatorRadioButtonList.SelectedValue == "archive")
		{
			ResultsGridView.Visible = false;
			ArchivesGridView.Visible = true;
			AcceptedButton.Visible = false;
			DeclineButton.Visible = false;
		}
		else
		{
			ArchivesGridView.Visible = false;
			ResultsGridView.Visible = true;
			AcceptedButton.Visible = true;
			DeclineButton.Visible = true;
		}
	}
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
		ArchivesGridView.Visible = false;
		OperatorRadioButtonList.Visible = false;
	}
}
