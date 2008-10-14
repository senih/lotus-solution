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

	protected void ResultsGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext();
		var source1 = from b in db.bookings
					  join p in db.pages on b.page_id equals p.page_id
					  where (b.status == "NEW" && b.id == int.Parse(ResultsGridView.SelectedDataKey.Value.ToString()))
					  orderby b.id descending
					  select new
					  {
						  ID = b.id,
						  User = b.user_name,
						  Service = p.title,
						  Date = b.submited_date.ToString(),
						  Status = b.status
					  };

		var s =	from d in db.form_datas
				join p in db.form_field_definitions on d.form_field_definition_id equals p.form_field_definition_id
				where (d.form_data_id == int.Parse(ResultsGridView.SelectedDataKey.Value.ToString()))
				orderby d.form_data_id descending
				select new {
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
			ReplyPanel.Visible = true;
		else
			ReplyPanel.Visible = false;
		DetailsPanel.Visible = true;
		ResultsGridView.Visible = false;
	}

	protected void BackButton_Click(object sender, EventArgs e)
	{
		DetailsPanel.Visible = false;
		ResultsGridView.Visible = true;
	}

	protected void ReplyButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		string comment = ReplyTextBox.Text;
		string status = "ACCEPTED";
		Data.UpdateBooking(bookingId, comment, status);
	}

	protected void AcceptedButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		string status = "ACCEPTED";
		Data.UpdateBooking(bookingId, "", status);
	}
	protected void DeclineButton_Click(object sender, EventArgs e)
	{
		int bookingId = int.Parse(ResultsGridView.SelectedDataKey.Value.ToString());
		string status = "DECLINED";
		Data.UpdateBooking(bookingId, "", status);
	}
}
