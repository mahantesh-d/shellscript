#curl -is curl 'http://10.252.169.12:7788/v1/sales/salesStatistic/stockAdjustment.json?filter=(&(transactionId=04))'
clear 
testServer="http://10.252.169.12:7788"
IOTServer="http://10.138.32.215:9101"
tmpIOTServer="http://10.138.32.216:9101"
server=$testServer
#server=$IOTServer
#server=$tmpIOTServer

figlet "Starting API Test"

>common_result
>common_result_hl

add_to_curl(){
curl -w %{time_total} -is "$server$1" > $2
#curl -w %{time_total} -is "http://10.138.32.215:9101$1" > $2
K=$(head -1 $2)
L=$(head -5 $2 | tail -1 | sed 's/Content-Length: //g')
T=$(tail -1 $2)
echo -e "$K\t\t\t\t$L\t\t\t\t\t\t\t\t$T\t\t\t\t\t$2"
cat $2 >> common_result
head -1 $2 >> common_result_hl
a=$(head -1 $2 | sed  's/[^0-9]//g' | sed 's/11//g')
if [ $a -eq "200" ]
        then
                sleep 1
        else
                sleep 5
fi
}

curl_post(){
curl -w %{time_total} -is -X POST "$server$1" -d @$3 > $2
#curl -w %{time_total} -is -X POST "http://10.138.32.215:9101$1" -d @$3 > $2
K=$(head -1 $2)
L=$(head -5 $2 | tail -1 | sed 's/Content-Length: //g')
T=$(tail -1 $2)
echo -e "$K\t\t\t\t$L\t\t\t\t\t\t\t\t$T\t\t\t\t\t$2"
cat $2 >> common_result
head -1 $2 >> common_result_hl
a=$(head -1 $2 | sed  's/[^0-9]//g' | sed 's/11//g')
if [ $a -eq "200" ]
        then
                sleep 1
        else
                sleep 5
fi
}


post_cassandra(){
echo -e "\n\nTest Post for Cassandra\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
curl_post '/v1/sales/salesStatistic/stockAdjustment.json' 'Stock_Adjustment_POST' 'stockadjustment.json'
curl_post '/v1/sales/salesStatistic/obtainDetail.json' 'Obtain_Detail_POST' 'obtaindetail.json'
curl_post '/v1/sales/salesStatistic/subStockDetailTransfer.json' 'Sub_Stock_Detail_Transfer_POST' 'substockdetailtransfer.json'
curl_post '/v1/sales/salesStatistic/subStockDailyDetail.json' 'Sub_Stock_Daily_Detail_POST' 'substockdailydetail.json'
curl_post '/v1/sales/salesStatistic/transferOutMismatch.json' 'Transfer_Out_Mismatch_POST' 'transferoutmismatch.json'
curl_post '/v1/sales/salesStatistic/requestGoods.json' 'Request_Goods_POST' 'requestgoods.json'
curl_post '/v1/sales/salesStatistic/orderTransfer.json' 'Order_Transfer_POST' 'ordertransfer.json'
curl_post '/v1/sales/salesStatistic/salesOutDetail.json' 'sales_Out_Detail_POST' 'salesoutdetails.json'
curl_post '/v1/customers/customerOrder/localServiceRequests.json' 'Local_Service_Requests_POST' 'localservicerequests.json'
curl_post '/v1/sales/salesStatistic/printHistoryDetail.json' 'Print_History_Detail_POST' 'printhistorydetals.json'
curl_post '/v1/sales/salesStatistic/checkStockDetail.json' 'Check_Stock_Detail_POST' 'checkstockdetail.json'
}
post_postgresxl(){
RANDOM=$$
x=$(grep -n "locationCode_key0" locationshipto.json | sed s/[^0-9]//g | sed s/^..//g)
sed -i "s/"$x"/"$RANDOM"/g" locationshipto.json
y=$(grep -n "documentNo_key0" printhistory.json | sed s/[^0-9]//g | sed s/^..//g)
sed -i "s/"$y"/"$RANDOM"/g" printhistory.json
z=$(grep -n "matCode_key15" productmaster.json | sed s/[^0-9]//g | sed s/^...//g)
sed -i "s/"$z"/"$RANDOM"/g" productmaster.json
echo -e "\n\nTest Post for Postgresxl\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
curl_post '/v1/product/productSpecification/productMaster.json' 'Product_Master_POST' 'productmaster.json'
curl_post '/v1/sales/salesChannel/printHistory.json' 'Print_history_POST' 'printhistory.json'
curl_post '/v1/sales/salesChannel/locationMappingPlant.json' 'Location_Mapping_Plant_POST' 'locationmappingplant.json'
curl_post '/v1/sales/salesChannel/locationShipTo.json' 'Location_Ship_To_POST' 'locationshipto.json'
curl_post '/v1/sales/salesChannel/stampDelivery.json' 'Stamp_Delivery_POST' 'stampdelivery.json'
}
get_cassandra(){
echo -e "\n\nTesting Cassandra GET APIs\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/sales/salesStatistic/stockAdjustment.json?filter=(&(locationCode=1177))' 'Stock_adjustment_GET'
add_to_curl '/v1/sales/salesStatistic/obtainDetail.json?filter=(&(transactionType=pickup))' 'Obtain_detail_GET'
add_to_curl '/v1/sales/salesStatistic/subStockDetailTransfer.json?filter=(&(locationCode=1177))' 'Sub_stock_detail_transfer_GET'
add_to_curl '/v1/sales/salesStatistic/subStockDailyDetail.json?filter=(&(salesFor=front))' 'Sub_Stock_Daily_Detail_GET'
add_to_curl '/v1/sales/salesStatistic/transferOutMismatch.json?filter=(&(transactionType=transferOutMismatch))' 'Transfer_Out_Mismatch_GET'
add_to_curl '/v1/sales/salesStatistic/requestGoods.json?filter=(&(fromLocationCode=1012))' 'Request_Goods_GET'
add_to_curl '/v1/sales/salesStatistic/orderTransfer.json?filter=(&(fromLocationCode=1012))' 'Order_Transfer_GET'
add_to_curl '/v1/sales/salesStatistic/salesOutDetail.json?filter=(&(transactionType=salesOut))' 'Sales_Out_Detail_GET'
add_to_curl '/v1/sales/salesStatistic/checkStockDetail.json?filter=(&(locationCode=1177))' 'Check_Stock_Detail_GET'
add_to_curl '/v1/customers/customerOrder/localServiceRequests.json?filter=(&(Actor=menu))' 'Local_Service_Requests_GET'
add_to_curl '/v1/sales/salesStatistic/printHistoryDetail.json?filter=(&(transactionId=03))' 'Print_History_Detail_GET'
}
get_cassandra_and(){
echo -e "\n\nTesting of Cassandra With AND Condition\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/sales/salesStatistic/stockAdjustment.json?filter=(&(adjustDateTime_start=20150909153750+0700)(transactionType=adjustStock))' 'Stock_Adjustment_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/obtainDetail.json?filter=(&(locationCode=1177)(transactionType=pickup))' 'Obtain_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/subStockDetailTransfer.json?filter=(&(locationCode=1177)(transferSubStockDateTime_start=20150909153750+0700))' 'Sub_Stock_Detail_Transfer_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/subStockDailyDetail.json?filter=(&(locationCode=1177)(salesFor=adjust))' 'Sub_Stock_Daily_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/transferOutMismatch.json?filter=(&(transactionId=03)(transactionType=transferOutMismatch))' 'Transfer_Out_Mismatch_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/requestGoods.json?filter=(&(fromLocationCode=1012)(toLocationCode=1177))' 'Request_Goods_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/orderTransfer.json?filter=(&(fromLocationCode=1012)(transferStatus=transferin))' 'Order_Transfer_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/salesOutDetail.json?filter=(&(transactionId=03)(transactionType=salesOut))' 'Sales_Out_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/checkStockDetail.json?filter=(&(confirmDateTime_start=20150909153750+0700)(locationCode=1177))' 'Check_Stock_Detail_GET_2_PAR'
add_to_curl '/v1/customers/customerOrder/localServiceRequests.json?filter=(&(Actor=menu)(Channel=Batch))' 'Local_Service_Requests_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/printHistoryDetail.json?filter=(&(transactionId=03)(transactionType=History))' 'Print_History_GET_2_PAR'
}
get_postgresxl(){
echo -e "\n\nTesting the Postgresxl GET APIs\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/product/productSpecification/productMaster.json?filter=(&(matCode_key15=02))' 'Product_Master_GET'
add_to_curl '/v1/sales/salesChannel/locationMappingPlant.json?filter=(&(locationCode_key0=02))' 'Location_Mapping_Plant_GET'
add_to_curl '/v1/sales/salesChannel/locationShipTo.json?filter=(&(locationCode_key0=02))' 'Location_Ship_To_GET'
add_to_curl '/v1/sales/salesChannel/routeMaster.json?filter=(&(routeAbbr_key0=MBK1))' 'Route_Master_GET'
add_to_curl '/v1/sales/salesChannel/printHistory.json?filter=(&(documentNo_key0=02))' 'Print_History_GET'
add_to_curl '/v1/sales/salesChannel/company.json?filter=(&(saleOrganize_data=1401))' 'Company_GET'
add_to_curl '/v1/sales/salesChannel/location.json?filter=(&(locationCode_key0=47218))' 'Location_GET'
add_to_curl '/v1/sales/salesChannel/locationSubstock.json?filter=(&(subStock_data=Bad))' 'Location_Sub_Stock_GET'
add_to_curl '/v1/sales/salesChannel/vendorMaster.json?filter=(&(vendorCode_key0=1111040462))' 'Vendor_Master_GET'
add_to_curl '/v1/sales/salesChannel/supplierMaster.json?filter=(&(supplierCode_key0=1111011765))' 'Supplier_Master_GET'
add_to_curl '/v1/sales/salesChannel/configRouteGroup.json?filter=(&(updateBy_data=phxsales))' 'Config_Route_Group_GET'
add_to_curl '/v1/sales/salesChannel/masterData.json?filter=(&(createDateTime_data=20170420085900+0700))' 'Master_Data_GET'
add_to_curl '/v1/product/productSpecification/deviceSpecification.json?filter=(&(2GNetwork_data=GSM 850/900/1800/1900 MHz))' 'Device_Specification_GET'
add_to_curl '/v1/sales/salesChannel/language.json?filter=(&(language_data=TH))' 'Language_GET'
add_to_curl '/v1/sales/salesChannel/runningFormat.json?filter=(&(createBy_data=maha))' 'Running_Format_GET'
add_to_curl '/v1/sales/salesChannel/lastRunning.json?filter=(&(createBy_data=text))' 'Last_Running_GET'
add_to_curl '/v1/sales/salesChannel/mapLocationRouteGroup.json?filter=(&(routeGroup_data=ZA84))' 'Map_Location_Route_Group_GET'
add_to_curl '/v1/sales/salesChannel/scheduleReport.json?filter=(&(reportType_key1=abcd))' 'Schedule_Report_GET'
add_to_curl '/v1/sales/salesChannel/locationRelational.json?filter=(&(parent_key1=1851))' 'Location_Relational_GET'
add_to_curl '/v1/product/productSpecification/newsFeed.json?filter=(&(newsTitle_key0=Test Title2))' 'News_Feed_GET'
add_to_curl '/v1/sales/salesChannel/toDoList.json?filter=(&(toDoListModule_key1=transferOut))' 'To_Do_List_GET'
add_to_curl '/v1/sales/salesChannel/menu.json?filter=(|(mainMenu_data=abc)(programCode_key0=123))' 'Menu_GET'
add_to_curl '/v1/sales/salesChannel/ascMaster.json?filter=(&(createBy_data=abc))' 'Asc_Master_GET'
add_to_curl '/v1/sales/salesChannel/qtyPerTimeInterval.json?filter=(&(company_key3=AWN))' 'Qty_Per_Time_Interval_GET'
add_to_curl '/v1/sales/salesChannel/userLogin.json?filter=(&(groupName_data=SM001))' 'User_Login_GET'
add_to_curl '/v1/sales/salesChannel/userAuthen.json?filter=(&(programCode_data=TDSSK009))' 'User_Authen_GET'
add_to_curl '/v1/sales/salesChannel/userGroup.json?filter=(&(groupName_data=SM001))' 'User_Group_GET'
add_to_curl '/v1/sales/salesChannel/userComponent.json?filter=(&(component_data=rdoQuota))' 'User_Component_GET'
add_to_curl '/v1/sales/salesChannel/userGroupLocation.json?filter=(&(groupLocationName_data=iPhone))' 'User_Group_Location_GET'
add_to_curl '/v1/sales/salesChannel/userLocation.json?filter=(&(groupLocationName_key0=abc))' 'User_Location_GET'
add_to_curl '/v1/sales/salesChannel/stampDelivery.json?filter=(&(shipToCode_key0=1400006267))' 'Stamp_Delivery_GET'
add_to_curl '/v1/sales/salesChannel/subStock.json?filter=(&(locationCode_data=2062))' 'Sub_Stock_View_GET'
add_to_curl '/v1/sales/salesChannel/mappingPlant.json?filter=(&(locationCode_key0=1010))' 'Mapping_Plant_View_GET'
add_to_curl '/v1/sales/salesChannel/configRouteGroupDetail.json?filter=(&(routeGroup_key0=ZA10))' 'Config_Route_Group_Detail_View_GET'
add_to_curl '/v1/sales/salesChannel/locationShipToDetail.json?filter=(&(locationCode_key0=1177))' 'Location_Ship_To_Detail_View_GET'
}
get_postgresxl_and(){
echo -e "\n\nTesting the Postgrexl APIs for AND Condition\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/product/productSpecification/productMaster.json?filter=(&(matCode_key15=02)(company_key0=WDS))' 'Product_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationMappingPlant.json?filter=(&(locationCode_key0=02)(company_key1=ais))' 'Location_Mapping_Plant_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationShipTo.json?filter=(&(locationCode_key0=02)(shipToDefaultFlag_data=Y))' 'Location_Ship_To_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/routeMaster.json?filter=(&(routeAbbr_key0=MBK1)(routeName_data=MBK Center))' 'Route_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/printHistory.json?filter=(&(documentNo_key0=02)(edition_data=20))' 'Print_History_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/company.json?filter=(&(saleOrganize_data=1401)(activeFlag_data=T))' 'Company_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/location.json?filter=(&(locationCode_key0=47218)(createBy_data=phxsales))' 'Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationSubstock.json?filter=(&(subStock_data=Bad)(createBy_data=phxsales))' 'Location_Sub_Stock_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/vendorMaster.json?filter=(&(vendorCode_key0=1111040462)(createDateTime_data=20170420085959+0700))' 'Vendor_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/supplierMaster.json?filter=(&(supplierCode_key0=1111011765)(updateBy_data=phxsales))' 'Supplier_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/configRouteGroup.json?filter=(&(updateBy_data=phxsales)(stampDelivery_data=BK1))' 'Config_Route_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/masterData.json?filter=(&(createDateTime_data=20170420085900+0700)(masterValue_key1=702))' 'Master_Data_GET_2_PAR'
add_to_curl '/v1/product/productSpecification/deviceSpecification.json?filter=(&(2GNetwork_data=GSM 850/900/1800/1900 MHz)(bluetooth_data=v4.0, A2DP))' 'Device_Specification_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/language.json?filter=(&(language_data=TH)(elementName_key0=Active))' 'Language_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/runningFormat.json?filter=(&(createBy_data=maha)(updateDateTime_data=20160930153750+0700))' 'Running_Format_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/lastRunning.json?filter=(&(createBy_data=text)(createDateTime_data=20160930153750+0700))' 'Last_Running_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/mapLocationRouteGroup.json?filter=(&(routeGroup_data=ZA84)(province_key0=BKK))' 'Map_Location_Route_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/scheduleReport.json?filter=(&(reportType_key1=abcd)(updateDateTime_key4=20160930153750+0700))' 'Schedule_Report_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationRelational.json?filter=(&(parent_key1=1851)(parent_key1=1851))' 'Location_Relational_GET_2_PAR'
add_to_curl '/v1/product/productSpecification/newsFeed.json?filter=(&(newsTitle_key0=Test Title2)(newsGroup_data=Shop))' 'News_Feed_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/toDoList.json?filter=(&(toDoListModule_key1=transferOut)(programCode_key0=TDSSK009))' 'To_Do_List_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/menu.json?filter=(&(mainMenu_data=abc)(updateDateTime_key1=20160909153300+0700))' 'Menu_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/ascMaster.json?filter=(&(createBy_data=abc)(updateDateTime_key1=20160909153300+0700))' 'Asc_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/qtyPerTimeInterval.json?filter=(&(company_key3=AWN)(matCode_key4=NEWAPPI5C16-BL01))' 'Qty_Per_Time_Interval_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userLogin.json?filter=(&(groupName_data=SM001)(locationCode_data=1004))' 'User_Login_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userAuthen.json?filter=(&(programCode_data=TDSSK009)(groupName_key0=SM082))' 'User_Authen_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userGroup.json?filter=(&(groupName_data=SM001)(groupId_key0=1))' 'User_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userComponent.json?filter=(&(component_data=rdoQuota)(groupName_key0=SM008))' 'User_Component_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userGroupLocation.json?filter=(&(groupLocationName_data=iPhone)(userId_key0=noppanam))' 'User_Group_Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userLocation.json?filter=(&(groupLocationName_key0=abc)(updateDateTime_key1=20170420085959+0700))' 'User_Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/stampDelivery.json?filter=(&(shipToCode_key0=1400006267)(createDateTime_data=20160909153300+0700))' 'Stamp_Delivery_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/subStock.json?filter=(&(locationCode_data=2062)(subStock_data=Bad))' 'Sub_Stock_View_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/mappingPlant.json?filter=(&(locationCode_key0=1010)(plant_key2=2020))' 'Mapping_Plant_View_GET_2_PAR_2_PAR'
add_to_curl '/v1/sales/salesChannel/configRouteGroupDetail.json?filter=(&(routeGroup_key0=ZA10))' 'Config_Route_Group_Detail_View_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationShipToDetail.json?filter=(&(locationCode_key0=1177)(locationSoi_data=53))' 'Location_Ship_To_Detail_View_GET_2_PAR'
}
get_postgresxl_or(){
echo "\n\nTesting postgresxl for OR\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/product/productSpecification/productMaster.json?filter=(|(matCode_key15=02)(company_key0=WDS))' 'Product_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationMappingPlant.json?filter=(|(locationCode_key0=02)(company_key1=ais))' 'Location_Mapping_Plant_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationShipTo.json?filter=(|(locationCode_key0=02)(shipToDefaultFlag_data=Y))' 'Location_Ship_To_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/routeMaster.json?filter=(|(routeAbbr_key0=MBK1)(routeName_data=MBK Center))' 'Route_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/printHistory.json?filter=(|(documentNo_key0=02)(edition_data=20))' 'Print_History_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/company.json?filter=(|(saleOrganize_data=1401)(activeFlag_data=T))' 'Company_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/location.json?filter=(|(locationCode_key0=47218)(createBy_data=phxsales))' 'Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationSubstock.json?filter=(|(subStock_data=Bad)(createBy_data=phxsales))' 'Location_Sub_Stock_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/vendorMaster.json?filter=(|(vendorCode_key0=1111040462)(createDateTime_data=20170420085959+0700))' 'Vendor_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/supplierMaster.json?filter=(|(supplierCode_key0=1111011765)(updateBy_data=phxsales))' 'Supplier_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/configRouteGroup.json?filter=(|(updateBy_data=phxsales)(stampDelivery_data=BK1))' 'Config_Route_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/masterData.json?filter=(|(createDateTime_data=20170420085900+0700)(masterValue_key1=702))' 'Master_Data_GET_2_PAR'
add_to_curl '/v1/product/productSpecification/deviceSpecification.json?filter=(|(2GNetwork_data=GSM 850/900/1800/1900 MHz)(bluetooth_data=v4.0, A2DP))' 'Device_Specification_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/language.json?filter=(|(language_data=TH)(elementName_key0=Active))' 'Language_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/runningFormat.json?filter=(|(createBy_data=maha)(updateDateTime_data=20160930153750+0700))' 'Running_Format_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/lastRunning.json?filter=(|(createBy_data=text)(createDateTime_data=20160930153750+0700))' 'Last_Running_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/mapLocationRouteGroup.json?filter=(|(routeGroup_data=ZA84)(province_key0=BKK))' 'Map_Location_Route_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/scheduleReport.json?filter=(|(reportType_key1=abcd)(updateDateTime_key4=20160930153750+0700))' 'Schedule_Report_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationRelational.json?filter=(|(parent_key1=1851)(updateBy_data=phxsales))' 'Location_Relational_GET_2_PAR'
add_to_curl '/v1/product/productSpecification/newsFeed.json?filter=(|(newsTitle_key0=Test Title2)(newsGroup_data=Shop))' 'News_Feed_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/toDoList.json?filter=(|(toDoListModule_key1=transferOut)(programCode_key0=TDSSK009))' 'To_Do_List_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/menu.json?filter=(|(mainMenu_data=abc)(updateDateTime_key1=20160909153300+0700))' 'Menu_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/ascMaster.json?filter=(|(createBy_data=abc)(updateDateTime_key1=20160909153300+0700))' 'Asc_Master_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/qtyPerTimeInterval.json?filter=(|(company_key3=AWN)(matCode_key4=NEWAPPI5C16-BL01))' 'Qty_Per_Time_Interval_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userLogin.json?filter=(|(groupName_data=SM001)(locationCode_data=1004))' 'User_Login_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userAuthen.json?filter=(|(programCode_data=TDSSK009)(groupName_key0=SM082))' 'User_Authen_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userGroup.json?filter=(|(groupName_data=SM001)(groupId_key0=1))' 'User_Group_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userComponent.json?filter=(|(component_data=rdoQuota)(groupName_key0=SM008))' 'User_Component_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userGroupLocation.json?filter=(|(groupLocationName_data=iPhone)(userId_key0=noppanam))' 'User_Group_Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/userLocation.json?filter=(|(groupLocationName_key0=abc)(updateDateTime_key1=20170420085959+0700))' 'User_Location_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/stampDelivery.json?filter=(|(shipToCode_key0=1400006267)(createDateTime_data=20160909153300+0700))' 'Stamp_Delivery_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/subStock.json?filter=(|(locationCode_data=2062)(subStock_data=Bad))' 'Sub_Stock_View_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/mappingPlant.json?filter=(|(locationCode_key0=1010)(plant_key2=2020))' 'Mapping_Plant_View_GET_2_PAR_2_PAR'
add_to_curl '/v1/sales/salesChannel/configRouteGroupDetail.json?filter=(|(routeGroup_key0=ZA10))' 'Config_Route_Group_Detail_View_GET_2_PAR'
add_to_curl '/v1/sales/salesChannel/locationShipToDetail.json?filter=(|(locationCode_key0=1177)(locationSoi_data=53))' 'Location_Ship_To_Detail_View_GET_2_PAR'
}

get_cassandra_or(){
echo "\n\nTesting Cassandra for OR\n"
echo -e "\nStatus\t\t\t\tContent-Length\t\t\tResponse-Time\t\t\t\ttable-Name"
echo -e "\n------\t\t\t\t--------------\t\t\t--------------\t\t\t\t----------\n"
add_to_curl '/v1/sales/salesStatistic/stockAdjustment.json?filter=(|(locationCode=1177))' 'Stock_Adjustment_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/obtainDetail.json?filter=(|(transactionType=pickup))' 'Obtain_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/subStockDetailTransfer.json?filter=(|(transferSubStockNo=TS0000275157452))' 'Sub_Stock_Detail_Transfer_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/subStockDailyDetail.json?filter=(|(locationCode=1177))' 'Sub_Stock_Daily_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/transferOutMismatch.json?filter=(|(transactionId=03)(transactionType=transferOutMismatch))' 'Transfer_Out_Mismatch_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/requestGoods.json?filter=(|(fromLocationCode=1012)(toLocationCode=1177))' 'Request_Goods_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/orderTransfer.json?filter=(|(transactionType=transferOut))' 'Order_Transfer_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/salesOutDetail.json?filter=(|(transactionId=03)(transactionType=salesOut))' 'Sales_Out_Detail_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/checkStockDetail.json?filter=(|(locationCode=1177))' 'Check_Stock_Detail_GET_2_PAR'
add_to_curl '/v1/customers/customerOrder/localServiceRequests.json?filter=(|(Actor=menu)(Channel=Batch))' 'Local_Service_Requests_GET_2_PAR'
add_to_curl '/v1/sales/salesStatistic/printHistoryDetail.json?filter=(|(transactionId=03)(transactionType=History))' 'Print_History_GET_2_PAR'
}

post_cassandra
post_postgresxl
get_cassandra
get_cassandra_and
get_postgresxl
get_postgresxl_and
get_postgresxl_or
get_cassandra_or
