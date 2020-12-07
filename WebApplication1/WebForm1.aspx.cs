using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace WebApplication1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void filldropdown()
        {
            DataTable dt = getdata();
                drp.DataSource = dt;
                drp.DataBind();
        }
        private DataTable getdata()
        {
            DataTable dt = new DataTable();
            string cs = ConfigurationManager.ConnectionStrings["Myconneection"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            using (SqlCommand cmd = new SqlCommand(con))
            {

              cmd.CommandText = 
               sq
            }
            return dt; 

        }
    }
}