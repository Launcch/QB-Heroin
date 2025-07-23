local Translations = {
    info = {
        ["pick_opium_sap"] = "Press <b style=\"color: limegreen;\">[E]</b> to pick Opium Sap",
        ["process_opium"] = "Press <b style=\"color: limegreen;\">[E]</b> to process your Opium",
        ["press_sell_heroin"] = "Press ~b~[E]~w~ to sell Heroin",
    },
    error = {
        ["not_enough_opium_sap"] = "You don't have enough Opium Sap",
        ["has_no_heroin"] = "You don't have any Heroin on you",
        ["not_enough_heroin"] = "You don't have enough Heroin on you",
    },
    success = {
        ["sold_amount"] = "You've sold %{amount}x Heroin bags for: $%{reward}",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
