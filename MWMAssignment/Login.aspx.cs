using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment.Guest
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void registerBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("SignUp.aspx");
        }

        protected void loginBtn_Click(object sender, EventArgs e)
        {
            string name = username.Text.Trim();
            string pwd = password.Text.Trim();

            if (isAdmin(name, pwd))
            {
                Session["username"] = name;
                Session["role"] = "Admin";
                Response.Redirect("AdminManageUser.aspx");
            }
            else if (isCustomer(name,pwd))
            {
                Session["username"] = name;
                Session["role"] = "Customer";
                Response.Redirect("HomePage.aspx");
            }
            else
            {
                errMssg.Visible = true;
                errMssg.Text = "Incorrect username or password, please try again.";
                return;
            }
        }

        private bool isAdmin(string username, string password)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            SqlCommand command = new SqlCommand("select count(*) from adminTable where username = '" + username + "' and password = '" + password + "'", con);
            int check = Convert.ToInt32(command.ExecuteScalar().ToString());

            con.Close();

            return check > 0;
        }
        private bool isCustomer(string username, string password)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            SqlCommand command = new SqlCommand("select customerId from customerTable where username = @username and password = @password", con);
            command.Parameters.AddWithValue("@username", username);
            command.Parameters.AddWithValue("@password", password);

            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                string customerId = reader["customerId"].ToString();
                Session["customerId"] = customerId;

                con.Close();
                return true;
            }

            con.Close();
            return false;
        }
    }
}