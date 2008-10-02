using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Services;

public partial class modules_service : BaseUserControl
{


	protected void Page_Init(object sender, EventArgs e)
	{
		RenderFormControls();
		//RenderFormControlsTest();
	}
	
	/// <summary>
	/// Handles the Load event of the Page control.
	/// </summary>
	/// <param name="sender">The source of the event.</param>
	/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void Page_Load(object sender, EventArgs e)
    {
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
			}
			else
			{
				LogedinPanel.Visible = true;
			}
		}
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
		if (ControlTypeDropDownList.SelectedValue == "txtBox" || ControlTypeDropDownList.SelectedValue == "txtArea")
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
		int ControlID = int.Parse(FormControlsGridView.SelectedPersistedDataKey.Value.ToString());
		LotusDataContext db = new LotusDataContext(Data.ConnectionManager());
		form_field_definition fieldUpdate = db.form_field_definitions.Where(f => f.form_field_definition_id == ControlID).Single<form_field_definition>();
		fieldUpdate.form_field_name = ControlNameTextBox.Text;		
		if (int.TryParse(SortingTextBox.Text, out sortNumber))
			fieldUpdate.sorting = sortNumber;
		if (int.TryParse(WidthTextBox.Text, out width))
			fieldUpdate.width = width;
		fieldUpdate.default_value = DefaultValueTextBox.Text;
		fieldUpdate.is_required = RequiredCheckBox.Checked;
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
		controlValue.display_value = ValueTextBox.Text;
		controlValue.is_default = DefaultValueCheckBox.Checked;
		db.form_field_values.InsertOnSubmit(controlValue);
		db.SubmitChanges();
	}

	protected void RenderFormControls()
	{
		List<container> listOfContainers = Data.GetContainers(PageID);
		foreach (container div in listOfContainers)
		{
			HtmlGenericControl divContainer = new HtmlGenericControl("div");
			divContainer.Attributes.Add("class", div.name);
			List<form_field_definition> listOfFormControls = Data.GetControlsInContainer(div.id);
			divContainer.Controls.Add(new LiteralControl("<table>"));
			foreach (form_field_definition field in listOfFormControls)
			{
				divContainer.Controls.Add(new LiteralControl("<tr>"));
				divContainer.Controls.Add(WebCustomControl.GetControl(field));
				divContainer.Controls.Add(new LiteralControl("</tr>"));
			}
			divContainer.Controls.Add(new LiteralControl("</table>"));
			ControlsPlaceHolder.Controls.Add(divContainer);
		}
	}

	protected void RenderFormControlsTest()
	{
		List<container> listOfContainers = Data.GetContainers(PageID);
		foreach (container div in listOfContainers)
		{			
			ControlsPlaceHolder.Controls.Add(new LiteralControl("<div class=" + div.name));
			List<form_field_definition> listOfFormControls = Data.GetControlsInContainer(div.id);
			ControlsPlaceHolder.Controls.Add(new LiteralControl("<table>"));
			foreach (form_field_definition field in listOfFormControls)
			{
				ControlsPlaceHolder.Controls.Add(new LiteralControl("<tr>"));
				ControlsPlaceHolder.Controls.Add(WebCustomControl.GetControl(field));
				ControlsPlaceHolder.Controls.Add(new LiteralControl("</tr>"));
			}
			ControlsPlaceHolder.Controls.Add(new LiteralControl("</table>"));
			ControlsPlaceHolder.Controls.Add(new LiteralControl("</div>"));
		}
	}

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
	}
}
