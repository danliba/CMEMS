# -*- coding: utf-8 -*-
"""
Created on Thu Apr 14 19:48:11 2022

@author: danli
"""
import os

cmems_user= """""""
cmems_pass= """"""
motu_server ="https://nrt.cmems-du.eu/motu-web/Motu"
product_id="dataset-oc-glo-bio-multi-l3-chl_300m_daily-rt"
service_id="OCEANCOLOUR_GLO_CHL_L3_NRT_OBSERVATIONS_009_032-TDS"
lon_min="-85"
lon_max="-65"
lat_min="-16"
lat_max="0"
# date_min=datetime.date.today().isoformat()
# date_max=(datetime.date.today()+timedelta(days=3)).isoformat()
date_min="2022-01-01 00:00:00"
date_max="2022-01-15 00:00:00"
variable1 = "CHL"
Out_dir = "D:\\descargas\\CMEMS"
#nc_name = time.strftime("%d_%m_%Y_%H_%M.nc")
nc_name = "Clorofila_"+date_min[:10]+"_"+date_max[:10]+".nc"
command_string = "python -m motuclient --user " + str(cmems_user) + " --pwd " + str(cmems_pass) +" --motu " + str(motu_server) + " --service-id " + str(service_id) + " --product-id " + str(product_id) + " --longitude-min " + str(lon_min) + " --longitude-max " + str(lon_max) + " --latitude-min " + str(lat_min) + " --latitude-max " + str(lat_max) + " --date-min " + str(date_min) + " --date-max " + str(date_max) + " --variable " + str(variable1) + " --out-dir " + str(Out_dir) + " --out-name " + str(nc_name)
os.system(command_string)

