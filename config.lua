Config = {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'  --dont change

Config.GruppeBailPrice = 250   --amount it costs to take a truck out
Config.DropOffPrice = 50 --amount of money gruppe employee gets per dropoff
Config.InkedBillsAmount = 10  --amount of inked bills you receive from opening case(criminal side)
Config.InkedBillsGiven = 10   --amount of Inked Bills you Give to the Cleaner  (criminal)
Config.InkedBillsValue = math.random(100, 150)  --value of selling inked bill   (criminal)
Config.GruppeCaseAmount = 20 --how many cases you receive from pick up at collect case( i dont recommend changing from 20)
Config.GJDrawText = "enabled" --dont change
Config.JobName = "gruppe"  --dont change
Config.GruppeLocations = {
    ["collect-case"] = {   --place to pick cases up before starting job
        [1] = vector3(8.06, -658.52, 33.45),
    },
    ["gruppe-duty"] = {   
        [1] = vector3(-4.65, -654.29, 33.45),
    },
    ["deposit-case"] = {  --deposit leftover cases here after job
        [1] = vector3(3.17, -659.65, 33.45),
    },
    ["sell-inked-bills"] = {  --place to clean inked bills (criminal)
        [1] = vector3(244.51, 373.88, 105.74), 
    },
}


Config.GJLocations = {
    ["homebase"] = {    
        label = "Truck Shed",
        coords = vector4(3.29, -669.96, 32.34, 167.37),
    },
    ["gruppetruck"] = {
        label = "Truck Storage",
        coords = vector4(-5.62, -669.58, 32.34, 186.33),
    },
    ["banks"] ={
        [1] = {
            name = "legion-square",
            coords = vector4(147.49, -1044.82, 29.37, 245.88),
        },
        [2] = {
            name = "hawick-ave-1",
            coords = vector4(311.65, -282.91, 54.16, 242.53),
        },
        [3] = {
            name = "hawick-ave-2",
            coords = vector4(-353.31, -54.11, 49.04, 266.43),
        },
        [4] = {
            name = "pacific-standard",
            coords = vector4(256.68, 220.13, 106.29, 341.59),
        },
        [5] = {
            name = "boulevard-del-porro",
            coords = vector4(-1211.29, -335.28, 37.78, 298.01),
        },
        [6] = {
            name = "route68",
            coords = vector4(1175.89, 2711.34, 38.09, 89.34),
        },
        [7] = {
            name = "paleto-bank",
            coords = vector4(-105.01, 6472.53, 31.63, 41.5),
        },
        [8] = {
            name = "great-ocean",
            coords = vector4(-2957.79, 481.95, 15.7, 15.59),
        },
        [9] = {
            name = "vangelico",
            coords = vector4(-630.59, -229.15, 38.06, 101.44),
        },
        [10] = {
            name = "247supermarket4",
            coords = vector4(1735.54, 6416.28, 35.03, 332.5),
        },
    },
}

Config.GJVehicles = {
    ["stockade"] = "Gruppe 6",
}
