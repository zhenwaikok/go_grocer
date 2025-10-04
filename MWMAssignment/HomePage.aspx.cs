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
    public partial class WebForm9 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["role"] == null)
                {
                    welcomeMessage.Text = "Welcome, Guest!";
                }
                else
                {
                    welcomeMessage.Text = "Welcome, " + Session["username"].ToString() + "!";
                }
                getCategories();
                getFeaturedProducts();
                getBestToBuyProducts();
            }
        }

        private void getFeaturedProducts()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT TOP 6 productId, productName, price, image FROM productTable";
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            productListRepeater.DataSource = dt;
            productListRepeater.DataBind();

            con.Close();
        }

        private void getBestToBuyProducts()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT TOP 6 p.productId, p.productName, p.price, p.image, p.categoryId, c.categoryName FROM productTable p " +
                "JOIN categoryTable c ON p.categoryId = c.categoryId WHERE LOWER(c.categoryName) = LOWER(@categoryName)";
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.SelectCommand.Parameters.AddWithValue("@categoryName", "Snacks");
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                int snacksCategoryId = Convert.ToInt32(dt.Rows[0]["categoryId"]);
                Session["snacksCategoryId"] = snacksCategoryId;
            }

            alwaysBestToBuyRepeater.DataSource = dt;
            alwaysBestToBuyRepeater.DataBind();

            con.Close();
        }

        private void getCategories()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT categoryId, categoryName, image FROM categoryTable WHERE isActive = @isActive";
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.SelectCommand.Parameters.AddWithValue("@isActive", true);
            DataTable dt = new DataTable();
            da.Fill(dt);

            categoryList.DataSource = dt;
            categoryList.DataBind();

            con.Close();
        }

        protected void categoryLinkButton_Click(object sender, CommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("CategoryProduct.aspx?categoryId=" + categoryId);
        }

        protected void viewAllBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("CategoryProduct.aspx?categoryId=" + Session["snacksCategoryId"]);
        }

        protected void productCardButton_Click(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("ProductDetails.aspx?productId=" + productId);
        }
    }
}