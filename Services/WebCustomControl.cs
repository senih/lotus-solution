using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace Services
{
	public class WebCustomControl : WebControl
	{
		public static Control GetControl(form_field_definition control)
		{
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
			ctrlHolder.Controls.Add(new LiteralControl("<td>"));
			ctrlHolder.Controls.Add(nameLbl);
			ctrlHolder.Controls.Add(new LiteralControl("</td>"));
			ctrlHolder.Controls.Add(new LiteralControl("<td>"));
			ctrlHolder.Controls.Add(new LiteralControl("&nbsp;&nbsp;:&nbsp;&nbsp;"));
			ctrlHolder.Controls.Add(new LiteralControl("</td>"));
			RequiredFieldValidator validator = new RequiredFieldValidator();

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
				;
				break;

				case "chkBox":
				;
				break;

				case "chkBoxList":
				;
				break;

				case "radioBtnList":
				;
				break;

				case "datePicker":
				;
				break;

				case "timePicker":
				;
				break;

				case "addressCtrl":
				;
				break;
			}
			newControl = ctrlHolder;
			return newControl;
		}
	}
}
