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
    public partial class GuestMasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UpdateNavBar();
            }
        }

        private void UpdateNavBar()
        {
            if (Session["role"] != null)
            {
                string username = Session["username"].ToString();
                int customerId = Convert.ToInt32(Session["customerId"]);
                GetCartDetails(customerId);
                guestLabel.Text = username;
                dropdownPanel.Controls.Clear(); 
                dropdownPanel.Controls.Add(new LiteralControl("<a href='Profile.aspx'>Profile</a>" +
                    $"<br /><a href='Order.aspx?customerId={customerId}&status={""}'>Order</a>" +
                    "<br /><a href='Logout.aspx'>Logout</a>"));
            }
            else
            {
                guestLabel.Text = "Guest";
                cartItemCountLabel.Text = "0";
            }
        }

        private void GetCartDetails(int customerId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT COUNT(*) FROM cartTable WHERE customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@customerId",customerId);
            int numberOfCartItem = Convert.ToInt32(cmd.ExecuteScalar().ToString());

            if(numberOfCartItem > 0)
            {
                cartItemCountLabel.Text = numberOfCartItem.ToString();
            }
            con.Close();
        }

        protected void cartBtn_Click(object sender, EventArgs e)
        {
            if(Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                int customerId = Convert.ToInt32(Session["customerId"]);
                Response.Redirect("Cart.aspx?customerId=" + customerId);
            }
        }
    }
}
