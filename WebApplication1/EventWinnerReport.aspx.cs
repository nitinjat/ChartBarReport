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
using System.Collections;
using Newtonsoft.Json;
using System.Web.Script.Serialization;

namespace WebApplication1
{
    public partial class EventWinnerReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            fillgrid();
            totalcount();
        }
        private void fillgrid()
        {
            DataTable dt = getdata();
            if (dt.Rows.Count > 0)
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
                SqlCommand cmd = new SqlCommand("Usp_GetwinnerDetails", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);

                con.Close();
            }
            return dt;
        }
        private void totalcount()
        {
            DataTable dt = new DataTable();
            int totalcount = 0;
            dt = getdata();
            foreach (DataRow dr in dt.Rows)
            {
                totalcount += Convert.ToInt32(dr["totalUser"]);
            }
            lblcount.Visible = true;
            lblcount.InnerText = totalcount.ToString();
        }
        [WebMethod]
        public static WinnerData SelectData()
        {
            WinnerData objWd = new WinnerData();
            DateTime dtt = DateTime.Now.AddDays(-7);
            DataTable dt = new DataTable();
            DataTable dt1 = new DataTable();
            dt1.Columns.Add("totalUser",typeof(Int32));
            dt1.Columns.Add("position", typeof(string));
            dt1.Rows.Add(12, "1");
            dt1.Rows.Add(20, "2");
            dt1.Rows.Add(15, "3");
            dt1.Rows.Add(36, "4");
            dt1.Rows.Add(12, "5");
            dt1.Rows.Add(30, "6");
            dt1.Rows.Add(42, "7");
            dt1.Rows.Add(62, "8");
            dt1.Rows.Add(16, "9");
            dt1.Rows.Add(8, "10");
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_GetwinnerDetails", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;             

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                 
                    objWd.TotalWinner = dt.AsEnumerable().Select(r => r.Field<int>("totalUser")).ToList();
                    objWd.Positions = dt.AsEnumerable().Select(r => r.Field<string>(Convert.ToString("position"))).ToList();

                   
                }
                con.Close();
            }

            return objWd;
        }
    }

    public class WinnerData
    {
        public List<string> Positions { get; set; }
        public List<int> TotalWinner { get; set; }
    }
}