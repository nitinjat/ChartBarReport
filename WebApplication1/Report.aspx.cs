using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.DataVisualization.Charting;
using System.Web.Services;
using System.Collections;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
namespace WebApplication1
{
    public partial class Report : System.Web.UI.Page
    {
      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                genrateReport();
                gettotalcount();
                fillgrid();
                hdnval.Value = "1";
            }
        }

        protected void PopulateChart(object sender, EventArgs e)
         {
            string fromdt = from_dt_picker.Value;
            string Todt = to_dt_picker.Value;
            if (validate() == 0)
            {
                chartdata chd = getdata(fromdt, Todt);
                string output = JsonConvert.SerializeObject(chd);
                var Myjson = new JavaScriptSerializer().Serialize(chd);
                //string script = "window.onload = function() { Fillchart('" + output + "'); };";
                //ClientScript.RegisterStartupScript(this.GetType(), "Fillchart", script, true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "myalert", "Fillchart(" + Myjson + ");", true);
            }
        }
        private int validate()
         {
            int valid = 0;
            if (from_dt_picker.Value == null || from_dt_picker.Value == "")
            {
                valid = 1;
                fromdt.Visible = true;
                fromdt.Text = "Please select From Date ";
                fromdt.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                fromdt.Visible = false;
                fromdt.Text = string.Empty;
            }
            if (to_dt_picker.Value==null || to_dt_picker.Value =="")
            {
                valid = 1;
                todt.Visible = true;
                todt.Text = "Please select To Date ";
                todt.ForeColor = System.Drawing.Color.Red;
            }
            else {
                todt.Visible = false;
                todt.Text = string.Empty;
            }
            return valid;
        }
             
        private void gettotalcount()
        {
            int tcount = 0 ;
            DataTable dt = getdata();
            if (dt.Rows.Count > 0)
            {
                
                foreach (DataRow dr in dt.Rows)
                {
                    tcount += Convert.ToInt32(dr["UserCount"]);
                }
            }

            lblcount.Visible = true;
            lblcount.InnerText = tcount.ToString();
        }      
        private void fillgrid()
        {
            DataTable dt = getdata();
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
        [WebMethod]
        public static chartdata SelectData()
        {
            chartdata obj_dashboard = new chartdata();
            DateTime dtt = DateTime.Now.AddDays(-7);
            DataTable dt = new DataTable();
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_ActiveUserCount", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@FromDate", dtt);
                cmd.Parameters.AddWithValue("@ToDate", DateTime.Now);               
                cmd.Parameters.AddWithValue("@Event", string.Empty);


                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    obj_dashboard.WeekDays = dt.AsEnumerable().Select(r => r.Field<string>("WeekDays")).ToList();
                    obj_dashboard.UserCount = dt.AsEnumerable().Select(r => r.Field<int>("UserCount")).ToList();                     
                                      

                }
                con.Close();
            }
        
            return obj_dashboard;
        }
        public DataTable getdata()
        {
            DataTable dt = new DataTable();
            DateTime dtt = DateTime.Now.AddDays(-7);
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_ActiveUserCount", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@FromDate", dtt);
                cmd.Parameters.AddWithValue("@ToDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@Event", string.Empty);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {

                }
                con.Close();
            }
            return dt;
        }
        public chartdata getdata(string fromdt, string todt)
        {
            int totalcount = 0;
            DataTable dt = new DataTable();
            chartdata obj_dashboard = new chartdata();
            string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("Usp_ActiveUserCount", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@FromDate", fromdt);
                cmd.Parameters.AddWithValue("@ToDate", todt);
                cmd.Parameters.AddWithValue("@Event", string.Empty);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    obj_dashboard.WeekDays = dt.AsEnumerable().Select(r => r.Field<string>("WeekDays")).ToList();
                    obj_dashboard.UserCount = dt.AsEnumerable().Select(r => r.Field<int>("UserCount")).ToList();

                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                    foreach (DataRow dr in dt.Rows)
                    {
                        totalcount += Convert.ToInt32(dr["UserCount"]);
                    }
                    lblcount.Visible = true;
                    lblcount.InnerText = totalcount.ToString();
                }
                con.Close();
            }


            return obj_dashboard;
        }
        private void genrateReport()
        {
            //chartContainer.Visible = true;//DrpUserActive.SelectedValue != "";
            //                              // string query = string.Format("select count(*) from [dbo].[User] where IsActive = 1", ddlCountries.SelectedValue);
            //DataTable dt = getdata();
            //chartContainer.DataSource = dt;
            //chartContainer.Series[0].ChartType = (SeriesChartType)int.Parse("10");
            //chartContainer.Legends[0].Enabled = true;
            //chartContainer.Series[0].XValueMember = "WeekDays";
            //chartContainer.Series[0].YValueMembers = "UserCount";
            //chartContainer.DataBind();
            ////ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "getImageUrl("+dt+")",  true);
            ////Page.ClientScript.RegisterStartupScript(this.GetType,"Myfunc", "Myfunc("+dt+")" ,true);
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "myalert", "Myfunc('" + dt + "');", true);

        }
        private void genrateReport(DataTable dt)
        {
            //chartContainer.Visible = true;//DrpUserActive.SelectedValue != "";
            //                              // string query = string.Format("select count(*) from [dbo].[User] where IsActive = 1", ddlCountries.SelectedValue);

            //chartContainer.DataSource = dt;
            //chartContainer.Series[0].ChartType = (SeriesChartType)int.Parse("10");
            //chartContainer.Legends[0].Enabled = true;
            //chartContainer.Series[0].XValueMember = "WeekDays";
            //chartContainer.Series[0].YValueMembers = "UserCount";
            //chartContainer.DataBind();
            ////ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "getImageUrl("+dt+")",  true);
            ////Page.ClientScript.RegisterStartupScript(this.GetType,"Myfunc", "Myfunc("+dt+")" ,true);
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "myalert", "Myfunc('" + dt + "');", true);

        }
    }
}

public class chartdata
{
   public List<int>  UserCount { get; set; }
    public List<string> WeekDays { get; set; }
}
//SqlParameter []outputPara = new SqlParameter[3];
//outputPara[0].ParameterName = "@FromDate";
//outputPara[0].Direction = System.Data.ParameterDirection.Input;
//outputPara[0].SqlDbType = System.Data.SqlDbType.Date;
//outputPara[0].Value = DateTime.Now;

//outputPara[1].ParameterName = "@ToDate";
//outputPara[1].Direction = System.Data.ParameterDirection.Input;
//outputPara[1].SqlDbType = System.Data.SqlDbType.Date;
//outputPara[1].Value = DateTime.Now;

//outputPara[2].ParameterName = "@Event";
//outputPara[2].Direction = System.Data.ParameterDirection.Input;
//outputPara[2].SqlDbType = System.Data.SqlDbType.VarChar;
//outputPara[2].Value = string.Empty;

// cmd.Parameters.Add(outputPara);