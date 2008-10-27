using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Services;
using System.Data.SqlTypes;
using System.Net.Mail;
using System.Web.Security;
using System.Text;

public partial class modules_service : BaseUserControl
{
	
	/// <summary>
	/// Handles the Init event of the Page control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void Page_Init(object sender, EventArgs e)
	{
		RenderFormControls();
		if (IsPostBack)
		{
			Page.Validate();
			if (Page.IsValid)
			{
				string value = "window.open('chat.aspx',null,'height=530, width=530, left=200, top=150, status= no, resizable= no, scrollbars=no, toolbar=no, location=no, menubar=no ');";
				SubmitTaxiButton.OnClientClick = value;
			}
		}
	}
	
	/// <summary>
	/// Handles the Load event of the Page control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void Page_Load(object sender, EventArgs e)
    {
		Session["Service"] = ModuleData;
		if (!Page.User.Identity.IsAuthenticated)
		{
			BookingLogin.DestinationPageUrl = Request.RawUrl;
			AnonymousPanel.Visible = true;
		}
		else
		{
			if (Page.User.IsInRole("administrators"))
			{
				AdministrationPanel.Visible = true;
				LogedinPanel.Visible = false;
				FormControlsGridView.DataSource = Data.GetControls(PageID);
				FormControlsGridView.DataBind();
				LinqDataSource1.Where = "page_id=" + PageID.ToString();
				ContainerDropDownList.DataBind();
			}
			else
			{
				LogedinPanel.Visible = true;
			}
		}
		if (ModuleData == "taxi")
		{
			SubmitButton.Visible = false;
			SubmitTaxiButton.Visible = true;
		}
		//string value = "window.open('chat.aspx',null,'height=530, width=530, left=200, top=150, status= no, resizable= no, scrollbars=no, toolbar=no, location=no, menubar=no ');";
		//SubmitTaxiButton.OnClientClick = value;

		//if (IsPostBack && ModuleData == "taxi")
		//{
		//    Page.Validate();
		//    if (Page.IsValid)
		//    {
		//        string value = "window.open('chat.aspx',null,'height=530, width=530, left=200, top=150, status= no, resizable= no, scrollbars=no, toolbar=no, location=no, menubar=no ');";
		//        SubmitTaxiButton.OnClientClick = value;
		//    }
		//}
    }

	/// <summary>
	/// Handles the SelectedIndexChanged event of the OptionsRadioButtonList control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void OptionsRadioButtonList_SelectedIndexChanged(object sender, EventArgs e)
	{
		switch (OptionsRadioButtonList.SelectedValue)
		{
			case "Edit":
			{
				EditPanel.Visible = true;
				SettingsPanel.Visible = false;
				LogedinPanel.Visible = false;
			}
			break;

			case "Settings":
			{
				EditPanel.Visible = false;
				SettingsPanel.Visible = true;
				LogedinPanel.Visible = false;
			}
			break;

			case "Preview":
			{
				EditPanel.Visible = false;
				SettingsPanel.Visible = false;
				LogedinPanel.Visible = true;
			}
			break;
		}
	}

	/// <summary>
	/// Handles the Click event of the AddControlButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void AddControlButton_Click(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		form_field_definition fieldDefinition = new form_field_definition();
		fieldDefinition.form_field_name = ControlNameTextBox.Text;
		int sortNumber = 0;
		int.TryParse(SortingTextBox.Text, out sortNumber);
		fieldDefinition.sorting = sortNumber;
		fieldDefinition.sorting = int.Parse(SortingTextBox.Text);
		fieldDefinition.is_required = RequiredCheckBox.Checked;
		fieldDefinition.input_type = ControlTypeDropDownList.SelectedValue;
		fieldDefinition.page_id = PageID;
		fieldDefinition.div_id = int.Parse(ContainerDropDownList.SelectedValue.ToString());
		if (DefaultValueTextBox.Text != string.Empty)
			fieldDefinition.default_value = DefaultValueTextBox.Text;
		if (WidthTextBox.Text != string.Empty)
			fieldDefinition.width = int.Parse(WidthTextBox.Text);
		db.form_field_definitions.InsertOnSubmit(fieldDefinition);
		db.SubmitChanges();
		FormControlsGridView.DataSource = Data.GetControls(PageID);
		FormControlsGridView.DataBind();
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the ControlTypeDropDownList control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void ControlTypeDropDownList_SelectedIndexChanged(object sender, EventArgs e)
	{
		if (ControlTypeDropDownList.SelectedValue == "txtBox" || ControlTypeDropDownList.SelectedValue == "txtArea" || 
			ControlTypeDropDownList.SelectedValue == "ddList")
			WidthPanel.Visible = true;
		else
			WidthPanel.Visible = false;
	}

	/// <summary>
	/// Handles the SelectedIndexChanged event of the FormControlsGridView control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void FormControlsGridView_SelectedIndexChanged(object sender, EventArgs e)
	{
		ControlNameTextBox.Text = FormControlsGridView.SelectedRow.Cells[1].Text;
		ControlTypeDropDownList.SelectedValue = FormControlsGridView.SelectedRow.Cells[2].Text;
		SortingTextBox.Text = FormControlsGridView.SelectedRow.Cells[3].Text;
		if (FormControlsGridView.SelectedRow.Cells[4].Text != "&nbsp;")
			WidthTextBox.Text = FormControlsGridView.SelectedRow.Cells[4].Text;
		else
			WidthTextBox.Text = string.Empty;
		if (FormControlsGridView.SelectedRow.Cells[6].Text != "&nbsp;")
			DefaultValueTextBox.Text = FormControlsGridView.SelectedRow.Cells[6].Text;
		else
			DefaultValueTextBox.Text = string.Empty;
		RequiredCheckBox.Checked = bool.Parse(FormControlsGridView.SelectedRow.Cells[8].Text);
		ContainerDropDownList.SelectedValue = FormControlsGridView.SelectedRow.Cells[9].Text;
		AddControlButton.Visible = false;
		UpdateControlButton.Visible = true;
		DeleteControlButton.Visible = true;
		CancelUpdateButton.Visible = true;
		ValuesPanel.Visible = false;
		ControlOptions.Visible = true;
		switch(FormControlsGridView.SelectedRow.Cells[2].Text)
		{
			case "ddList":
			case "chkBoxList":
			case "radioBtnList":
			case "addressCtrl":
			WidthPanel.Visible = false;
			AddValuesLinkButton.Visible = true;
			break;
			case "txtBox":
			case "txtArea":
			AddValuesLinkButton.Visible = false;
			WidthPanel.Visible = true;
			break;
			default:
			WidthPanel.Visible = false;
			AddValuesLinkButton.Visible = false;
			break;
		}

	}

	/// <summary>
	/// Handles the Click event of the CancelUpdateButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void CancelUpdateButton_Click(object sender, EventArgs e)
	{
		Response.Redirect(Request.RawUrl);
	}

	/// <summary>
	/// Handles the Click event of the UpdateControlButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void UpdateControlButton_Click(object sender, EventArgs e)
	{
		int sortNumber, width;
		int ControlID = int.Parse(FormControlsGridView.SelectedDataKey.Value.ToString());
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		form_field_definition fieldUpdate = db.form_field_definitions.Where(f => f.form_field_definition_id == ControlID).Single<form_field_definition>();
		fieldUpdate.form_field_name = ControlNameTextBox.Text;		
		if (int.TryParse(SortingTextBox.Text, out sortNumber))
			fieldUpdate.sorting = sortNumber;
		if (int.TryParse(WidthTextBox.Text, out width))
			fieldUpdate.width = width;
		fieldUpdate.default_value = DefaultValueTextBox.Text;
		fieldUpdate.is_required = RequiredCheckBox.Checked;
		fieldUpdate.div_id = int.Parse(ContainerDropDownList.SelectedValue);
		db.SubmitChanges();
		Response.Redirect(Request.RawUrl);
	}

	/// <summary>
	/// Handles the Click event of the DeleteControlButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void DeleteControlButton_Click(object sender, EventArgs e)
	{
		int ControlID = int.Parse(FormControlsGridView.SelectedDataKey.Value.ToString());
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		db.form_field_definitions.DeleteAllOnSubmit(db.form_field_definitions.Where(f => f.form_field_definition_id == ControlID));
		db.form_field_values.DeleteAllOnSubmit(db.form_field_values.Where(v => v.form_field_definition_id == ControlID));
		db.SubmitChanges();
		Response.Redirect(Request.RawUrl);
	}

	/// <summary>
	/// Handles the Click event of the AddValuesLinkButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void AddValuesLinkButton_Click(object sender, EventArgs e)
	{
		ControlOptions.Visible = false;
		ValuesPanel.Visible = true;
		//if (FormControlsGridView.SelectedRow.Cells[2].Text == "addressCtrl")
		//{
		//    XmlFileUpload.Visible = true;
		//    ValueTextBox.Visible = false;
		//}
		//else
		//{
		//    XmlFileUpload.Visible = false;
		//    ValueTextBox.Visible = true;
		//}
		LinqDataSource2.Where = "form_field_definition_id=" + FormControlsGridView.SelectedDataKey.Value.ToString();
	}

	/// <summary>
	/// Handles the Click event of the BackButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void BackButton_Click(object sender, EventArgs e)
	{
		ControlOptions.Visible = true;
		ValuesPanel.Visible = false;
	}

	/// <summary>
	/// Handles the Click event of the AddValueButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void AddValueButton_Click(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		form_field_value controlValue = new form_field_value();
		controlValue.form_field_definition_id = int.Parse(FormControlsGridView.SelectedDataKey.Value.ToString());
		//if (FormControlsGridView.SelectedRow.Cells[2].Text == "addressCtrl")
		//{
		//    if (XmlFileUpload.HasFile)
		//    {
		//        XmlFileUpload.SaveAs(Server.MapPath("~/App_Data/") + XmlFileUpload.FileName);
		//        controlValue.display_value = XmlFileUpload.FileName;
		//    }
		//}
		//else
		controlValue.display_value = ValueTextBox.Text;
		controlValue.is_default = DefaultValueCheckBox.Checked;
		db.form_field_values.InsertOnSubmit(controlValue);
		db.SubmitChanges();
		LinqDataSource2.Where = "form_field_definition_id=" + FormControlsGridView.SelectedDataKey.Value.ToString();
		ValuesGridView.DataBind();
	}

	/// <summary>
	/// Renders the form controls.
	/// </summary>
	protected void RenderFormControls()
	{
		form_setting settings = Data.GetFormSettings(PageID);
		if (settings != null)
			HeaderLabel.Text = settings.header;
		if (settings != null)
			FooterLabel.Text = settings.footer;
		List<container> listOfContainers = Data.GetContainers(PageID);
		foreach (container div in listOfContainers)
		{
			HtmlGenericControl divContainer = new HtmlGenericControl("div");
			divContainer.Attributes.Add("class", div.name);
			List<form_field_definition> listOfFormControls = Data.GetControlsInContainer(div.id);
			divContainer.Controls.Add(new LiteralControl("<table>"));
			foreach (form_field_definition field in listOfFormControls)
			{
				WebCustomControl custCtrl = new WebCustomControl();
				divContainer.Controls.Add(new LiteralControl("<tr>"));
				divContainer.Controls.Add(custCtrl.GetControl(field));
				divContainer.Controls.Add(new LiteralControl("</tr>"));
			}
			divContainer.Controls.Add(new LiteralControl("</table>"));
			ControlsPlaceHolder.Controls.Add(divContainer);
		}
	}


	/// <summary>
	/// Handles the Click event of the AddContainerButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void AddContainerButton_Click(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		container newContainer = new container();
		newContainer.name = ContainerNameTextBox.Text.Replace(" ", "") + "_" + PageID.ToString();
		newContainer.page_id = PageID;
		int sortNumber = 0;
		int.TryParse(ContainerSortingTextBox.Text, out sortNumber);
		newContainer.sorting = sortNumber;
		db.containers.InsertOnSubmit(newContainer);
		db.SubmitChanges();
		ContainersGridView.DataBind();
	}

	/// <summary>
	/// Handles the Click event of the btnregister control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void btnregister_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/registration.aspx");
    }
	

	/// <summary>
	/// Handles the Click event of the SubmitButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void SubmitTaxiButton_Click(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		int dataId = (from d in db.form_datas select d.form_data_id).Max() + 1;
		string user = Page.User.Identity.Name;
		List<form_field_definition> listControls = Data.GetControls(PageID);
		foreach (form_field_definition control in listControls)
		{
			string sValue = null;
			bool? bValue = null;
			DateTime? dValue = null;
			string ctrlId = control.form_field_name.Replace(" ","");
			switch (control.input_type)
			{
				case "txtBox":
				case "txtArea":
				sValue = ((TextBox)this.FindControl(ctrlId)).Text;				
				break;

				case "ddList":
				sValue = ((DropDownList)this.FindControl(ctrlId)).SelectedValue;
				break;

				case "chkBox":
				bValue = ((CheckBox)this.FindControl(ctrlId)).Checked;
				break;

				case "chkBoxList":
				CheckBoxList chkList = (CheckBoxList)this.FindControl(ctrlId);
				foreach (ListItem item in chkList.Items)
				{
					if (item.Selected)
						sValue += item.Text + ", ";
				}
				break;

				case "radioBtnList":
				sValue = ((RadioButtonList)this.FindControl(ctrlId)).SelectedValue;
				break;

				case "datePicker":
				int day = int.Parse(((DropDownList)this.FindControl("days")).SelectedValue);
				int month = int.Parse(((DropDownList)this.FindControl("months")).SelectedValue);
				int year = int.Parse(((DropDownList)this.FindControl("years")).SelectedValue);
				dValue = new DateTime(year, month, day);
				break;

				case "timePicker":
				sValue = ((DropDownList)this.FindControl("hours")).SelectedValue + ":" + ((DropDownList)this.FindControl("minutes")).SelectedValue;
				break;

				case "addressCtrl":
				string city = ((DropDownList)this.FindControl("city" + control.default_value)).SelectedValue;
				string region = ((DropDownList)this.FindControl("region" + control.default_value)).SelectedValue;
				string address = ((TextBox)this.FindControl("address1" + control.default_value)).Text;
				sValue = address + ", " + region + ", " + city;
				break;

				//case "addressToCtrl":
				//string cityTo = ((DropDownList)this.FindControl("cityTo")).SelectedValue;
				//string regionTo = ((DropDownList)this.FindControl("regionTo")).SelectedValue;
				//string addressTo = ((TextBox)this.FindControl("addressTo")).Text;
				//sValue = addressTo + ", " + regionTo + ", " + cityTo;
				//break;
			}
			Data.InsertData(dataId, control.form_field_definition_id, PageID, control.input_type, sValue, bValue, dValue);
		}
		Data.InsertBooking(dataId, PageID, Page.User.Identity.Name);
		LogedinPanel.Visible = true;
		SubmitPanel.Visible = false;
		ThankYouPanel.Visible = true;
		if (ModuleData != "taxi")
		{
			Session["Service"] = ModuleData;
			SendMail();
		}
		else
		{
			string query = EncodingDecoding.EncodeMd5(dataId.ToString());
			Session["ChatID"] = query;
			Session["Service"] = ModuleData;
		}
	}

	/// <summary>
	/// Sends the mail.
	/// </summary>
	protected void SendMail()
	{
		form_setting settings = Data.GetFormSettings(PageID);
		MembershipUser user = Membership.GetUser(Page.User.Identity.Name);
		string body = "Your booking is registered. Soon operator will contact you. Thank you for using our services";
		if (settings != null && settings.thank_you_message != string.Empty)
			body = settings.thank_you_message;
		MailMessage msg = new MailMessage("contact@lotustransport.com", user.Email, "Confirmation", body);
		SmtpClient client = new SmtpClient();
		client.Send(msg);
		msg.Dispose();
	}

	/// <summary>
	/// Handles the Click event of the SaveSettingsButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void SaveSettingsButton_Click(object sender, EventArgs e)
	{
		Data.SaveSettings(PageID, HeaderTextBox.Text, FooterTextBox.Text, ThankYouTextBox.Text);
	}

	/// <summary>
	/// Handles the Click event of the SubmitButton control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
	protected void SubmitButton_Click(object sender, EventArgs e)
	{
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		int dataId = (from d in db.form_datas select d.form_data_id).Max() + 1;
		string user = Page.User.Identity.Name;
		List<form_field_definition> listControls = Data.GetControls(PageID);
		foreach (form_field_definition control in listControls)
		{
			string sValue = null;
			bool? bValue = null;
			DateTime? dValue = null;
			string ctrlId = control.form_field_name.Replace(" ", "");
			switch (control.input_type)
			{
				case "txtBox":
				case "txtArea":
				sValue = ((TextBox)this.FindControl(ctrlId)).Text;
				break;

				case "ddList":
				sValue = ((DropDownList)this.FindControl(ctrlId)).SelectedValue;
				break;

				case "chkBox":
				bValue = ((CheckBox)this.FindControl(ctrlId)).Checked;
				break;

				case "chkBoxList":
				CheckBoxList chkList = (CheckBoxList)this.FindControl(ctrlId);
				foreach (ListItem item in chkList.Items)
				{
					if (item.Selected)
						sValue += item.Text + ", ";
				}
				break;

				case "radioBtnList":
				sValue = ((RadioButtonList)this.FindControl(ctrlId)).SelectedValue;
				break;

				case "datePicker":
				int day = int.Parse(((DropDownList)this.FindControl("days")).SelectedValue);
				int month = int.Parse(((DropDownList)this.FindControl("months")).SelectedValue);
				int year = int.Parse(((DropDownList)this.FindControl("years")).SelectedValue);
				dValue = new DateTime(year, month, day);
				break;

				case "timePicker":
				sValue = ((DropDownList)this.FindControl("hours")).SelectedValue + ":" + ((DropDownList)this.FindControl("minutes")).SelectedValue;
				break;

				case "addressCtrl":
				string city = ((DropDownList)this.FindControl("city" + control.default_value)).SelectedValue;
				string region = ((DropDownList)this.FindControl("region" + control.default_value)).SelectedValue;
				string address = ((TextBox)this.FindControl("address1" + control.default_value)).Text;
				sValue = address + ", " + region + ", " + city;
				break;

			}
			Data.InsertData(dataId, control.form_field_definition_id, PageID, control.input_type, sValue, bValue, dValue);
		}
		Data.InsertBooking(dataId, PageID, Page.User.Identity.Name);
		LogedinPanel.Visible = true;
		SubmitPanel.Visible = false;
		ThankYouPanel.Visible = true;
		if (ModuleData != "taxi")
		{
			Session["Service"] = ModuleData;
			SendMail();
		}
		else
		{
			string query = EncodingDecoding.EncodeMd5(dataId.ToString());
			Session["ChatID"] = query;
			Session["Service"] = ModuleData;
		}
	}
}
