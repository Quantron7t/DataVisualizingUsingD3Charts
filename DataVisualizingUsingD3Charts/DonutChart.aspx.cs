using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using Newtonsoft.Json;

namespace DataVisualizingUsingD3Charts
{
    public partial class DonutChart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            JsonLabel.Text= "Data Set : <br>"+GetDataForCharts();
            string chartScript = "var data = " + GetDataForCharts() + ";";
            ClientScript.RegisterClientScriptBlock(this.Page.GetType(), "ChartData", chartScript, true);

        }

        private string GetDataForCharts()
        {
            string connectionString = "Data Source=(local);Initial Catalog=Demo;Integrated Security=true";
            string query = "Select name,instock from Cars where availability=1";

            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Open();
                SqlCommand sqlCommand = new SqlCommand(query,sqlConnection);
                SqlDataReader reader;
                reader = sqlCommand.ExecuteReader();
                StringBuilder sb = new StringBuilder();
                int i = 0;
                if (reader.HasRows)
                {
                    sb.Append("[");
                    while (reader.Read())
                    {
                        if (i != 0)
                        {
                            sb.Append(",");
                        }
                        else
                        {
                            i++;
                        }
                        sb.Append("{");
                        sb.Append(reader.GetName(0)+":'"+reader[0]+"',");
                        sb.Append("value:" + reader[1]);
                        sb.Append("}");
                    }
                    sb.Append("]");
                    return sb.ToString();
                }

                return "No Data";
            }
        }
    }
}