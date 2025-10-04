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
    public partial class WebForm5 : System.Web.UI.Page
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
                    LoadProductData();
                    PopulateCategories();
                }
            }
        }

        private void LoadProductData()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();

                string query = "SELECT p.productID, p.image, p.productName, p.description," +
                    " c.categoryName, p.price, p.createdDate FROM productTable p JOIN categoryTable c ON p.categoryId = c.categoryId";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                productDataGrid.DataSource = dt;
                productDataGrid.DataBind();

                con.Close();
            }
        }

        private void PopulateCategories()
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();
            string query = "SELECT categoryID, categoryName FROM categoryTable";

            SqlCommand cmd = new SqlCommand(query, con);

            SqlDataReader reader = cmd.ExecuteReader();
            category.DataSource = reader;
            category.DataTextField = "categoryName";
            category.DataValueField = "categoryId";
            category.DataBind();
        }

        protected void addBtn_Click(object sender, EventArgs e)
        {
            try
            {
                string imgUrl = string.Empty;

                string folderPath = Server.MapPath("~/ProductImage/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                if (imageFileUpload.HasFile)
                {
                    imgUrl = "~/ProductImage/" + this.imageFileUpload.FileName.ToString();

                    imageFileUpload.SaveAs(folderPath + Path.GetFileName(imageFileUpload.FileName));
                }

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "INSERT into productTable(productName, description, categoryId, price, image, createdDate) " +
                    "values (@productName, @description, @categoryId, @price, @image, @createdDate)";
                SqlCommand command = new SqlCommand(query, con);

                command.Parameters.AddWithValue("@productName", productName.Text);
                command.Parameters.AddWithValue("@description", description.Text);
                command.Parameters.AddWithValue("@categoryId", category.SelectedValue);
                command.Parameters.AddWithValue("@price", price.Text);
                command.Parameters.AddWithValue("@image", imgUrl);
                command.Parameters.AddWithValue("@createdDate", DateTime.Now);

                command.ExecuteNonQuery();

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
                con.Close();
            }
            catch (Exception ex)
            {
                errMssg.Visible = true;
                errMssg.Text = "Fail to add new product!" + ex.ToString();
            }

        }

        protected void productDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            productDataGrid.PageIndex = e.NewPageIndex;
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

        protected void deleteBtn_Click(object sender, EventArgs e)
        {
            int productId = Convert.ToInt32(hiddenProductId.Value);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "DELETE FROM productTable WHERE productId = @productId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("productId", productId);
            command.ExecuteNonQuery();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessDltMessage();", true);
            con.Close();
        }

        protected void editBtn_Click(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("AdminEditProduct.aspx?productId=" + productId);
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

            string query = "SELECT p.productID, p.image, p.productName, p.description," +
                    " c.categoryName, p.price, p.createdDate FROM productTable p JOIN categoryTable c ON p.categoryId = c.categoryId " +
                    "WHERE productName LIKE @search OR description LIKE @search OR " +
                "categoryName LIKE @search OR price LIKE @search";
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
                productDataGrid.DataSource = null;
                productDataGrid.DataBind();
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

            string query = "SELECT p.productID, p.image, p.productName, p.description, c.categoryName, p.price, p.createdDate " +
                    "FROM productTable p JOIN categoryTable c ON p.categoryId = c.categoryId";

            if (!string.IsNullOrEmpty(searchText))
            {
                query += " AND (p.productName LIKE @search OR p.description LIKE @search OR " +
                         "c.categoryName LIKE @search OR p.price LIKE @search)";
            }

            if (filterOption == "Recently Created")
            {
                query += " ORDER BY p.createdDate DESC";
            }
            else if (filterOption == "Name: A-Z")
            {
                query += " ORDER BY p.productName ASC";
            }
            else if (filterOption == "Price: Low-High")
            {
                query += " ORDER BY p.price ASC";
            }
            else if (filterOption == "Price: High-Low")
            {
                query += " ORDER BY p.price DESC";
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

                productDataGrid.DataSource = dt;
                productDataGrid.DataBind();

                con.Close();
            }
        }
    }
}