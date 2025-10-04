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
    public partial class WebForm8 : System.Web.UI.Page
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
                    if (Request.QueryString["categoryId"] != null)
                    {
                        int categoryId = Convert.ToInt32(Request.QueryString["categoryId"]);
                        LoadCategoryDetails(categoryId);
                    }
                }
            }
        }

        private void LoadCategoryDetails(int categoryId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "SELECT * FROM categoryTable WHERE categoryId = @categoryId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@categoryId", categoryId);

            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                categoryName.Text = reader["categoryName"].ToString();

                Session["imageURL"] = reader["image"].ToString();
                imagePreview.ImageUrl = Session["imageURL"].ToString();
                imagePreview.Visible = true; ;
            }
            reader.Close();
            con.Close();

        }

        protected void saveBtn_Click(object sender, EventArgs e)
        {
            string imgURL;
            string folderPath = Server.MapPath("~/CategoryImage/");
            if (imageFileUpload.HasFile)
            {
                imgURL = "~/CategoryImage/" + this.imageFileUpload.FileName.ToString();

                imageFileUpload.SaveAs(folderPath + Path.GetFileName(imageFileUpload.FileName));
            }
            else
            {
                imgURL = Session["imageURL"].ToString();
            }

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "UPDATE categoryTable SET categoryName = @categoryName, image = @image WHERE categoryId = @categoryId";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@categoryName", categoryName.Text);
            command.Parameters.AddWithValue("@image", imgURL);
            command.Parameters.AddWithValue("@categoryId", Request.QueryString["categoryId"]);
            command.ExecuteNonQuery();

            con.Close();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "showSuccessMessage();", true);
        }

        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminManageCategory.aspx");
        }
    }
}