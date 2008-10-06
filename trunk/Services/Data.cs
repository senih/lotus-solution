using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data;

namespace Services
{
	/// <summary>
	/// Methods for working with form data
	/// </summary>
	public class Data
	{
		/// <summary>
		/// Connections the manager.
		/// </summary>
		/// <returns>Gets the database connection string</returns>
		public static string ConnectionManager()
		{
			string connection = ConfigurationSettings.AppSettings["ConnectionString"];
			return connection;
		}

		/// <summary>
		/// Gets the controls.
		/// </summary>
		/// <param name="pageId">The page id.</param>
		/// <returns>Gets list of all controls defined for this page</returns>
		public static List<form_field_definition> GetControls(int pageId)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			return db.form_field_definitions.Where(f => f.page_id == pageId).OrderBy(f => f.sorting).ToList<form_field_definition>();
		}

		/// <summary>
		/// Gets the containers.
		/// </summary>
		/// <param name="pageId">The page id.</param>
		/// <returns>Returns list of all containers defined for this page</returns>
		public static List<container> GetContainers(int pageId)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			return db.containers.Where(c => c.page_id == pageId).OrderBy(c => c.sorting).ToList<container>();
		}

		/// <summary>
		/// Gets the controls in container.
		/// </summary>
		/// <param name="containerId">The container id.</param>
		/// <returns>Returns list of all controls in given container</returns>
		public static List<form_field_definition> GetControlsInContainer(int containerId)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			return db.form_field_definitions.Where(c => c.div_id == containerId).OrderBy(c => c.sorting).ToList<form_field_definition>();
		}


		/// <summary>
		/// Inserts the data.
		/// </summary>
		/// <param name="dataId">The data id.</param>
		/// <param name="fieldId">The field id.</param>
		/// <param name="pageId">The page id.</param>
		/// <param name="inputType">Type of the input.</param>
		/// <param name="sValue">The s value.</param>
		/// <param name="bValue">The b value.</param>
		/// <param name="dValue">The d value.</param>
		/// <param name="user">The user.</param>
		public static void InsertData(int dataId, int fieldId, int pageId, string inputType, string sValue, bool? bValue, DateTime? dValue, string user)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			form_data data = new form_data();
			data.form_data_id = dataId;
			data.form_field_definition_id = fieldId;
			data.page_id = pageId;
			data.submitted_date = DateTime.Now;
			data.status = 0;
			data.user = user;

			switch (inputType)
			{
				case "txtBox":				
				case "ddList":
				case "radioBtnList":
				case "timePicker":
				data.value1 = sValue;
				break;

				case "txtArea":
				case "chkBoxList":
				data.value2 = sValue;
				break;

				case "chkBox":
				data.value3 = bValue;
				break;

				case "datePicker":
				data.value6 = dValue;
				break;
			}
			db.form_datas.InsertOnSubmit(data);
			db.SubmitChanges();
		}


		public static void SaveSettings(int pageId, string header, string footer, string msg)
		{
			string conn = ConnectionManager();
			form_setting settings;
			LotusDataContext db = new LotusDataContext(conn);
			if (db.form_settings.Where(s => s.page_id == pageId).Any())
			{
				settings = db.form_settings.Where(s => s.page_id == pageId).Single<form_setting>();
				settings.header = header;
				settings.footer = footer;
				settings.thank_you_message = msg;
			}
			else
			{
				settings = new form_setting();
				settings.page_id = pageId;
				settings.header = header;
				settings.footer = footer;
				settings.thank_you_message = msg;
				db.form_settings.InsertOnSubmit(settings);
			}
			db.SubmitChanges();
		}

		/// <summary>
		/// Gets the form settings.
		/// </summary>
		/// <param name="pageId">The page id.</param>
		/// <returns></returns>
		public static form_setting GetFormSettings(int pageId)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			form_setting settings = null;
			if (db.form_settings.Where(s => s.page_id == pageId).Any<form_setting>())
				settings = db.form_settings.Where(s => s.page_id == pageId).Single<form_setting>();
			return settings;
		}
	}
}
