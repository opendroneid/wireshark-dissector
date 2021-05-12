-- Open Drone ID Dissector for Wireshark
-- Copyright 2021, Gabriel Cox
-- License: apache-2.0

odid_protocol = Proto("OpenDroneID",  "Open Drone ID Protocol")

--
-- ENUMERATIONS
--

-- Header Enumerations
local msgTypes = {
    [0]="Basic ID",
    [1]="Location/Vector",
    [2]="Authentication",
    [3]="Self ID",
    [4]="Operator ID",
    [5]="System",
    [15]="Message Pack"
}
local protoVersions = {
    [0]="F3411-19 (1.0)",
    [1]="F3411-20 (1.1)",
    [15]="Reserved for Private Use"
}

-- Basic ID Enumerations
local idTypes = {
    [0] = "None ",
    [1] = "Serial Number (ANSI/CTA-2063-A)",
    [2] = "CAA Assigned Registration ID ",
    [3] = "UTM Assigned UUID",
    [4] = "Specific Session ID"
}
local uaTypes = {
    [0] = "None/Not Declared",
    [1] = "Aeroplane",
    [2] = "Helicopter (or Multirotor)",
    [3] = "Gyroplane",
    [4] = "Hybrid Lift",
    [5] = "Ornithopter",
    [6] = "Glider",
    [7] = "Kite",
    [8] = "Free Balloon",
    [9] = "Captive Balloon",
    [10] = "Airship (such as a blimp)",
    [11] = "Free Fall/Parachute (unpowered)",
    [12] = "Rocket",
    [13] = "Tethered Powered Aircraft",
    [14] = "Ground Obstacle",
    [15] = "Other"
}

-- Location/Vector Enumerations
local statuses = {
    [0]="Undeclared",
    [1]="On Ground",
    [2]="Airborne",
    [3]="Emergency"
}
local heightTypes = {
    [0]="Above Takeoff",
    [1]="AGL",
}
local ewDirectionSegments = {
    [0]="East (<180)",
    [1]="West (>=180)",
}
local speedMultipliers = {
    [0]=0.25,
    [1]=0.75,
}
local horizAccuracies = {
    [0] = ">=18.52 km (10 NM) or Unknown",
    [1] = "<18.52 km (10 NM)",
    [2] = "<7.408 km (4 NM)",
    [3] = "<3.704 km (2 NM)",
    [4] = "<1852 m (1 NM)",
    [5] = "<926 m (0.5 NM)",
    [6] = "<555.6 m (0.3 NM)",
    [7] = "<185.2 m (0.1 NM)",
    [8] = "<92.6 m (0.05 NM)",
    [9] = "<30 m",
    [10] = "<10 m",
    [11] = "<3 m",
    [12] = "<1 m",
    [13] = "Reserved",
    [14] = "Reserved",
    [15] = "Reserved"
}
local vertAccuracies = {
    [0] = ">=150 m or Unknown",
    [1] = "<150 m ",
    [2] = "<45 m",
    [3] = "<25 m",
    [4] = "<10 m",
    [5] = "<3 m",
    [6] = "<1 m",
    [7] = "Reserved",
    [8] = "Reserved",
    [9] = "Reserved",
    [10] = "Reserved",
    [11] = "Reserved",
    [12] = "Reserved",
    [13] = "Reserved",
    [14] = "Reserved",
    [15] = "Reserved"
}
local speedAccuracies = {
    [0] = ">=10 m/s or Unknown",
    [1] = "<10 m/s",
    [2] = "<3 m/s",
    [3] = "<1 m/s",
    [4] = "<0.3 m/s",
    [5] = "Reserved",
    [6] = "Reserved",
    [7] = "Reserved",
    [8] = "Reserved",
    [9] = "Reserved",
    [10] = "Reserved",
    [11] = "Reserved",
    [12] = "Reserved",
    [13] = "Reserved",
    [14] = "Reserved",
    [15] = "Reserved"
}
local authTypes = {
    [0] = "None",
    [1] = "UAS ID Signature",
    [2] = "Operator ID Signature",
    [3] = "Message Set Signature",
    [4] = "Authentication Provided by Network Remote ID",
    [5] = "Specific Method",
    [6] = "Reserved",
    [7] = "Reserved",
    [8] = "Reserved",
    [9] = "Reserved",
    [10] = "Available for Private Use",
    [11] = "Available for Private Use",
    [12] = "Available for Private Use",
    [13] = "Available for Private Use",
    [14] = "Available for Private Use",
    [15] = "Available for Private Use"    
}
local selfIDTypes = {
    [0] = "Text description"
}
local classificationTypes = {
    [0] = "Undeclared",
    [1] = "European Union",
    [2] = "Reserved",
    [3] = "Reserved",
    [4] = "Reserved",
    [5] = "Reserved",
    [6] = "Reserved",
    [7] = "Reserved"
}
local OperatorLocTypes = {
    [0] = "Take Off",
    [1] = "Live GNSS",
    [2] = "Fixed Location"
}
local EUCats = {
    [0] = "Undefined",
    [1] = "Open",
    [2] = "Specific",
    [3] = "Certified"
}
local EUClasses = {
    [0] = "Undefined",
    [1] = "Class 0",
    [2] = "Class 1",
    [3] = "Class 2",
    [4] = "Class 3",
    [5] = "Class 4",
    [6] = "Class 5",
    [7] = "Class 6"
}
--
--  Field Protocols
--

-- Frame Fields
odid_app_code    = ProtoField.uint8("OpenDroneID.appCode", "App Code", base.DEC_HEX)
odid_counter     = ProtoField.uint8("OpenDroneID.counter", "Message Counter", base.DEC_HEX)

-- Header Fields
odid_msgType     = ProtoField.uint8("OpenDroneID.msgType", "Message Type", base.DEC_HEX,msgTypes,0xf0)
odid_protoVersion  = ProtoField.uint8("OpenDroneID.protoVersion", "Protocol Version", base.DEC,protoVersions,0x0f)

-- Message Pack Fields
odid_msgPack_msgSize = ProtoField.uint8("OpenDroneID.msgPack_msgSize", "MessagePack: Message Size", base.DEC)
odid_msgPack_msgQty = ProtoField.uint8("OpenDroneID.msgPack_msgQty", "MessagePack: Message Quantity", base.DEC)

-- Basic ID Fields
odid_basicID_idType = ProtoField.uint8("OpenDroneID.basicID_idType", "ID Type", base.DEC, idTypes, 0xf0)
odid_basicID_uaType = ProtoField.uint8("OpenDroneID.basicID_uaType", "UA Type", base.DEC, uaTypes, 0x0f)
odid_basicID_id_asc = ProtoField.string("OpenDroneID.basicID_id_asc", "ID", base.ASCII)
--    if idType == 4, show binary
odid_basicID_id_bin = ProtoField.bytes("OpenDroneID.basicID_id_bin", "ID", base.SPACE)

-- Location/Vector Fields
odid_loc_status = ProtoField.uint8("OpenDroneID.loc_status", "UAS Status", base.DEC, statuses, 0xf0)
odid_loc_flags = ProtoField.uint8("OpenDroneID.loc_flags", "Flags", base.DEC, nil, 0x0f)

odid_loc_flag_heightType = ProtoField.uint8("OpenDroneID.loc_flag_heightType", "Height Type", base.DEC, heightTypes, 0x04)
odid_loc_flag_ewDirectionSegment = ProtoField.uint8("OpenDroneID.loc_flag_ewDirectionSegment", "East/West Direction Segment", base.DEC, ewDirectionSegments, 0x02)
odid_loc_flag_speedMultiplier = ProtoField.uint8("OpenDroneID.loc_flag_speedMultiplier", "Speed Multiplier", base.DEC, speedMultipliers, 0x01)

odid_loc_direction = ProtoField.uint8("OpenDroneID.loc_direction", "Direction", base.DEC,nil,nil,"desc")
odid_loc_speed = ProtoField.uint8("OpenDroneID.loc_speed", "Speed", base.DEC)
odid_loc_vspeed = ProtoField.uint8("OpenDroneID.loc_vspeed", "Vert Speed", base.DEC)
odid_loc_lat = ProtoField.int32("OpenDroneID.loc_lat", "UA Lattitude", base.DEC)
odid_loc_lon = ProtoField.int32("OpenDroneID.loc_lon", "UA Longitude", base.DEC)
odid_loc_pressAlt = ProtoField.uint16("OpenDroneID.loc_pressAlt","UA Pressure Altitude", base.DEC)
odid_loc_geoAlt = ProtoField.uint16("OpenDroneID.loc_geoAlt","UA Geodetic Altitude",base.DEC)
odid_loc_height = ProtoField.uint16("OpenDroneID.loc_height","UA Height AGL",base.DEC)
odid_loc_hAccuracy = ProtoField.uint8("OpenDroneID.loc_hAccuracy","Horizontal Accuracy",base.DEC, horizAccuracies,0xf0)
odid_loc_vAccuracy = ProtoField.uint8("OpenDroneID.loc_vAccuracy","Vertical Accuracy",base.DEC, vertAccuracies,0x0f)
odid_loc_baroAccuracy = ProtoField.uint8("OpenDroneID.loc_baroAccuracy","Baro Accuracy",base.DEC, vertAccuracies,0xf0)
odid_loc_speedAccuracy = ProtoField.uint8("OpenDroneID.loc_speedAccuracy","Speed Accuracy",base.DEC, speedAccuracies,0x0f)
odid_loc_timeStamp = ProtoField.uint16("OpenDroneID.loc_timeStamp","Timestamp (1/10s since hour)",base.DEC)
odid_loc_tsReserved = ProtoField.uint8("OpenDroneID.loc_tsReserved","Reserved",base.DEC,{},0xf0)
odid_loc_tsAccuracy = ProtoField.uint8("OpenDroneID.loc_tsAccuracy","Timestamp Accuracy",base.DEC,{},0x0f)
odid_loc_reserved = ProtoField.uint8("OpenDroneID.loc_reserved","Reserved",base.DEC)

-- Authentication Fields
odid_auth_type = ProtoField.uint8("OpenDroneID.auth_type","Auth Type",base.DEC,authTypes,0xf0)
odid_auth_pageNumber = ProtoField.uint8("OpenDroneID.auth_pageNumber","Page Number",base.DEC,nil,0x0f)
odid_auth_pageCount = ProtoField.uint8("OpenDroneID.auth_pageCount","Page Count",base.DEC)
odid_auth_length = ProtoField.uint8("OpenDroneID.auth_length","Length",base.DEC)
odid_auth_timeStamp = ProtoField.uint32("OpenDroneID.auth_timeStamp","Time Stamp",base.DEC)
odid_auth_data = ProtoField.bytes("OpenDroneID.auth_data", "Auth Data", base.SPACE)

-- Self ID Fields
odid_self_type = ProtoField.uint8("OpenDroneID.self_type","Self Description Type",base.DEC,selfIDTypes)
odid_self_desc = ProtoField.string("OpenDroneID.self_desc","Self Description",base.ASCII)

-- System Fields
odid_system_flags = ProtoField.uint8("OpenDroneID.system_flags","System Flags",base.HEX)
odid_system_flag_class = ProtoField.uint8("OpenDroneID.system_flag_class","Classification Type",base.DEC,classificationTypes,0x0c)
odid_system_flag_locType = ProtoField.uint8("OpenDroneID.system_flag_locType","Operator Location Type",base.DEC,OperatorLocTypes,0x03)
odid_system_lat = ProtoField.int32("OpenDroneID.system_lat","Operator Lattitude",base.DEC)
odid_system_lon = ProtoField.int32("OpenDroneID.system_lon","Operator Longitude",base.DEC)
odid_system_areaCount = ProtoField.uint16("OpenDroneID.system_areaCount","Area Count",base.DEC)
odid_system_areaRadius = ProtoField.uint8("OpenDroneID.system_areaRadius","Area Radius",base.DEC)
odid_system_areaCeiling = ProtoField.uint16("OpenDroneID.system_areaCeiling","Area Ceiling",base.DEC)
odid_system_areaFloor = ProtoField.uint16("OpenDroneID.system_areaFloor","Area Floor",base.DEC)
odid_system_uaClass = ProtoField.uint8("OpenDroneID.system_usClass","UA Classification",base.HEX)
odid_system_uaClassEUCat = ProtoField.uint8("OpenDroneID.system_usClassEUCat","UA Classification Category",base.DEC,EUCats,0xf0)
odid_system_uaClassEUClass = ProtoField.uint8("OpenDroneID.system_usClassEUCat","UA Classification Category",base.DEC,EUClasses,0x0f)
odid_system_opGeoAlt = ProtoField.uint16("OpenDroneID.system_opGeoAlt","Operator Geodetic Alt",base.DEC)
odid_system_reserved = ProtoField.bytes("OpenDroneID.system_reserved","Reserved",base.SPACE)

-- Operator ID Fields
odid_operator_type = ProtoField.uint8("OpenDroneID.operator_type","Operator ID Type",base.DEC,selfIDTypes)
odid_operator_id = ProtoField.string("OpenDroneID.operator_id","Operator ID",base.ASCII)
odid_operator_reserved = ProtoField.string("OpenDroneID.operator_reserved","Reserved",base.ASCII)

odid_protocol.fields = { 
    odid_app_code, odid_counter, odid_msgType, odid_protoVersion, odid_msgPack_msgSize, odid_msgPack_msgQty, 

    odid_basicID_idType, odid_basicID_uaType, odid_basicID_id_a, odid_basicID_id_b,

    odid_loc_flag_ewDirectionSegment, odid_loc_flag_heightType, odid_loc_flag_speedMultiplier,

    odid_loc_status, odid_loc_flags, odid_loc_direction, odid_loc_speed, odid_loc_vspeed, odid_loc_lat,
    odid_loc_lon, odid_loc_pressAlt, odid_loc_geoAlt, odid_loc_height, odid_loc_hAccuracy, odid_loc_vAccuracy,
    odid_loc_baroAccuracy, odid_loc_speedAccuracy, odid_loc_timeStamp, odid_loc_tsReserved, odid_loc_tsAccuracy,
    odid_loc_reserved,

    odid_auth_type, odid_auth_pageNumber, odid_auth_pageCount, odid_auth_length, odid_auth_timeStamp, odid_auth_data,

    odid_self_type, odid_self_desc,

    odid_system_flags, odid_system_flag_class, odid_system_flag_locType, odid_system_lat, odid_system_lon, 
    odid_system_areaCount, odid_system_areaRadius, odid_system_areaCeiling, odid_system_areaFloor, odid_system_uaClass, 
    odid_system_opGeoAlt, odid_system_reserved,

    odid_operator_type, odid_operator_id, odid_operator_reserved
}

function odid_messageSubTree(buffer,subtree,msg_start,treeIndex,size)
    subMsgType =  bit32.extract(buffer(msg_start,1):int(),4,4)
    if subMsgType == 0 then
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Basic ID Message (0)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_id_idType, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_id_uaType, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_id_uasID, buffer(msg_start+2,20))
        subsub[treeIndex]:add_le(odid_id_reserved, buffer(msg_start+22,3))
    elseif subMsgType == 1 then
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Location/Vector Message (1)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_loc_status, buffer(msg_start+1,1))
        --subsub[treeIndex]:add_le(odid_loc_flags, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_loc_flag_heightType, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_loc_flag_ewDirectionSegment, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_loc_flag_speedMultiplier, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_loc_direction, buffer(msg_start+2,1))
        subsub[treeIndex]:add_le(odid_loc_speed, buffer(msg_start+3,1))
        subsub[treeIndex]:add_le(odid_loc_vspeed, buffer(msg_start+4,1))
        subsub[treeIndex]:add_le(odid_loc_lat, buffer(msg_start+5,4))
        subsub[treeIndex]:add_le(odid_loc_lon, buffer(msg_start+9,4))
        subsub[treeIndex]:add_le(odid_loc_pressAlt, buffer(msg_start+13,2))
        subsub[treeIndex]:add_le(odid_loc_geoAlt, buffer(msg_start+15,2))
        subsub[treeIndex]:add_le(odid_loc_height, buffer(msg_start+17,2))
        subsub[treeIndex]:add_le(odid_loc_hAccuracy, buffer(msg_start+19,1))
        subsub[treeIndex]:add_le(odid_loc_vAccuracy, buffer(msg_start+19,1))
        subsub[treeIndex]:add_le(odid_loc_baroAccuracy, buffer(msg_start+20,1))
        subsub[treeIndex]:add_le(odid_loc_speedAccuracy, buffer(msg_start+20,1))
        subsub[treeIndex]:add_le(odid_loc_timeStamp, buffer(msg_start+21,2))
        subsub[treeIndex]:add_le(odid_loc_tsReserved, buffer(msg_start+23,1))
        subsub[treeIndex]:add_le(odid_loc_tsAccuracy, buffer(msg_start+23,1))
        subsub[treeIndex]:add_le(odid_loc_reserved, buffer(msg_start+24,1))
    elseif subMsgType == 2 then 
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Authentication Message (2)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_auth_type, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_auth_pageNumber, buffer(msg_start+1,1))
        if bit32.extract(buffer(msg_start+1,1):uint(),0,4) == 0 then
            subsub[treeIndex]:add_le(odid_auth_pageCount, buffer(msg_start+2,1))
            subsub[treeIndex]:add_le(odid_auth_length, buffer(msg_start+3,1))
            subsub[treeIndex]:add_le(odid_auth_timeStamp, buffer(msg_start+4,4))
            subsub[treeIndex]:add_le(odid_auth_data, buffer(msg_start+8,17))
        else
            subsub[treeIndex]:add_le(odid_auth_data, buffer(msg_start+2,23))
        end
    elseif subMsgType == 3 then 
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Self-ID Message (3)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_self_type, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_self_desc, buffer(msg_start+2,23))

    elseif subMsgType == 4 then 
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - System Message (4)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_system_flag_class, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_system_flag_locType, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_system_lat, buffer(msg_start+2,4))
        subsub[treeIndex]:add_le(odid_system_lon, buffer(msg_start+6,4))
        subsub[treeIndex]:add_le(odid_system_areaCount, buffer(msg_start+10,2))
        subsub[treeIndex]:add_le(odid_system_areaRadius, buffer(msg_start+12,1))
        subsub[treeIndex]:add_le(odid_system_areaCeiling, buffer(msg_start+13,2))
        subsub[treeIndex]:add_le(odid_system_areaFloor, buffer(msg_start+15,2))
        if bit32.extract(buffer(msg_start+1,1):uint(),0,4) == 1 then
            subsub[treeIndex]:add_le(odid_system_uaClassEUCat, buffer(msg_start+17,1))
            subsub[treeIndex]:add_le(odid_system_uaClassEUClass, buffer(msg_start+17,1))
        else
            subsub[treeIndex]:add_le(odid_system_uaClass, buffer(msg_start+17,1))
        end
        subsub[treeIndex]:add_le(odid_system_opGeoAlt, buffer(msg_start+18,2))
        subsub[treeIndex]:add_le(odid_system_reserved, buffer(msg_start+20,5))
    elseif subMsgType == 5 then 
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Operator ID Message (5)")
        subsub[treeIndex]:add_le(odid_msgType, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion, buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_operator_type, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_operator_id, buffer(msg_start+2,20))
        subsub[treeIndex]:add_le(odid_operator_reserved, buffer(msg_start+22,3))
    elseif msgType == 15 then
        subsub[treeIndex] = subtree:add(odid_protocol,buffer(msg_start,size), "Open Drone ID - Message Pack (15)")
        subsub[treeIndex]:add_le(odid_msgType,  buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_protoVersion,  buffer(msg_start+0,1))
        subsub[treeIndex]:add_le(odid_msgPack_msgSize, buffer(msg_start+1,1))
        subsub[treeIndex]:add_le(odid_msgPack_msgQty,  buffer(msg_start+2,1))
        --for m=1,buffer(msg_start+4,1):int() do
        --    sub_msg_start = start+5
        --    odid_messageSubTree(buffer,subsub[n],sub_msg_start,m)
        --end
    end
end
function odid_protocol.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then 
        return 
    end
    --
    -- TODO: 
    --  1. Rather than using a static offset, figure out how to "find" the offset to the VSIE.
    --  2. Add NAN Support
    --
    local offset_vend_tag = 0x48
    local offset_len=offset_vend_tag+1
    local offset_oui = offset_vend_tag + 2
    local start = offset_vend_tag + 5

    -- check for vend specific ie
    if not (buffer(offset_vend_tag,1):uint() == 221) then
        return
    end
    -- check that ie oui is either parrot or ASD-STAN
    if not (buffer(offset_oui,3):bytes() == {0x90,0x3a,0xe6} or buffer(offset_oui,3):bytes() == {0xfa,0xob,0xbc} ) then
        return
    end
    frameLen = buffer(offset_len,1):int()
    msgTypeByte = buffer(start+2,1)
    msgType = bit32.extract(msgTypeByte:uint(),4,4)
    subsub={}
    pinfo.cols.protocol = odid_protocol.name
    local subtree = tree:add(odid_protocol, buffer(start,frameLen-3), "Open Drone ID - Beacon Frame")
    subtree:add_le(odid_app_code, buffer(start+0,1))
    subtree:add_le(odid_counter,  buffer(start+1,1))
    if msgType == 15 then
        subMsgSize = buffer(start+3,1):int()
        subMsgQty = buffer(start+4,1):int()
        odid_messageSubTree(buffer,subtree,start+2,0,subMsgSize*subMsgQty+3)
        msgSize = buffer(start+3,1):int()
        for n=1,buffer(start+4,1):int() do
            msg_start = start+5
            odid_messageSubTree(buffer,subsub[0],msg_start,n,msgSize)
        end
    else
        msgSize=25
        odid_messageSubTree(buffer,subtree,start+2,0,msgSize)
    end
end
--local vend_specific_oui = DissectorTable.get("wlan.tag.oui")
--local wlan_pkt_type = DissectorTable.get("wtap_encap")
--wlan_pkt_type:add(wtap_encaps["IEEE_802_11_RADIOTAP"], odid_protocol)
--vend_specific_oui:add(0x903ae6, odid_protocol) -- parrot
--vend_specific_oui:add(0xfa0bbc, odid_protocol) -- ASD-STAN
--	["IEEE_802_11"] = 20,
--	["IEEE_802_11_PRISM"] = 21,
--	["IEEE_802_11_WITH_RADIO"] = 22,
--	["IEEE_802_11_RADIOTAP"] = 23,
dis = DissectorTable.get("wtap_encap")
dis:add(wtap_encaps["IEEE_802_11"],odid_protocol)
register_postdissector(odid_protocol)