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
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		var source = (from d in db.form_datas
					  join p in db.pages on d.page_id equals p.page_id
					  orderby d.form_data_id descending
					  select new { d.form_data_id, d.user, p.title }).Distinct();
		ResultsGridView.DataSource = source;
		ResultsGridView.DataBind();
	}
}
