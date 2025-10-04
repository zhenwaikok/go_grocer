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
    public partial class WebForm17 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                int productId = Convert.ToInt32(Request.QueryString["productId"]);
                LoadProductReviewDetails(productId);
            }
        }

        private void LoadProductReviewDetails(int productId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT pr.reviewId, pr.reviewMssg, pr.createdDate, c.username, p.image, p.productName
                            FROM productReviewTable pr
                            INNER JOIN customerTable c ON pr.customerId = c.customerId
                            INNER JOIN productTable p ON pr.productId = p.productId
                            WHERE pr.productId = @productId";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@productId", productId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                productNameLabel.Text = dt.Rows[0]["productName"].ToString();

                string imagePath = dt.Rows[0]["image"].ToString();
                productImage.ImageUrl = ResolveUrl(imagePath);
            }

            productReviewDataGrid.DataSource = dt;
            productReviewDataGrid.DataBind();

            con.Close();
        }

        protected void productReviewDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            productReviewDataGrid.PageIndex = e.NewPageIndex;
            int productId = Convert.ToInt32(Request.QueryString["productId"]);
            LoadProductReviewDetails(productId);
        }
    }
}