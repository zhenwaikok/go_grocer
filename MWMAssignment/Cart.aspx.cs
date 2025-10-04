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
    public partial class WebForm13 : System.Web.UI.Page
    {
        protected decimal totalItemsPrice = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["role"] != null)
                {
                    int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
                    LoadCartItems(customerId);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadCartItems(int customerId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT c.productId, c.quantity, p.productName, p.image, p.price
                            FROM cartTable c    
                            INNER JOIN productTable p ON c.productId = p.productId
                            WHERE customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@customerId",customerId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            int numOfItems = dt.Rows.Count;
            numOfItemsLabel.Text = numOfItems + " Item(s)";

            if(numOfItems > 0)
            {
                cartPanel.Visible = true;
                emptyCartPanel.Visible = false;
                cartItemsRepeater.DataSource = dt;
                cartItemsRepeater.DataBind();

                subTotalLAbel.Text = "RM " + totalItemsPrice.ToString();
                totalLabel.Text = "RM " + totalItemsPrice.ToString();
            }
            else
            {
                cartPanel.Visible = false;
                emptyCartPanel.Visible = true;
            }

            con.Close();
        }

        protected void deleteBtn_Click(object sender, EventArgs e)
        {
            LinkButton deleteBtn = (LinkButton)sender;
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            int productId = Convert.ToInt32(deleteBtn.CommandArgument);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "DELETE FROM cartTable WHERE customerId = @customerId AND productId = @productId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@customerId",customerId);
            cmd.Parameters.AddWithValue("@productId", productId);

            cmd.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"showSuccessMessage({customerId});", true);
        }

        protected void minusBtn_Click(object sender, EventArgs e)
        {
            Button minusBtn = (Button)sender;
            int productId = Convert.ToInt32(minusBtn.CommandArgument);
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT quantity FROM cartTable WHERE productId = @productId AND customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@productId", productId);
            cmd.Parameters.AddWithValue("@customerId", customerId);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                int existingQuantity = Convert.ToInt32(reader["quantity"]);
                reader.Close();

                if (existingQuantity > 1)
                {
                    int newQuantity = existingQuantity - 1;

                    if(newQuantity < 1)
                    {
                        newQuantity = 1;
                    }

                    string query2 = @"UPDATE cartTable SET quantity = @quantity 
                                    WHERE productId = @productId AND customerId = @customerId";
                    SqlCommand cmd2 = new SqlCommand(query2, con);
                    cmd2.Parameters.AddWithValue("@quantity", newQuantity);
                    cmd2.Parameters.AddWithValue("@productId", productId);
                    cmd2.Parameters.AddWithValue("@customerId", customerId);
                    cmd2.ExecuteNonQuery();

                    con.Close();

                    Response.Redirect("Cart.aspx?customerId=" + customerId);
                }
            }

        }

        protected void plusBtn_Click(object sender, EventArgs e)
        {
            Button plusBtn = (Button)sender;
            int productId = Convert.ToInt32(plusBtn.CommandArgument);
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT quantity FROM cartTable WHERE productId = @productId AND customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@productId", productId);
            cmd.Parameters.AddWithValue("@customerId", customerId);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                int existingQuantity = Convert.ToInt32(reader["quantity"]);
                reader.Close();

                if (existingQuantity > 0)
                {
                    int newQuantity = existingQuantity + 1;

                    string query2 = @"UPDATE cartTable SET quantity = @quantity 
                                    WHERE productId = @productId AND customerId = @customerId";
                    SqlCommand cmd2 = new SqlCommand(query2, con);
                    cmd2.Parameters.AddWithValue("@quantity", newQuantity);
                    cmd2.Parameters.AddWithValue("@productId", productId);
                    cmd2.Parameters.AddWithValue("@customerId", customerId);
                    cmd2.ExecuteNonQuery();

                    con.Close();

                    Response.Redirect("Cart.aspx?customerId=" + customerId);
                }
            }

        }

        protected void cartItemsRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int quantity = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "quantity"));
                decimal unitPrice = Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "price"));

                decimal totalPrice = quantity * unitPrice;

                totalItemsPrice += totalPrice;

                Label totalPriceLabel = (Label)e.Item.FindControl("totalPrice");
                totalPriceLabel.Text = "RM " + totalPrice.ToString("F2");
            }
        }

        protected void proceedBtn_Click(object sender, EventArgs e)
        {
            int customerId = Convert.ToInt32(Request.QueryString["customerId"]);
            string itemsOrderId = generateOrderId();


            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = @"SELECT c.productId, c.quantity, p.productName, p.image, p.price
                            FROM cartTable c    
                            INNER JOIN productTable p ON c.productId = p.productId
                            WHERE customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@customerId", customerId);

            SqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(reader);
            reader.Close();

            foreach (DataRow row in dt.Rows)
            {
                int productId = Convert.ToInt32(row["productId"]);
                string productImage = row["image"].ToString();
                string productName = row["productName"].ToString();
                int productQuantity = Convert.ToInt32(row["quantity"]);
                decimal unitPrice = Convert.ToDecimal(row["price"]);
                string status = "Pending";

                string query2 = "INSERT INTO orderTable (itemsOrderId, customerId, productId, productImage, productName," +
                    "productQuantity, unitPrice, totalPrice, status, createdDate) " +
                    "VALUES (@itemsOrderId, @customerId, @productId, @productImage, @productName," +
                    "@productQuantity, @unitPrice, @totalPrice, @status, @createdDate)";

                SqlCommand cmd2 = new SqlCommand(query2, con);
                cmd2.Parameters.AddWithValue("@itemsOrderId", itemsOrderId);
                cmd2.Parameters.AddWithValue("@customerId", customerId);
                cmd2.Parameters.AddWithValue("@productId", productId);
                cmd2.Parameters.AddWithValue("@productImage", productImage);
                cmd2.Parameters.AddWithValue("@productName", productName);
                cmd2.Parameters.AddWithValue("@productQuantity", productQuantity);
                cmd2.Parameters.AddWithValue("@unitPrice", unitPrice);
                cmd2.Parameters.AddWithValue("@totalPrice", unitPrice * productQuantity);
                cmd2.Parameters.AddWithValue("@status", status);
                cmd2.Parameters.AddWithValue("@createdDate", DateTime.Now);

                cmd2.ExecuteNonQuery();
            }
            con.Close();
            clearCartItems(customerId);
            ClientScript.RegisterStartupScript(this.GetType(), "Pop", "openSuccessModal();", true);
        }

        private string generateOrderId()
        {
            string dateTime = DateTime.Now.ToString("yyyyMMddTHHmmssfff");
            string randomNum = new Random().Next(10000, 99999).ToString();

            return $"{dateTime}{randomNum}";
        }

        private void clearCartItems(int customerId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "DELETE FROM cartTable WHERE customerId = @customerId";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@customerId", customerId);

            cmd.ExecuteNonQuery();

            con.Close();
        }

    }
}