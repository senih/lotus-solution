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

		/// <summary>
		/// Gets the containers.
		/// </summary>
		/// <param name="pageId">The page id.</param>
		/// <returns>Returns list of all containers defined for this page</returns>
		public static List<container> GetContainers(int pageId)
		{
			LotusDataContext db = new LotusDataContext(ConnectionManager());
			return db.containers.Where(c => c.page_id == pageId).OrderBy(c => c.sorting).ToList<container>();
		}

		public static List<form_field_definition> GetControlsInContainer(int containerId)
		{
			LotusDataContext db = new LotusDataContext(ConnectionManager());
			return db.form_field_definitions.Where(c => c.div_id == containerId).OrderBy(c => c.sorting).ToList<form_field_definition>();
		}
	}
}
