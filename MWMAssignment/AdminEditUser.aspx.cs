using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class WebForm15 : System.Web.UI.Page
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
                    int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
                    LoadUserDetails(customerId);
                }
            }
        }

        private void LoadUserDetails(int customerId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM customerTable WHERE customerId = @customerId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@customerId", customerId);

            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                username.Text = reader["username"].ToString();
                email.Text = reader["email"].ToString();
                phoneNum.Text = reader["phoneNum"].ToString();

                string actualPassword = reader["password"].ToString();
                password.Text = new string('*',actualPassword.Length);

                gender.SelectedValue = reader["gender"].ToString();
                address.Text = reader["address"].ToString();
            }
            reader.Close();
            con.Close();

        }

        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminManageUser.aspx");
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE customerTable SET email = @email, phoneNum = @phoneNum, address = @address" +
                " WHERE customerId = @customerId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@email", email.Text);
            command.Parameters.AddWithValue("@phoneNum", phoneNum.Text);
            command.Parameters.AddWithValue("@address", address.Text);;
            command.Parameters.AddWithValue("@customerId", Request.QueryString["customerId"]);
            command.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
        }
    }
}