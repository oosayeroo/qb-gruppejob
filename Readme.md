# A Gruppe6 Job for QBCore Framework




## Please note

- Please make sure u use the latest dependencies aswell as core for this in order to work.

- This Job has been tested on the latest build as of 04/07/2022.

Discord - https://discord.gg/3WYz3zaqG5

## Dependencies :

QBCore Framework - https://github.com/qbcore-framework/qb-core

PolyZone - https://github.com/mkafrin/PolyZone

qb-target - https://github.com/BerkieBb/qb-target (Only needed if not using draw text)

qb-input - https://github.com/qbcore-framework/qb-input

qb-menu - https://github.com/qbcore-framework/qb-menu


## Credits : 

- BigBearBeastUK for his idea to make it and his amazing support throughout
- Elyria Crew for putting up with my tired moaning
- QBCore for their trucker script which gave me some of the code to make this

## Insert images from folder into qb-inentory/html/images

## Insert into @qb-core/shared/items.lua 

```
QBShared.Items = {
-- gruppejob
	['gruppe-case'] 		     	 = {['name'] = 'gruppe-case', 		     	 	['label'] = "Money Case", 	        	['weight'] = 200, 	   	['type'] = 'item',   	['image'] = 'gruppe-case.png',       	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'A metal case full of money'},
	['inked-bills'] 		     	 = {['name'] = 'inked-bills', 		     	 	['label'] = "Inked Bills", 	        	['weight'] = 200, 	   	['type'] = 'item',   	['image'] = 'inked-bills.png',       	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'A Bag of Inked Bills'},

}

```
## Insert into @qb-core/shared/jobs.lua 
```
QBShared.Jobs = {
    ['gruppe'] = {
		label = 'Gruppe',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 10
            },
        },
	},
}		
```
