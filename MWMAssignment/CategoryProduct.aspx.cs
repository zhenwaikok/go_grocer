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
    public partial class WebForm10 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["categoryId"] != null)
                {
                    int categoryId = Convert.ToInt32(Request.QueryString["categoryId"]);
                    getCategoryProducts(categoryId);

                    string categoryName = getCategoryName(categoryId);
                    categoryTitleLabel.Text = categoryName;
                }
                else
                {
                    Response.Redirect("HomePage.aspx");
                }
            }
        }

        private void getCategoryProducts(int categoryId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT productId, productName, price, image FROM productTable WHERE categoryId = @categoryId ";
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.SelectCommand.Parameters.AddWithValue("@categoryId", categoryId);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                productListRepeater.DataSource = dt;
                productListRepeater.DataBind();
                noResultPanel.Visible = false;
            }
            else
            {
                productListRepeater.DataSource = null;
                productListRepeater.DataBind();
                noResultPanel.Visible = true;
            }
            con.Close();
        }

        private string getCategoryName(int categoryId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT categoryName FROM categoryTable WHERE categoryId = @categoryId ";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@categoryId", categoryId);
            string categoryName = command.ExecuteScalar()?.ToString();

            con.Close();

            return categoryName;
        }

        private void filterProductData(int categoryId, string searchText)
        {
            string filterOption = filterDropdown.SelectedValue;
            string query;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();

                if (filterOption == "Name: A-Z")
                {
                    query = "SELECT productId, productName, image, price " +
                            "FROM productTable WHERE categoryId = @categoryId";
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        query += " AND productName LIKE @searchText";
                    }
                    query += " ORDER BY productName ASC";
                }
                else if (filterOption == "Price: Low-High")
                {
                    query = "SELECT productId, productName, image, price " +
                            "FROM productTable WHERE categoryId = @categoryId";
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        query += " AND productName LIKE @searchText";
                    }
                    query += " ORDER BY price ASC";
                }
                else if (filterOption == "Price: High-Low")
                {
                    query = "SELECT productId, productName, image, price " +
                            "FROM productTable WHERE categoryId = @categoryId";
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        query += " AND productName LIKE @searchText";
                    }
                    query += " ORDER BY price DESC";
                }
                else
                {
                    query = "SELECT productId, productName, image, price " +
                            "FROM productTable WHERE categoryId = @categoryId";
                    if (!string.IsNullOrEmpty(searchText))
                    {
                        query += " AND productName LIKE @searchText";
                    }
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@categoryId", categoryId);

                if (!string.IsNullOrEmpty(searchText))
                {
                    cmd.Parameters.AddWithValue("@searchText", "%" + searchText + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@categoryId", categoryId);
                da.SelectCommand.Parameters.AddWithValue("@searchText", "%" + searchText + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    productListRepeater.DataSource = dt;
                    productListRepeater.DataBind();
                    noResultPanel.Visible = false;
                }
                else
                {
                    productListRepeater.DataSource = null;
                    productListRepeater.DataBind();
                    noResultPanel.Visible = true;
                }

                con.Close();
            }
        }

        protected void filterDropdown_SelectedIndexChanged(object sender, EventArgs e)
        {
            int categoryId = Convert.ToInt32(Request.QueryString["categoryId"]);
            string searchText = Session["searchText"]?.ToString();
            filterProductData(categoryId, searchText);
        }

        protected void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            string searchText = searchTextBox.Text.Trim();
            Session["SearchText"] = searchText;
            int categoryId = Convert.ToInt32(Request.QueryString["categoryId"]);

            if (!string.IsNullOrEmpty(searchText))
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "SELECT productId, productName, image, price FROM productTable WHERE productName LIKE @search";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    filterProductData(categoryId, searchText);
                    noResultPanel.Visible = false;
                }
                else
                {
                    productListRepeater.DataSource = null;
                    productListRepeater.DataBind();
                    noResultText.Text = "Opps, no result found!";
                    noResultPanel.Visible = true;
                }

                con.Close();
            }
            else
            {
                noResultPanel.Visible = false;
                filterProductData(categoryId, searchText);
            }
        }

        protected void productCardButton_Clicked(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("ProductDetails.aspx?productId=" + productId);
        }
    }
}