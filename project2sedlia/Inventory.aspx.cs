using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace project2sedlia
{
    public partial class Inventory : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                ViewState["CurrentFilter"] = "ALL";
                LoadInventoryData("", "ALL");
            }
        }

        private void LoadInventoryData(string searchTerm, string filterType)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT b.BatchID, m.Barcode, m.TradeName, c.CategoryName, b.Quantity, b.SellPrice, b.ExpiryDate
                    FROM Medicines m
                    INNER JOIN Batches b ON m.MedicineID = b.MedicineID
                    INNER JOIN Categories c ON m.CategoryID = c.CategoryID
                    WHERE (m.TradeName LIKE @SearchTerm OR m.Barcode LIKE @SearchTerm) ";

                if (filterType == "EXPIRED")
                {
                    query += " AND b.ExpiryDate < GETDATE() ";
                }
                else if (filterType == "LOW_STOCK")
                {
                    query += " AND b.Quantity <= 5 ";
                }

                query += " ORDER BY b.ExpiryDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm.Trim() + "%");

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvInventory.DataSource = dt;
                        gvInventory.DataBind();
                    }
                }
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string filter = ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL";
            LoadInventoryData(txtSearch.Text, filter);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadInventoryData(txtSearch.Text, ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ViewState["CurrentFilter"] = "ALL";
            lblStatusMsg.Text = "تم عرض كامل المخزون.";
            lblStatusMsg.ForeColor = System.Drawing.Color.FromArgb(71, 85, 105);
            LoadInventoryData("", "ALL");
        }

        protected void btnFilterExpired_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ViewState["CurrentFilter"] = "EXPIRED";
            lblStatusMsg.Text = "تمت تصفية الجدول لعرض الأدوية المنتهية الصلاحية فقط للتخلص منها.";
            lblStatusMsg.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
            LoadInventoryData("", "EXPIRED");
        }

        protected void btnFilterLowStock_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ViewState["CurrentFilter"] = "LOW_STOCK";
            lblStatusMsg.Text = "تمت تصفية الجدول لعرض نواقص المخزون فقط.";
            lblStatusMsg.ForeColor = System.Drawing.Color.FromArgb(245, 158, 11);
            LoadInventoryData("", "LOW_STOCK");
        }

        protected void gvInventory_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvInventory.EditIndex = e.NewEditIndex;
            string filter = ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL";
            LoadInventoryData(txtSearch.Text, filter);
        }

        protected void gvInventory_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvInventory.EditIndex = -1;
            string filter = ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL";
            LoadInventoryData(txtSearch.Text, filter);
        }

        protected void gvInventory_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int batchId = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvInventory.Rows[e.RowIndex];
            TextBox txtQty = (TextBox)row.Cells[3].Controls[0];
            TextBox txtPrice = (TextBox)row.Cells[4].Controls[0];

            int newQty = Convert.ToInt32(txtQty.Text);
            decimal newPrice = Convert.ToDecimal(txtPrice.Text);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string updateQuery = "UPDATE Batches SET Quantity = @Qty, SellPrice = @Price WHERE BatchID = @BatchID";
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Qty", newQty);
                    cmd.Parameters.AddWithValue("@Price", newPrice);
                    cmd.Parameters.AddWithValue("@BatchID", batchId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvInventory.EditIndex = -1;
            string filter = ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL";
            LoadInventoryData(txtSearch.Text, filter);
        }

        protected void gvInventory_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int batchId = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string updateQuery = "UPDATE Batches SET Quantity = 0 WHERE BatchID = @BatchID";
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@BatchID", batchId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblStatusMsg.Text = "تم إبعاد الصنف المنتهي وتصفير كميته في المخزن بنجاح دون التأثير على الفواتير السابقة.";
            lblStatusMsg.ForeColor = System.Drawing.Color.FromArgb(16, 185, 129);

            string filter = ViewState["CurrentFilter"] != null ? ViewState["CurrentFilter"].ToString() : "ALL";
            LoadInventoryData(txtSearch.Text, filter);
        }

        protected void gvInventory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if ((e.Row.RowState & DataControlRowState.Edit) > 0)
                    return;

                try
                {
                    int qty = Convert.ToInt32(e.Row.Cells[3].Text);
                    string expiryDateStr = e.Row.Cells[5].Text;
                    DateTime expiryDate = Convert.ToDateTime(expiryDateStr);

                    if (expiryDate <= DateTime.Now.AddDays(90))
                    {
                        e.Row.BackColor = System.Drawing.Color.FromArgb(254, 226, 226);
                    }
                    else if (qty <= 5)
                    {
                        e.Row.BackColor = System.Drawing.Color.FromArgb(254, 243, 199);
                    }
                }
                catch
                {
                }
            }
        }
    }
}