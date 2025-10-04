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
    public partial class WebForm11 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["productId"] != null)
                {
                    int productId = Convert.ToInt32(Request.QueryString["productId"]);
                    LoadProductDetails(productId);
                    LoadProductReviews(productId);
                }
                else
                {
                    Response.Redirect("HomePage.aspx");
                }
            }
        }

        private void LoadProductDetails(int productId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM productTable WHERE productId = @productId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@productId", productId);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                productNameLabel.Text = reader["productName"].ToString();
                productPriceLabel.Text = "RM " + reader["price"].ToString();
                productDescriptionMessage.Text = reader["description"].ToString();
                productImage.ImageUrl = reader["image"].ToString();
                quantity.Text = "1";
            }

            con.Close();
        }

        private void LoadProductReviews(int productId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT p.reviewMssg, c.username
                            FROM productReviewTable p    
                            INNER JOIN customerTable c ON p.customerId = c.customerId
                            WHERE productId = @productId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@productId", productId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            int numOfItems = dt.Rows.Count;

            if (numOfItems > 0)
            {
                noReviewsLabel.Visible = false;
                reviewDetailsRepeater.DataSource = dt;
                reviewDetailsRepeater.DataBind();
            }
            else
            {
                noReviewsLabel.Visible = true;
                reviewDetailsRepeater.DataSource = null;
                reviewDetailsRepeater.DataBind();
            }

            con.Close();
        }

        protected void cartBtn_Click(object sender, EventArgs e)
        {
            if (Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string productId = Request.QueryString["productId"];

                if (Convert.ToInt32(quantity.Text) > 0)
                {
                    string query = "SELECT quantity FROM cartTable WHERE productId = @productId AND customerId = @customerId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@productId", productId);
                    cmd.Parameters.AddWithValue("@customerId", Session["customerId"]);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        int existingQuantity = Convert.ToInt32(reader["quantity"]);
                        reader.Close(); 

                        int newQuantity = existingQuantity + Convert.ToInt32(quantity.Text);

                        string queryUpdate = "UPDATE cartTable SET quantity = @newQuantity WHERE productId = @productId AND customerId = @customerId";
                        SqlCommand cmdUpdate = new SqlCommand(queryUpdate, con);
                        cmdUpdate.Parameters.AddWithValue("@newQuantity", newQuantity);
                        cmdUpdate.Parameters.AddWithValue("@productId", productId);
                        cmdUpdate.Parameters.AddWithValue("@customerId", Session["customerId"]);

                        cmdUpdate.ExecuteNonQuery();
                    }
                    else
                    {
                        reader.Close(); 

                        string query2 = "INSERT INTO cartTable(productId, quantity, customerId) " +
                                             "VALUES (@productId, @quantity, @customerId)";
                        SqlCommand cmd2 = new SqlCommand(query2, con);
                        cmd2.Parameters.AddWithValue("@productId", productId);
                        cmd2.Parameters.AddWithValue("@quantity", quantity.Text);
                        cmd2.Parameters.AddWithValue("@customerId", Session["customerId"]);

                        cmd2.ExecuteNonQuery();
                    }

                    ClientScript.RegisterStartupScript(this.GetType(), "Pop", $"openSuccessModal({productId});", true);
                }
                else
                {
                    quantity.Text = "1";
                }

                con.Close();
            }
        }

        protected void submitBtn_Click(object sender, EventArgs e)
        {
            if(Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                int customerId = Convert.ToInt32(Session["customerId"]);
                int productId = Convert.ToInt32(Request.QueryString["productId"]);

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                string query = "INSERT INTO productReviewTable (customerId, productId, reviewMssg, createdDate) " +
                                "VALUES (@customerId, @productId, @reviewMssg, @createdDate)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@customerId",customerId);
                cmd.Parameters.AddWithValue("@productId", productId);
                cmd.Parameters.AddWithValue("@reviewMssg", reviewTextBox.Text.Trim());
                cmd.Parameters.AddWithValue("@createdDate", DateTime.Now);

                cmd.ExecuteNonQuery();
                con.Close();

                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"showSuccessMessage({productId});", true);
            }
        }

        protected void quantity_TextChanged(object sender, EventArgs e)
        {
            if(Convert.ToInt32(quantity.Text) < 1)
            {
                quantity.Text = "1";
            }
        }
    }
}