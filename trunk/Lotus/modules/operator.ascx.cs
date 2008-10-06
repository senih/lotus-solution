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
		Result res = new Result();
		TimeLabel.Text = DateTime.Now.ToString();
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var test = (from d in db.form_datas
			select new
			{
				ID = d.form_data_id,
				Hour = d.submitted_date.Value.Hour,
				Minutes = d.submitted_date.Value.Minute,
				Seconds = d.submitted_date.Value.Second
			}).Distinct();
		var source = (from d in db.form_datas
					  join p in db.pages on d.page_id equals p.page_id
					  where d.status == 0
					  from v in test
					  where v.ID == d.form_data_id
					  orderby d.form_data_id descending
					  select new { 
						  ID = d.form_data_id, 
						  User = d.user, 
						  Service = p.title,
						  Date = v,
						  Status = d.status }).Distinct();
		GridView1.DataSource = test;
		GridView1.DataBind();
		ResultsGridView.DataSource = source;
		ResultsGridView.DataBind();
	}
}
