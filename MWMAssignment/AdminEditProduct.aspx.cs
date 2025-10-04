using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class WebForm6 : System.Web.UI.Page
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
                    if (Request.QueryString["productId"] != null)
                    {
                        int productId = Convert.ToInt32(Request.QueryString["productId"]);
                        LoadProductDetails(productId);
                        PopulateCategories();
                    }
                }
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

        private void LoadProductDetails(int productId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT p.productID, p.image, p.productName, p.description," +
                        " c.categoryId, p.price, p.createdDate FROM productTable p " +
                        "JOIN categoryTable c ON p.categoryId = c.categoryId WHERE productId = @productId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("productId", productId);

            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                productName.Text = reader["productName"].ToString();
                description.Text = reader["description"].ToString();
                category.SelectedValue = reader["categoryId"].ToString();
                price.Text = reader["price"].ToString();

                Session["imageURL"] = reader["image"].ToString();
                imagePreview.ImageUrl = Session["imageURL"].ToString();
                imagePreview.Visible = true; ;
            }   
            reader.Close();
            con.Close();

        }

        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminManageProduct.aspx");
        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string imgURL;
            string folderPath = Server.MapPath("~/ProductImage/");
            if (imageFileUpload.HasFile)
            {
                imgURL = "~/ProductImage/" + this.imageFileUpload.FileName.ToString();

                imageFileUpload.SaveAs(folderPath + Path.GetFileName(imageFileUpload.FileName));
            }
            else
            {
                imgURL = Session["imageURL"].ToString();
            }

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE productTable SET productName = @productName, description = @description, categoryId = @categoryId, " +
                "price = @price, image = @image WHERE productId = @productId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@productName", productName.Text);
            command.Parameters.AddWithValue("@description", description.Text);
            command.Parameters.AddWithValue("@categoryId", category.SelectedValue);
            command.Parameters.AddWithValue("@price", price.Text);
            command.Parameters.AddWithValue("@image", imgURL);
            command.Parameters.AddWithValue("@productId", Request.QueryString["productId"]);
            command.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
        }
    }
}