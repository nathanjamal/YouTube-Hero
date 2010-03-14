﻿Imports System.Data
Imports System.Xml
Imports System.Net
Imports System.Net.Sockets
Imports System.Net.Mail
Imports System.IO


Partial Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim ipAddy = Dns.GetHostEntry(Dns.GetHostName).AddressList(0).ToString
        Dim fileName As String = Replace(ipAddy, ":", "")
        fileName = Replace(fileName, "%", "")

        HiddenField1.Value = fileName


        ' ' For debugging youtube data api
        ' Dim myDataSet As New DataSet()

        'myDataSet.ReadXml("http://gdata.youtube.com/feeds/api/videos?q=dead prez&start-index=1&max-results=20&v=2")
        ' Dim cont = myDataSet.Tables(8)
        ' Dim thumbnail = myDataSet.Tables("thumbnail")
        ' Dim title = myDataSet.Tables("title")



    End Sub

    <System.Web.Services.WebMethod()> _
    Public Shared Function searchYT(ByVal term As String)

        Dim ipAddy = Dns.GetHostEntry(Dns.GetHostName).AddressList(0).ToString 'get computer ip addy for xml file name
        Dim fileName As String = Replace(ipAddy, ":", "") ' format xml file name
        fileName = Replace(fileName, "%", "") ' format xml file name
        ' term = Trim(term) 'formatting query
        ' term = Replace(term, " ", "+") 'formatting query
        Dim myDataSet As New DataSet()

        If InStr(term, "@") = 1 Then
            term = Replace(term, "@", "")
            myDataSet.ReadXml("http://gdata.youtube.com/feeds/api/videos?author=" & term & "&start-index=1&max-results=20&format=5&v=2")
        Else
            myDataSet.ReadXml("http://gdata.youtube.com/feeds/api/videos?q=" & term & "&start-index=1&max-results=20&format=5&v=2")
        End If

        Dim content = myDataSet.Tables("link")
        Dim thumbnail = myDataSet.Tables("thumbnail")
        Dim title = myDataSet.Tables("title")


        Dim xmlCont As String = "<videos>"
        Dim counter = 0
        Try
            While counter < 20
                Dim titleRow = title.Rows(counter)

                Dim groupID = titleRow("group_Id") 'find small thumbN
                Dim Texpression As String = "group_Id =" & groupID
                Dim Lexpression As String = "entry_Id =" & groupID & " and rel='self'"
                'about 4 Tnails and links come through for each vid, gotta get the right 1
                Dim thumbArray As DataRow() = thumbnail.Select(Texpression)
                Dim thumbnailRow As DataRow = thumbArray(0)
                Dim linkArray As DataRow() = content.Select(Lexpression)
                Dim linkRow As DataRow = linkArray(0)

                ' nice up the title *****************************
                Dim mashupTitle = titleRow("title_Text")
                Dim length = Len(mashupTitle)
                Dim formatTitle As String

                If length > 40 Then
                    formatTitle = Left(mashupTitle, 25) & "..."
                Else
                    formatTitle = mashupTitle
                End If
                '*************************


                xmlCont = xmlCont & "<item n='" & counter & "'>"

                xmlCont = xmlCont & "<title><![CDATA[" & formatTitle & "]]></title>"

                xmlCont = xmlCont & "<altTag><![CDATA[" & titleRow("title_Text") & "]]></altTag>"

                xmlCont = xmlCont & "<thumb><![CDATA[" & thumbnailRow("url") & "]]></thumb>"

                xmlCont = xmlCont & "<vidurl><![CDATA[" & linkRow("href") & "]]></vidurl>"

                xmlCont = xmlCont & "</item>"

                counter = counter + 1
            End While
        Catch

        End Try
        xmlCont = xmlCont & "</videos>"

        Dim doc As New XmlDocument
        doc.LoadXml(xmlCont)
        'Save the document to a file.
        doc.Save(HttpContext.Current.Server.MapPath("~/xml/" & fileName & ".xml"))

        myDataSet.Clear() 'clear all tables
        content.Clear()
        thumbnail.Clear()
        title.Clear()


    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function TweetIt(ByVal strMessage As String)

        Dim strUser As String = "YouTube_Hero"
        Dim strPass As String = "3stacks"
        Dim strTweet As String = HttpContext.Current.Server.HtmlEncode("status=" & strMessage)

        'convert post variable to byte array for transmission purposes
        Dim bRequest As Byte() = System.Text.Encoding.ASCII.GetBytes(strTweet)

        'create HttpWebRequest to status update API resource
        Dim objRequest As HttpWebRequest = WebRequest.Create("http://twitter.com/statuses/update.xml")
        'pass basic authentication credentials
        objRequest.Credentials = New NetworkCredential(strUser, strPass)
        'set method to post and pass request as a form
        objRequest.Method = "POST"
        objRequest.ContentType = "application/x-www-form-urlencoded"
        'tell the server it will not receive a 100 Continue HTTP response
        objRequest.ServicePoint.Expect100Continue = False
        'set content length of request
        objRequest.ContentLength = bRequest.Length

        'capture the stream (content) of the request
        Dim objStream As Stream = objRequest.GetRequestStream()
        'put the bytes into request
        objStream.Write(bRequest, 0, bRequest.Length)
        'close the stream to complete the request
        objStream.Close()

        Dim objResponse As WebResponse = objRequest.GetResponse()
        Dim objReader As New StreamReader(objResponse.GetResponseStream())
        ' Dim Label1 As Label =
        ' Label1.Text = objReader.ReadToEnd()

    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function sendMail(ByVal what As String)

        'send emails
        Dim Msg As MailMessage = New MailMessage()
        Dim MailObj As New SmtpClient("xmail.wallacehcl.com")

        Msg.From = New MailAddress("form@youtubehero.com")
        Msg.To.Add(New MailAddress("nathan@wallacehcl.com"))
        Msg.IsBodyHtml = "true"
        Msg.Body = "<p style=""font-size: 14px;"">HeY,<br> some internet hipster has some feedback.<br><strong>" & what & ".</strong></p>"

        Msg.Subject = "Some fool wants a word"

        MailObj.Send(Msg)


    End Function

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        '*******************for Debuging************************

        Dim term = TextBox1.Text

        Dim ipAddy = Dns.GetHostEntry(Dns.GetHostName).AddressList(0).ToString 'get computer ip addy for xml file name
        Dim fileName As String = Replace(ipAddy, ":", "") ' format xml file name
        fileName = Replace(fileName, "%", "") ' format xml file name
        ' term = Trim(term) 'formatting query
        ' term = Replace(term, " ", "+") 'formatting query
        Dim myDataSet As New DataSet()
        'immortal technique caught in a hustle
        myDataSet.ReadXml("http://gdata.youtube.com/feeds/api/videos?q=" & term & "&start-index=1&max-results=20&format=5&v=2")
        'Dim cont = myDataSet.Tables(8)
        Dim content = myDataSet.Tables("link")
        Dim thumbnail = myDataSet.Tables("thumbnail")
        Dim title = myDataSet.Tables("title")


        Dim xmlCont As String = "<videos>"
        Dim counter = 0
        ' Try
        While counter < 20
            Dim titleRow = title.Rows(counter)
            ' Dim contRow = cont.Rows(counter)

            Dim groupID = titleRow("group_Id") 'find small thumbN
            Dim Texpression As String = "group_Id =" & groupID
            Dim Lexpression As String = "entry_Id =" & groupID & " and rel='self'"
            'about 4 Tnails and links come through for each vid, gotta get the right 1
            Dim thumbArray As DataRow() = thumbnail.Select(Texpression)
            Dim thumbnailRow As DataRow = thumbArray(0)
            Dim linkArray As DataRow() = content.Select(Lexpression)
            Dim linkRow As DataRow = linkArray(0)

            ' nice up the title *****************************
            Dim mashupTitle = titleRow("title_Text")
            Dim length = Len(mashupTitle)
            Dim formatTitle As String

            If length > 40 Then
                formatTitle = Left(mashupTitle, 40) & "..."
            Else
                formatTitle = mashupTitle
            End If
            '*************************


            xmlCont = xmlCont & "<item n='" & counter & "'>"

            xmlCont = xmlCont & "<title><![CDATA[" & formatTitle & "]]></title>"

            xmlCont = xmlCont & "<altTag><![CDATA[" & titleRow("title_Text") & "]]></altTag>"

            xmlCont = xmlCont & "<thumb><![CDATA[" & thumbnailRow("url") & "]]></thumb>"

            xmlCont = xmlCont & "<vidurl><![CDATA[" & linkRow("href") & "]]></vidurl>"

            xmlCont = xmlCont & "</item>"

            counter = counter + 1
        End While
        '   Catch

        ' End Try
        xmlCont = xmlCont & "</videos>"

        Dim doc As New XmlDocument
        doc.LoadXml(xmlCont)
        'Save the document to a file.
        doc.Save(HttpContext.Current.Server.MapPath("~/xml/" & fileName & ".xml"))

        myDataSet.Clear() 'clear all tables
        content.Clear()
        thumbnail.Clear()
        title.Clear()

    End Sub
End Class
