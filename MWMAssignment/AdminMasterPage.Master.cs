using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MWMAssignment
{
    public partial class AdminMasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadAdminDetails();
        }


        private void LoadAdminDetails()
        {
            if (Session["username"] != null)
            {
                string adminName = Session["username"].ToString();
                adminNameLabel.Text = adminName;
                adminNameLabelSmall.Text = adminName;
            }
        }

    }
}