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
    public partial class WebForm4 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                if (!IsPostBack)
                {
                    LoadUsersData();
                }
            }
        }

        private void LoadUsersData()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM customerTable";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            userDataGrid.DataSource = dt;
            userDataGrid.DataBind();

            con.Close();
        }

        protected void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            string searchText = searchTextBox.Text.Trim();
            Session["SearchText"] = searchText;

            if (!string.IsNullOrEmpty(searchText))
            {
                PerformSearch(searchText);
            }
            else
            {
                noResultPanel.Visible = false;
                filterUserData(searchText);
            }
        }
        private void PerformSearch(string searchText)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM customerTable WHERE username LIKE @search OR email LIKE @search OR phoneNum LIKE @search OR address LIKE @search OR gender LIKE @search";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                filterUserData(searchText);
                noResultPanel.Visible = false;
            }
            else
            {
                userDataGrid.DataSource = null;
                userDataGrid.DataBind();
                noResultPanel.Visible = true;
            }

            con.Close();
        }

        protected void filterDropdown_SelectedIndexChanged(object sender, EventArgs e)
        {
            string searchText = Session["SearchText"]?.ToString();
            filterUserData(searchText);
        }

        private void filterUserData(string searchText)
        {
            string filterOption = filterDropdown.SelectedValue;
            string query = "SELECT * FROM customerTable";
            if (!string.IsNullOrEmpty(searchText))
            {
                query += " WHERE (username LIKE @search OR email LIKE @search OR phoneNum LIKE @search OR address LIKE @search OR gender LIKE @search)";

            }

            if (filterOption == "Recently Created")
            {
                query += " ORDER BY createdDate DESC";
            }
            else if (filterOption == "Name: A-Z")
            {
                query += " ORDER BY username ASC";
            }
            else
            {
                query += "";
            }

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                if (!string.IsNullOrEmpty(searchText))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchText + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);

                userDataGrid.DataSource = dt;
                userDataGrid.DataBind();

                con.Close();
            }
        }

        protected void userDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            userDataGrid.PageIndex = e.NewPageIndex;
            string searchKeyword = Session["SearchText"] != null ? Session["SearchText"].ToString() : string.Empty;

            if (!string.IsNullOrEmpty(searchKeyword))
            {
                PerformSearch(searchKeyword);
            }
            else { 
                filterUserData(searchKeyword);
            }
        }

        protected void deleteBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(hiddenCustomerId.Value);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "DELETE FROM customerTable WHERE customerId = @customerId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("customerId", customerId);
            command.ExecuteNonQuery();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessDltMessage();", true);
            con.Close();
        }

        protected void editIconBtn_Click(object sender, CommandEventArgs e)
        {
            int customerId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("AdminEditUser.aspx?customerId=" + customerId);
        }
    }
}