using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;

namespace WebApplication1
{
    public partial class EventReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            fillgrid();
        }
        
        private void  fillgrid()
        {
            DataTable dt =  getdata();
            if (dt.Rows.Count> 0)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
          
        }
        private DataTable getdata()
        {
            DataTable dt = new DataTable();
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_GetLottoEventDetails", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;             

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
               
                con.Close();
            }
            return dt;
        }

        [WebMethod]
        private DataTable GetFromDb()
        {
            DataTable dt = new DataTable();
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_GetLottoEventDetails", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);

                con.Close();
            }
            return dt;
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            this.fillgrid();
        }
    }
}