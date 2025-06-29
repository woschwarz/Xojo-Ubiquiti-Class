#tag Class
Protected Class UniFiApiClient
	#tag Method, Flags = &h0
		Function GetSites() As String
		  // Get the Site ID from the first available UniFi Controller. 
		  // Site ID is required for other UniFi Network API calls.
		  SendRequest("v1/sites")
		  
		  If lastStatusCode = 200 Then
		    
		    Try
		      // Access the “data” array in the JSONItem
		      Var dataArray As JSONItem = responseData.Value("data")
		      
		      If dataArray.Count > 0 Then
		        // Read first element of the array
		        Var firstItem As JSONItem = dataArray.Child(0)
		        
		        // Access to the “id” value
		        Var idValue As String = firstItem.Value("id")
		        
		        // Read Site ID
		        siteId = idValue
		        System.DebugLog("SiteID: " + idValue)
		        
		        Return idValue
		      Else
		        System.DebugLog("No data in array.")
		      End If
		      
		    Catch e As JSONException
		      System.DebugLog("Parse Error: " + e.Message)
		    End Try
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetVersion() As String
		  // Get UniFi Network application Version
		  SendRequest("/v1/info")
		  
		  If lastStatusCode = 200 Then
		    
		    System.DebugLog("applicationVersion: " + responseData.Value("applicationVersion"))
		    Return responseData.Value("applicationVersion")
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListClients() As Dictionary
		  // Reads all connected Clients
		  SendRequest("/v1/sites/" + siteID + "/clients")
		  
		  If lastStatusCode = 200 Then
		    
		    // Return value as a dictonary 
		    Return ParseJSON(responseData.ToString)
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListDevices() As Dictionary
		  // Reads all UniFi Devices
		  SendRequest("/v1/sites/" + siteID + "/devices")
		  
		  If lastStatusCode = 200 Then
		    
		    // Return value as a dictonary 
		    Return ParseJSON(responseData.ToString)
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListVouchers() As Dictionary
		  // Reads all Voucher codes
		  SendRequest("/v1/sites/" + siteID + "/hotspot/vouchers")
		  
		  If lastStatusCode = 200 Then
		    
		    // Return value as a dictonary 
		    Return ParseJSON(responseData.ToString)
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendRequest(action As String)
		  // Main Method for the Request
		  Var connection As New URLConnection
		  Var response As String = ""
		  Var apiURL As String = "https://" + ipAddress + "/proxy/network/integration/" + action
		  
		  connection.AllowCertificateValidation = False
		  connection.RequestHeader("X-API-KEY") = apiKey
		  connection.RequestHeader("Accept") = "application/json"
		  
		  // Execute call
		  Try
		    response = connection.SendSync("GET", apiURL, 30)
		    lastStatusCode = connection.HTTPStatusCode
		  Catch e As RuntimeException
		    lastStatusCode = 0
		    System.DebugLog("HTTP-Error: " + e.Message)
		  End Try
		  
		  // Save return value as Json item
		  If response <> "" Then
		    Try 
		      responseData = New JSONItem(response)
		      
		      // Output the return values in the Debug Log
		      System.DebugLog(apiURL)
		      System.DebugLog(response)
		      System.DebugLog(lastStatusCode.ToString)
		      
		    Catch e As JSONException
		      System.DebugLog("Error parsing JSON: " + e.Message)
		    End Try
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = ReadMe
		Xojo Ubiquiti Class - Developed by Wolfgang Schwarz, Germany
		
		UniFiApiClient is a universal class for Xojo to access the UniFi Network API.
		
		Written in Xojo (https://www.xojo.com)
		
		
		How To:
		
		First, go to UniFi Network > Settings > Control Plane > Integrations and create an API Key.
		
		Save the IP address of your UniFi Controller and the created API Key in the values.
		
		The returned value is saved as a JSONitem. It is also possible to process this as a dictionary.
		
		Take a look at the example calls in the MainWindow to understand how the class can be used.
		
		The official documentation of the UniFi API can also be found under Integrations.
		
		
		For more information, visit: https://github.com/woschwarz
		
	#tag EndNote

	#tag Note, Name = ToDo
		- Add all UniFi API calls
		
	#tag EndNote


	#tag Property, Flags = &h0
		apiKey As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ipAddress As String = "192.168.1.1"
	#tag EndProperty

	#tag Property, Flags = &h0
		lastStatusCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		responseData As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		siteID As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ipAddress"
			Visible=false
			Group="Behavior"
			InitialValue="192.168.1.1"
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="lastStatusCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="siteID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
