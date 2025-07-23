Config = {}

Config.SellPrice = 823
Config.RewardMoneyType = 'cash'

-- picking zone
Config.PickingZone = vector3(-2079.5, 2529.08, 3.82)
Config.PickingZoneHeading = 311.3

-- processing zone
Config.ProcessingZone = vector3(891.93, -960.75, 39.28)
Config.ProcessingZoneHeading = 339.0

-- Rewards
Config.Reward = {
    ['opium_sap'] = {
        item = 'opium_sap',
        minAmount = 1,
        maxAmount = 3,
    },
    ['heroin_bag'] = {
        item = 'heroin_bag',
        amountOfLeaves = 15,
    }
}

-- Buyer setup
Config.Buyer = {
    ped = 'ig_djsolmike',
    bodyguard = 'u_m_m_jewelsec_01',
    pos = vector4(-128.23, -2207.64, 6.81, 180.32),

    bodyguard1Pos = vector4(706.1929, -3607.4968, -57.2960, 217.8187),
    bodyguard2Pos = vector4(712.0178, -3615.1182, -60.2394, 214.5778),

    vehicle = 'baller',
    vehiclePos = vector4(715.6856, -3638.1260, -62.1765, 181.1093)
}