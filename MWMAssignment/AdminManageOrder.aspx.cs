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
    public partial class WebForm3 : System.Web.UI.Page
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
                    LoadOrderData();
                }
            }
        }

        private void LoadOrderData()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();

                string query = @"SELECT o1.itemsOrderId, MAX(c.username) AS username, MAX(o1.status) AS status, MAX(o1.createdDate) createdDate,
                        STUFF((
                            SELECT ',' + productImage + '|' + productName + '|' + CAST(productQuantity AS VARCHAR(10))
                            FROM orderTable o2
                            WHERE o2.itemsOrderId = o1.itemsOrderId
                            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Items,
                        SUM(o1.totalPrice) AS totalPrice
                        FROM orderTable o1
                        INNER JOIN customerTable c ON o1.customerId = c.customerId
                        GROUP BY o1.itemsOrderId;";

                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                orderDataGrid.DataSource = dt;
                orderDataGrid.DataBind();

                con.Close();
            }
        }


        protected void orderDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            orderDataGrid.PageIndex = e.NewPageIndex;
            string searchKeyword = Session["SearchText"] != null ? Session["SearchText"].ToString() : string.Empty;

            if (!string.IsNullOrEmpty(searchKeyword))
            {
                PerformSearch(searchKeyword);
            }
            else
            {
                filterOrderData(searchKeyword);
            }

        }

        protected void orderDataGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                string itemsData = DataBinder.Eval(e.Row.DataItem, "Items").ToString();
                string[] itemsArray = itemsData.Split(',');

                Repeater itemsRepeater = (Repeater)e.Row.FindControl("itemsRepeater");

                itemsRepeater.DataSource = itemsArray;
                itemsRepeater.DataBind();

                string status = DataBinder.Eval(e.Row.DataItem, "status").ToString();
                Button actionBtn = (Button)e.Row.FindControl("actionBtn");

                if (status == "Pending")
                {
                    actionBtn.Visible = true;
                    actionBtn.Text = "Order Shipped";
                }
                else
                {
                    actionBtn.Visible = false;
                }
            }
        }

        protected void itemsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string[] itemDetails = e.Item.DataItem.ToString().Split('|');
                Image productImage = (Image)e.Item.FindControl("productImage");
                Label productNameLabel = (Label)e.Item.FindControl("productNameLabel");
                Label productQuantityLabel = (Label)e.Item.FindControl("productQuantityLabel");

                productImage.ImageUrl = itemDetails[0];
                productNameLabel.Text = itemDetails[1];
                productQuantityLabel.Text = "x" + itemDetails[2];
            }
        }

        protected void filterDropdown_SelectedIndexChanged(object sender, EventArgs e)
        {
            string searchText = Session["SearchText"]?.ToString();
            filterOrderData(searchText);
        }

        private void filterOrderData(string searchText)
        {
            string filterOption = filterDropdown.SelectedValue;

            string query = @"SELECT o1.itemsOrderId, MAX(c.username) AS username, MAX(o1.status) AS status, MAX(o1.createdDate) createdDate,
                        STUFF((
                            SELECT ',' + productImage + '|' + productName + '|' + CAST(productQuantity AS VARCHAR(10))
                            FROM orderTable o2
                            WHERE o2.itemsOrderId = o1.itemsOrderId
                            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Items,
                        SUM(o1.totalPrice) AS totalPrice
                        FROM orderTable o1
                        INNER JOIN customerTable c ON o1.customerId = c.customerId";

            List<string> condition = new List<string>();

            if (filterOption == "Pending")
            {
               condition.Add("o1.status = 'Pending'");
            }
            else if (filterOption == "Shipped")
            {
                condition.Add("o1.status = 'Shipped'");
            }
            else if (filterOption == "Completed")
            {
                condition.Add("o1.status = 'Delivered'");
            }
            
            if (!string.IsNullOrEmpty(searchText))
            {
                condition.Add("(c.username LIKE @search OR o1.itemsOrderId LIKE @search)");
            }

            if(condition.Count > 0)
            {
                query += " WHERE " + string.Join(" AND ", condition);
            }


            query += " GROUP BY o1.itemsOrderId";

            if (filterOption == "Recently Created")
            {
                query += " ORDER BY MAX(o1.createdDate) DESC";
            }

            query += ";";


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

                if(dt.Rows.Count > 0)
                {
                    orderDataGrid.DataSource = dt;
                    orderDataGrid.DataBind();
                    noResultPanel.Visible = false;
                }
                else{
                    orderDataGrid.DataSource = null;
                    orderDataGrid.DataBind();
                    noResultPanel.Visible = true;
                }


                con.Close();
            }
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
                filterOrderData(searchText);
            }
        }

        private void PerformSearch(string searchText)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT o1.itemsOrderId, MAX(c.username) AS username, MAX(o1.status) AS status, MAX(o1.createdDate) createdDate,
                        STUFF((
                            SELECT ',' + productImage + '|' + productName + '|' + CAST(productQuantity AS VARCHAR(10))
                            FROM orderTable o2
                            WHERE o2.itemsOrderId = o1.itemsOrderId
                            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Items,
                        SUM(o1.totalPrice) AS totalPrice
                        FROM orderTable o1
                        INNER JOIN customerTable c ON o1.customerId = c.customerId
                        WHERE itemsOrderId LIKE @search OR username LIKE @search
                        GROUP BY o1.itemsOrderId;";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                filterOrderData(searchText);
                noResultPanel.Visible = false;
            }
            else
            {
                orderDataGrid.DataSource = null;
                orderDataGrid.DataBind();
                noResultPanel.Visible = true;
            }

            con.Close();
        }

        protected void actionBtn_Click(object sender, CommandEventArgs e)
        {
            string orderId = e.CommandArgument.ToString();
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE orderTable SET status = @status WHERE itemsOrderId = @itemsOrderId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@status", "Shipped");
            cmd.Parameters.AddWithValue("@itemsOrderId", orderId);

            cmd.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
        }
    }
}