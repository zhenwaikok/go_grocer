using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class WebForm7 : System.Web.UI.Page
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
                    LoadCategoryData();
                }
            }
        }

        protected void categoryDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            categoryDataGrid.PageIndex = e.NewPageIndex;
            string searchKeyword = Session["SearchText"] != null ? Session["SearchText"].ToString() : string.Empty;
            if (!string.IsNullOrEmpty(searchKeyword))
            {
                PerformSearch(searchKeyword);
            }
            else
            {
                filterProductData(searchKeyword);
            }
        }

        private void LoadCategoryData()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM categoryTable";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            categoryDataGrid.DataSource = dt;
            categoryDataGrid.DataBind();

            con.Close();
        }

        protected void editBtn_Click(object sender, CommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("AdminEditCategory.aspx?categoryId=" + categoryId);
        }

        protected void addBtn_Click(object sender, EventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "SELECT COUNT(*) FROM categoryTable WHERE categoryName = '" + categoryName.Text.ToLower() + "'";
                SqlCommand command = new SqlCommand(query, con);
                int check = Convert.ToInt32(command.ExecuteScalar().ToString());

                if (check > 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "showNameExistMessage();", true);
                }
                else
                {
                    string imgUrl = string.Empty;

                    string folderPath = Server.MapPath("~/CategoryImage/");

                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    if (imageFileUpload.HasFile)
                    {
                        imgUrl = "~/CategoryImage/" + this.imageFileUpload.FileName.ToString();

                        imageFileUpload.SaveAs(folderPath + Path.GetFileName(imageFileUpload.FileName));
                    }

                    string query2 = "INSERT into categoryTable(categoryName, image, createdDate, isActive) " +
                        "values (@categoryName, @image, @createdDate, @isActive)";
                    SqlCommand command2 = new SqlCommand(query2, con);

                    command2.Parameters.AddWithValue("@categoryName", categoryName.Text);
                    command2.Parameters.AddWithValue("@image", imgUrl);
                    command2.Parameters.AddWithValue("@createdDate", DateTime.Now);
                    command2.Parameters.AddWithValue("@isActive", true);

                    command2.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "showSuccessMessage('Successfully added new category');", true);
                }
                con.Close();
            }
            catch (Exception ex)
            {
                errMssg.Visible = true;
                errMssg.Text = "Fail to add new category!" + ex.ToString();
            }
        }

        protected void confirmBtn_Click(object sender, EventArgs e)
        {
            int categoryId = Convert.ToInt32(hiddenCategoryId.Value);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT isActive FROM categoryTable WHERE categoryId = @categoryId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@categoryId", categoryId);
            bool currentIsActive = Convert.ToBoolean(command.ExecuteScalar());

            bool newIsActive = !currentIsActive;

            string query2 = "UPDATE categoryTable SET isActive = @isActive WHERE categoryId = @categoryId";
            SqlCommand command2 = new SqlCommand(query2, con);
            command2.Parameters.AddWithValue("@isActive", newIsActive);
            command2.Parameters.AddWithValue("@categoryId", categoryId);
            command2.ExecuteNonQuery();

            con.Close();

            string message = newIsActive ? "Activated successfully!" : "Deactivated successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"showSuccessMessage('{message}');", true);
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
                filterProductData(searchText);
            }
        }

        private void PerformSearch(string searchText)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM categoryTable WHERE categoryName LIKE @search";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                filterProductData(searchText);
                noResultPanel.Visible = false;
            }
            else
            {
                categoryDataGrid.DataSource = null;
                categoryDataGrid.DataBind();
                noResultPanel.Visible = true;
            }

            con.Close();
        }

        protected void filterDropdown_SelectedIndexChanged(object sender, EventArgs e)
        {
            string searchText = Session["SearchText"]?.ToString();
            filterProductData(searchText);
        }

        private void filterProductData(string searchText)
        {
            string filterOption = filterDropdown.SelectedValue;
            string query = "SELECT * FROM categoryTable ";
            if (!string.IsNullOrEmpty(searchText))
            {
                query += " WHERE categoryName LIKE @search";
            }

            if (filterOption == "Recently Created")
            {
                query += " ORDER BY createdDate DESC";
            }
            else if (filterOption == "Name: A-Z")
            {
                query += " ORDER BY categoryName ASC";
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

                categoryDataGrid.DataSource = dt;
                categoryDataGrid.DataBind();

                con.Close();
            }
        }
    }
}