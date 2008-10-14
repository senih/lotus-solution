using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data;
using System.Xml;
using System.Xml.Linq;

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
		public static void InsertData(int dataId, int fieldId, int pageId, string inputType, string sValue, bool? bValue, DateTime? dValue)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			form_data data = new form_data();
			data.form_data_id = dataId;
			data.form_field_definition_id = fieldId;
			data.page_id = pageId;

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
				case "addressFromCtrl":
				case "addressToCtrl":
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


		/// <summary>
		/// Saves the settings.
		/// </summary>
		/// <param name="pageId">The page id.</param>
		/// <param name="header">The header.</param>
		/// <param name="footer">The footer.</param>
		/// <param name="msg">The MSG.</param>
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

		/// <summary>
		/// Inserts the booking.
		/// </summary>
		/// <param name="formDataId">The form data id.</param>
		/// <param name="pageId">The page id.</param>
		/// <param name="user">The user.</param>
		public static void InsertBooking(int formDataId, int pageId, string user)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			booking newBooking = new booking();
			newBooking.form_data_id = formDataId;
			newBooking.page_id = pageId;
			newBooking.user_name = user;
			newBooking.status = "NEW";
			newBooking.submited_date = DateTime.Now;

			db.bookings.InsertOnSubmit(newBooking);
			db.SubmitChanges();
		}

		/// <summary>
		/// Updates the booking.
		/// </summary>
		/// <param name="id">The id.</param>
		/// <param name="msg">The MSG.</param>
		/// <param name="status">The status.</param>
		public static void UpdateBooking(int id, string msg, string status)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			booking updateBooking = db.bookings.Where(b => b.id == id).Single<booking>();
			updateBooking.comment = msg;
			updateBooking.status = status;
			db.SubmitChanges();
		}

		/// <summary>
		/// Gets the comment.
		/// </summary>
		/// <param name="bookingId">The booking id.</param>
		/// <returns>Returns response from operator</returns>
		public static string GetComment(int bookingId)
		{
			string conn = ConnectionManager();
			LotusDataContext db = new LotusDataContext(conn);
			string response = db.bookings.Where(b => b.id == bookingId).Select(b => b.comment).ToString();
			return response;
		}

		/// <summary>
		/// Gets the XML elements.
		/// </summary>
		/// <param name="path">The path.</param>
		/// <returns>Returns list of parent elements</returns>
		public static List<string> GetXmlElements(string path)
		{
			XDocument xmlFile = XDocument.Load(path);
			List<string> list = (from e in xmlFile.Descendants("city")
								  select e.Attribute("name").Value).ToList<string>();
			return list;
		}

		/// <summary>
		/// Gets the XML child elements.
		/// </summary>
		/// <param name="path">The path.</param>
		/// <param name="parent">The parent.</param>
		/// <returns>Returns list of child elements</returns>
		public static List<string> GetXmlChildElements(string path, string parent)
		{
		    XDocument xmlFile = XDocument.Load(path);
			List<string> list = new List<string>();
			List<XAttribute> regions = xmlFile.Descendants("city").Where(e => e.Attribute("name").
				Value == parent).Elements("region").Attributes("name").ToList<XAttribute>();
			foreach (XAttribute atribut in regions)
			{
				list.Add(atribut.Value);
			}
			return list;
		}
	}
}
