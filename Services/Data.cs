using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

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
			string connection = ConfigurationSettings.AppSettings["SiteConnectionString"];
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
	}
}
