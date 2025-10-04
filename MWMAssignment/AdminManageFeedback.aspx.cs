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
    public partial class WebForm16 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                LoadProductReview("");
            }
        }

        private void LoadProductReview(string searchText)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT pr.productId, p.productName, p.image, COUNT(*) AS numOfReviews
                            FROM productReviewTable pr
                            INNER JOIN productTable p ON pr.productId = p.productId";

            if (!string.IsNullOrEmpty(searchText))
            {
                query += " WHERE p.productName LIKE @search";
            }

            query += " GROUP BY pr.productId, p.productName, p.image";

            SqlCommand cmd = new SqlCommand(query, con);

            if (!string.IsNullOrEmpty(searchText))
            {
                cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
            }

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            productReviewDataGrid.DataSource = dt;
            productReviewDataGrid.DataBind();

            productReviewDataGrid.Visible = dt.Rows.Count > 0;
            websiteFeedbackDataGrid.Visible = false;
            noResultPanel.Visible = dt.Rows.Count == 0;

            con.Close();
        }

        private void LoadWebsiteFeedback(string searchText)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT f.feedbackId, f.feedbackType, f.feedbackMessage, 
                         CASE WHEN f.isGuest = 1 THEN 'Guest' ELSE c.username END AS username, 
                         f.createdDate
                  FROM feedbackTable f
                  LEFT JOIN customerTable c ON f.customerId = c.customerId";

            if (!string.IsNullOrEmpty(searchText))
            {
                query += " WHERE((" +
                    "f.isGuest = 1 AND 'Guest' LIKE @search) OR " +
                    "(f.isGuest = 0 AND c.username LIKE @search) OR " +
                    "f.feedbackType LIKE @search )";
            }

            SqlCommand cmd = new SqlCommand(query, con);
            if (!string.IsNullOrEmpty(searchText))
            {
                cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
            }

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            websiteFeedbackDataGrid.DataSource = dt;
            websiteFeedbackDataGrid.DataBind();

            websiteFeedbackDataGrid.Visible = dt.Rows.Count > 0;
            productReviewDataGrid.Visible = false;
            noResultPanel.Visible = dt.Rows.Count == 0;

            con.Close();
        }

        protected void productReviewDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            productReviewDataGrid.PageIndex = e.NewPageIndex;
            string searchKeyword = Session["SearchText"] != null ? Session["SearchText"].ToString() : string.Empty;
            bool isProductReview = filterDropdown.SelectedValue == "Product";

            if (!string.IsNullOrEmpty(searchKeyword))
            {
                PerformSearch(searchKeyword, isProductReview);
            }
            else
            {
                filterFeedbackData(searchKeyword,isProductReview);
            }
        }

        protected void websiteFeedbackDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            productReviewDataGrid.PageIndex = e.NewPageIndex;
            string searchKeyword = Session["SearchText"] != null ? Session["SearchText"].ToString() : string.Empty;
            bool isProductReview = filterDropdown.SelectedValue == "Product";

            if (!string.IsNullOrEmpty(searchKeyword))
            {
                PerformSearch(searchKeyword, isProductReview);
            }
            else
            {
                filterFeedbackData(searchKeyword, isProductReview);
            }
        }

        protected void filterDropdown_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool isProductReview = filterDropdown.SelectedValue == "Product";
            string searchText = Session["SearchText"]?.ToString() ?? "";

            filterFeedbackData(searchText, isProductReview);
        }

        private void filterFeedbackData(string searchText,bool isProductReview)
        {
            if (isProductReview)
            {
                LoadProductReview(searchText);
            }
            else
            {
                LoadWebsiteFeedback(searchText);
            }
        }

        protected void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            string searchText = searchTextBox.Text.Trim();
            Session["SearchText"] = searchText;
            bool isProductReview = filterDropdown.SelectedValue == "Product";

            if (!string.IsNullOrEmpty(searchText))
            {
                PerformSearch(searchText, isProductReview);
            }
            else
            {
                noResultPanel.Visible = false;
                filterFeedbackData(searchText,isProductReview);
            }
        }

        private void PerformSearch(string searchText, bool isProductReview)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query;


            if(!isProductReview)
            {
               query = @"SELECT f.feedbackId, f.feedbackType, f.feedbackMessage, 
                         CASE WHEN f.isGuest = 1 THEN 'Guest' ELSE c.username END AS username, 
                         f.createdDate
                  FROM feedbackTable f
                  LEFT JOIN customerTable c ON f.customerId = c.customerId
                  WHERE (f.isGuest = 1 AND 'Guest' LIKE @search) 
                         OR (c.username LIKE @search) 
                         OR (f.feedbackType LIKE @search)";
            }
            else
            {
                query = @"SELECT pr.productId, p.productName, p.image, COUNT(*) AS numOfReviews
                        FROM productReviewTable pr
                        INNER JOIN productTable p ON pr.productId = p.productId
                        WHERE productName LIKE @search
                        GROUP BY pr.productId, p.productName, p.image;";
            }

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                noResultPanel.Visible = false;
                if (isProductReview)
                {
                    productReviewDataGrid.DataSource = dt;
                    productReviewDataGrid.DataBind();
                    productReviewDataGrid.Visible = true;
                    websiteFeedbackDataGrid.Visible = false;
                }
                else
                {
                    websiteFeedbackDataGrid.DataSource = dt;
                    websiteFeedbackDataGrid.DataBind();
                    websiteFeedbackDataGrid.Visible = true;
                    productReviewDataGrid.Visible = false;
                }
            }
            else
            {
                productReviewDataGrid.Visible = false;
                websiteFeedbackDataGrid.Visible = false;
                noResultPanel.Visible = true;
            }

            con.Close();
        }

        protected void viewIconBtn_Click(object sender, CommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("AdminProductReviewDetails.aspx?productId=" + productId);
        }
    }
}