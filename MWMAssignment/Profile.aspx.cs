using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["role"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    LoadCustomerProfile();
                }
            }
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE customerTable SET username = @username, email = @email, phoneNum = @phoneNum," +
                "password = @password, gender = @gender, address = @address WHERE customerId = @customerId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@username", username.Text);
            command.Parameters.AddWithValue("@email", email.Text); 
            command.Parameters.AddWithValue("@phoneNum", phoneNum.Text);
            command.Parameters.AddWithValue("@password", password.Text); 
            command.Parameters.AddWithValue("@gender", gender.SelectedValue);
            command.Parameters.AddWithValue("@address", address.Text);
            command.Parameters.AddWithValue("@customerId", Session["customerId"].ToString());
            command.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);

            Session["username"] = username.Text;
        }

        private void LoadCustomerProfile()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM customerTable WHERE customerId = @customerId", con);
            da.SelectCommand.Parameters.AddWithValue("@customerId", Session["customerId"].ToString());
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                username.Text = dt.Rows[0][1].ToString();
                email.Text = dt.Rows[0][2].ToString();
                phoneNum.Text = dt.Rows[0][3].ToString();
                password.Text = dt.Rows[0][4].ToString();
                gender.SelectedValue = dt.Rows[0][5].ToString().Trim();
                address.Text = dt.Rows[0][6].ToString();
            }

            con.Close();
        }
    }
}