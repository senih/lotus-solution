using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using EclipseWebSolutions;
using System.Xml;
using System.Xml.Linq;

namespace Services
{
	public class WebCustomControl : WebControl
	{
		DropDownList region = new DropDownList();
		DropDownList city = new DropDownList();

		/// <summary>
		/// Gets the control.
		/// </summary>
		/// <param name="control">The control.</param>
		/// <returns>Returns custom user control</returns>
		public Control GetControl(form_field_definition control)
		{
			string conn = Data.ConnectionManager();
			int ctrlId = control.form_field_definition_id;
			LotusDataContext db = new LotusDataContext(conn);
			List<form_field_value> listOfValues = db.form_field_values.Where(v => v.form_field_definition_id == ctrlId).ToList<form_field_value>();
			Control newControl = new Control();			
			string name = control.form_field_name;
			string id = name.Replace(" ", "");
			string type = control.input_type;
			int sorting = control.sorting;
			bool required = control.is_required;
			string defaultValue = string.Empty;
			int width = 200;
			int height = 50;
			if (control.default_value != null)
				defaultValue = control.default_value;
			if (control.width.HasValue)
				width = control.width.Value;
			if (control.height.HasValue)
				height = control.height.Value;
			Label nameLbl = new Label();
			nameLbl.Text = name;
			PlaceHolder ctrlHolder = new PlaceHolder();
			RequiredFieldValidator validator = new RequiredFieldValidator();
			RequiredFieldValidator validator1 = new RequiredFieldValidator();
			if (type != "header" && type != "lblNoName" && type != "addressCtrl")
			{
				ctrlHolder.Controls.Add(new LiteralControl("<td align=\"left\">"));
				ctrlHolder.Controls.Add(nameLbl);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(new LiteralControl("&nbsp;:&nbsp;"));
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
			}

			switch (type)
			{
				case "label":
				Label labelCtrl = new Label();
				labelCtrl.ID = id;
				labelCtrl.Width = width;
				labelCtrl.Text = defaultValue;
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(labelCtrl);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
				break;

				case "txtBox":
				TextBox txtBoxCtrl = new TextBox();
				txtBoxCtrl.ID = id;
				txtBoxCtrl.Text = defaultValue;
				txtBoxCtrl.Width = width;
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(txtBoxCtrl);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				if (required)
				{
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					validator.ControlToValidate = txtBoxCtrl.ID;
					validator.ErrorMessage = "*";
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(validator);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				}
				else
					ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
				
				break;

				case "txtArea":
				TextBox txtArea = new TextBox();
				txtArea.ID = id;
				txtArea.Text = defaultValue;
				txtArea.Width = width;
				txtArea.Height = height;
				txtArea.TextMode = TextBoxMode.MultiLine;
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(txtArea);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				if (required)
				{
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					validator.ControlToValidate = txtArea.ID;
					validator.ErrorMessage = "*";
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(validator);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				}
				else
					ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
				;
				break;

				case "ddList":
				DropDownList ddList = new DropDownList();
				ddList.ID = id;
				ddList.Width = width;
				foreach (form_field_value value in listOfValues)
				{
					ListItem item = new ListItem(value.display_value, value.display_value);
					ddList.Items.Add(item);
					if (value.is_default.Value)
						ddList.SelectedValue = item.Value;
				}
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(ddList);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;

				case "chkBox":
				CheckBox box = new CheckBox();
				box.ID = id;
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(box);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;

				case "chkBoxList":
				CheckBoxList boxList = new CheckBoxList();
				boxList.ID = id;
				foreach (form_field_value value in listOfValues)
				{
					ListItem item = new ListItem(value.display_value, value.display_value);
					boxList.Items.Add(item);
					if (value.is_default.Value)
						boxList.SelectedValue = item.Value;
				}
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(boxList);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));				
				break;

				case "radioBtnList":
				RadioButtonList radioList = new RadioButtonList();
				radioList.ID = id;
				foreach (form_field_value value in listOfValues)
				{
					ListItem item = new ListItem(value.display_value, value.display_value);
					radioList.Items.Add(item);
					if (value.is_default.Value)
						radioList.SelectedValue = item.Value;
				}
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(radioList);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));	
				break;

				case "datePicker":
				//EclipseWebSolutions.DatePicker.DatePicker datePicker = new EclipseWebSolutions.DatePicker.DatePicker();
				//datePicker.ID = id;
				//datePicker.CalendarPosition = EclipseWebSolutions.DatePicker.DatePicker.CalendarDisplay.DisplayRight;
				Panel datePicker = new Panel();
				DropDownList days = new DropDownList();
				days.ID = "days";
				DropDownList months = new DropDownList();
				months.ID = "months";
				DropDownList years = new DropDownList();
				years.ID = "years";
				for (int i = 1; i <= 31; i++)
				{
					if (i < 10)
						days.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
					else
						days.Items.Add(new ListItem(i.ToString(), i.ToString()));
				}
				for (int i = 1; i <= 12; i++)
				{
					if (i<10)
						months.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
					else
						months.Items.Add(new ListItem(i.ToString(), i.ToString()));
				}
				for (int i=2008; i<=2015; i++)
					years.Items.Add(new ListItem(i.ToString(), i.ToString()));
				datePicker.Controls.Add(new LiteralControl("<table><tr>"));
				datePicker.Controls.Add(new LiteralControl("<td>"));
				datePicker.Controls.Add(days);
				datePicker.Controls.Add(new LiteralControl("</td>"));
				datePicker.Controls.Add(new LiteralControl("<td>"));
				datePicker.Controls.Add(months);
				datePicker.Controls.Add(new LiteralControl("</td>"));
				datePicker.Controls.Add(new LiteralControl("<td>"));
				datePicker.Controls.Add(years);
				datePicker.Controls.Add(new LiteralControl("</td>"));
				datePicker.Controls.Add(new LiteralControl("</tr></table>"));

				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(datePicker);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;

				case "timePicker":
				DropDownList hour = new DropDownList();
				hour.ID = "hours";
				DropDownList minutes = new DropDownList();
				minutes.ID = "minutes";
				Panel timePicker = new Panel();
				for (int i = 0; i < 60; i++)
				{
					if (i > 0 && i <= 24)
					{
						if (i<10)
							hour.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
						else
							hour.Items.Add(new ListItem(i.ToString(), i.ToString()));
					}
					if (i % 10 == 0)
					{
						if(i<10)
							minutes.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
						else
							minutes.Items.Add(new ListItem(i.ToString(), i.ToString()));
					}
				}
				timePicker.Controls.Add(new LiteralControl("<table><tr>"));
				timePicker.Controls.Add(new LiteralControl("<td>"));
				timePicker.Controls.Add(hour);
				timePicker.Controls.Add(new LiteralControl("</td>"));
				timePicker.Controls.Add(new LiteralControl("<td>"));
				timePicker.Controls.Add(new LiteralControl(":"));
				timePicker.Controls.Add(new LiteralControl("</td>"));
				timePicker.Controls.Add(new LiteralControl("<td>"));
				timePicker.Controls.Add(minutes);
				timePicker.Controls.Add(new LiteralControl("</td>"));
				timePicker.Controls.Add(new LiteralControl("</tr></table>"));

				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(timePicker);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;

				case "addressCtrl":
				Unit adressWidth = new Unit(150);
				string xmlFileName = "";
				if (listOfValues.Count != 0)
				{
					xmlFileName = listOfValues[0].display_value;
					string path = HttpContext.Current.Server.MapPath("~/App_Data/") + xmlFileName;
					city.ID = "city" + defaultValue;
					region.ID = "region" + defaultValue;
					city.Width = adressWidth;
					region.Width = adressWidth;
					region.Enabled = false;
					city.DataSource = Data.GetXmlElements(path);
					city.DataBind();
					Label cityLabel = new Label();
					Label regionLabel = new Label();
					Label addressLabel = new Label();
					cityLabel.Text = "City " + defaultValue;
					regionLabel.Text = "Region " + defaultValue;
					addressLabel.Text = "Address " + defaultValue;
					TextBox addressTxtBox = new TextBox();
					addressTxtBox.ID = "address1" + defaultValue;
					addressTxtBox.TextMode = TextBoxMode.MultiLine;
					addressTxtBox.Width = adressWidth;
					Panel addressPanel = new Panel();
					addressPanel.ID = id;
					city.SelectedIndexChanged += new EventHandler(city_SelectedIndexChanged);
					city.AutoPostBack = true;
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<table>"));

					ctrlHolder.Controls.Add(new LiteralControl("<tr>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(cityLabel);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(new LiteralControl("&nbsp;:&nbsp;"));
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(city);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					validator1.ControlToValidate = city.ID;
					validator1.InitialValue = "Please select city";
					validator1.ErrorMessage = "*";
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(validator1);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("</tr>"));

					ctrlHolder.Controls.Add(new LiteralControl("<tr>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(regionLabel);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(new LiteralControl("&nbsp;:&nbsp;"));
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(region);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
					ctrlHolder.Controls.Add(new LiteralControl("</tr>"));

					ctrlHolder.Controls.Add(new LiteralControl("<tr>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(addressLabel);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(new LiteralControl("&nbsp;:&nbsp;"));
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(addressTxtBox);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					validator.ControlToValidate = addressTxtBox.ID;
					validator.ErrorMessage = "*";
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(validator);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
					ctrlHolder.Controls.Add(new LiteralControl("</tr>"));

					ctrlHolder.Controls.Add(new LiteralControl("</table>"));
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				}
				else
				{
					Label errorLabel = new Label();
					errorLabel.Text = "Please enter XML source file!";
					ctrlHolder.Controls.Add(new LiteralControl("<td>"));
					ctrlHolder.Controls.Add(errorLabel);
					ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				}

				break;

				case "header":
				Label headerCtrl = new Label();
				headerCtrl.ID = id;
				headerCtrl.Text = defaultValue;
				headerCtrl.Font.Bold = true;
				ctrlHolder.Controls.Add(new LiteralControl("<td colspan=\"3\">"));
				ctrlHolder.Controls.Add(headerCtrl);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;

				case "lblNoName":
				Label infoCtrl = new Label();
				infoCtrl.ID = id;
				infoCtrl.Text = defaultValue;
				ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
				ctrlHolder.Controls.Add(new LiteralControl("<td></td>"));
				ctrlHolder.Controls.Add(new LiteralControl("<td>"));
				ctrlHolder.Controls.Add(infoCtrl);
				ctrlHolder.Controls.Add(new LiteralControl("</td>"));
				break;
			}
			newControl = ctrlHolder;
			return newControl;
		}

		/// <summary>
		/// Handles the SelectedIndexChanged event of the city control.
		/// </summary>
		/// <param name="sender">The source of the event.</param>
		/// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
		protected void city_SelectedIndexChanged(object sender, EventArgs e)
		{
			string path = HttpContext.Current.Server.MapPath("~/App_Data/") + "CityRegion.xml";
			if (city.SelectedValue != "Please select city")
				region.Enabled = true;
			else
				region.Enabled = false;
			region.DataSource = Data.GetXmlChildElements(path, city.SelectedItem.Text);
			region.DataBind();
		}
	}
}
