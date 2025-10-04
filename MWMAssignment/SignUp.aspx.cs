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
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void loginBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        protected void registerBtn_Click(object sender, EventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "select count(*) from customerTable where username = '" + username.Text + "'";
                SqlCommand command = new SqlCommand(query, con);
                int check = Convert.ToInt32(command.ExecuteScalar().ToString());

                string query2 = "select count(*) from customerTable where email = '" + email.Text + "'";
                SqlCommand command2 = new SqlCommand(query2, con);
                int check2 = Convert.ToInt32(command2.ExecuteScalar().ToString());

                if (check > 0)
                {
                    errMssg.Visible = true;
                    errMssg.Text = "Username has been taken, try another.";
                }
                else if (check2 > 0)
                {
                    errMssg.Visible = true;
                    errMssg.Text = "This email has already registered an account.";
                }
                else
                {
                    string query3 = "insert into customerTable(username, email, phoneNum, password, gender, address, createdDate) " +
                        "values (@username, @email, @phoneNum, @password, @gender, @address, @createdDate)";
                    SqlCommand command3 = new SqlCommand(query3, con);

                    command3.Parameters.AddWithValue("@username", username.Text);
                    command3.Parameters.AddWithValue("@email", email.Text);
                    command3.Parameters.AddWithValue("@phoneNum", phoneNum.Text);
                    command3.Parameters.AddWithValue("@password", password.Text);
                    command3.Parameters.AddWithValue("@gender", gender.SelectedItem.ToString());
                    command3.Parameters.AddWithValue("@address", "-");
                    command3.Parameters.AddWithValue("@createdDate", DateTime.Now);             

                    command3.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                errMssg.Visible = true;
                errMssg.Text = "Unsuccessfully create account!" + ex.ToString();
            }

        }
    }
}