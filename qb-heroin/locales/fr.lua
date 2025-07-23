local Translations = {
    info = {
        ["pick_opium_sap"] = "Appuyez <b style=\"color: limegreen;\">[E]</b> pour ramasser feuilles de Coca",
        ["process_opium"] = "Appuyez <b style=\"color: limegreen;\">[E]</b> pour traiter Coca",
        ["press_sell_heroin"] = "~b~[E]~w~ vendre Cocaine",
    },
    error = {
        ["not_enough_opium_sap"] = "Vous n'avez pas assez de feuilles de Coca",
        ["has_no_heroin"] = "Vous n'avez pas de Cocaine sur vous",
        ["not_enough_herion"] = "Vous n'avez pas assez de Cocaine sur vous",
    },
    success = {
        ["sold_amount"] = "Vous avez vendu %{amount} pochons de Heroin pour: %{reward}€"
    }
}

if GetConvar("qb_locale", "en") == "fr" then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end