using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void submitButton_Click(object sender, EventArgs e)
        {
            if ((feedbackMessageTextBox.Text != null) && (suggestion.Checked || comment.Checked))
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "insert into feedbackTable(feedbackType, feedbackMessage, customerId, isGuest, createdDate) " +
                        "values (@feedbackType, @feedbackMessage, @customerId, @isGuest, @createdDate)";
                SqlCommand command = new SqlCommand(query, con);

                string feedbackType = suggestion.Checked ? "Suggestion" : "Comment";
                string feedbackMessage = feedbackMessageTextBox.Text.Trim();
                int customerId = 0;
                bool isGuest = false;

                if (Session["role"] != null)
                {
                    customerId = Convert.ToInt32(Session["customerId"]);
                    isGuest = false;
                }
                else
                {
                    customerId = 0;
                    isGuest = true;
                }

                command.Parameters.AddWithValue("@feedbackType", feedbackType);
                command.Parameters.AddWithValue("@feedbackMessage", feedbackMessage);
                command.Parameters.AddWithValue("@customerId", customerId);
                command.Parameters.AddWithValue("@isGuest", isGuest);
                command.Parameters.AddWithValue("@createdDate", DateTime.Now);

                command.ExecuteNonQuery();

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);

                con.Close();
            }
        }
    }
}