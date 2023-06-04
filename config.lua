Config = {}


Config.UseESX = true				-- Use ESX Framework
Config.UseQBCore = false			-- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.UseCustomNotify = false		-- Use a custom notification script, must complete event below.

-- Only complete this event if Config.UseCustomNotify is true; mythic_notification provided as an example
RegisterNetEvent('angelicxs-FREE-VINscratch:CustomNotify')
AddEventHandler('angelicxs-FREE-VINscratch:CustomNotify', function(message, type)
    --exports.mythic_Notify:SendAlert(type, message, 4000)
end)

-- Item Requirement
Config.NeedsLockpick = false
Config.LockpickName = 'lockpick'
Config.RemoveLockpick = true

--LEO Configuration
Config.RequireMinimumLEO = true 	-- When on will require a minimum number of LEOs to be available to start robbery
Config.RequiredNumberLEO = 1		-- Minimum number of LEO needed for robbery to start when Config.RequireMinimumLEO = true
Config.LEOJobName = {'police',} 		-- Job name of law enforcement officers, can be multiple jobs
Config.LEOScratches = true			-- Turning this true will allow LEO's to do VIN scratches
Config.CleanGetAway = true 			-- Turning this off means that the vehicle can be turned in with cops beside the drop of point.
Config.CleanGetAWayRadius = 250 	-- How far away the cops need to be to allow for a turn in (with Config.CleanGetAway turned on)
Config.TrackerDistance = 500 		-- How close to the drop off point does the vehicle need to be to turn off tracker.


Config.PoliceDispatch = false 		-- If true, will turn off police messaging through notifications and utilize a custom dispatch system (must fill event out below).
-- Only complete this event if Config.PoliceDispatch is true
RegisterNetEvent('angelicxs-FREE-VINscratch:CustomDisptachFoundIt')
AddEventHandler('angelicxs-FREE-VINscratch:CustomDisptachFoundIt', function(coords)
    --DISPATCH EXPORT HERE
end)

-- Rewards Configuration
Config.AllowKeepingVehicle = false 	-- When true will allow individuals to keep the vehicle instead of gaining other rewards.

Config.AccountMoney = 'cash' 		-- How you want the delivery paid.
Config.MoneyAmount = 5000 			-- If Config.RandomMoneyAmount = false, Amount paid out in Config.AccountMoney for a successful delivery.
Config.RandomMoneyAmount = true 	--If true, will randomly award money ammount on successful completion instead of Config.MoneyAmount.
Config.RandomMoneyAmountMin = 1000 	-- Minimum money gained on successful completion.
Config.RandomMoneyAmountMax = 10000 -- Maximum money gained on successful completion.

--Failure Configuration
Config.TimeLimit = 60				-- In minutes, how long do the robbers have to complete the heist before they fail.

-- Start Vehicle NPC Information
Config.StartVehicleLocation = {455.8330, -573.3048, 28.4998, 116.5867}		-- Coordinates for vehicle VIN dealer
Config.StartVehicleModel = 's_f_m_shop_high'

-- Drop Off NPC
Config.DropOffModel = 's_m_m_dockwork_01'

-- Model info: https://docs.fivem.net/docs/game-references/ped-models/
-- Blip info: https://docs.fivem.net/docs/game-references/blips/
-- Vehicle Blip Config
Config.StartVehicleBlip = true 		-- Enable Blip for starting NPC
Config.StartVehicleBlipIcon = 488 	-- Starting blip icon (if Config.StarBlip = true)
Config.StartVehicleBlipColour = 50 	-- Colour of blip icon (if Config.StarBlip = true)
Config.StartVehicleBlipText = 'VIN Scratch Dealer' -- Blip text on map (if Config.StarBlip = true)


--Vehicle List
Config.ClassZero = {
	{Name = 'Gang Burrito', Hash = "gburrito2"},
	{Name = 'Rat-Truck', Hash = "ratloader2"},
	{Name = 'Bravado Paradise', Hash = "paradise"},
	{Name = 'Rocoto', Hash = "rocoto"},
	{Name = 'Peyote', Hash = "peyote"},
	{Name = 'Manana', Hash = "manana"},
	{Name = 'Surge', Hash = "surge"},
	{Name = 'Romero Hearse', Hash = "romero"},
	{Name = 'Faggio', Hash = "faggio2"},
	{Name = 'Dilettante', Hash = "dilettante"},
	{Name = 'Brawler', Hash = "brawler"},
	{Name = 'Slamvan', Hash = "slamvan"},
	{Name = 'Go Go Monkey Blista', Hash = "blista3"},
	{Name = 'Stratum', Hash = "stratum"},
	{Name = 'Sandking XL', Hash = "sandking"},
	{Name = 'Sandking SWB', Hash = "sandking2"},
	{Name = 'Rusty Rebel', Hash = "rebel"},
	{Name = 'Kalahari', Hash = "kalahari"},
	{Name = 'Bifta', Hash = "bifta"},
	{Name = 'Primo', Hash = "primo"},
	{Name = 'Hexer', Hash = "hexer"},
	{Name = 'Innovation', Hash = "innovation"},
	{Name = 'Sovereign', Hash = "sovereign"},
	{Name = 'Pigalle', Hash = "pigalle"},
	{Name = 'Zion', Hash = "zion"},
	{Name = 'Sentinel XS', Hash = "sentinel"},
	{Name = 'Coquette BlackFin', Hash = "coquette3"},
	{Name = 'Furore GT', Hash = "furoregt"},
	{Name = 'Comet', Hash = "comet2"},
	{Name = 'Carbonizzare', Hash = "carbonizzare"},
	{Name = 'Buffalo S', Hash = "buffalo2"},
	{Name = 'Banshee', Hash = "banshee"},
	{Name = 'T20', Hash = "t20"},
	{Name = 'Turismo R', Hash = "turismor"},
	{Name = 'Akuma', Hash = "akuma"},
}
Config.VINClassDropLocation = {
	-- City Drop Offs
	{755.2930, -3193.2749, 6.0732, 242.6377}, 	-- Dock Warehouse		Postal 10102
	{116.7567, -3101.9941, 6.0154, 57.3417}, 	-- Bugstar Warehouse 	Postal 10072
	{-1159.3872, -1987.9984, 13.1604, 231.8784},-- LS Customs			Postal 10032
	{684.0112, -1185.8285, 24.6112, 66.2259},	-- Trainyard Olympic	Postal 8180
	-- Map Wilderness Drop Offs
	{1653.1421, 34.2466, 172.8805, 54.6159},	-- Dam					Postal 7350
	{-2015.9980, 3384.9888, 31.2546, 24.2569}, 	-- Fort Zancudo			Postal 5006
	-- Sandy/Grapeseed Drop Offs
	{2396.6431, 3316.6726, 47.7012, 315.1962}, 	-- Sandy Trailer   		Postal 3049
	-- Paleto Drop Offs
	{-17.8897, 6199.3979, 31.2398, 33.5448}, 	-- Plaeto Train Yard  	Postal 1023

}
Config.ClassZeroLocation = {
	-- Armarillo Vista
	{1416.5551, -1503.3585, 60.1610, 332.0409},
	{1395.6708, -1533.1389, 57.5875, 255.4763},
	{1372.8932, -1522.7465, 57.0466, 195.7837},
	{1273.2607, -1609.9583, 54.1519, 20.3144},
	{1261.4694, -1632.6107, 53.5465, 216.3149},
	{1166.9800, -1646.3206, 36.9196, 353.6617},
	{1153.8761, -1651.8915, 36.5290, 189.9301},
	{1332.1897, -1731.5212, 56.1254, 175.6534},
	-- Little Bighorn to Roy Lowenstein
	{522.1528, -1822.5161, 28.5031, 234.2069},
	{506.0708, -1842.7488, 27.6064, 308.7126},
	{432.0124, -1737.3484, 29.2469, 48.7180},
	{399.8630, -1753.6260, 29.2841, 232.1299},
	{375.2509, -1832.5363, 28.6895, 225.0302},
	{364.9791, -1809.4471, 29.0746, 169.8366},
	{275.4138, -1935.6316, 25.1721, 233.3475},
	{315.1719, -1941.5481, 24.6452, 50.6392},
	{299.5100, -1976.2478, 22.3236, 236.0105},
	{243.4547, -2032.7407, 18.3054, 47.6073},
	-- Mirror Park
	{1224.4312, -727.6890, 60.4964, 174.6441},
	{1221.2166, -704.2518, 60.7062, 278.1375},
	{1239.5405, -585.9667, 69.3291, 66.4288},
	{1256.0688, -624.5583, 69.3612, 299.8860},
	{1271.4879, -658.6450, 67.7370, 118.2627},
	{1274.6145, -672.6793, 65.9313, 273.0399},
	{1257.8688, -444.1426, 69.9834, 101.9606},
	{1258.2518, -420.0527, 69.4277, 293.5235},
	{950.3969, -653.7749, 57.9580, 309.2754},
	{919.7287, -637.3405, 57.8632, 138.4845},
	{914.0032, -626.1549, 58.0487, 88.2694},
	{856.9849, -520.4924, 57.3268, 44.9494},
	{943.5834, -468.5078, 61.2522, 213.2399},
	{971.7474, -451.6881, 62.4026, 268.2471},
	{1049.7263, -379.5013, 67.8535, 225.8052},
	{1008.1524, -591.0432, 58.9947, 110.8084},
	{916.5397, -524.1575, 58.9359, 3.5537},
	{946.6933, -510.3105, 60.2125, 233.0208},
	{977.4597, -526.1912, 60.1193, 207.0429},
	{844.8137, -191.9947, 72.6371, 38.0966},
	-- Roy Lowenstein to Davis (NOT GROVE STREET)
	{322.4721, -1744.2571, 29.3669, 48.4724},
	{308.7965, -1744.2505, 29.2658, 265.8176},
	{302.1878, -1754.5426, 29.1614, 36.9321},
	{267.2500, -1745.6001, 29.5159, 210.8549},
	{210.9302, -1882.7025, 24.4259, 136.7873},
	{184.8656, -1867.0182, 24.4533, 158.4576},
	{226.8201, -1686.9553, 29.2966, 217.8236},
	{188.0194, -1694.1335, 29.1396, 230.9920},
	-- Grove Street
	{118.0150, -1898.2733, 23.0542, 157.2944},
	{168.4981, -1928.0640, 20.5888, 27.3327},
	{99.9366, -1974.7601, 20.4358, 354.0358},
	{41.5425, -1920.8408, 21.6607, 315.6242},
	{16.9639, -1884.4304, 23.2800, 101.9074},
	{24.0930, -1909.2133, 22.2147, 127.1666},
	{42.1128, -1840.7031, 23.2261, 252.3538},
	-- Vespucci Canals
	{-950.4185, -899.7085, 1.7395, 200.5609},
	{-947.4933, -1096.9666, 1.7265, 297.4934},
	{-960.7030, -1101.1217, 1.7265, 192.7092},
	{-978.7848, -1114.4785, 1.7262, 213.8935},
	{-1048.5380, -1152.6177, 1.7349, 28.6458},
	{-1119.8781, -1237.2917, 2.5898, 300.9724},
	{-1131.1235, -1172.3086, 1.9328, 123.5252},
	{-1136.7281, -1165.5653, 2.2738, 69.4528},
	{-1165.6089, -1115.9362, 1.8620, 26.6794},
	{-1210.0493, -1025.3740, 1.7260, 249.6346},
	{-1135.6256, -1061.1066, 1.7266, 293.3383},
	{-1022.9092, -1015.4169, 1.7261, 269.8819},
	{-1038.4479, -1232.4188, 5.4228, 291.6032},
	--Mirror Park
	{1295.1683, -567.9190, 71.2152, 335.2992},
	{1379.5773, -598.1265, 74.3379, 51.1895},
	{1391.4170, -576.3590, 74.3388, 294.7092},
	{1362.4240, -553.1705, 74.3380, 335.0030},
	{936.2535, -50.6206, 78.7641, 229.7344},
	{856.2175, -19.8374, 78.7640, 54.6698},
	-- Vinewood Hills
	{315.0320, 567.7413, 154.0230, 210.2742},
	{319.0664, 497.0699, 152.2502, 101.9418},
	{64.7512, 456.0088, 146.3990, 31.6936},
	{55.9563, 467.8873, 146.3710, 274.6314},
	{-78.3937, 496.7294, 144.0307, 337.1714},
	{-123.1739, 509.1587, 142.5838, 167.3375},
	{-370.3651, 351.0523, 108.9202, 110.6231},
	{-404.2358, 337.0561, 108.2949, 178.5672},
	{-473.3662, 352.8577, 103.5806, 149.9020},
	{-359.0368, 513.6817, 119.2844, 319.6052},
	{-398.8503, 519.0386, 120.1045, 172.3384},
	{-542.5972, 544.8939, 110.1008, 79.8550},
	{-484.2513, 798.7479, 180.5021, 340.6140},
	{-551.1077, 830.8937, 197.3605, 338.6435},
	{-667.7462, 753.4286, 173.8356, 29.8895},
	{-695.4375, 704.9927, 156.8538, 320.9599},
	{-742.9911, 601.7471, 141.6195, 62.6623},
	{-753.8148, 627.3825, 142.1844, 203.4808},
	{-768.0120, 671.4154, 144.4091, 39.3551},
	{-1359.1130, 553.0984, 129.5138, 54.5833},
	{-1453.0778, 533.7262, 118.7851, 75.4932},
	{-1210.7821, 556.7115, 98.6832, 2.7172},
	{-1154.9221, 575.6596, 101.4101, 192.0510},
	{-1107.1497, 552.2207, 102.1586, 211.1841},
	{-871.3345, 499.9972, 89.5257, 275.5409},
	{-861.2972, 463.7256, 87.3297, 139.1831},
	{-845.3624, 458.9959, 87.3047, 101.8446},
	{-807.5854, 424.4561, 91.1449, 339.0071},
	{-634.0143, 526.8312, 109.2634, 11.7801},
	{-993.7186, 489.5850, 81.8431, 165.2137},
	{-1113.5936, 490.5027, 81.7679, 167.0420},
	{-1074.8909, 464.8119, 77.2745, 147.3126},
	{-1096.6871, 440.6773, 74.8624, 226.9269},
	-- Gated Homes (North Hills)
	{-128.9651, 1002.5933, 235.3093, 15.8098},
	{-163.4263, 928.6794, 235.2316, 226.5076},
	{-1375.0085, 453.2778, 104.5769, 261.5457},
	-- Gated Homes (West Hills)
	{-586.2554, 528.3542, 107.3354, 221.6052},
	{-1271.1893, 506.9263, 96.8747, 178.2570},
	{-869.0621, 318.4782, 83.5547, 4.3159},
	{-889.2078, 364.0840, 84.6076, 1.6744},
	{-1129.9161, 307.8975, 65.7625, 168.1084},
	{-1205.7174, 269.8027, 69.1251, 261.5269},
	{-1529.8446, 85.3010, 56.2489, 339.1727},
	{-1568.7090, 32.6548, 58.6909, 256.4320},
	{-1571.0363, -85.3780, 53.7106, 277.7913},
	-- Richman / Rockfiled Area
	{-1184.2020, 326.1053, 70.1750, 17.6817},
	{-1205.9259, 320.1293, 70.4613, 195.1615},
	{-1391.8721, 80.7316, 53.4535, 314.9323},
	{-1870.3865, 191.0651, 83.8716, 36.7753},
	{-1934.8312, 182.6320, 84.1581, 123.9420},
	{-1989.4164, 296.3040, 91.3415, 193.4890},
	{-1858.7117, 328.4783, 88.2274, 244.3274},
	{-1794.4615, 347.9786, 88.1317, 250.3867},
	{-1943.1473, 385.0820, 96.0562, 278.6653},
	{-1910.2332, 406.6918, 95.8728, 97.3640},
	{-1885.2649, 622.9408, 129.5762, 128.2701},
}

-- Language Configuration
Config.LangType = {
	['error'] = 'error',
	['success'] = 'success',
	['info'] = 'primary'
}

Config.Lang = {
	['request'] = 'Press ~r~[E]~w~ to request VIN scratch.',
	['notallowed'] = 'Sorry, I don\'t think I will ever get information on potential vehicles of this type to scratch.',
	['start'] = 'I think I have something that may fit your skill level. I marked the rough location on your map.',
	['delay'] = 'Huh, what\'s your rep like around here?',
	['RepOff'] = 'You don\'t need rep for the jobs I have for you!',
	['ClassD'] = 'Looks like your still fresh around here, only Class D VINs are available for you.',
	['ClassC'] = 'I think I have heard about your work... How about you try a Class C VIN for size.',
	['ClassB'] = 'Hell ya! You sure are reliable, I think you may be able to take on some Class B contracts.',
	['ClassA'] = 'You are a pro at this! Class A VIN scratches are right up your alley!',
	['ClassS'] = 'I can\'t believe your skills! Get to work boosting these Class S vehicles!',
	['ClassSPlus'] = 'Folks are actively seeking you out to help them out. Get moving, these Class S Plus scratches aren\'t going to move themselves!',
	['nocop'] = 'What? I am minding my own business, I\'m not talking to any cops.',
	['lockpick'] = 'Press ~r~[E]~w~ to break into the vehicle.',
	['missing_lockpick'] = 'You need a '..Config.LockpickName..'!',
	['locate'] = 'I found a vehicle, go grab it. It is going to be a ',
	['working'] = 'Someone else is currently on a job. Come back later.',
	['mincops'] = 'No risk, no reward. Come back later!',
	['delivery_blip'] = 'Drop off location.',
	['dropoff'] = 'Press ~r~[E]~w~ to drop off vehicle. \n Press ~r~[G]~w~ to keep scratch for your own.',
	['tracker_removed'] = 'The vehicle tracker has been removed, lose any pursuers before turning in!',
	['faraway'] = 'Your vehicle is too far away, bring it closer.',
	['no_scratch'] = 'You are responsible for delivery only, no way do you get to keep this.',
	['garage'] = 'The vehicle has been successfully scratched and has been delivered to your garage.',
	['reward'] = 'You successfully delivered the vehicle and have been paid out.',
	['startvehicle'] = 'An increase in stolen vehicles has been reported.',
	['startboat'] = 'An increase in stolen boats has been reported.',
	['startheli'] = 'An increase in stolen helicopters has been reported.',
	['track_on'] = 'A vehicle tracking device has been activated, GPS signal has been activated.',
		['find_dropoff'] = 'Looking for a drop off point now, I will send it to you in a few minutes!',
	['track_off'] = 'A vehicle tracking device has been deactivated, the GPS signal is no longer available.',
	['failed_death'] = 'Robbery failed as you have been incapacitated.',
	['failed_vehicleswap'] = 'Robbery failed as you got in a different vehicle.',
	['failed_timeup'] = 'Robbery failed as you took to long to deliver the vehicle.',
	['failed_damage'] = 'Robbery failed as the vehicle is too badly damaged to deliver.',
	['notclear'] = 'Shit are those sirens? The area is too hot to deal with this right now.',
	['failed_locate'] = 'Robbery failed as you took to long to find the vehicle.',
}

--Table Combiners
Config.NPCLocations = {

	['Vehicle'] = {
		Coords = Config.StartVehicleLocation,
		Model = Config.StartVehicleModel,
		Scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
		Icon = 'fas fa-clipboard-list',
		Type = 'vehicle',		
	},
}
