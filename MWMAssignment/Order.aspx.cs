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
    public partial class WebForm14 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["role"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("customer id:" + Request.QueryString["customerId"]);
                    int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
                    string status = Request.QueryString["status"].ToString();
                    LoadOrderDetails(customerId, status);
                }
            }
        }

        private void LoadOrderDetails(int customerId, string status)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT o1.itemsOrderId, o1.status, MIN(o1.createdDate) AS createdDate,SUM(o1.totalPrice) AS totalPrice,
                            STUFF((
                                SELECT ','+ o2.productImage + '|' + o2.productName + '|' + CAST(o2.productQuantity AS NVARCHAR) + '|' + CAST(o2.unitPrice AS NVARCHAR)
                                FROM orderTable o2
                                WHERE o2.itemsOrderId = o1.itemsOrderId
                                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS orderItems
                        FROM orderTable o1
                        WHERE o1.customerId = @customerId";

            if (!string.IsNullOrEmpty(status))
            {
                query += " AND status = @status";
            }

            query += " GROUP BY o1.itemsOrderId, o1.status;";

            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.SelectCommand.Parameters.AddWithValue("@customerId", customerId);

            if (!string.IsNullOrEmpty(status)) 
            { 
                da.SelectCommand.Parameters.AddWithValue("@status", status);
            }

            DataTable dt = new DataTable();
            da.Fill(dt);

            if(dt.Rows.Count > 0)
            {
                noOrderPanel.Visible = false;
                orderDetailsRepeater.DataSource = dt;
                orderDetailsRepeater.DataBind();
            }
            else
            {
                noOrderPanel.Visible = true;
                orderDetailsRepeater.DataSource = null;
                orderDetailsRepeater.DataBind();
            }

            con.Close();
        }

        protected void allBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            Response.Redirect("Order.aspx?customerId=" + customerId + "&status=" + "");
        }

        protected void toShipBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            Response.Redirect("Order.aspx?customerId=" + customerId + "&status=" + "Pending");
        }

        protected void toReceiveBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            Response.Redirect("Order.aspx?customerId=" + customerId + "&status=" + "Shipped");
        }

        protected void completedBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            Response.Redirect("Order.aspx?customerId=" + customerId + "&status=" + "Delivered");
        }

        protected void orderDetailsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater orderItemsRepeater = (Repeater)e.Item.FindControl("orderItemsRepeater");
                string orderItems = DataBinder.Eval(e.Item.DataItem, "orderItems").ToString();

                if (!string.IsNullOrEmpty(orderItems))
                {
                    string[] items = orderItems.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                    orderItemsRepeater.DataSource = items;
                    orderItemsRepeater.DataBind();
                }
            }
        }

        protected void orderItemsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string itemDetails = e.Item.DataItem.ToString();
                string[] details = itemDetails.Split('|');

                if (details.Length >= 4)
                {
                    Image productImage = (Image)e.Item.FindControl("productImage");
                    Label productName = (Label)e.Item.FindControl("productName");
                    Label productQuantity = (Label)e.Item.FindControl("productQuantity");
                    Label productPrice = (Label)e.Item.FindControl("productPrice");

                    productImage.ImageUrl = details[0];
                    productName.Text = details[1];
                    productQuantity.Text = "Quantity: " + details[2];
                    productPrice.Text = "RM " + details[3];
                }
            }
        }

        protected void orderReceivedBtn_Click(object sender, CommandEventArgs e)
        {
            string orderId = e.CommandArgument.ToString();
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE orderTable SET status = @status WHERE itemsOrderId = @itemsOrderId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@status", "Delivered");
            cmd.Parameters.AddWithValue("@itemsOrderId", orderId);

            cmd.ExecuteNonQuery();

            con.Close();


            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"showSuccessMessage({customerId});", true);

        }
    }
}