using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace project2sedlia
{
    public partial class SalesReturn : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnSearchInvoice_Click(object sender, EventArgs e)
        {
            string invIdStr = txtInvoiceID.Text.Trim();
            if (string.IsNullOrEmpty(invIdStr))
            {
                lblMsg.Text = "الرجاء إدخال رقم الفاتورة أولاً.";
                lblMsg.CssClass = "msg-error";
                return;
            }

            int invoiceId;
            if (!int.TryParse(invIdStr, out invoiceId))
            {
                lblMsg.Text = "رقم الفاتورة غير صالح.";
                lblMsg.CssClass = "msg-error";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // تم جعل اسم العمود Price ليتطابق تماماً مع واجهة GridView وتجنب أي خطأ
                string query = @"
                    SELECT id.BatchID, m.TradeName, (id.SubTotal / NULLIF(id.Qty, 0)) AS Price, id.Qty 
                    FROM InvoiceDetails id
                    INNER JOIN Batches b ON id.BatchID = b.BatchID
                    INNER JOIN Medicines m ON b.MedicineID = m.MedicineID
                    WHERE id.InvoiceID = @InvoiceID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvReturnItems.DataSource = dt;
                            gvReturnItems.DataBind();
                            btnConfirmReturn.Visible = true;
                            lblMsg.Text = "";
                        }
                        else
                        {
                            gvReturnItems.DataSource = null;
                            gvReturnItems.DataBind();
                            btnConfirmReturn.Visible = false;
                            lblMsg.Text = "لم يتم العثور على تفاصيل لهذه الفاتورة أو أن رقم الفاتورة خاطئ.";
                            lblMsg.CssClass = "msg-error";
                        }
                    }
                }
            }
        }

        protected void btnConfirmReturn_Click(object sender, EventArgs e)
        {
            int invoiceId = Convert.ToInt32(txtInvoiceID.Text.Trim());
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    decimal totalRefund = 0;
                    bool hasItemsToReturn = false;

                    foreach (GridViewRow row in gvReturnItems.Rows)
                    {
                        TextBox txtQty = (TextBox)row.FindControl("txtReturnQty");
                        int returnQty = 0;
                        if (int.TryParse(txtQty.Text.Trim(), out returnQty) && returnQty > 0)
                        {
                            hasItemsToReturn = true;
                            break;
                        }
                    }

                    if (!hasItemsToReturn)
                    {
                        lblMsg.Text = "الرجاء إدخال كمية صحيحة واحدة على الأقل للإرجاع.";
                        lblMsg.CssClass = "msg-error";
                        transaction.Rollback();
                        return;
                    }

                    string insertReturnQuery = "INSERT INTO SalesReturns (InvoiceID, UserID, ReturnDate, TotalRefund) OUTPUT INSERTED.ReturnID VALUES (@InvoiceID, @UserID, GETDATE(), 0)";
                    SqlCommand cmdReturn = new SqlCommand(insertReturnQuery, conn, transaction);
                    cmdReturn.Parameters.AddWithValue("@InvoiceID", invoiceId);
                    cmdReturn.Parameters.AddWithValue("@UserID", userId);
                    int returnId = (int)cmdReturn.ExecuteScalar();

                    foreach (GridViewRow row in gvReturnItems.Rows)
                    {
                        TextBox txtQty = (TextBox)row.FindControl("txtReturnQty");
                        HiddenField hfBatchID = (HiddenField)row.FindControl("hfBatchID");

                        int returnQty = 0;
                        if (int.TryParse(txtQty.Text.Trim(), out returnQty) && returnQty > 0)
                        {
                            int batchId = Convert.ToInt32(hfBatchID.Value);

                            string checkDetailQuery = "SELECT Qty, SubTotal FROM InvoiceDetails WHERE InvoiceID = @InvoiceID AND BatchID = @BatchID";
                            SqlCommand cmdCheck = new SqlCommand(checkDetailQuery, conn, transaction);
                            cmdCheck.Parameters.AddWithValue("@InvoiceID", invoiceId);
                            cmdCheck.Parameters.AddWithValue("@BatchID", batchId);

                            using (SqlDataReader reader = cmdCheck.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    int originalSoldQty = Convert.ToInt32(reader["Qty"]);
                                    decimal originalSubTotal = Convert.ToDecimal(reader["SubTotal"]);

                                    if (returnQty > originalSoldQty)
                                    {
                                        reader.Close();
                                        transaction.Rollback();
                                        lblMsg.Text = $"خطأ: لا يمكنك إرجاع كمية ({returnQty}) أكبر من الكمية المباعة أصلاً ({originalSoldQty})!";
                                        lblMsg.CssClass = "msg-error";
                                        return;
                                    }

                                    decimal actualUnitPrice = originalSoldQty > 0 ? (originalSubTotal / originalSoldQty) : 0;
                                    decimal subTotal = actualUnitPrice * returnQty;
                                    totalRefund += subTotal;

                                    reader.Close();

                                    string insertDetailQuery = "INSERT INTO ReturnDetails (ReturnID, BatchID, Qty, SubTotal) VALUES (@ReturnID, @BatchID, @Qty, @SubTotal)";
                                    SqlCommand cmdDetail = new SqlCommand(insertDetailQuery, conn, transaction);
                                    cmdDetail.Parameters.AddWithValue("@ReturnID", returnId);
                                    cmdDetail.Parameters.AddWithValue("@BatchID", batchId);
                                    cmdDetail.Parameters.AddWithValue("@Qty", returnQty);
                                    cmdDetail.Parameters.AddWithValue("@SubTotal", subTotal);
                                    cmdDetail.ExecuteNonQuery();
                                }
                                else
                                {
                                    reader.Close();
                                }
                            }

                            string updateStockQuery = "UPDATE Batches SET Quantity = Quantity + @Qty WHERE BatchID = @BatchID";
                            SqlCommand cmdStock = new SqlCommand(updateStockQuery, conn, transaction);
                            cmdStock.Parameters.AddWithValue("@Qty", returnQty);
                            cmdStock.Parameters.AddWithValue("@BatchID", batchId);
                            cmdStock.ExecuteNonQuery();
                        }
                    }

                    string updateRefundQuery = "UPDATE SalesReturns SET TotalRefund = @TotalRefund WHERE ReturnID = @ReturnID";
                    SqlCommand cmdUpdRefund = new SqlCommand(updateRefundQuery, conn, transaction);
                    cmdUpdRefund.Parameters.AddWithValue("@TotalRefund", totalRefund);
                    cmdUpdRefund.Parameters.AddWithValue("@ReturnID", returnId);
                    cmdUpdRefund.ExecuteNonQuery();

                    transaction.Commit();
                    lblMsg.Text = $"تم إتمام عملية المرتجع بنجاح! وإعادة المبلغ للزبون بقيمة: {totalRefund:0.00} ريال وإرجاع الكميات للمخزن.";
                    lblMsg.CssClass = "msg-success";
                    btnConfirmReturn.Visible = false;
                    gvReturnItems.DataSource = null;
                    gvReturnItems.DataBind();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMsg.Text = "حدث خطأ أثناء تنفيذ المرتجع: " + ex.Message;
                    lblMsg.CssClass = "msg-error";
                }
            }
        }
    }
}