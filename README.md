Basically qb-cocaine https://github.com/cyberrp-fr/qb-cocaine
but now it makes heroin so you can have multiple drugs.
also add heroin_bag to qb-drugs cornerselling list to sell on the street
drag and drop qb-heroin into resources/[qb] and enjoy

i miss spelt heroin with herion in lots of spots but just leave it the actual items and in game it says heroin

add this to qb-core/shared/items.lua

['opium_sap']	= {['name'] = 'opium_sap', ['label'] = 'Opium Sap', ['weight'] = 50,['type'] = 'item',	['image'] = 'opiumsap.png',	['unique'] = false,		['useable'] = false,	['shouldClose'] = false,	['combinable'] = nil,	['description'] = 'Gooey Opium Sap.'},


['heroin_bag']	= {['name'] = 'heroin_bag',	['label'] = 'Heroin Bag', ['weight'] = 600,	['type'] = 'item', ['image'] = 'herion_bag.png',	['unique'] = false,	['useable'] = false, ['shouldClose'] = false,	['combinable'] = nil,	['description'] = 'Bag of Finest H'},
