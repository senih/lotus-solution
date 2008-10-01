Imports Microsoft.VisualBasic
Imports System.Web.Security.Membership
Public Class Search

    Public Function KeywordForProduct(ByVal root_id As Integer, ByVal sKey As String, ByVal user As String, ByVal i As String) As String
        Dim sScript As String = ""
        Dim sSQLHid As String = ""
        If user = "" Then
            'where is_hidden=0
            sSQLHid = " AND products.is_hidden=0 "
        Else
            If Not Roles.IsUserInRole(user, "Administrators") Then
                'where is_hidden=0
                sSQLHid = " AND products.is_hidden=0 "
            End If
        End If

        If i = 0 Then
            sScript += "SELECT product_id from products left join pages as pg on pg.page_id=products.page_id Where (products.title like '%" & sKey & "%' "
        Else
            sScript += "UNION SELECT product_id from products left join pages as pg on pg.page_id=products.page_id Where (products.title like '%" & sKey & "%' "
        End If
        sScript += " OR products.title like '" & sKey & "%' "
        sScript += " OR products.title like '%" & sKey & "' "
        sScript += " OR products.title like '" & sKey & "') AND pg.root_id=" & root_id & sSQLHid
        sScript += " UNION SELECT product_id FROM products left join pages as pg on pg.page_id=products.page_id WHERE (products.author like '%" & sKey & "%' "
        sScript += " OR products.author like '" & sKey & "%' "
        sScript += " OR products.author like '%" & sKey & "' "
        sScript += " OR products.author like '" & sKey & "') AND pg.root_id=" & root_id & sSQLHid
        sScript += " UNION SELECT product_id FROM products left join pages as pg on pg.page_id=products.page_id WHERE (products.long_description like '%" & sKey & "%' "
        sScript += " OR products.long_description like '" & sKey & "%' "
        sScript += " OR products.long_description like '%" & sKey & "' "
        sScript += " OR products.long_description like '" & sKey & "') AND pg.root_id=" & root_id & sSQLHid
        Return sScript
    End Function

    Public Function KeywordForSite(ByVal root_id As Integer, ByVal sKey As String, ByVal user As String, ByVal i As String) As String
        Dim sScript As String = ""
        Dim sKeywords As String = sKey
        Dim arrUserRoles() As String = Roles.GetRolesForUser()
        Dim sSQL As String = ""
        Dim sWhere As String = ""
        Dim sChannel As String = ""
        Dim item As String
        Dim oChannels As ChannelManager = New ChannelManager
        Dim oChannel As CMSChannel = New CMSChannel
        Dim nCount As Integer = 0
        Dim oCount As Integer = oChannels.GetChannelsCollection().Count
        If user = "" Then
            For Each oChannel In oChannels.GetChannelsCollection()
                If (oChannel.Permission = 1) Then
                    If (nCount = 0) Then
                        sWhere = " AND (channel_name='" & oChannel.ChannelName & " '"
                    Else
                        sWhere += " OR channel_name='" & oChannel.ChannelName & " '"
                    End If
                End If
                nCount += 1
                If (nCount = oCount) And (Not sWhere = "") Then
                    sWhere += ")"
                End If
            Next
        Else 'user sudah login
            For Each oChannel In oChannels.GetChannelsCollection()
                If (oChannel.Permission = 1) Or (oChannel.Permission = 2) Then
                    If nCount = 0 Then
                        sWhere = " AND (channel_name='" & oChannel.ChannelName & " '"
                    Else
                        sWhere += " OR channel_name='" & oChannel.ChannelName & " '"
                    End If
                End If
                nCount += 1
            Next

            If Roles.IsUserInRole(user, "Administrators") Then
                nCount = 0
                For Each oChannel In oChannels.GetChannelsCollection()
                    If (oChannel.Permission = 3) Then
                        sWhere += " OR channel_name='" & oChannel.ChannelName & " '"
                    End If
                    nCount += 1
                    If (nCount = oCount) And (Not sWhere = "") Then
                        sWhere += ")"
                    End If
                Next
            Else 'Bukan Admin
                nCount = 0
                If arrUserRoles.Length > 0 Then
                    For Each item In arrUserRoles
                        If Not (item = "Administrators") Then
                            sChannel = item.Substring(0, item.IndexOf(" ", 1))
                            oChannel = oChannels.GetChannelByName(sChannel)
                            If Not IsNothing(oChannel) Then
                                If (oChannel.Permission = 3) Then
                                    sWhere += "  OR channel_name='" & sChannel & "'"
                                End If
                            End If
                            nCount += 1
                            If (nCount = arrUserRoles.Length) And (Not sWhere = "") Then
                                sWhere += ")"
                            End If
                        End If
                    Next
                Else 'jika tidak punya role sama-sekali
                    sWhere += ")"
                End If

            End If

        End If
        If i = 0 Then
            sScript += "SELECT Top 50 page_id, version FROM Pages_published WHERE (title like '%" & sKey & "%' "
        Else
            sScript += "UNION SELECT Top 50 page_id, version FROM Pages_published WHERE (title like '%" & sKey & "%' "
        End If

        'sScript += " OR title like '" & sKey & "%' " & _
        '    " OR title like '%" & sKey & "' " & _
        '    " OR title like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " " & _
        '    " UNION SELECT page_id, version FROM Pages_published WHERE (content_body like '%" & sKey & "%' " & _
        '    " OR content_body like '" & sKey & "%' " & _
        '    " OR content_body like '%" & sKey & "' " & _
        '    " OR content_body like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " "

        'sScript += " OR title like '" & sKey & "%' " & _
        '    " OR title like '%" & sKey & "' " & _
        '    " OR title like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " " & _
        '    " UNION SELECT page_id, version FROM Pages_published WHERE (content_body like '%" & sKey & "%' " & _
        '    " OR content_body like '" & sKey & "%' " & _
        '    " OR content_body like '%" & sKey & "' " & _
        '    " OR content_body like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " "

        sScript += " OR title like '" & sKey & "%' " & _
            " OR title like '%" & sKey & "' " & _
            " OR title like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " " & _
            " UNION SELECT page_id, version FROM Pages_published WHERE (content_body like '%" & sKey & "%' " & _
            " OR content_body like '" & sKey & "%' " & _
            " OR content_body like '%" & sKey & "' " & _
            " OR content_body like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " " & _
            " UNION SELECT page_id, version FROM Pages_published WHERE (summary like '%" & sKey & "%' " & _
            " OR summary like '" & sKey & "%' " & _
            " OR summary like '%" & sKey & "' " & _
            " OR summary like '" & sKey & "') " & sWhere & " AND is_system=0 AND is_hidden=0 and display_date <= getdate() and (published_start_date <= getdate() or published_start_date is null) and (getdate() <= published_end_date or published_end_date is null) AND allow_page_indexed=1 AND root_id=" & root_id.ToString & " "
        Return sScript
    End Function


    Public Function GetSqlScript(ByVal root_id As Integer, ByVal sKeywords As String, Optional ByVal user As String = "", Optional ByVal opt As String = "product") As String
        Dim sSql As String = ""
        Dim sKeyword As String = ""
        Dim sKey As String = ""
        Dim i As Integer = 0
        Dim bDoubleQuote As Boolean = False
        If Not sKeywords = "" Then
            sKeywords = sKeywords.Replace("'", "")
            sKeywords = sKeywords.Replace("<", " ")
            sKeywords = sKeywords.Replace(">", " ")

            For Each sKey In sKeywords.Split(" ")
                If Not bDoubleQuote Then
                    If sKey.StartsWith("""") Then
                        bDoubleQuote = True ' Set awal "
                        sKey = sKey.Remove(0, 1)
                    End If
                End If

                If bDoubleQuote Then
                    If sKey.EndsWith("""") Then
                        bDoubleQuote = False
                        sKey = sKey.Replace("""", "") ' Replace "
                    End If

                    If Not sKey = "" Then
                        If sKeyword = "" Then
                            sKeyword = sKey  'isi awal keyword
                        Else
                            sKeyword += " " & sKey ' isi keyword
                        End If
                    End If
                Else
                    sKeyword = sKey
                End If

                If Not bDoubleQuote Then
                    If Not sKeyword = "" Then
                        If opt = "product" Then
                            sSql += KeywordForProduct(root_id, sKeyword, user, i)
                        Else
                            sSql += KeywordForSite(root_id, sKeyword, user, i)
                        End If
                        i = +1
                    End If
                End If
            Next
            If Not sSql = "" Then
                If opt = "product" Then
                    'sSql = "SELECT products.product_id,products.sub_title,products.image,products.title,products.short_description,products.unit_price,products.sale_price,products.discount, products.upcoming,products.is_hidden FROM products " & _
                    '       "INNER JOIN (" & sSql & " AS srch_result pages pg ON p.page_id= pg.page_id where root_id=" & root_id & ") AS srch_result ON (products.product_id=srch_result.product_id)"

                    sSql = "SELECT products.product_id,products.sub_title,products.image,products.title,products.short_description,products.unit_price,products.sale_price,products.discount, products.upcoming,products.is_hidden FROM  products " & _
                            "INNER JOIN (" & sSql & ") AS srch_result ON (products.product_id=srch_result.product_id)"
                Else
                    sSql = "SELECT title,file_name, content_body, last_updated_date FROM pages_published " & _
                           "INNER JOIN (" & sSql & ") AS srch_result ON (pages_published.page_id=srch_result.page_id AND pages_published.version=srch_result.version)"
                End If
            End If
        End If
        'MsgBox(sSql)
        Return sSql
    End Function
End Class
